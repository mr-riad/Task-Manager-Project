import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/update_profile_controller.dart';
import '../widget/center_circular_progress_bar.dart';
import '../widget/screen_background.dart';
import '../widget/td_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = '/updvar ile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final UpdateProfileController _updateProfileController =
  Get.find<UpdateProfileController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _updateProfileController.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateProfileController>(
      builder: (controller) {
        return Scaffold(
          appBar: TDAppBar(),
          body: ScreenBackground(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Update Profile',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      _buildPhotoPicker(),

                      const SizedBox(height: 8),

                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.email,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(hintText: 'Email'),
                        validator: (String? value) {
                          String email = value ?? '';
                          if (EmailValidator.validate(email) == false) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.firstName,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(hintText: 'First name'),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your first name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.lastName,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(hintText: 'Last name'),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your Last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.phone,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(hintText: 'Mobile'),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your mobile number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.password,
                        obscureText: controller.obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () =>
                                controller.togglePasswordVisibility(),
                          ),
                        ),
                        validator: (String? value) {
                          int length = value?.length ?? 0;
                          if (length > 0 && length <= 6) {
                            return 'Enter a password more than 6 letters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: controller.isLoading == false,
                        replacement: CenteredCircularProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.updateProfile(context);
                            }
                          },

                          child: Icon(Icons.arrow_circle_right_outlined),
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

  Widget _buildPhotoPicker() {
    return GetBuilder<UpdateProfileController>(
      builder: (controller) {
        return GestureDetector(
          onTap: () => controller.pickImage(context),
          child: Container(
            height: 50,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Photo',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  controller.selectedImage == null
                      ? 'Select image'
                      : controller.selectedImage!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}