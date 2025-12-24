import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modernlogintute/Login/login_or_register_page.dart';
import 'package:modernlogintute/home_page/home_page.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loading indicator
          }

          if (snapshot.hasError) {
            return const Center(child: Text("An error occurred. Please try again."));
          }

          if (snapshot.hasData) {
            return HomePage(); // User is logged in
          } else {
            return LoginOrRegisterPage(); // User not logged in
          }
        },
      ),
    );
  }
}
