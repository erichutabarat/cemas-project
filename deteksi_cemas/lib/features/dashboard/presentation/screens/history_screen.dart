import 'package:deteksi_cemas/features/dashboard/data/models/medical_record_model.dart';
import 'package:deteksi_cemas/features/dashboard/domain/repository/history_repository.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/screens/inspection_detail_screen.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/widgets/medical_history_card.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/widgets/responsive_layout.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/widgets/shaded_line.dart';
import 'package:deteksi_cemas/l10n/app_localizations.dart';
import 'package:deteksi_cemas/theme/color_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final ScrollController? controller;
  const HistoryScreen({super.key, this.controller});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<MedicalRecordModel> medicalRecords = [];
  List<MedicalRecordModel> _filteredRecords = [];
  bool isLoading = true;
  DateTimeRange? _selectedDateRange;
  final historyRepo = HistoryRepository();

  @override
  void initState() {
    super.initState();
    _loadMedicalRecords();
  }

  void _loadMedicalRecords() async {
    try {
      final List<MedicalRecordModel> records = await historyRepo
          .fetchUsersInspectionHistory();
      if (kDebugMode) {
        print("Fetched records: $records");
      }
      setState(() {
        medicalRecords = records;
        isLoading = false;
      });
      _applyDateFilter();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching medical records: $e');
      }
    }
  }

  void _applyDateFilter() {
    if (_selectedDateRange == null) {
      setState(() {
        _filteredRecords = medicalRecords;
      });
      return;
    }

    final start = DateTime(
      _selectedDateRange!.start.year,
      _selectedDateRange!.start.month,
      _selectedDateRange!.start.day,
    );
    final end = DateTime(
      _selectedDateRange!.end.year,
      _selectedDateRange!.end.month,
      _selectedDateRange!.end.day,
      23,
      59,
      59,
    );

    setState(() {
      _filteredRecords = medicalRecords.where((record) {
        final recordDate = record.checkedAt;
        return recordDate.isAfter(start.subtract(const Duration(seconds: 1))) &&
            recordDate.isBefore(end.add(const Duration(seconds: 1)));
      }).toList();
    });
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      initialDateRange:
          _selectedDateRange ??
          DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: ColorList.aquaCyan),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      _applyDateFilter();
    }
  }

  void _clearDateFilter() {
    setState(() {
      _selectedDateRange = null;
    });
    _applyDateFilter();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(0),
        child: SingleChildScrollView(
          controller: widget.controller,
          child: Column(
            children: [
              // history header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorList.aquaCyan,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.history, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      l10n.history,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.info_rounded, color: Colors.white),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // heart rate zone
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(color: Colors.red.shade100),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Anxiety Level",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              "Know more",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.red.shade700,
                              ),
                            ),
                            Icon(Icons.arrow_right_rounded, size: 30),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 18),
                    ShadedLineWidget(),
                  ],
                ),
              ),
              SizedBox(height: 26),

              // filter by date row — sits right above Medical History
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: _selectedDateRange == null
                          ? const SizedBox.shrink()
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Chip(
                                avatar: const Icon(Icons.date_range, size: 18),
                                label: Text(
                                  '${dateFormat.format(_selectedDateRange!.start)} - ${dateFormat.format(_selectedDateRange!.end)}',
                                ),
                                onDeleted: _clearDateFilter,
                                deleteIcon: const Icon(Icons.close, size: 18),
                              ),
                            ),
                    ),
                    TextButton.icon(
                      onPressed: _pickDateRange,
                      icon: Icon(
                        Icons.filter_alt_rounded,
                        color: ColorList.aquaCyan,
                      ),
                      label: Text(
                        _selectedDateRange == null
                            ? 'Filter by date'
                            : 'Change',
                        style: TextStyle(color: ColorList.aquaCyan),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),

              // Medical History
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.medical_history,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 14),
                    // list here
                    isLoading
                        ? CircularProgressIndicator()
                        : _filteredRecords.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                _selectedDateRange != null
                                    ? 'No records in the selected date range'
                                    : 'No records found',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap:
                                true, // <-- allow height to grow with content
                            physics:
                                NeverScrollableScrollPhysics(), // <-- disable scrolling here
                            itemCount: _filteredRecords.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = _filteredRecords[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => responsiveLayout(
                                        content: InspectionDetailScreen(
                                          record: item,
                                        ),
                                      ),
                                    ),
                                  ).then(
                                    (_) => _loadMedicalRecords(),
                                  ); // ← add this
                                },

                                child: MedicalHistoryCard(medicalRecord: item),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
