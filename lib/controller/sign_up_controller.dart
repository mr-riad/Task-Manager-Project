import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../network/network_caller.dart';
import '../ui/screens/sign_in_screen.dart';
import '../ui/utils/urls.dart';
import '../ui/widget/snackbar_messages.dart';

class SignUpController extends GetxController {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _phoneTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  TextEditingController get emailTEController => _emailTEController;

  TextEditingController get firstNameTEController => _firstNameTEController;

  TextEditingController get lastNameTEController => _lastNameTEController;

  TextEditingController get phoneTEController => _phoneTEController;

  TextEditingController get passwordTEController => _passwordTEController;

  bool get isLoading => _isLoading;

  bool get obscurePassword => _obscurePassword;

  Future<void> SignUp(BuildContext context) async {
    _isLoading = true;
    update();

    Map<String, String> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _phoneTEController.text.trim(),
      "password": _passwordTEController.text,
    };

    NetworkResponse response = await networkCaller.postRequest(
      url: urls.SignupUrl,
      body: requestBody,
    );

    _isLoading = false;
    update();

    if (response.isSuccess) {
      clearTextFields();
      showSnackBarMessage(
        context,
        'Registration has been success. Please login',
      );
      await Navigator.pushNamedAndRemoveUntil(
        context,
        SignInScreen.name,
            (predicate) => false,
      );
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
  }

  void clearTextFields() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _phoneTEController.clear();
    _passwordTEController.clear();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    update();
  }

  void onTapSignInButton(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void onClose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _phoneTEController.dispose();
    _passwordTEController.dispose();
    super.onClose();
  }
}