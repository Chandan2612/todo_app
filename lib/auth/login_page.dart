import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/auth/bloc/auth_bloc.dart';
import 'package:travel/auth/bloc/auth_event.dart';
import 'package:travel/auth/bloc/auth_state.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  void _navigateWithFade(Widget page) {
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
      appBar: AppBar(title: const Text("🔐 Login")),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                ),
                behavior: SnackBarBehavior.floating,
                elevation: 8,
              ),
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
                                  AuthLoginRequested(
                                    emailCtrl.text.trim(),
                                    passCtrl.text.trim(),
                                  ),
                                );
                          },
                          icon: const Icon(Icons.login),
                          label: const Text("Login"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            _navigateWithFade(RegisterPage());
                          },
                          child: const Text("👤 Don't have an account? Register"),
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
