import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ivy_contacts_app/models/contact_model.dart';
import 'package:ivy_contacts_app/utils/app_functions.dart';

class FirestoreServices {
  static final _firestore = FirebaseFirestore.instance;

  static Future<List<ContactModel>> getAllContacts() async {
    final _auth = FirebaseAuth.instance;
    final uid = _auth.currentUser!.uid;
    List<ContactModel> list = [];
    try {
      await _firestore
          .collection('persons')
          .doc(uid)
          .collection('contacts')
          .get()
          .then((lists) {
        for (var elementQuery in lists.docs) {
          var element = elementQuery.data();
          // debugPrint(prettyJson(element));

          element['id'] = elementQuery.id;
          list.add(ContactModel.fromJson(element));
        }
      });
    } catch (error) {
      debugPrint('$error in getAllContacts');
    }
    return list;
  }

  static Future<ContactModel?> addContact(
      Map<String, dynamic> contactJson) async {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser!.uid;
    ContactModel? contactModel;
    try {
      await _firestore
          .collection('persons')
          .doc(uid)
          .collection('contacts')
          .add(contactJson)
          .then((res) {
        // debugPrint(res.id.toString());

        contactModel = ContactModel.fromJson({
          "id": res.id,
          ...contactJson,
        });
        // debugPrint(prettyJson(contactModel!.toJson()));
      });
    } catch (error) {
      debugPrint('$error in addContacts');
    }
    return contactModel;
  }

  static Future<ContactModel?> updateContact(
      ContactModel contactModelToUpdate) async {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser!.uid;
    ContactModel? contactModel;
    try {
      await _firestore
          .collection('persons')
          .doc(uid)
          .collection('contacts')
          .doc(contactModelToUpdate.id)
          .update(contactModelToUpdate.toJson())
          .then((res) {
        contactModel = contactModelToUpdate;
      });
    } catch (error) {
      debugPrint('$error in addContacts');
    }
    return contactModel;
  }

  static Future<ContactModel?> deleteContact(
      ContactModel contactModelToUpdate) async {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser!.uid;
    ContactModel? contactModel;
    try {
      await _firestore
          .collection('persons')
          .doc(uid)
          .collection('contacts')
          .doc(contactModelToUpdate.id)
          .delete()
          .then((res) {
        contactModel = contactModelToUpdate;
      });
    } catch (error) {
      debugPrint('$error in addContacts');
    }
    return contactModel;
  }
}
