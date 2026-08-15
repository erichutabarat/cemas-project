package utils

var anxietyLevelEN = map[string]string{
	"Ringan":       "Mild",
	"Sedang":       "Moderate",
	"Berat":        "Severe",
	"Sangat Berat": "Severe", // TEMP: merged with "Berat" until app supports 4 tiers
}

func TranslateAnxietyLevel(label string) string {
	if en, ok := anxietyLevelEN[label]; ok {
		return en
	}
	return label
}