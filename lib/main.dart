import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/auth/bloc/auth_bloc.dart';
import 'package:travel/auth/login_page.dart';
import 'package:travel/auth/register_page.dart';
import 'package:travel/tasks/bloc/task_bloc.dart';
import 'package:travel/tasks/task_page.dart';
import 'package:travel/core/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => AuthBloc()),
      BlocProvider(create: (_) => TaskBloc()),
      BlocProvider(create: (_) => ThemeCubit()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: themeMode,
          initialRoute: FirebaseAuth.instance.currentUser == null ? "/login" : "/tasks",
          routes: {
            "/login": (_) => const LoginPage(),
            "/register": (_) => RegisterPage(),
            "/tasks": (_) => const TaskPage(),
          },
        );
      },
    );
  }
}
