import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_app_firebase_bloc/screens/home/widgets/contact_item.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/model/contact_data.dart';
import '../../theme/color/light_color.dart';
import '../add/add_contact_screen.dart';
import '../edit/edit.dart';
import '../login/login_screen.dart';
import 'dialog/custom_delete_dialog.dart';
import 'dialog/custom_logot_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? user;
  List<ContactData> contacts = [];

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _loadContacts();
  }

  void _loadContacts() async {
    if (user != null) {
      var snapshot = await _firestore
          .collection('contacts')
          .get();
      print(snapshot);
      contacts = snapshot.docs
          .map((doc) => ContactData.fromMap(doc.data()))
          .toList();
      setState(() {});
    }
  }

  void _deleteContact(int index) async {
    if (user != null) {
      var contactId = contacts[index].id;
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('contacts')
          .doc(contactId)
          .delete();
      _loadContacts();
    }
  }

  void _logoutContact() async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  void _deleteAccount() async {
    if (user != null) {
      await _firestore.collection('users').doc(user!.uid).delete();
      await user!.delete();
      _logoutContact();
    }
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDeleteDialog(
          onDelete: () {
            _deleteContact(index);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomLogOutDialog(
          onLogout: () {
            _logoutContact();
            Navigator.of(context).pop();
          },
          onUnregister: () {
            _deleteAccount();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text('My Contacts', style: TextStyle(fontFamily: 'PaynetB')),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
                color: LightColor.mainColor,
                borderRadius: BorderRadius.circular(12)),
            child: IconButton(
              icon: const Icon(
                Iconsax.logout,
                color: Colors.white,
              ),
              onPressed: () => _showLogoutDialog(),
            ),
          ),
        ],
      ),
      body: contacts.isEmpty
          ? const Center(
          child: Text('Empty', style: TextStyle(fontFamily: 'PaynetB')))
          : ListView.separated(
        itemCount: contacts.length,
        itemBuilder: (context, index) => ContactItem(
          contact: contacts[index],
          onCardClick: () {
            _showDeleteDialog(index);
          },
          onItemClick: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditContactScreen(
                    index: index,
                    contactData: contacts[index],
                  )),
            );
            if (result == true) {
              _loadContacts();
            }
          },
        ),
        separatorBuilder: (BuildContext context, int index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              height: 2,
              color: Colors.grey,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: LightColor.mainColor,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContactScreen()),
          );
          if (result == true) {
            _loadContacts();
          }
        },
        child: const Icon(Iconsax.add, color: Colors.white,),
      ),
    );
  }
}
