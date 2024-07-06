import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';

import '../home/home.dart';
import '../register/register.dart';
import 'bloc/login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final textController1 = TextEditingController();
  final textController2 = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(FirebaseAuth.instance),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/login_image.png'),
                      ),
                    ),
                    width: 188,
                    height: 174,
                  ),
                  Column(
                    children: [
                      myTextField(
                        controller: textController1,
                        hintText: 'Email',
                        isPassword: false,
                      ),
                      const SizedBox(height: 16),
                      myTextField(
                        controller: textController2,
                        hintText: 'Password',
                        isPassword: true,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      BlocConsumer<LoginBloc, LoginState>(
                        listener: (context, state) {
                          if (state is LoginSuccess) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                              (Route<dynamic> route) => false,
                            );
                          } else if (state is LoginFailure) {
                            Fluttertoast.showToast(
                              msg: "Login failed: ${state.error}",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        builder: (context, state) {
                          return myButton(() {
                            context.read<LoginBloc>().add(LoginUser(
                                  email: textController1.text,
                                  password: textController2.text,
                                ));
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: RichText(
                            text: const TextSpan(
                              text: 'Don’t have an account yet? ',
                              style: TextStyle(
                                fontFamily: 'PaynetB',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 1.6,
                                letterSpacing: -0.4,
                                color: Color(0xFF8E8E93),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign up here',
                                  style: TextStyle(
                                    fontFamily: 'PaynetB',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    height: 1.3,
                                    color: Color(0xFF8E8E93),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget myButton(void Function() onCardClick) => GestureDetector(
        onTap: onCardClick,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFEB5757),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.fromLTRB(0, 14, 0, 15),
          child: const Center(
            child: Text(
              'Log In',
              style: TextStyle(
                fontFamily: 'PaynetB',
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      );

  Widget myTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isPassword,
  }) {
    return TextField(
      controller: controller,
      cursorColor: const Color(0xff646262),
      obscureText: isPassword ? !showPassword : false,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'PaynetB',
          color: Colors.grey,
          fontSize: 16,
        ),
        filled: true,
        fillColor: const Color(0xffffffff),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xff263238),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xff263238),
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        errorStyle: const TextStyle(color: Colors.red),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xff000000),
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              )
            : IconButton(
                icon: const Icon(
                  Iconsax.close_square5,
                  color: Color(0xff000000),
                ),
                onPressed: () {
                  controller.clear();
                },
              ),
      ),
      style: const TextStyle(color: Colors.black, fontFamily: 'PaynetB'),
    );
  }
}
