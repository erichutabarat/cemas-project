// lib/features/dashboard_admin/presentation/screens/add_article_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:deteksi_cemas/features/dashboard_admin/data/models/article_model.dart';
import 'package:deteksi_cemas/features/dashboard_admin/domain/repository/article_repository.dart';

class AddArticleScreen extends StatefulWidget {
  const AddArticleScreen({super.key});

  @override
  State<AddArticleScreen> createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  // State
  ArticleType _selectedType = ArticleType.food;
  String _selectedAnxietyLevel = 'Low';
  File? _pickedImage;
  bool _isLoading = false;

  static const _anxietyLevels = [
    'Low',
    'Mild',
    'Moderate',
    "Severe",
    "Very Severe",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // ─── Image Picker ─────────────────────────────────────────────────────────

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  // ─── Submit ───────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih gambar terlebih dahulu')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context); // ← capture before await

    try {
      final success = await ArticleRepository().createArticle(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        type: _selectedType,
        anxietyLevel: _selectedAnxietyLevel,
        imageFile: _pickedImage!,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Artikel berhasil ditambahkan')),
        );
        Navigator.pop(context, true); // ← true = tell parent to refresh
      } else {
        messenger.showSnackBar(
          const SnackBar(content: Text('Gagal menambahkan artikel')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Tambah Artikel Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildImagePicker(),
            const SizedBox(height: 20),
            _buildTypeDropdown(),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _nameController,
              label: 'Nama Artikel',
              hint: 'Masukkan nama artikel',
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Nama tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _descController,
              label: 'Deskripsi',
              hint: 'Masukkan deskripsi artikel',
              maxLines: 4,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Deskripsi tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 16),
            _buildAnxietyDropdown(),
            const SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // ─── Widgets ──────────────────────────────────────────────────────────────

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _pickedImage == null
                ? const Color(0xFFCBD5E1)
                : const Color(0xFF1E3A8A),
            width: _pickedImage == null ? 1.5 : 2,
            style: _pickedImage == null ? BorderStyle.solid : BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: _pickedImage != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(_pickedImage!, fit: BoxFit.cover),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _pickedImage = null),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit, color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Ganti',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap untuk pilih gambar',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'JPG, PNG — maks. 5MB',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<ArticleType>(
      value: _selectedType,
      decoration: _inputDecoration('Tipe Artikel'),
      items: const [
        DropdownMenuItem(value: ArticleType.food, child: Text('🍎  Food')),
        DropdownMenuItem(
          value: ArticleType.activity,
          child: Text('🏃  Activity'),
        ),
      ],
      onChanged: (val) => setState(() => _selectedType = val!),
    );
  }

  Widget _buildAnxietyDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedAnxietyLevel,
      decoration: _inputDecoration('Anxiety Level'),
      items: _anxietyLevels
          .map((l) => DropdownMenuItem(value: l, child: Text(l)))
          .toList(),
      onChanged: (val) => setState(() => _selectedAnxietyLevel = val!),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: _inputDecoration(label).copyWith(hintText: hint),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E3A8A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isLoading ? null : _submit,
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Simpan Artikel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
