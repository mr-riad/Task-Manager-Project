import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/utils/assets_path.dart';
import '../../controller/auth_controller.dart';
import '../widget/screen_background.dart';
import 'main_navbar_screen.dart';

class SpalashScreen extends StatefulWidget {
  const SpalashScreen({super.key});

  static const String name = '/';

  @override
  State<SpalashScreen> createState() => _SpalashScreenState();
}

class _SpalashScreenState extends State<SpalashScreen> {
  @override
  initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {

    await Future.delayed(Duration(seconds: 2));
    bool isLoggedIn = await AuthController.isUserLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, MainNavbarScreen.name);
    } else {
      Navigator.pushReplacementNamed(context, SignInScreen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(child: SvgPicture.asset(AssetPaths.logoSvg)),
      ),
    );
  }
}