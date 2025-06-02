import 'package:flutter/material.dart';

import '../models/onboarding_page_model.dart';
import '../utils/Text_styles.dart';
import '../utils/widgets/button_neomorphic.dart';
import '../utils/widgets/logo_neomorphic.dart';
import 'sign_in_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static List<OnboardingPage> pages = [
    OnboardingPage(
      icon: Icon(Icons.people_alt_outlined, size: 80, color: Colors.blueGrey[800]),
      headline: 'Welcome to User Hub',
      text: 'A modern user management application with DummyJSON API integration and elegant neomorphic design',
    ),
    OnboardingPage(
      icon: Icon(Icons.data_array_outlined, size: 80, color: Colors.blueGrey[800]),
      headline: 'API Integration',
      text: 'Connected with DummyJSON Users API with pagination, search functionality, and access to user posts and todos',
    ),
    OnboardingPage(
      icon: Icon(Icons.architecture, size: 80, color: Colors.blueGrey[800]),
      headline: 'BLoC Architecture',
      text: 'Built with BLoC for efficient state management, handling loading, success, and error states with clean separation of concerns',
    ),
    OnboardingPage(
      icon: Icon(Icons.featured_play_list_outlined, size: 80, color: Colors.blueGrey[800]), 
      headline: 'Feature Rich',
      text: 'Explore users with infinite scrolling, search functionality, view user details, posts, and todos all in one application',
    ),
  ];

  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: PageView.builder(
        controller: _pageController,
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return buildIsomorphicStarterPages(
              pages,
              index
            );
        }
      ),
    );
  }
  
  
  Widget buildIsomorphicStarterPages(List<OnboardingPage> pages, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          // Logo
          neomorphicLogo(pages[index].icon),

          const SizedBox(height: 50),

          // Title
          Text(
            pages[index].headline ?? '',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),

          // Subtitle
          Text(
            pages[index].text ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey[600],
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 80),

          // Sign in button
          neomorphicButton(
            onPressed: () {
              (index < pages.length-1) ? 
              // Go to next page 
              _pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              )
              :{
                //navigate to login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SigninPage()),
                ),
              };
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_forward),
                const SizedBox(width: 12),
                Text(
                  (index < pages.length-1) ? "Next":"Sign In",
                  style: getTextStyle(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          if (index < pages.length-1)
          TextButton(
            onPressed: () {
              _pageController.animateToPage(
                pages.length,  // Skip to last page
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
            child: Text(
              "Skip",
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[400],
                fontFamily: 'Poppins',
              ),
            ),
          )
        ],
      ),
    );
  }
}
