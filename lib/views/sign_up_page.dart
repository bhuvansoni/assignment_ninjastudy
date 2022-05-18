import 'package:assignment_app/controller/validation_controller.dart';
import 'package:assignment_app/model/validation_model.dart';
import 'package:assignment_app/views/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';

class SignUpUI extends StatefulWidget {
  const SignUpUI({Key? key}) : super(key: key);

  @override
  State<SignUpUI> createState() => _SignUpUIState();
}

class _SignUpUIState extends State<SignUpUI> {
  final validationController = Get.put(ValidationController());

  bool circular = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => validationController.loading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      buttonItem(
                          "assets/google.svg", "Continue with Google", 25,
                          () async {
                        await validationController.googleSignIn(context);
                        // await authClass.googleSignIn(context);
                      }),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Or",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: Get.size.width - 70,
                        height: 55,
                        child: Obx(
                          () => TextFormField(
                            onChanged: (str) {
                              validationController.email.value =
                                  ValidationModel(str, null);
                            },
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              errorText: validationController.email.value.error,
                              errorMaxLines: 2,
                              hintText: "Email",
                              hintStyle: const TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                      SizedBox(
                        width: Get.size.width - 70,
                        height: 55,
                        child: Obx(
                          () => TextFormField(
                            onChanged: (str) {
                              validationController.password.value =
                                  ValidationModel(str, null);
                            },
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              errorText:
                                  validationController.password.value.error,
                              errorMaxLines: 2,
                              hintText: "Password",
                              labelStyle: const TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      colorButton("Sign Up"),
                      const SizedBox(
                        height: 15,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(SignInPage());
                        },
                        child:
                            const Text('Already have an account? Click here.'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget buttonItem(
      String imagePath, String buttonName, double size, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: Get.size.width - 60,
        height: 60,
        child: Card(
          elevation: 8,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(
                width: 1,
                color: Colors.grey,
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SvgPicture.asset(
              //   imagePath,
              //   height: size,
              //   width: size,
              // ),
              const SizedBox(
                width: 15,
              ),
              Text(
                buttonName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textItem(
      String name, TextEditingController controller, bool obsecureText) {
    return SizedBox(
      width: Get.size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
        obscureText: obsecureText,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: name,
          labelStyle: const TextStyle(
            fontSize: 17,
            color: Colors.black,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1.5,
              color: Colors.amber,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget colorButton(String name) {
    return InkWell(
      onTap: () async {
        validationController.submit();
        // authController.emailAndPasswordSignIn();
        // try {
        //   firebase_auth.UserCredential userCredential =
        //       await firebaseAuth.createUserWithEmailAndPassword(
        //           email: _emailController.text,
        //           password: _passwordController.text);
        //   print(userCredential.user.email);
        //   setState(() {
        //     circular = false;
        //   });
        //   Navigator.pushAndRemoveUntil(
        //       context,
        //       MaterialPageRoute(builder: (builder) => const HomePage()),
        //       (route) => false);
        // } catch (e) {
        //   final snackbar = SnackBar(content: Text(e.toString()));
        //   ScaffoldMessenger.of(context).showSnackBar(snackbar);
        //   setState(() {
        //     circular = false;
        //   });
        // }
      },
      child: Container(
        width: Get.size.width - 90,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(colors: [
            Color(0xFFFD746C),
            Color(0xFFFF9068),
            Color(0xFFFD746C),
          ]),
        ),
        child: Center(
          child: circular
              ? const CircularProgressIndicator()
              : Text(name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  )),
        ),
      ),
    );
  }
}
