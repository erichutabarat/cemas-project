import 'package:deteksi_cemas/features/dashboard/domain/services/token_service.dart';
import 'package:deteksi_cemas/l10n/app_localizations.dart';
import 'package:deteksi_cemas/language/localecubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatefulWidget {
  final ScrollController? controller;
  const SettingScreen({super.key, this.controller});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // Mock user data for the profile card
  String userName = "Jane Doe";
  String userEmail = "jane.doe@example.com";
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigating to $title... (Placeholder)')),
    );
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.3),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // User Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userEmail,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Edit Button
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => _onNavigate('Edit Profile'),
                  ),
                ],
              ),
            ),
          ),
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
              backgroundColor: Colors.red.shade400,
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
              'App Version 1.0.0',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
        ),
      ],
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
