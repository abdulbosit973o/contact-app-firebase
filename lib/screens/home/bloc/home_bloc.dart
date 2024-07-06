import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../data/model/contact_data.dart';

// Contact Events
abstract class ContactEvent {}

class LoadContacts extends ContactEvent {}

class DeleteContact extends ContactEvent {
  final int index;

  DeleteContact(this.index);
}

class LogoutContact extends ContactEvent {}

class DeleteAccount extends ContactEvent {}

// Contact States
@immutable
abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final List<ContactData> contacts;

  ContactLoaded(this.contacts);
}

class ContactError extends ContactState {
  final String message;

  ContactError(this.message);
}

// Contact Bloc
class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  ContactBloc(this._auth, this._firestore) : super(ContactInitial()) {
    on<LoadContacts>((event, emit) async {
      emit(ContactLoading());
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          var snapshot = await _firestore.collection('contacts').get();
          List<ContactData> contacts = snapshot.docs
              .map((doc) => ContactData.fromMap(doc.data()))
              .toList();
          emit(ContactLoaded(contacts));
        }
      } catch (e) {
        emit(ContactError(e.toString()));
      }
    });

    on<DeleteContact>((event, emit) async {
      try {
        User? user = _auth.currentUser;
        print('DeleteContact state -> top');
        if (user != null) {
          var contactId = state is ContactLoaded
              ? (state as ContactLoaded).contacts[event.index].id
              : null;
          print('user not null ContactLoaded contactId -> $contactId');
          if (contactId != null) {
            Fluttertoast.showToast(
              msg: 'contactId != null = true $contactId',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            await _firestore
                .collection('users')
                .doc(user.uid)
                .collection('contacts')
                .doc(contactId)
                .delete();
            add(LoadContacts());
          }
        }
      } catch (e) {
        emit(ContactError(e.toString()));
      }
    });

    on<LogoutContact>((event, emit) async {
      await _auth.signOut();
      emit(ContactInitial());
    });

    on<DeleteAccount>((event, emit) async {
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).delete();
          await user.delete();
          add(LogoutContact());
        }
      } catch (e) {
        emit(ContactError(e.toString()));
      }
    });
  }
}
