import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/ui/utils/urls.dart';
import '../model/user_model.dart';
import '../network/network_caller.dart';
import '../ui/widget/snackbar_messages.dart';
import 'auth_controller.dart';

class UpdateProfileController extends GetxController {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();

  TextEditingController get email => _email;

  TextEditingController get firstName => _firstName;

  TextEditingController get lastName => _lastName;

  TextEditingController get phone => _phone;

  TextEditingController get password => _password;




  bool _obscurePassword = true;
  bool _isLoading = false;
  XFile? selectedImage;
  final imagePicker = ImagePicker();

  bool get isLoading => _isLoading;

  bool get obscurePassword => _obscurePassword;

  set obscurePassword(bool value) {
    _obscurePassword = value;
    update();
  }

  @override
  void onInit() {
    final user = AuthController.userModel;
    _email.text = user?.email ?? '';
    _firstName.text = user?.firstName ?? '';
    _lastName.text = user?.lastName ?? '';
    _phone.text = user?.mobile ?? '';
    super.onInit();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    update();
  }

  Future<void> pickImage(BuildContext context) async {
    final picked = await imagePicker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final fileSizeInBytes = await picked.length();
      final sizeKB = fileSizeInBytes / 1024;

      if (sizeKB > 64) {
        showSnackBarMessage(
          context,
          'Image is too large. Max allowed size is 64KB.',
        );
        return;
      }
      selectedImage = picked;
    } else {
      showSnackBarMessage(context, 'No image selected');
    }
    update();
  }

  Future<void> updateProfile(BuildContext context) async {
    _isLoading = true;
    update();

    Uint8List? imageBytes;
    final body = {
      'email': _email.text.trim(),
      'firstName': _firstName.text.trim(),
      'lastName': _lastName.text.trim(),
      'mobile': _phone.text.trim(),
    };

    if (_password.text.isNotEmpty) {
      body['password'] = _password.text;
    }

    if (selectedImage != null) {
      imageBytes = await selectedImage!.readAsBytes();
      body['photo'] = base64Encode(imageBytes);
    }

    final response = await networkCaller.postRequest(
      url: urls.UpdateProfileUrl,
      body: body,
    );

    if (response.isSuccess) {
      final updatedUser = UserModel(
        id: AuthController.userModel!.id,
        email: _email.text.trim(),
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        mobile: _phone.text.trim(),
        photo: imageBytes == null
            ? AuthController.userModel!.photo
            : base64Encode(imageBytes),
      );
      await AuthController.updateUserData(updatedUser);
      _password.clear();
      showSnackBarMessage(context, 'Profile updated');
    } else {
      showSnackBarMessage(context, response.errorMessage ?? '');
    }
    _isLoading = false;
    update();
  }

  @override
  void onClose() {
    _email.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _password.dispose();
    super.onClose();
  }
}