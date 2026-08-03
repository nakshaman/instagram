import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/resources/auth_methods.dart';
import 'package:insta/responsive/mobile_screen_layout.dart';
import 'package:insta/responsive/responsive_layout_screen.dart';
import 'package:insta/responsive/web_screen_layout.dart';
import 'package:insta/screens/login_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/global_variables.dart';
import 'package:insta/utils/utils.dart';
import 'package:insta/widgets/text_input_field.dart';
import 'package:lottie/lottie.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;

  void selectImage() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    if (image == null) {
      return;
    }
    setState(() {
      _image = image;
    });
  }

  void signUpUser() async {
    if (_image == null) {
      showSnackBar('Please select a profile picture', context);
      return;
    }
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim(),
      file: _image!,
    );
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    if (res != 'sucess') {
      if (mounted) {
        showSnackBar(res, context);
      }
    } else {
      // navigate
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void navigateToLogIn() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = screenWidth > webScreenSize;

    Widget formContent = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Instagram Logo
            SvgPicture.asset(
              'assets/ic_instagram.svg',
              colorFilter: const ColorFilter.mode(
                primaryColor,
                BlendMode.srcIn,
              ),
              height: 64,
            ),
            const SizedBox(height: 32),

            // Profile Picture Picker
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundColor: blackColor,
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedUser03,
                          size: 50,
                        ),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedCamera01,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Username Field
            TextInputField(
              controller: _usernameController,
              hintText: 'Username',
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 24),

            // Email Field
            TextInputField(
              controller: _emailController,
              hintText: 'Email',
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),

            // Password Field
            TextInputField(
              controller: _passwordController,
              hintText: 'Password',
              textInputType: TextInputType.visiblePassword,
              isObsecureText: true,
            ),
            const SizedBox(height: 24),

            // Bio Field
            TextInputField(
              controller: _bioController,
              hintText: 'Bio',
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 24),

            // Sign Up Button
            InkWell(
              onTap: signUpUser,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  color: blueColor,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 21,
                        width: 21,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          backgroundColor: mobileBackgroundColor,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Sign Up'),
              ),
            ),
            const SizedBox(height: 24),

            // Navigation to Login
            GestureDetector(
              onTap: navigateToLogIn,
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                  children: [
                    TextSpan(
                      text: 'Log In',
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
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: isWeb
              ? Row(
                  children: [
                    // Left Side: Lottie Animation
                    Expanded(
                      child: Center(
                        child: Lottie.asset(
                          'assets/hello.json', 
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // Right Side: Sign-Up Form
                    Expanded(
                      child: formContent,
                    ),
                  ],
                )
              : formContent, // Mobile Layout
        ),
      ),
    );
  }
}
