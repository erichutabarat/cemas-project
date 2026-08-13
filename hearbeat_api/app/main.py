"""
Heartbeat Sound -> Anxiety Level Prediction API
================================================
Serves the SVM_MFCC_DEPLOYMENT_FULLDATA.joblib model (StandardScaler + SVC)
behind a FastAPI HTTP endpoint.

FEATURE EXTRACTION - matches the original training pipeline exactly
---------------------------------------------------------------------
Confirmed from the training notebook ("01 - Ekstraksi MFCC dari Dataset
PCG Final" / "02 - Klasifikasi SVM pada Dataset PCG Final"):

1. Load audio at its NATIVE sample rate (no resampling). Training data
   was all 16 kHz PCG (heart sound) recordings.
2. DC removal (subtract the signal mean).
3. Butterworth band-pass filter, order 4, 20-400 Hz, applied with
   zero-phase filtering (sosfiltfilt).
4. Framing: 100 ms frame size, 50 ms hop (50% overlap), Hamming window.
5. Power spectrum via rFFT, NFFT = next power of 2 >= frame length.
6. 26 Mel filters, fmin=20 Hz, fmax=400 Hz, htk=True, norm=None.
7. log(mel energies), then DCT-II (norm="ortho").
8. Keep coefficients C1-C13 (the C0 / energy term is DROPPED).
9. Mean each coefficient across all frames -> 13-dim feature vector.

If you change the training pipeline in the future, this function must be
updated to match, or predictions will be silently wrong.
"""

import io
import logging

import joblib
import librosa
import numpy as np
from fastapi import FastAPI, File, HTTPException, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from scipy.fft import dct
from scipy.signal import butter, sosfiltfilt

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("heartbeat-api")

MODEL_PATH = "app/model.joblib"

# --- extraction config, must match training notebook exactly ---
LOWCUT = 20.0
HIGHCUT = 400.0
FILTER_ORDER = 4
FRAME_SIZE_SEC = 0.100
FRAME_STRIDE_SEC = 0.050
N_MELS = 26
N_MFCC = 13

app = FastAPI(
    title="Heartbeat Anxiety Level Prediction API",
    description="Upload a heartbeat sound file and get a predicted anxiety level.",
    version="1.0.0",
)

# Allow browser-based clients (mobile app / web front-end) to call this API.
# Lock this down to specific origins in production.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load model once at startup (not per-request)
model = None


@app.on_event("startup")
def load_model():
    global model
    logger.info("Loading model from %s", MODEL_PATH)
    model = joblib.load(MODEL_PATH)
    logger.info("Model loaded. Expected input features: %s", model.named_steps["scaler"].n_features_in_)


class PredictionResponse(BaseModel):
    predicted_label: str
    class_scores: dict
    n_features_used: int


def extract_features(audio_bytes: bytes) -> np.ndarray:
    """
    Load raw audio bytes and extract the 13-dim MFCC (C1-C13, mean-pooled)
    feature vector, using the exact same pipeline as the training notebook.
    """
    try:
        # sr=None -> keep native sample rate, same as training (sr=None there too)
        signal, sr = librosa.load(io.BytesIO(audio_bytes), sr=None, mono=True)
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Could not read audio file: {e}")

    if signal.size == 0:
        raise HTTPException(status_code=400, detail="Audio file is empty or unreadable.")

    if sr != 16000:
        logger.warning(
            "Uploaded audio sample rate is %d Hz, but the model was trained "
            "on 16000 Hz recordings. Predictions may be unreliable.",
            sr,
        )

    # 1. DC removal
    signal = signal - np.mean(signal)

    # 2. Band-pass filter (heart sound band, 20-400 Hz)
    sos = butter(FILTER_ORDER, [LOWCUT, HIGHCUT], btype="bandpass", fs=sr, output="sos")
    signal = sosfiltfilt(sos, signal)

    # 3. Framing (100ms frame, 50ms hop, Hamming window)
    frame_length = int(round(FRAME_SIZE_SEC * sr))
    frame_step = int(round(FRAME_STRIDE_SEC * sr))

    if len(signal) < frame_length:
        raise HTTPException(
            status_code=400,
            detail=(
                f"Audio too short: needs at least {FRAME_SIZE_SEC * 1000:.0f}ms "
                f"of audio at {sr} Hz."
            ),
        )

    n_frames = 1 + int(np.ceil((len(signal) - frame_length) / frame_step))
    padded_length = (n_frames - 1) * frame_step + frame_length
    padded = np.pad(signal, (0, padded_length - len(signal)))
    idx = np.arange(frame_length)[None, :] + np.arange(n_frames)[:, None] * frame_step
    frames = padded[idx] * np.hamming(frame_length)[None, :]

    # 4. Power spectrum
    nfft = 2 ** int(np.ceil(np.log2(frame_length)))
    power = (np.abs(np.fft.rfft(frames, n=nfft, axis=1)) ** 2) / nfft

    # 5. Mel filterbank (26 filters, 20-400 Hz, htk formula, unnormalized)
    mel_filters = librosa.filters.mel(
        sr=sr, n_fft=nfft, n_mels=N_MELS, fmin=LOWCUT, fmax=HIGHCUT, htk=True, norm=None
    )
    mel = np.maximum(power @ mel_filters.T, np.finfo(float).eps)

    # 6. log -> DCT-II -> keep C1-C13 (drop C0 energy term)
    mfcc_all = dct(np.log(mel), type=2, axis=1, norm="ortho")
    mfcc = mfcc_all[:, 1 : N_MFCC + 1]

    # 7. Mean-pool across frames
    features = np.mean(mfcc, axis=0)  # shape: (13,)
    return features.reshape(1, -1)


@app.get("/health")
def health():
    return {"status": "ok", "model_loaded": model is not None}


@app.post("/predict", response_model=PredictionResponse)
async def predict(file: UploadFile = File(...)):
    if model is None:
        raise HTTPException(status_code=503, detail="Model is not loaded yet.")

    allowed_ext = (".wav", ".mp3", ".flac", ".ogg", ".m4a")
    if file.filename and not file.filename.lower().endswith(allowed_ext):
        logger.warning("Unusual file extension: %s", file.filename)

    audio_bytes = await file.read()
    if not audio_bytes:
        raise HTTPException(status_code=400, detail="Uploaded file is empty.")

    features = extract_features(audio_bytes)

    try:
        prediction = model.predict(features)[0]
        # SVC was trained with probability=False, so we use decision_function
        # (signed distance to each class boundary) as a rough confidence signal
        # instead of calibrated probabilities.
        decision = model.decision_function(features)[0]
        classes = model.named_steps["svm"].classes_
        scores = {cls: float(score) for cls, score in zip(classes, decision)}
    except Exception as e:
        logger.exception("Prediction failed")
        raise HTTPException(status_code=500, detail=f"Prediction failed: {e}")

    return PredictionResponse(
        predicted_label=str(prediction),
        class_scores=scores,
        n_features_used=features.shape[1],
    )


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)