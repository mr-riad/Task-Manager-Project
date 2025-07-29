import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/ui/screens/EmailPinVarification.dart';
import 'package:task_manager/widget/Center_circular_progress_bar.dart';
import '../../Model/Verification_Data_Model.dart';
import '../../Network/network_caller.dart';
import '../../widget/ScreenBackground.dart';
import '../../widget/Snackbar_Messages.dart';
import '../utils/urls.dart';
import 'Sign_in_screen.dart';

class Emailvarification extends StatefulWidget {
  const Emailvarification({super.key});

  static const String name = '/emailvarification';

  @override
  State<Emailvarification> createState() => _EmailvarificationState();
}

class _EmailvarificationState extends State<Emailvarification> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _emailisLoading = false;

  @override
  Widget build(BuildContext context) {
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
                    controller: _emailController,
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
                          visible: _emailisLoading == false,
                          replacement: CenteredCircularProgressIndicator(),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_key.currentState!.validate()) {
                                _getOtpMail();
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
                                  ..onTap = _onTapSignInButton,
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
  }

  void _onTapSignInButton() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignInScreen.name,
          (predicate) => false,
    );
  }

  Future<void> _getOtpMail() async {
    _emailisLoading = true;
    if (mounted) {
      setState(() {});
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token') ?? '';

    NetworkResponse response = await networkCaller.getRequest(
      url: urls.RecoverVerifyEmailUrl(_emailController.text.trim()),
    );
    if (response.isSuccess) {
      VerificationDataModel emailVerificationDataModel =
      VerificationDataModel.fromJson(response.body!);

      String getStatus = emailVerificationDataModel.status ?? '';
      String getData = emailVerificationDataModel.data ?? '';

      if (getStatus == 'success') {
        _emailisLoading = false;
        SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
        sharedPreferences.setString('email', _emailController.text.trim());
        if (mounted) {
          _emailController.clear();
          showSnackBarMessage(context, "$getStatus $getData");
          await Future.delayed(Duration(seconds: 1));
          await Navigator.pushNamedAndRemoveUntil(
            context,
            Emailpinvarification.name,
                (predicate) => false,
          );
        }
      } else {
        if (mounted) {
          _emailisLoading = false;
          showSnackBarMessage(context, "$getStatus $getData");
        }
      }
    } else {
      if (mounted) {
        _emailisLoading = false;
        showSnackBarMessage(context, response.errorMessage!);
      }
    }

    _emailisLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}