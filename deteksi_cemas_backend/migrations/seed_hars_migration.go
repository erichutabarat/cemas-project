package migrations

import (
    "log"
    "deteksi_cemas_backend/models"
    "gorm.io/gorm"
)

func SeedHarsQuestions(db *gorm.DB) {
    questions := []models.HarsQuestions{
        {ID: 1, Category: "Anxious Mood", Question: "Worrying, anticipation of the worst, fearful rumination.", SymptomType: "Psychic"},
        {ID: 2, Category: "Tension", Question: "Feelings of tension, fatigability, startle response, moving about restlessly, inability to relax.", SymptomType: "Psychic"},
        {ID: 3, Category: "Fears", Question: "Fear of darkness, of strangers, of being left alone, of animals, of crowds, of traffic, etc.", SymptomType: "Psychic"},
        {ID: 4, Category: "Insomnia", Question: "Difficulty falling asleep, broken sleep, unsatisfying sleep and fatigue on waking, dreams, nightmares, night terrors.", SymptomType: "Psychic"},
        {ID: 5, Category: "Intellectual (Cognitive) Symptoms", Question: "Difficulty in concentration, poor memory.", SymptomType: "Psychic"},
        {ID: 6, Category: "Depressed Mood", Question: "Loss of interest, lack of pleasure in hobbies, depression, early waking, diurnal swing.", SymptomType: "Psychic"},
        {ID: 7, Category: "Somatic (Muscular) Symptoms", Question: "Aches and pains, twitching, stiffness, grinding of teeth, unsteady voice, muscular tension.", SymptomType: "Somatic"},
        {ID: 8, Category: "Sensory Symptoms", Question: "Tinnitus, blurring of vision, hot and cold flushes, feelings of weakness, pricking sensations.", SymptomType: "Somatic"},
        {ID: 9, Category: "Cardiovascular Symptoms", Question: "Tachycardia, palpitations, pain in chest, throbbing of vessels, fainting feelings, skipped heart beat.", SymptomType: "Somatic"},
        {ID: 10, Category: "Respiratory Symptoms", Question: "Pressure or constriction in chest, choking feelings, sighs, dyspnea.", SymptomType: "Somatic"},
        {ID: 11, Category: "Gastrointestinal Symptoms", Question: "Difficulty swallowing, wind, abdominal pain, burning sensations, abdominal fullness, nausea, vomiting, looseness of bowels, loss of weight, constipation.", SymptomType: "Somatic"},
        {ID: 12, Category: "Genitourinary Symptoms", Question: "Frequency of micturition, urgency of micturition, amenorrhoea, menorrhagia, frigidity, premature ejaculation, loss of libido, impotence.", SymptomType: "Somatic"},
        {ID: 13, Category: "Autonomic Symptoms", Question: "Dry mouth, flushing, pallor, tendency to sweat, giddiness, tension headache, raising of hair.", SymptomType: "Somatic"},
        {ID: 14, Category: "Behaviour at Interview", Question: "General behavior (fidgeting, restlessness, tremor of hands, furrowed brow, strained face, sighing respiration, rapid respiration, pallor, swallowing, belching, etc.)", SymptomType: "General"},
    }

    for _, q := range questions {
        if err := db.Create(&q).Error; err != nil {
            log.Println("Failed to insert question:", q.ID, err)
        }
    }
}
