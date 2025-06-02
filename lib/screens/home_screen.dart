import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_hub/auth/bloc/auth_event.dart';

import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_state.dart';
import '../utils/widgets/dialog_neomorphic.dart';
import 'onboarding_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  void _confirmLogout() async {
    final shouldLogout = await showNeomorphicDialog(
      context: context, 
      title: 'Logout Confirmation', 
      content: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
      icon: Icons.logout,
      iconColor: Colors.red[700],
    );
    
    if (shouldLogout && mounted) {
      context.read<AuthBloc>().add(LogoutRequested());
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc,AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('ChatBot'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.blueGrey[800],
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: _confirmLogout,
            ),
          ],
        ),
        body: Column(
          children: [
            Text('hello world'),
          ],
        ),
      ),
    );
  }
}