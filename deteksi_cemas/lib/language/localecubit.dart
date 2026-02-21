import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  // Default to English
  LocaleCubit() : super(const Locale('en')) {
    _loadStoredLocale();
  }

  // Save and change language
  Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    emit(Locale(languageCode));
  }

  // Load language when app starts
  Future<void> _loadStoredLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('language_code') ?? 'id';
    emit(Locale(code));
  }
}
