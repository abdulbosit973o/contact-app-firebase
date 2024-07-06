import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../data/model/contact_data.dart';

// Add Contact Events
abstract class AddContactEvent {}

class SubmitContact extends AddContactEvent {
  final ContactData contactData;

  SubmitContact(this.contactData);
}

// Add Contact States
@immutable
abstract class AddContactState {}

class AddContactInitial extends AddContactState {}

class AddContactLoading extends AddContactState {}

class AddContactSuccess extends AddContactState {}

class AddContactError extends AddContactState {
  final String message;

  AddContactError(this.message);
}

// Add Contact Bloc
class AddContactBloc extends Bloc<AddContactEvent, AddContactState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AddContactBloc(this._auth, this._firestore) : super(AddContactInitial()) {
    on<SubmitContact>((event, emit) async {
      emit(AddContactLoading());
      try {
        final User? user = _auth.currentUser;
        if (user != null) {
          final contact = event.contactData;
          await _firestore.collection('contacts').doc(contact.id).set(contact.toMap());
          emit(AddContactSuccess());
        }
      } catch (error) {
        emit(AddContactError(error.toString()));
      }
    });
  }
}
