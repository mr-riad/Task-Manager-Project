import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/email_varification_controller.dart';
import '../widget/center_circular_progress_bar.dart';
import '../widget/screen_background.dart';

class Emailvarification extends StatefulWidget {
  const Emailvarification({super.key});

  static const String name = '/emailvarification';

  @override
  State<Emailvarification> createState() => _EmailvarificationState();
}

class _EmailvarificationState extends State<Emailvarification> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmailVerificationController>(
      builder: (controller) {
        return Scaffold(
          body: ScreenBackground(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsGeometry.all(25),
                child: Form(
                  key: _key,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Text(
                        'Your Email Address',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'A 6 digit varification pin will sent to your\nemail address',
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),

                      const SizedBox(height: 24),

                      TextFormField(
                        controller: controller.email,
                        decoration: InputDecoration(hintText: 'Email'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!EmailValidator.validate(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      Center(
                        child: Column(
                          children: [
                            Visibility(
                              visible: controller.isLoading == false,
                              replacement: CenteredCircularProgressIndicator(),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_key.currentState!.validate()) {
                                    controller.getOtpMail(context);
                                  }
                                },
                                child: Icon(Icons.arrow_circle_right_outlined),
                              ),
                            ),

                            const SizedBox(height: 8),

                            RichText(
                              text: TextSpan(
                                text: 'Have account? ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.4,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign In',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () =>
                                          controller.onTapSignInButton(context),
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