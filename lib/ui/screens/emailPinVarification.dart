import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/ui/screens/SetPassword.dart';
import 'package:task_manager/ui/screens/Sign_in_screen.dart';
import 'package:task_manager/widget/Center_circular_progress_bar.dart';
import '../../Model/Verification_Data_Model.dart';
import '../../Network/network_caller.dart';
import '../../widget/ScreenBackground.dart';
import '../../widget/Snackbar_Messages.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../utils/urls.dart';

class Emailpinvarification extends StatefulWidget {
  const Emailpinvarification({super.key});

  static const String name = '/emailpinvarification';

  @override
  State<Emailpinvarification> createState() => _EmailpinvarificationState();
}

class _EmailpinvarificationState extends State<Emailpinvarification> {
  final TextEditingController _otpTEController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _OtpisLoading = false;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
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
                    controller: _otpTEController,
                    appContext: context,
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _OtpisLoading == false,
                    replacement: CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: () => _OtpVerification(),
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
                              ..onTap = _onTapSignInButton,
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
  }

  void _onTapSubmitButton() {
    // if (_formKey.currentState!.validate()) {
    //   // TODO: Sign in with API
    // }
    Navigator.pushNamed(context, Setpassword.name);
  }

  void _onTapSignInButton() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignInScreen.name,
          (predicate) => false,
    );
  }

  Future<void> _OtpVerification() async {
    _OtpisLoading = true;
    if (mounted) {
      setState(() {});
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? Email = sharedPreferences.getString('email') ?? '';
    await sharedPreferences.setString('UserOtp', _otpTEController.text.trim());

    NetworkResponse response = await networkCaller.getRequest(
      url: urls.VeriftOtpdUrl(Email, _otpTEController.text.trim()),
    );
    if (response.isSuccess) {
      VerificationDataModel emailPinVerificationDataModel =
      VerificationDataModel.fromJson(response.body!);

      String getStatus = emailPinVerificationDataModel.status ?? '';
      String getData = emailPinVerificationDataModel.data ?? '';

      if (getStatus == 'success') {
        _OtpisLoading = false;
        if (mounted) {
          _otpTEController.clear();
          showSnackBarMessage(context, "$getStatus $getData");
          showSnackBarMessage(context, 'Please set your new password');
          await Future.delayed(Duration(seconds: 1));
          await Navigator.pushNamedAndRemoveUntil(
            context,
            Setpassword.name,
                (predicate) => false,
          );
        }
      } else {
        if (mounted) {
          _OtpisLoading = false;
          showSnackBarMessage(context, "$getStatus $getData");
        }
      }
    } else {
      if (mounted) {
        _OtpisLoading = false;
        showSnackBarMessage(context, response.errorMessage!);
      }
    }

    _OtpisLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // _otpTEController.dispose();
    super.dispose();
  }
}