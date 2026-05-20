// ignore_for_file: use_build_context_synchronously

import 'package:deteksi_cemas/features/dashboard/data/models/userprofile_model.dart';
import 'package:deteksi_cemas/features/dashboard/domain/repository/user_repository.dart';
import 'package:deteksi_cemas/features/dashboard/domain/services/token_service.dart';
import 'package:deteksi_cemas/l10n/app_localizations.dart';
import 'package:deteksi_cemas/language/localecubit.dart';
import 'package:deteksi_cemas/theme/color_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatefulWidget {
  final ScrollController? controller;
  const SettingScreen({super.key, this.controller});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // app version
  final String appVersion = const String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.0',
  );

  // Mock user data for the profile card
  final UserRepository _userRepository = UserRepository();
  late Future<UserProfile> _userFuture;

  bool isDarkMode = false;
  bool enableNotifications = true;

  // Placeholder functions for settings
  void _onLogout() {
    // Implement your sign-out logic here (e.g., Firebase signOut, clear token)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logging out... (Placeholder)')),
    );
    final tokenService = TokenStorageService();
    tokenService.deleteToken();
    // Navigate to login screen or onboarding after logout
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _onToggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
    // Implement theme switching logic here
  }

  void _onToggleNotifications(bool value) {
    setState(() {
      enableNotifications = value;
    });
    // Implement notification control logic here
  }

  void _onNavigate(String title) {
    if (title == 'Privacy Policy') {
      Navigator.pushNamed(context, '/privacy_policy');
    } else if (title == 'Terms of Service') {
      Navigator.pushNamed(context, '/terms_of_service');
    } else if (title == 'About App') {
      Navigator.pushNamed(context, '/about_app');
    } else if (title == 'Edit Profile') {
      Navigator.pushNamed(context, '/edit_profile');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigating to $title... (Placeholder)')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _userFuture = _userRepository.fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    // --- Inside build method ---
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context).languageCode;
    return ListView(
      controller: widget.controller,
      padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
      children: <Widget>[
        // --- 1. User Profile Header (Modern Card Style) ---
        FutureBuilder<UserProfile>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final user = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.3),
                        child: Icon(
                          Icons.person,
                          size: 28,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _showEditProfileModal(user),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        const Divider(height: 32, thickness: 1),

        // --- 2. General Settings Group ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            l10n.general_settings,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),

        // Dark Mode Toggle
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Enable light or dark application theme'),
          secondary: const Icon(Icons.brightness_4_outlined),
          value: isDarkMode,
          onChanged: _onToggleTheme,
        ),

        // Notifications Toggle
        SwitchListTile(
          title: const Text('Notifications'),
          subtitle: const Text('Receive alerts and reminders'),
          secondary: const Icon(Icons.notifications_active_outlined),
          value: enableNotifications,
          onChanged: _onToggleNotifications,
        ),

        // Language Switcher
        ListTile(
          title: Text(l10n.language), // Use ARB key
          subtitle: Text(
            currentLocale == 'en' ? 'English' : 'Bahasa Indonesia',
          ),
          leading: const Icon(Icons.language_outlined),
          trailing: const Icon(Icons.chevron_right),
          onTap: _showLanguageDialog,
        ),

        // --- 3. App/Account Settings Group ---
        const Divider(height: 32, thickness: 1),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            l10n.account_and_app,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),

        // Privacy Policy
        ListTile(
          title: Text(l10n.privacy_policy),
          leading: const Icon(Icons.lock_outline),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _onNavigate('Privacy Policy'),
        ),

        // Terms of Service
        ListTile(
          title: Text(l10n.terms_service),
          leading: const Icon(Icons.description_outlined),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _onNavigate('Terms of Service'),
        ),

        // About
        ListTile(
          title: Text(l10n.about_app),
          leading: const Icon(Icons.info_outline),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _onNavigate('About App'),
        ),

        const Divider(height: 32, thickness: 1),

        // --- 4. Logout Button ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: ElevatedButton.icon(
            onPressed: _onLogout,
            icon: const Icon(Icons.logout),
            label: const Text('Log Out'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorList.roseDusty,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        // App Version
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'App Version $appVersion',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _showEditProfileModal(UserProfile user) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final addressController = TextEditingController(text: user.address ?? '');
    final jobController = TextEditingController(text: user.job ?? '');

    String selectedGender = user.gender;
    DateTime selectedBirthdate = user.birthdate;
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          Future<void> pickDate() async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedBirthdate,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) setModalState(() => selectedBirthdate = picked);
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ────────────────────────────────────────
                    Row(
                      children: [
                        const Text(
                          'Edit Profil',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // ── Avatar ────────────────────────────────────────
                    Center(
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Theme.of(
                          context,
                        ).primaryColor.withOpacity(0.15),
                        child: Icon(
                          Icons.person,
                          size: 36,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Name ──────────────────────────────────────────
                    TextFormField(
                      controller: nameController,
                      decoration: _modalInputDecoration(
                        'Nama',
                        Icons.person_outline,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Nama tidak boleh kosong'
                          : null,
                    ),
                    const SizedBox(height: 14),

                    // ── Email ─────────────────────────────────────────
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _modalInputDecoration(
                        'Email',
                        Icons.email_outlined,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!v.contains('@')) return 'Format email tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // ── Gender Dropdown ───────────────────────────────
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: _modalInputDecoration(
                        'Jenis Kelamin',
                        Icons.wc_outlined,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'male',
                          child: Text('Laki-laki'),
                        ),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text('Perempuan'),
                        ),
                      ],
                      onChanged: (v) =>
                          setModalState(() => selectedGender = v!),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Pilih jenis kelamin'
                          : null,
                    ),
                    const SizedBox(height: 14),

                    // ── Birthdate Picker ──────────────────────────────
                    GestureDetector(
                      onTap: pickDate,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration:
                              _modalInputDecoration(
                                'Tanggal Lahir',
                                Icons.cake_outlined,
                              ).copyWith(
                                hintText:
                                    '${selectedBirthdate.day}/${selectedBirthdate.month}/${selectedBirthdate.year}',
                                suffixIcon: const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 18,
                                ),
                              ),
                          controller: TextEditingController(
                            text:
                                '${selectedBirthdate.day}/${selectedBirthdate.month}/${selectedBirthdate.year}',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Address (optional) ────────────────────────────
                    TextFormField(
                      controller: addressController,
                      decoration: _modalInputDecoration(
                        'Alamat (opsional)',
                        Icons.location_on_outlined,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 14),

                    // ── Job (optional) ────────────────────────────────
                    TextFormField(
                      controller: jobController,
                      decoration: _modalInputDecoration(
                        'Pekerjaan (opsional)',
                        Icons.work_outline,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Save Button ───────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isSaving
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) return;

                                setModalState(() => isSaving = true);
                                final messenger = ScaffoldMessenger.of(context);

                                final updatedProfile = UserProfile(
                                  id: user.id,
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  gender: selectedGender,
                                  birthdate: selectedBirthdate,
                                  address: addressController.text.trim().isEmpty
                                      ? null
                                      : addressController.text.trim(),
                                  job: jobController.text.trim().isEmpty
                                      ? null
                                      : jobController.text.trim(),
                                );

                                try {
                                  final success = await _userRepository
                                      .updateProfile(updatedProfile);
                                  if (!mounted) return;
                                  Navigator.pop(context);
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        success
                                            ? 'Profil berhasil diperbarui'
                                            : 'Gagal memperbarui profil',
                                      ),
                                    ),
                                  );
                                  if (success) {
                                    setState(() {
                                      _userFuture = _userRepository
                                          .fetchUserProfile();
                                    });
                                  }
                                } catch (e) {
                                  if (!mounted) return;
                                  setModalState(() => isSaving = false);
                                  messenger.showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                }
                              },
                        child: isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Simpan Perubahan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _modalInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey[50],
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
        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
      ),
    );
  }

  void _showLanguageDialog() {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.selectLanguage,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Text("🇺🇸", style: TextStyle(fontSize: 24)),
                title: const Text("English"),
                trailing: Localizations.localeOf(context).languageCode == 'en'
                    ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                    : null,
                onTap: () {
                  context.read<LocaleCubit>().setLocale('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Text("🇮🇩", style: TextStyle(fontSize: 24)),
                title: const Text("Bahasa Indonesia"),
                trailing: Localizations.localeOf(context).languageCode == 'id'
                    ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                    : null,
                onTap: () {
                  context.read<LocaleCubit>().setLocale('id');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
