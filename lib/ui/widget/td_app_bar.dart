import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/widget/snackbar_messages.dart';
import '../../controller/auth_controller.dart';
import '../screens/sign_in_screen.dart';
import '../screens/update_profile_screen.dart';

class TDAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TDAppBar({super.key});

  @override
  State<TDAppBar> createState() => _TDAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TDAppBarState extends State<TDAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,

      title: GestureDetector(
        onTap: () => _onTapProfileBar(context),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage:
              AuthController.userModel?.photo == null
                  ? null
                  : MemoryImage(
                base64Decode(AuthController.userModel!.photo!),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userModel!.Fullname,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    AuthController.userModel!.email,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            IconButton(onPressed: _onTapLogOutButton, icon: Icon(Icons.logout)),
          ],
        ),
      ),
    );
  }

  Future<void> _onTapLogOutButton() async {
    await AuthController.clearUserData();

    Navigator.pushNamedAndRemoveUntil(
      context,
      SignInScreen.name,
          (predicate) => false,
    );
  }

  void _onTapProfileBar(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute == UpdateProfileScreen.name) {
      showSnackBarMessage(context, 'You are already on the profile page');
    } else {
      // Navigate to profile page
      Navigator.pushNamed(context, UpdateProfileScreen.name);
    }
  }
}