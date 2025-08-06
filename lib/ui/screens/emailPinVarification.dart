import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../controller/email_pin_varification_controller.dart';
import '../widget/center_circular_progress_bar.dart';
import '../widget/screen_background.dart';

class Emailpinvarification extends StatefulWidget {
  const Emailpinvarification({super.key});

  static const String name = '/emailpinvarification';

  @override
  State<Emailpinvarification> createState() => _EmailpinvarificationState();
}

class _EmailpinvarificationState extends State<Emailpinvarification> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmailPinVerificationController>(
      builder: (controller) {
        return Scaffold(
          body: ScreenBackground(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _key,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Text(
                        'Pin Verification',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'A 6 digits OTP has been sent to your email address',
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      PinCodeTextField(
                        length: 6,
                        animationType: AnimationType.fade,
                        keyboardType: TextInputType.number,
                        // autoDismissKeyboard: false,
                        // autoFocus: true,
                        // focusNode: _focusNode,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 50,
                          activeFillColor: Colors.white,
                          selectedColor: Colors.green,
                          inactiveColor: Colors.grey,
                        ),
                        animationDuration: Duration(milliseconds: 300),
                        backgroundColor: Colors.transparent,
                        controller: controller.otpTEController,
                        appContext: context,
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: controller.isLoading == false,
                        replacement: CenteredCircularProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: () => controller.OtpVerification(context),
                          child: Text('Verify'),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Have an account? ",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
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