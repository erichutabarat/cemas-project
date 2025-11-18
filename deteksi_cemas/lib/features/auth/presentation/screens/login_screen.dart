// Ini adalah file screen Anda, misal: login_screen.dart
import 'package:deteksi_cemas/features/auth/presentation/states/auth_bloc.dart';
import 'package:deteksi_cemas/features/auth/presentation/states/auth_event.dart';
import 'package:deteksi_cemas/features/auth/presentation/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deteksi_cemas/features/auth/presentation/widget/appname_sketch.dart'; // Ganti path ini

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
      LoginButtonPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final blueContainerHeight = screenHeight * 0.3;
    final overlapAmount = 50.0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login Berhasil!'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },

        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                height: blueContainerHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8E6AD8), Color(0xFF6AD8E0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: appNameSketch(),
              ),

              Positioned(
                top: blueContainerHeight - overlapAmount,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
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
                      Center(
                        child: Text(
                          'Login Your Account',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "youremail@example.com",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,

                        child: (state is AuthLoading)
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed:
                                    _onLoginPressed, // Panggil fungsi helper
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  backgroundColor: Color(0xFF8E6AD8),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed("/register");
                        },
                        child: Text(
                          'Don\'t have an account? Register here',
                          style: TextStyle(color: Colors.grey[700]),
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
          );
        },
      ),
    );
  }
}
