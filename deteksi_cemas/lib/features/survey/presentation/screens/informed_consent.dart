// ignore_for_file: unused_field

import 'package:deteksi_cemas/features/dashboard/presentation/widgets/responsive_layout.dart';
import 'package:deteksi_cemas/features/survey/data/models/guest_models.dart';
import 'package:deteksi_cemas/features/survey/data/repository/hars_questions.dart';
import 'package:deteksi_cemas/features/survey/presentation/screens/guest_hars_survey_screen.dart';
import 'package:deteksi_cemas/theme/color_list.dart';
import 'package:flutter/material.dart';

class InformedConsentForm extends StatefulWidget {
  const InformedConsentForm({super.key});

  @override
  State<InformedConsentForm> createState() => _InformedConsentFormState();
}

class _InformedConsentFormState extends State<InformedConsentForm> {
  final _formKey = GlobalKey<FormState>();

  // Custom Colors for a "Premium" look
  final Color primaryDark = const Color(0xFF1A237E); // Indigo
  final Color accentColor = const Color(0xFF3949AB);
  final Color bgColor = const Color(0xFFF8FAFC);
  final Color cardColor = Colors.white;

  String? _gender;
  bool? _isAgreed;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _prodiController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: responsiveLayout(
        content: CustomScrollView(
          slivers: [
            // Modern Floating AppBar
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: primaryDark,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  "Informed Consent",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                centerTitle: true,
                background: Container(
                  decoration: BoxDecoration(
                    color: ColorList.aquaCyan,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(),
                      const SizedBox(height: 32),
                      _buildSectionHeader("Informasi Personal"),
                      const SizedBox(height: 16),

                      _buildModernField(
                        _nameController,
                        "Nama Lengkap",
                        Icons.person_rounded,
                      ),
                      _buildModernField(
                        _emailController,
                        "Email",
                        Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: _buildModernField(
                              _ageController,
                              "Usia",
                              Icons.calendar_month_rounded,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: _buildModernDropdown()),
                        ],
                      ),

                      _buildSectionHeader("Akademik & Kontak"),
                      const SizedBox(height: 16),
                      _buildModernField(
                        _prodiController,
                        "Program Studi",
                        Icons.account_balance_rounded,
                      ),
                      _buildModernField(
                        _nimController,
                        "NIM",
                        Icons.fingerprint_rounded,
                      ),
                      _buildModernField(
                        _whatsappController,
                        "WhatsApp",
                        Icons.phone_rounded,
                        keyboardType: TextInputType.phone,
                      ),
                      _buildModernField(
                        _addressController,
                        "Alamat",
                        Icons.map_rounded,
                        maxLines: 2,
                      ),

                      const SizedBox(height: 24),
                      _buildAgreementCard(),

                      const SizedBox(height: 40),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: primaryDark.withOpacity(0.6),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryDark.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryDark.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.verified_user_rounded, color: primaryDark),
              const SizedBox(width: 12),
              const Text(
                "Dengan ini saya menyatakan bahwa:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '''
Semua penjelasan telah saya pahami dengan baik.
Saya telah diberi kesempatan untuk bertanya dan semua pertanyaan saya telah dijawab.
Saya setuju secara sukarela untuk menjalani prosedur atau menjadi peserta penelitian ini.''',
            style: TextStyle(color: Colors.black54, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildModernField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: primaryDark.withOpacity(0.7)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: primaryDark, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.grey.shade600),
        ),
      ),
    );
  }

  Widget _buildModernDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Gender",
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        items: [
          "Male",
          "Female",
        ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
        onChanged: (v) => setState(() => _gender = v),
      ),
    );
  }

  Widget _buildAgreementCard() {
    return Column(
      children: [
        Text(
          "Dengan ini saya menyatakan setuju untuk terlibat sebagai pasrtisipan dalam penelitian dengan judul diatas secara sukarela dan tanpa paksaan dari pihak manapun",
          style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.5),
        ),
        _selectionTile("Saya Setuju", true, Colors.green),
        const SizedBox(height: 12),
        _selectionTile("Saya Tidak Setuju", false, Colors.redAccent),
      ],
    );
  }

  Widget _selectionTile(String title, bool value, Color activeColor) {
    bool isSelected = _isAgreed == value;
    return GestureDetector(
      onTap: () => setState(() => _isAgreed = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final repository = HarsQuestionsRepository();
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: [primaryDark, accentColor]),
        boxShadow: [
          BoxShadow(
            color: primaryDark.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (!_validateForm()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please fill all fields")),
            );
            return;
          } else {
            Guest guest = Guest(
              name: _nameController.text,
              email: _emailController.text,
              age: int.tryParse(_ageController.text) ?? 0,
              prodi: _prodiController.text,
              nim: _nimController.text,
              phoneNumber: _whatsappController.text,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GuestHarsSurveyScreen(
                  surveyRepository: repository,
                  guest: guest, // <-- FIX: Passing the dependency
                ),
              ),
            );
          }
        }, // Add logic here
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "Next",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _prodiController.text.isEmpty ||
        _nimController.text.isEmpty ||
        _whatsappController.text.isEmpty) {
      return false;
    }
    return true;
  }
}
