import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_contacts_app/app_services/database/firestore_services.dart';
import 'package:ivy_contacts_app/utils/app_functions.dart';

import '../../../app_services/database/uploader.dart';
import '../../../models/contact_model.dart';
part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(const ContactState(listContactModel: []));

  Future<void> initialiseList() async {
    emit(state.copyWith(loadState: LoadState.loading));
    try {
      await FirestoreServices.getAllContacts().then((list) {
        // debugPrint(list.length.toString());
        list.sort((c1, c2) {
          return c1.name.compareTo(c2.name);
        });
        emit(state.copyWith(
          loadState: LoadState.loaded,
          listContactModel: list,
        ));
      });
    } catch (e) {
      emit(state.copyWith(loadState: LoadState.errorLoading));
    }
  }

  Future<void> addContact({
    required String name,
    required String contactNo,
    required String url,
    Uint8List? image,
  }) async {
    emit(state.copyWith(addLoadState: LoadState.loading));
    try {
      await FirestoreServices.addContact({
        "name": name,
        "contactNo": contactNo,
        "profilePhoto": url,
      }).then((res) async {
        if (res == null) {
          emit(state.copyWith(addLoadState: LoadState.errorLoading));
        } else {
          // debugPrint(prettyJson(res.toJson()));
          List<ContactModel> list = [...state.listContactModel, res];
          list.sort((c1, c2) {
            return c1.name.compareTo(c2.name);
          });
          emit(state.copyWith(
            addLoadState: LoadState.loaded,
            listContactModel: [
              ...list,
            ],
          ));
          // TODO: ADD IMAGE
          if (image != null) {
            await FileUploader.uploadFile(
              dbPath: 'contactPicture/${res.id}',
              fileData: image,
            );
          }
        }
      });
    } catch (e) {
      emit(state.copyWith(addLoadState: LoadState.errorLoading));
    }
  }

  Future<void> updateContact(
    ContactModel contactModel,
    int index,
    Uint8List? image,
  ) async {
    emit(state.copyWith(editLoadState: LoadState.loading));
    try {
      await FirestoreServices.updateContact(contactModel).then((res) async {
        if (res == null) {
          emit(state.copyWith(editLoadState: LoadState.errorLoading));
        } else {
          // debugPrint(prettyJson(contactModel.toJson()));
          // debugPrint(index.toString());
          List<ContactModel> list = [...state.listContactModel];
          list[index] = contactModel;
          // debugPrint(prettyJson(list[index].toJson()));
          emit(
            state.copyWith(
              editLoadState: LoadState.loaded,
              listContactModel: list,
            ),
          );
          // TODO: UPLOAD IMAGE
          if (image != null) {
            await FileUploader.uploadFile(
              dbPath: 'contactPicture/${res.id}',
              fileData: image,
            );
          }
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(editLoadState: LoadState.errorLoading));
    }
  }

  Future<void> deleteContact(ContactModel contactModel, int index) async {
    emit(state.copyWith(deleteLoadState: LoadState.loading));
    try {
      await FirestoreServices.deleteContact(contactModel).then((res) {
        if (res == null) {
          emit(state.copyWith(deleteLoadState: LoadState.errorLoading));
        } else {
          List<ContactModel> list = [...state.listContactModel];
          list.removeAt(index);
          emit(
            state.copyWith(
              deleteLoadState: LoadState.loaded,
              listContactModel: list,
            ),
          );
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(deleteLoadState: LoadState.errorLoading));
    }
  }
}
