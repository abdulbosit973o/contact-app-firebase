import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import '../../data/model/contact_data.dart';
import '../home/home.dart';
import 'bloc/edit_bloc.dart';

class EditContactScreen extends StatefulWidget {
  final int index;
  final ContactData contactData;

  const EditContactScreen({super.key, required this.index, required this.contactData});

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late TextEditingController textController1;
  late TextEditingController textController2;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController(text: widget.contactData.name);
    textController2 = TextEditingController(text: widget.contactData.phone);
  }

  @override
  void dispose() {
    textController1.dispose();
    textController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditContactBloc(FirebaseAuth.instance, FirebaseFirestore.instance),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Contact', style: TextStyle(fontFamily: 'PaynetB')),
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
                        image: AssetImage('assets/images/edit_image.png'),
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
                  BlocConsumer<EditContactBloc, EditContactState>(
                    listener: (context, state) {
                      if (state is EditContactSuccess) {
                        Fluttertoast.showToast(
                          msg: "Edited successfully",
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
                      } else if (state is EditContactError) {
                        Fluttertoast.showToast(
                          msg: "Failed to edit contact: ${state.message}",
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
                      if (state is EditContactLoading) {
                        return const CircularProgressIndicator();
                      }
                      return myButton(() {
                        final contact = ContactData(
                          id: widget.contactData.id,
                          name: textController1.text,
                          phone: textController2.text, email: '',
                        );
                        context.read<EditContactBloc>().add(UpdateContact(contact));
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
          'Edit Contact',
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
