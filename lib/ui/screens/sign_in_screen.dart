import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/sign_in_controller.dart';
import '../widget/center_circular_progress_bar.dart';
import '../widget/screen_background.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String name = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInController>(
      builder: (controller) {
        return Scaffold(
          body: ScreenBackground(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsGeometry.all(20),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Text(
                        'Get Started With',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),

                      const SizedBox(height: 24),
                      TextFormField(
                        controller: controller.emailController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(hintText: 'Email'),
                        validator: (String? value) {
                          String email = value ?? '';
                          if (EmailValidator.validate(email) == false) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => controller.toggleObscurePassword(),
                          ),
                        ),

                        validator: (String? value) {
                          if ((value?.length ?? 0) <= 6) {
                            return 'Enter a valid password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: controller.isLoading == false,
                        replacement: CenteredCircularProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.signIn(context);
                            }
                          },
                          child: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),

                      const SizedBox(height: 32),

                      Center(
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () =>
                                  controller.onTapForgetPassword(context),
                              child: Text(
                                'Forget Password?',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),

                            RichText(
                              text: TextSpan(
                                text: 'Don\'t have an account? ',
                                style: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 0.4,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () =>
                                          controller.onTapSignUpButton(context),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}