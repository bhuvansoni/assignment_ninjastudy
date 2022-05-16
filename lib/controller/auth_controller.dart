import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/home_page.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordError = ''.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        try {
          await auth.signInWithCredential(credential);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => HomePage()),
              (route) => false);
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      } else {
        final snackbar = SnackBar(content: Text("Not Able to sign In "));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> emailAndPasswordSignIn() async {
    if (emailController.text.isEmpty || !emailController.text.isEmail) {
      Get.snackbar('Email Cannot be Empty!', 'Please change',
          snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 2));
      return;
    }
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    bool has = regExp.hasMatch(passwordController.text);
    if (!has) {
      Get.snackbar('Weak Password', 'Please change',
          snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 2));
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', emailController.text);
    await prefs.setString('password', passwordController.text);
    await auth.signInAnonymously();
    Get.back();
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Get.back();
    } catch (e) {}
  }

  void showSnackBar(BuildContext context, String text) {
    final snackbar = SnackBar(content: Text(text.toString()));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
