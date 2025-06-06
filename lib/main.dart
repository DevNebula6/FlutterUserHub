import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_hub/auth/auth_service.dart';
import 'package:flutter_user_hub/auth/bloc/auth_event.dart';
import 'package:flutter_user_hub/auth/bloc/auth_state.dart';
import 'package:flutter_user_hub/repositories/user_repository.dart';
import 'package:flutter_user_hub/screens/home_screen.dart';
import 'package:flutter_user_hub/user/bloc/user_bloc.dart';

import 'auth/bloc/auth_bloc.dart';
import 'screens/onboarding_page.dart';
import 'user/bloc/user_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  final userRepository = UserRepository();
  
  runApp(
    MultiBlocProvider(
      providers: [
        RepositoryProvider<UserRepository>(
        create: (context) => userRepository,
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authService: authService)..add(CheckAuthStatus()),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userRepository: userRepository)..add(const UserFetchRequested()),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Hub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return Scaffold(
              backgroundColor: Colors.grey[200],
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Initializing...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey[600],
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is Unauthenticated) {
            return const OnboardingScreen();
          } else if (state is Authenticated) {
            return const HomeScreen();
          } else {
            return const OnboardingScreen();
          }
        },
      ),
    );
  }
}