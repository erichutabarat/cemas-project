# Heartbeat Sound → Anxiety Level API

A FastAPI server that wraps your `SVM_MFCC_DEPLOYMENT_FULLDATA.joblib` model
(StandardScaler + SVC) and serves it over HTTP.

## ⚠️ Before you trust this in production

The model expects **13 numeric features**. This server assumes those are
**13 MFCC coefficients, averaged (mean) over time**, extracted with `librosa`
at a 22050 Hz sample rate. This is the most common setup for a 13-feature
MFCC model, but it is a guess — I don't have your original training code.

**If your predictions look wrong/random, this is the first thing to check.**
Open `app/main.py` and look at `extract_features()`. Update it to match
exactly what you did when you trained the model:
- Sample rate (`SAMPLE_RATE`)
- Number of MFCCs (`N_MFCC`)
- Mean vs. mean+std vs. mean+delta, etc.
- Whether you trimmed silence, normalized volume, fixed audio duration, etc.

## Project structure

```
heartbeat_api/
├── app/
│   ├── main.py          # FastAPI app + prediction logic
│   └── model.joblib      # your trained model (copied in)
├── requirements.txt
└── README.md
```

## Run locally

```bash
cd heartbeat_api
python3 -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt

python3 -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

Server will be live at `http://localhost:8000`.
Interactive API docs (auto-generated): `http://localhost:8000/docs`

## Endpoints

### `GET /health`
Simple check that the server and model are up.

```bash
curl http://localhost:8000/health
```

### `POST /predict`
Upload an audio file (wav/mp3/flac/ogg/m4a), get back the predicted
anxiety level.

```bash
curl -X POST -F "file=@heartbeat_sample.wav" http://localhost:8000/predict
```

Response:
```json
{
  "predicted_label": "Ringan",
  "class_scores": {
    "Berat": 0.76,
    "Ringan": 3.29,
    "Sangat Berat": 2.09,
    "Sedang": -0.28
  },
  "n_features_used": 13
}
```

Note: `class_scores` are SVM **decision-function** distances, not
calibrated probabilities (the model was trained with `probability=False`).
Higher = more confident for that class, but they aren't 0–1 probabilities.
If you want real probabilities, you'd need to retrain the SVM with
`probability=True` — that's the only way to get calibrated confidence.

## Deploying online (a few options)

Once it works locally, you have several options to put it on the internet:

1. **Render / Railway / Fly.io** — easiest for a small FastAPI app.
   Push this folder to GitHub, connect the repo, they auto-detect
   `requirements.txt` and run `uvicorn app.main:app --host 0.0.0.0 --port $PORT`.
2. **Docker + any cloud VM** (AWS EC2, GCP, DigitalOcean) — most control.
   Wrap it in a Dockerfile (ask me if you want one generated) and run
   `docker run -p 8000:8000 your-image`.
3. **Hugging Face Spaces (Docker SDK)** — free tier, good for demos.

For any of these, put the server behind HTTPS (most platforms above handle
this for you automatically) and restrict `allow_origins` in `main.py`
from `"*"` to your actual front-end domain before going live.