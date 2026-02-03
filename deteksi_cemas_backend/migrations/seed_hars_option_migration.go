package migrations

import (
	"deteksi_cemas_backend/models"
	"fmt"
	"gorm.io/gorm"
	"log"
)

func SeedHarsOptions(db *gorm.DB) {
	var count int64
	db.Model(&models.HarsOptions{}).Count(&count)
	if count > 0 {
		log.Println("HarsOptions already seeded, skipping...")
		return
	}
	options := []models.HarsOptions{
		// 1. Suasana hati cemas (Anxious mood)
		{QuestionID: 1, Option: "Feelings of excessive anxiety or worry", OptionId: "Perasaan cemas atau khawatir berlebihan", Score: 1},
		{QuestionID: 1, Option: "Bad premonition", OptionId: "Firasat buruk", Score: 1},
		{QuestionID: 1, Option: "Fear for no apparent reason", OptionId: "Takut tanpa alasan yang jelas", Score: 1},
		{QuestionID: 1, Option: "Easily irritated or restless", OptionId: "Mudah tersinggung atau tidak tenang", Score: 1},

		// 2. Ketegangan (Tension)
		{QuestionID: 2, Option: "Feeling restless", OptionId: "Merasa gelisah", Score: 1},
		{QuestionID: 2, Option: "Difficult to relax", OptionId: "Sulit untuk rileks", Score: 1},
		{QuestionID: 2, Option: "Easily startled", OptionId: "Mudah terkejut", Score: 1},
		{QuestionID: 2, Option: "Body feels tense", OptionId: "Tubuh terasa tegang", Score: 1},
		{QuestionID: 2, Option: "Trembling hands or feet", OptionId: "Tangan atau kaki gemetar", Score: 1},

		// 3. Ketakutan (Fears)
		{QuestionID: 3, Option: "Fear of being alone", OptionId: "Takut sendirian", Score: 1},
		{QuestionID: 3, Option: "Fear of crowded places", OptionId: "Takut berada di tempat ramai", Score: 1},
		{QuestionID: 3, Option: "Fear of meeting strangers", OptionId: "Takut bertemu dengan orang asing", Score: 1},
		{QuestionID: 3, Option: "Fear of specific situations", OptionId: "Takut pada situasi tertentu", Score: 1},
		{QuestionID: 3, Option: "Fear without a clear cause", OptionId: "Takut tanpa sebab yang jelas", Score: 1},

		// 4. Gangguan tidur (Insomnia)
		{QuestionID: 4, Option: "Difficulty falling asleep", OptionId: "Sulit memulai tidur", Score: 1},
		{QuestionID: 4, Option: "Frequent waking at night", OptionId: "Sering terbangun di malam hari", Score: 1},
		{QuestionID: 4, Option: "Restless sleep", OptionId: "Tidur tidak nyenyak", Score: 1},
		{QuestionID: 4, Option: "Nightmares", OptionId: "Mimpi buruk", Score: 1},
		{QuestionID: 4, Option: "Feeling tired upon waking", OptionId: "Bangun tidur merasa lelah", Score: 1},

		// 5. konsentrasi (Intelektual)
		{QuestionID: 5, Option: "Difficulty concentrating", OptionId: "Sulit berkonsentrasi", Score: 1},
		{QuestionID: 5, Option: "Forgetfulness", OptionId: "Mudah lupa", Score: 1},
		{QuestionID: 5, Option: "Blank mind", OptionId: "Pikiran terasa kosong", Score: 1},
		{QuestionID: 5, Option: "Difficulty understanding conversations", OptionId: "Sulit mamahami pembicaraan", Score: 1},
		{QuestionID: 5, Option: "Difficulty making decisions", OptionId: "Sulit mengambil keputusan", Score: 1},

		// 6. Perasaan depresi (Depressed mood)
		{QuestionID: 6, Option: "Feeling sad", OptionId: "Merasa sedih", Score: 1},
		{QuestionID: 6, Option: "Loss of interest", OptionId: "Kehilangan minat", Score: 1},
		{QuestionID: 6, Option: "Feeling hopeless", OptionId: "Merasa putus asa", Score: 1},
		{QuestionID: 6, Option: "Easy to cry", OptionId: "Mudah menangis", Score: 1},
		{QuestionID: 6, Option: "Feeling worthless", OptionId: "Merasa tidak berharga", Score: 1},

		// 7. Gejala Somatik (Somatic muscular)
		{QuestionID: 7, Option: "Muscle aches or pains", OptionId: "Nyeri atau pregal otot", Score: 1},
		{QuestionID: 7, Option: "Muscle stiffness", OptionId: "Otot terasa kaku", Score: 1},
		{QuestionID: 7, Option: "Muscle twitching", OptionId: "Kedutan otot", Score: 1},
		{QuestionID: 7, Option: "Unstable voice", OptionId: "Suara tidak stabil", Score: 1},
		{QuestionID: 7, Option: "Body tremors", OptionId: "Tubuh terasa gemetar", Score: 1},

		// 8. Gejala Somatik (Sensorik)
		{QuestionID: 8, Option: "Blurred vision", OptionId: "Penglihatan kabur", Score: 1},
		{QuestionID: 8, Option: "Hot or cold flashes", OptionId: "Rasa panas atau dingin", Score: 1},
		{QuestionID: 8, Option: "Ringing in the ears (Tinnitus)", OptionId: "Telinga berdenging", Score: 1},
		{QuestionID: 8, Option: "Numbness", OptionId: "Mati rasa", Score: 1},
		{QuestionID: 8, Option: "Prickling sensation (Paresthesia)", OptionId: "Kesemutan", Score: 1},

		// 9. Gejala kardiovaskular (Cardiovascular symptoms)
		{QuestionID: 9, Option: "Palpitations", OptionId: "Jantung berdebar (palpitasi)", Score: 1},
		{QuestionID: 9, Option: "Rapid heartbeat (Tachycardia)", OptionId: "Detak jantung cepat (takikardia)", Score: 1},
		{QuestionID: 9, Option: "Chest pain", OptionId: "Nyeri dada", Score: 1},
		{QuestionID: 9, Option: "Feeling faint or weak", OptionId: "Perasaan lemas seperti ingin pingsan", Score: 1},

		// 10. Gejala pernapasan (Respiratory symptoms)
		{QuestionID: 10, Option: "Difficulty drawing breath", OptionId: "Sulit menarik napas", Score: 1},
		{QuestionID: 10, Option: "Shortness of breath", OptionId: "Napas terasa pendek", Score: 1},
		{QuestionID: 10, Option: "Breathlessness (Dyspnea)", OptionId: "Sesak napas", Score: 1},
		{QuestionID: 10, Option: "Choking sensation", OptionId: "Perasaan tercekik", Score: 1},

		// 11. Gejala gastrointestinas (Gastrointestinal symptoms)
		{QuestionID: 11, Option: "Nausea", OptionId: "Mual", Score: 1},
		{QuestionID: 11, Option: "Vomiting", OptionId: "Muntah", Score: 1},
		{QuestionID: 11, Option: "Abdominal pain", OptionId: "Nyeri perut", Score: 1},
		{QuestionID: 11, Option: "Diarrhea", OptionId: "Diare", Score: 1},
		{QuestionID: 11, Option: "Decreased appetite", OptionId: "Nafsu makan menurun", Score: 1},
		{QuestionID: 11, Option: "Weight loss", OptionId: "Penurunan berat badan", Score: 1},

		// 12. Gejala genitourinaria
		{QuestionID: 12, Option: "Frequent urination", OptionId: "Sering buang air kecil", Score: 1},
		{QuestionID: 12, Option: "Menstrual disorders", OptionId: "Gangguan menstruasi", Score: 1},
		{QuestionID: 12, Option: "Decreased libido", OptionId: "Penurunan gairah seksual", Score: 1},
		{QuestionID: 12, Option: "Premature ejaculation", OptionId: "Ejakulasi dini", Score: 1},

		// 13. Gejala Otonom (Autonomic symptoms)
		{QuestionID: 13, Option: "Dry mouth", OptionId: "Mulut kering", Score: 1},
		{QuestionID: 13, Option: "Excessive sweating", OptionId: "Berkeringat berlebihan", Score: 1},
		{QuestionID: 13, Option: "Flushed or hot face", OptionId: "Wajah terasa panas atau kemerahan", Score: 1},
		{QuestionID: 13, Option: "Giddiness or lightheadedness", OptionId: "Pusing atau sakit kepala ringan", Score: 1},

		// 14. Perilaku saat wawancara atau pengisian kuesioner
		{QuestionID: 14, Option: "Difficulty sitting still", OptionId: "Sulit duduk tenang", Score: 1},
		{QuestionID: 14, Option: "Feeling restless", OptionId: "Merasa gelisah", Score: 1},
		{QuestionID: 14, Option: "Hand tremors", OptionId: "Tangan gemetar", Score: 1},
		{QuestionID: 14, Option: "Tense face", OptionId: "Wajah terasa tegang", Score: 1},
		{QuestionID: 14, Option: "Furrowed brow", OptionId: "Alis dan dahi berkerut", Score: 1},
		{QuestionID: 14, Option: "Frequent swallowing", OptionId: "Sering menelan ludah", Score: 1},
	}

	fmt.Println("Starting to seed HARS options...")
	for _, opt := range options {
		// Use FirstOrCreate to prevent duplicate data if you run the script again
		err := db.Where(models.HarsOptions{QuestionID: opt.QuestionID, Option: opt.Option, OptionId: opt.OptionId}).
			FirstOrCreate(&opt).Error
		if err != nil {
			fmt.Printf("Error seeding option '%s' for QuestionID %d: %v\n", opt.Option, opt.QuestionID, err)
		}
	}
	fmt.Println("HARS options seeding finished!")
}