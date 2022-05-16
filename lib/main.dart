import 'package:assignment_app/views/home_page.dart';
import 'package:assignment_app/views/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        builder: ((context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return HomePage();
            } else {
              return SignUpUI();
            }
          } else {
            return SignUpUI();
          }
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
        stream: FirebaseAuth.instance.authStateChanges(),
      ),
    );
  }
}
