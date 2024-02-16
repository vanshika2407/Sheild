import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:she_secure/features/home/home_page.dart';

import '../../colors.dart';
import '../../common/widgets/common_snackbar.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});
  static const routeName = '/docAuth';

  @override
  ConsumerState<AuthScreen> createState() => _DoctorAuthState();
}

class _DoctorAuthState extends ConsumerState<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLogin = true;
  bool showPassword = false;
  void login() {
    var email = emailController.text.trim();
    var password = passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      // ref.read(authControllerProvider).signInWithEmailAndPassword(
      //       context: context,
      //       email: email,
      //       password: password,
      //       type: UserTypeEnum.,
      //     );
    } else {
      showsnackbar(
        context: context,
        msg: 'please input both the fields properly',
      );
    }
  }

  void signUp() {
    var email = emailController.text.trim();
    var password = passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      // ref.read(authControllerProvider).signUpWithPhone(
      //   context: context,
      //   email: email,
      //   password: password,
      // );
    } else {
      showsnackbar(
        context: context,
        msg: 'please input both the fields properly',
      );
    }
  }

  void changeShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(10),
              height: size.height * 0.98,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(14),
                    child: Text(
                      " ${isLogin ? 'Login' : 'Sign Up'}",
                      style: const TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(14),
                    height: 327,
                    width: 280,
                    child: Image.asset('assets/logo.jpg'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: boxBorderColor),
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: boxBorderColor),
                    ),
                    child: SizedBox(
                      height: size.height * 0.045,
                      width: size.width * 0.85,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: size.width * 0.85 * 0.70,
                              child: TextField(
                                obscureText: !showPassword,
                                controller: passwordController,
                                decoration: const InputDecoration.collapsed(
                                  hintText: 'Password',
                                ),
                              ),
                            ),
                            IconButton(
                              splashRadius: 0.1,
                              iconSize: 20,
                              alignment: Alignment.center,
                              icon: !showPassword
                                  ? const Icon(Icons.remove_red_eye)
                                  : const Icon(Icons.password),
                              onPressed: changeShowPassword,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: double.infinity,
                    alignment: Alignment.bottomRight,
                    child: const TextButton(
                      onPressed: null,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tabColor,
                      ),
                      onPressed: () {
                        // return isLogin ? login() : signUp();
                        Navigator.of(context).pushNamed(HomePage.routeName);  
                      },
                      child: Text(
                        isLogin ? 'Login' : 'Sign Up',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLogin
                            ? 'Don\'t have an account?'
                            : 'Already have an account?',
                        style: const TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(
                          isLogin ? 'Sign Up' : 'Login',
                          style:
                              const TextStyle(fontSize: 16, color: blackColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
