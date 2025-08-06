import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/verification_data_model.dart';
import '../network/network_caller.dart';
import '../ui/screens/emailPinVarification.dart';
import '../ui/screens/sign_in_screen.dart';
import '../ui/utils/urls.dart';
import '../ui/widget/snackbar_messages.dart';

class EmailVerificationController extends GetxController {
  bool _isLoading = false;
  final TextEditingController _email = TextEditingController();

  bool get isLoading => _isLoading;

  TextEditingController get email => _email;

  Future<void> getOtpMail(BuildContext context) async {
    _isLoading = true;
    update();

    NetworkResponse response = await networkCaller.getRequest(
      url: urls.RecoverVerifyEmailUrl(email.text.trim()),
    );
    if (response.isSuccess) {
      VerificationDataModel emailVerificationDataModel =
      VerificationDataModel.fromJson(response.body!);

      String getStatus = emailVerificationDataModel.status ?? '';
      String getData = emailVerificationDataModel.data ?? '';

      if (getStatus == 'success') {
        _isLoading = false;
        SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
        sharedPreferences.setString('email', email.text.trim());

        email.clear();
        showSnackBarMessage(context, "$getStatus $getData");
        await Future.delayed(Duration(seconds: 1));
        await Navigator.pushNamedAndRemoveUntil(
          context,
          Emailpinvarification.name,
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
    email.dispose();
    super.onClose();
  }
}