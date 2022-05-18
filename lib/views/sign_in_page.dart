import 'package:assignment_app/controller/validation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../model/validation_model.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  final authController = Get.find<ValidationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(
        () => authController.loading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: Get.size.width - 70,
                      height: 55,
                      child: Obx(
                        () => TextFormField(
                          onChanged: (str) {
                            authController.email.value =
                                ValidationModel(str, null);
                          },
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            errorText: authController.email.value.error,
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
                            authController.password.value =
                                ValidationModel(str, null);
                          },
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            errorText: authController.password.value.error,
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
                    InkWell(
                      onTap: () async {
                        authController.login();
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
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('New user? Click here.'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
