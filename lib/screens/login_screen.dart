import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta/resources/auth_methods.dart';
import 'package:insta/responsive/mobile_screen_layout.dart';
import 'package:insta/responsive/responsive_layout_screen.dart';
import 'package:insta/responsive/web_screen_layout.dart';
import 'package:insta/screens/sign_up_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/global_variables.dart';
import 'package:insta/utils/utils.dart';
import 'package:insta/widgets/text_input_field.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void logInUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().logInUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    if (res != "sucess") {
      if (mounted) {
        showSnackBar(res, context);
      }
    } else {
      log(res);
      log(FirebaseAuth.instance.currentUser!.uid);
      // Navigate to the home screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayoutScreen(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout(),
            ),
          ),
        );
      }
    }
  }

  void navigateToSignUp() {
    Navigator.of(
      context,
    ).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isWeb = MediaQuery.of(context).size.width > webScreenSize;
    final double screenWidth = MediaQuery.of(context).size.width;

    Widget formContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/ic_instagram.svg',
            color: primaryColor,
            height: 64,
          ),
          const SizedBox(
            height: 64,
          ),
          TextInputField(
            controller: _emailController,
            hintText: 'Email',
            textInputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 24,
          ),
          TextInputField(
            controller: _passwordController,
            hintText: 'Password',
            textInputType: TextInputType.visiblePassword,
            isObsecureText: true,
          ),
          const SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: logInUser,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                color: blueColor,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 21,
                      width: 21,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    )
                  : const Text('Log in'),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: navigateToSignUp,
            child: RichText(
              text: TextSpan(
                text: 'Don\'t have an account ? ',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w300,
                ),
                children: [
                  TextSpan(
                    text: ' Sign Up',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: isWeb
            ? Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Lottie.asset('assets/stress.json'),
                    ),
                  ),
                  Expanded(child: formContent),
                ],
              )
            : formContent,
      ),
    );
  }
}
