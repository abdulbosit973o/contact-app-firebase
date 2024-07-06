import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../data/model/contact_data.dart';

// Edit Contact Events
abstract class EditContactEvent {}

class UpdateContact extends EditContactEvent {
  final ContactData contactData;

  UpdateContact(this.contactData);
}

// Edit Contact States
@immutable
abstract class EditContactState {}

class EditContactInitial extends EditContactState {}

class EditContactLoading extends EditContactState {}

class EditContactSuccess extends EditContactState {}

class EditContactError extends EditContactState {
  final String message;

  EditContactError(this.message);
}

// Edit Contact Bloc
class EditContactBloc extends Bloc<EditContactEvent, EditContactState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  EditContactBloc(this._auth, this._firestore) : super(EditContactInitial()) {
    on<UpdateContact>((event, emit) async {
      emit(EditContactLoading());
      try {
        final User? user = _auth.currentUser;
        if (user != null) {
          final contact = event.contactData;
          await _firestore.collection('contacts').doc(contact.id).update(contact.toMap());
          emit(EditContactSuccess());
        }
      } catch (error) {
        emit(EditContactError(error.toString()));
      }
    });
  }
}
