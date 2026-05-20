import 'package:deteksi_cemas/features/dashboard_admin/data/models/article_model.dart';
import 'package:deteksi_cemas/features/dashboard_admin/domain/repository/article_repository.dart';
import 'package:deteksi_cemas/features/dashboard_admin/presentation/screens/add_article_screen.dart';
import 'package:deteksi_cemas/features/onboarding/domain/repository/backend_repository.dart';
import 'package:flutter/material.dart';

class ArticleAdminScreen extends StatefulWidget {
  const ArticleAdminScreen({super.key});

  @override
  State<ArticleAdminScreen> createState() => _ArticleAdminScreenState();
}

class _ArticleAdminScreenState extends State<ArticleAdminScreen> {
  late String _backendUrl;
  List<ArticleModel> _articles = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchBackendUrl();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    setState(() => _loading = true);
    try {
      final articles = await ArticleRepository().fetchArticles();
      if (!mounted) return;
      setState(() {
        _articles = articles;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat artikel: $e')));
    }
  }

  void _fetchBackendUrl() async {
    final url = await BackendRepository.getBackendUrl();
    setState(() => _backendUrl = url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Kelola Artikel & Saran",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E3A8A),
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddArticleScreen()),
          );
          if (created == true) _fetchArticles();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _articles.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada artikel',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _articles.length,
              itemBuilder: (context, index) =>
                  _buildArticleCard(_articles[index]),
            ),
    );
  }

  Widget _buildArticleCard(ArticleModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image preview
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              '$_backendUrl${item.url}',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,

              // 1. PANTAU GAMBAR YANG BERHASIL
              loadingBuilder:
                  (
                    BuildContext context,
                    Widget child,
                    ImageChunkEvent? loadingProgress,
                  ) {
                    if (loadingProgress == null) {
                      // Jika loadingProgress bernilai null, berarti gambar SUDAH SELESAI diunduh dengan sukses
                      debugPrint('✅ GAMBAR BERHASIL: $_backendUrl${item.url}');
                      return child; // Tampilkan gambarnya
                    }

                    // Selagi proses download berjalan, tampilkan widget loading (opsional)
                    return child;
                  },

              // 2. PANTAU GAMBAR YANG ERROR
              errorBuilder: (context, error, stackTrace) {
                // Mencetak URL yang gagal beserta alasan error-nya
                debugPrint('❌ GAMBAR ERROR: $_backendUrl${item.url}');
                debugPrint('⚠️ Alasan Gagal: $error');

                // Tampilkan widget fallback jika error
                return Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLevelBadge(item.anxietyLevel),
                    // ✅ Two separate IconButtons, not nested
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Colors.blue,
                            size: 20,
                          ),
                          onPressed: () =>
                              _showArticleForm(context, article: item),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () => _confirmDelete(item),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelBadge(String level) {
    final color = level.toLowerCase().contains("high")
        ? Colors.red
        : level.toLowerCase().contains("moderate")
        ? Colors.orange
        : Colors.green;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _confirmDelete(ArticleModel item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus artikel?"),
        content: Text("\"${item.name}\" akan dihapus secara permanen."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              // TODO: call delete API then _fetchArticles()
              Navigator.pop(context);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showArticleForm(BuildContext context, {ArticleModel? article}) {
    final idController = TextEditingController(
      text: article?.id.toString() ?? '',
    );
    final nameController = TextEditingController(text: article?.name ?? '');
    final levelController = TextEditingController(
      text: article?.anxietyLevel ?? '',
    );
    final descController = TextEditingController(
      text: article?.description ?? '',
    );
    final urlController = TextEditingController(text: article?.url ?? '');

    // ← State for dropdown inside StatefulBuilder
    ArticleType selectedType = article?.articleType ?? ArticleType.food;

    final isEdit = article != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        // ← needed to rebuild dropdown
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            // ← prevents overflow on small screens
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? "Edit Artikel" : "Tambah Artikel Baru",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Nama Artikel",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: levelController,
                  decoration: InputDecoration(
                    labelText: "Anxiety Level (low / moderate / high)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Deskripsi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      final newArticle = ArticleModel(
                        id: int.tryParse(idController.text) ?? 0,
                        name: nameController.text,
                        articleType:
                            selectedType, // ← from dropdown, not controller
                        url: urlController.text,
                        description: descController.text,
                        anxietyLevel: levelController.text,
                      );
                      _updateArticle(newArticle);
                      Navigator.pop(context);
                    },
                    child: Text(
                      isEdit ? "Simpan Perubahan" : "Simpan Artikel",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateArticle(ArticleModel article) async {
    // ← capture BEFORE the await, while context is still valid
    final messenger = ScaffoldMessenger.of(context);

    final success = await ArticleRepository().updateArticle(article);

    if (!mounted) return;

    messenger.showSnackBar(
      // ← use captured reference, not ScaffoldMessenger.of(context)
      SnackBar(
        content: Text(
          success ? 'Artikel berhasil diperbarui' : 'Gagal memperbarui artikel',
        ),
      ),
    );

    if (success) _fetchArticles();
  }
}
