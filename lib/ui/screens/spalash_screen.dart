import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Controller/Auth_controller.dart';
import '../utils/assets_path.dart';
import '../widget/screen_background.dart';
import 'Sign_in_screen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _moveToNextScreen();
    });
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