import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_app_firebase_bloc/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';

import '../../data/model/contact_data.dart';
import 'bloc/add_bloc.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController textController1 = TextEditingController();
  final TextEditingController textController2 = TextEditingController();
  bool showPassword = false;

  @override
  void dispose() {
    textController1.dispose();
    textController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddContactBloc(FirebaseAuth.instance, FirebaseFirestore.instance),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Contact',
              style: TextStyle(fontFamily: 'PaynetB')),
        ),
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
                        image: AssetImage('assets/images/add_image.png'),
                      ),
                    ),
                    width: 188,
                    height: 174,
                  ),
                  Column(
                    children: [
                      myTextField(
                        controller: textController1,
                        hintText: 'Name',
                        isPassword: false,
                      ),
                      const SizedBox(height: 16),
                      myTextField(
                        controller: textController2,
                        hintText: 'Phone',
                        isPassword: false,
                      ),
                    ],
                  ),
                  BlocConsumer<AddContactBloc, AddContactState>(
                    listener: (context, state) {
                      if (state is AddContactSuccess) {
                        Fluttertoast.showToast(
                          msg: "Added successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      } else if (state is AddContactError) {
                        Fluttertoast.showToast(
                          msg: "Failed to add contact: ${state.message}",
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
                      if (state is AddContactLoading) {
                        return const CircularProgressIndicator();
                      }
                      return myButton(() {
                        final User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          final contactId = FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('contacts')
                              .doc()
                              .id;
                          final contact = ContactData(
                            id: contactId,
                            name: textController1.text,
                            phone: textController2.text,
                            email: '',
                          );
                          context
                              .read<AddContactBloc>()
                              .add(SubmitContact(contact));
                        } else {
                          Fluttertoast.showToast(
                            msg: "User not logged in",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      });
                    },
                  ),
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
              'Add Contact',
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
            fontFamily: 'PaynetB', color: Colors.grey, fontSize: 16),
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
