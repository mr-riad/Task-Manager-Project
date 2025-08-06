import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/verification_data_model.dart';
import '../network/network_caller.dart';
import '../ui/screens/sign_in_screen.dart';
import '../ui/utils/urls.dart';
import '../ui/widget/snackbar_messages.dart';


class SetPasswordController extends GetxController {
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _ConfirmobscurePassword = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ConfirmpasswordController =
  TextEditingController();

  bool get isLoading => _isLoading;

  TextEditingController get passwordController => _passwordController;

  TextEditingController get ConfirmpasswordController =>
      _ConfirmpasswordController;

  bool get obscurePassword => _obscurePassword;
  bool get ConfirmobscurePassword => _ConfirmobscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    update();
  }

  void toggleConfirmPasswordVisibility() {
    _ConfirmobscurePassword = !_ConfirmobscurePassword;
    update();
  }

  Future<void> resetPassword(BuildContext context) async {
    _isLoading = true;
    update();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> requestBody = {
      "email": prefs.getString('email') ?? '',
      "OTP": prefs.getString('UserOtp') ?? '',
      "password": _ConfirmpasswordController.text,
    };
    NetworkResponse response = await networkCaller.postRequest(
      url: urls.ResetPasswordUrl,
      body: requestBody,
      isFromLogin: false,
    );

    if (response.isSuccess) {
      VerificationDataModel PasswordResetVerificationDataModel =
      VerificationDataModel.fromJson(response.body!);

      String getStatus = PasswordResetVerificationDataModel.status ?? '';
      String getData = PasswordResetVerificationDataModel.data ?? '';

      if (getStatus == 'success') {
        _isLoading = false;

        _passwordController.clear();
        _ConfirmpasswordController.clear();
        showSnackBarMessage(context, "$getStatus $getData");
        showSnackBarMessage(context, 'Please Sign In With New Password');
        await Future.delayed(Duration(seconds: 1));
        await Navigator.pushNamedAndRemoveUntil(
          context,
          SignInScreen.name,
              (predicate) => false,
        );
      } else {
        _isLoading = false;
        showSnackBarMessage(context, "$getStatus $getData");
        update();
      }
    } else {
      _isLoading = false;
      showSnackBarMessage(context, response.errorMessage!);
      update();
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
    _passwordController.dispose();
    _ConfirmpasswordController.dispose();
    super.onClose();
  }
}