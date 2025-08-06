import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';
import '../network/network_caller.dart';
import '../ui/screens/emailVarification.dart';
import '../ui/screens/main_navbar_screen.dart';
import '../ui/screens/sign_up_screen.dart';
import '../ui/utils/urls.dart';
import '../ui/widget/snackbar_messages.dart';
import 'auth_controller.dart';

class SignInController extends GetxController {
  bool _isLoading = false;
  String? errorMessage;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  bool get obscurePassword => _obscurePassword;

  bool get isLoading => _isLoading;

  bool get isObscurePassword => _obscurePassword;

  TextEditingController get emailController => _emailController;

  TextEditingController get passwordController => _passwordController;

  set obscurePassword(bool value) {
    _obscurePassword = value;
    update();
  }

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    update();
  }

  void onTapForgetPassword(BuildContext context) {
    Navigator.pushNamed(context, Emailvarification.name);
  }

  void onTapSignUpButton(BuildContext context) {
    Navigator.pushNamed(context, SignUpScreen.name);
  }

  Future<void> signIn(BuildContext context) async {
    _isLoading = true;
    update();

    Map<String, String> requestBody = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text,
    };
    NetworkResponse response = await networkCaller.postRequest(
      url: urls.LoginUrl,
      body: requestBody,
      isFromLogin: true,
    );

    if (response.isSuccess) {
      update();
      UserModel userModel = UserModel.fromJson(response.body!['data']);
      String token = response.body!['token'];

      await AuthController.saveUserData(userModel, token);
      showSnackBarMessage(context, 'Login successful');

      await Navigator.pushNamedAndRemoveUntil(
        context,
        MainNavbarScreen.name,
            (predicate) => false,
      );
      _emailController.clear();
      _passwordController.clear();
      _isLoading = false;
      update();
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }

    _isLoading = false;
    update();
  }

  @override
  void onClose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.onClose();
  }
}