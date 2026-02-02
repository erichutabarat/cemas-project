import 'package:deteksi_cemas/features/auth/presentation/states/register_bloc.dart';
import 'package:deteksi_cemas/features/auth/presentation/states/register_event.dart';
import 'package:deteksi_cemas/features/auth/presentation/states/register_state.dart';
import 'package:deteksi_cemas/features/auth/presentation/widget/appname_sketch.dart';
import 'package:deteksi_cemas/l10n/app_localizations.dart';
import 'package:deteksi_cemas/theme/app_theme.dart';
import 'package:deteksi_cemas/theme/color_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender;
  final List<String> _genders = ['Male', 'Female'];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final blueContainerHeight = screenHeight * 0.3;
    final overlapAmount = 50.0;

    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration Successful!')),
            );
            Navigator.of(context).pushReplacementNamed("/login");
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is RegisterLoading;

          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Stack(
              fit: StackFit.expand,
              children: [
                // Background Gradient Header
                Container(
                  height: blueContainerHeight,
                  decoration: const BoxDecoration(
                    gradient: AppTheme.softChillReversed,
                  ),
                  child: appNameSketch(),
                ),

                // Main Content Card
                Positioned(
                  top: blueContainerHeight - overlapAmount,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(24.0),
                      children: [
                        const Center(
                          child: Text(
                            'Register Your Account',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Name Field
                        TextField(
                          controller: _nameController,
                          enabled: !isLoading,
                          decoration: const InputDecoration(
                            labelText: "Full Name",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Gender Field
                        DropdownButtonFormField<String>(
                          initialValue: _selectedGender,
                          decoration: const InputDecoration(
                            labelText: "Gender",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.wc),
                          ),
                          items: _genders.map((String gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: isLoading
                              ? null
                              : (val) => setState(() => _selectedGender = val),
                        ),
                        const SizedBox(height: 16),

                        // Birthdate Field
                        TextField(
                          controller: _birthDateController,
                          readOnly: true,
                          enabled: !isLoading,
                          decoration: const InputDecoration(
                            labelText: "Birthdate",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () => _selectDate(context),
                        ),
                        const SizedBox(height: 16),

                        // Email Field
                        TextField(
                          controller: _emailController,
                          enabled: !isLoading,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          enabled: !isLoading,
                          decoration: const InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Confirm Password Field
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          enabled: !isLoading,
                          decoration: const InputDecoration(
                            labelText: "Confirm Password",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock_reset),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Main Action Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (_selectedDate == null ||
                                        _selectedGender == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Please fill in all fields",
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    context.read<RegisterBloc>().add(
                                      RegisterSubmitted(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        confirmPassword:
                                            _confirmPasswordController.text,
                                        birthDate: _selectedDate!,
                                        gender: _selectedGender!,
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: ColorList.emeraldBLue,
                              foregroundColor: Colors.white,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Login Link
                        TextButton(
                          onPressed: () => Navigator.of(
                            context,
                          ).pushReplacementNamed("/login"),
                          child: Text(
                            l10n.have_account,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),

                        // Divider or "OR" text could go here
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text(
                              "OR",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),

                        // Google Sign Up
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  /* Google Auth Logic */
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                'https://developers.google.com/identity/images/g-logo.png',
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Sign Up with Google',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
