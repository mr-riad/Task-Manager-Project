import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/verification_data_model.dart';
import '../network/network_caller.dart';
import '../ui/screens/setPassword.dart';
import '../ui/screens/sign_in_screen.dart';
import '../ui/utils/urls.dart';
import '../ui/widget/snackbar_messages.dart';

class EmailPinVerificationController extends GetxController {
  final TextEditingController _otpTEController = TextEditingController();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  TextEditingController get otpTEController => _otpTEController;

  Future<void> OtpVerification(BuildContext context) async {
    _isLoading = true;
    update();

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
        _isLoading = false;
        update();
        _otpTEController.clear();
        showSnackBarMessage(context, "$getStatus $getData");
        showSnackBarMessage(context, 'Please set your new password');
        await Future.delayed(Duration(seconds: 1));
        await Navigator.pushNamedAndRemoveUntil(
          context,
          Setpassword.name,
              (predicate) => false,
        );
        _isLoading = false;
        update();
      } else {
        _isLoading = false;
        showSnackBarMessage(context, "$getStatus $getData");
      }
    } else {
      _isLoading = false;
      showSnackBarMessage(context, response.errorMessage!);
    }

    _isLoading = false;
    update();
  }

  void onTapSignInButton(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignInScreen.name,
          (predicate) => false,
    );
  }

  @override
  void onClose() {
    _otpTEController.dispose();
    super.onClose();
  }
}