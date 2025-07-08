import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/auth/bloc/auth_bloc.dart';
import 'package:travel/auth/bloc/auth_event.dart';
import 'package:travel/auth/bloc/auth_state.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  RegisterPage({super.key});

  void _navigateWithFade(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: page,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text("👤 Register")),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, "/tasks");
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          "assets/todo.png",
                          height: screenHeight * 0.25,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 32),
                        TextField(
                          controller: emailCtrl,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: passCtrl,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  AuthRegisterRequested(
                                    emailCtrl.text.trim(),
                                    passCtrl.text.trim(),
                                  ),
                                );
                          },
                          icon: const Icon(Icons.app_registration),
                          label: const Text("Register"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            _navigateWithFade(context, const LoginPage());
                          },
                          child: const Text("🔐 Already have an account? Login"),
                        ),
                        if (state is AuthLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
