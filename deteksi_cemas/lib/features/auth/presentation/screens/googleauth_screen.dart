import 'package:deteksi_cemas/features/auth/presentation/states/googleauth_bloc.dart';
import 'package:deteksi_cemas/features/auth/presentation/states/googleauth_event.dart';
import 'package:deteksi_cemas/features/auth/presentation/states/googleauth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleAuthLoadingScreen extends StatefulWidget {
  const GoogleAuthLoadingScreen({super.key});

  @override
  State<GoogleAuthLoadingScreen> createState() =>
      _GoogleAuthLoadingScreenState();
}

class _GoogleAuthLoadingScreenState extends State<GoogleAuthLoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger the sign-in immediately when the screen opens
    context.read<GoogleAuthBloc>().add(GoogleSignInPressed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<GoogleAuthBloc, GoogleAuthState>(
        listener: (context, state) {
          if (state is GoogleAuthSuccess) {
            Navigator.pushReplacementNamed(
              context,
              '/dashboard',
              arguments: {'userName': state.name},
            );
          } else if (state is GoogleAuthNeedsRegistration) {
            Navigator.pushReplacementNamed(
              context,
              '/register',
              arguments: {'email': state.email, 'name': state.name},
            );
          } else if (state is GoogleAuthFailure) {
            // If it fails, go back to login and show error
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                "Verifying with Google...",
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
