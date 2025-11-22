import 'package:deteksi_cemas/features/dashboard/domain/models/medical_record_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MedicalHistoryCard extends StatelessWidget {
  final MedicalRecordModel medicalRecord;
  const MedicalHistoryCard({super.key, required this.medicalRecord});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(FontAwesomeIcons.heart, color: Colors.red.shade700),
          ),
          Column(
            children: [
              Text(
                "${medicalRecord.bpm} BPM",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              Text(
                formatDate(medicalRecord.checkedAt),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Text(
            medicalRecord.result,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Icon(Icons.arrow_circle_right_rounded, color: Colors.red.shade700),
        ],
      ),
    );
  }
}
