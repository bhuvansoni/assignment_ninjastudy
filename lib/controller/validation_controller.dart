import 'package:assignment_app/model/validation_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/home_page.dart';

class ValidationController extends GetxController {
  final loading = false.obs;
  final email = ValidationModel(null, null).obs;
  final password = ValidationModel(null, null).obs;

  Future<void> submit() async {
    print('here');
    print(password.value.data);
    print(email.value.data);
    bool validEmail = false;
    bool validPassword = false;
    if (password.value.data!.isNotEmpty) {
      String pattern =
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      RegExp regExp = RegExp(pattern);
      bool has = regExp.hasMatch(password.value.data!);
      if (has) {
        password.value = ValidationModel(password.value.data, null);
        validPassword = true;
      } else {
        password.value = ValidationModel(password.value.data,
            'Password should contain 1 Uppercase, 1 Lowercase, 1 number and a special character.');
      }
    } else {
      password.value =
          ValidationModel(password.value.data, 'Password cannot be empty');
    }

    if (email.value.data!.isNotEmpty) {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email.value.data!);
      if (emailValid) {
        email.value = ValidationModel(email.value.data, null);
        validEmail = true;
      } else {
        email.value = ValidationModel(
            email.value.data, 'Please enter a valid email address.');
      }
    } else {
      email.value = ValidationModel(email.value.data, 'Email cannot be empty');
    }

    if (validPassword && validEmail) {
      print('yes');
      loading(true);
      await emailAndPasswordSignIn();
      loading(false);
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> googleSignIn(BuildContext context) async {
    loading(true);
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
    loading(false);
  }

  Future<void> emailAndPasswordSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email.value.data!);
    await prefs.setString('password', email.value.data!);
    await auth.signInAnonymously();
    Get.back();
  }

  Future<void> logout() async {
    // if (_googleSignIn.currentUser == null) {
    //   await auth.signOut();
    // }
    try {
      await auth.signOut();
    } catch (e) {
      print('in catch block');
      print(e);
    }
  }

  Future<void> login() async {
    print('here');
    print(password.value.data);
    print(email.value.data);
    bool validEmail = false;
    bool validPassword = false;
    if (password.value.data!.isNotEmpty) {
      String pattern =
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      RegExp regExp = RegExp(pattern);
      bool has = regExp.hasMatch(password.value.data!);
      if (has) {
        password.value = ValidationModel(password.value.data, null);
        validPassword = true;
      } else {
        password.value = ValidationModel(password.value.data,
            'Password should contain 1 Uppercase, 1 Lowercase, 1 number and a special character.');
      }
    } else {
      password.value =
          ValidationModel(password.value.data, 'Password cannot be empty');
    }

    if (email.value.data!.isNotEmpty) {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email.value.data!);
      if (emailValid) {
        email.value = ValidationModel(email.value.data, null);
        validEmail = true;
      } else {
        email.value = ValidationModel(
            email.value.data, 'Please enter a valid email address.');
      }
    } else {
      email.value = ValidationModel(email.value.data, 'Email cannot be empty');
    }

    if (validPassword && validEmail) {
      print('yes');
      loading(true);
      await emailAndPasswordSignIn();
      loading(false);
    }
  }
}
