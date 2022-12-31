import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../common/repository/common_firebase_storage_repository.dart';
import '../../../common/utils/utils.dart';
import '../../../models/status_model.dart';
import '../../../models/user_model.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageurl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            '/status/$statusId$uid',
            statusImage,
          );
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      List<String> uidWhoCanSee = [];
      for (int i = 0; i < contacts.length; i++) {
        if (contacts[i].phones.toString() == "[]") continue;
        String phoneNum = contacts[i].phones[0].number.replaceAll(
              ' ',
              '',
            );
        if (phoneNum[0] != "+") {
          phoneNum = "+91$phoneNum";
        }
        var userDataFirebase = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: phoneNum,
            )
            .get();

        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCanSee.add(userData.uid);
        }
      }
      List<String> statusImageUrls = [];
      var statusesSnapshot = await firestore
          .collection('status')
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          .get();
      print("3");
      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusesSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageurl);
        await firestore
            .collection('status')
            .doc(statusesSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
        return;
      } else {
        statusImageUrls = [imageurl];
      }
      print("4");
      Status status = Status(
        uid: uid,
        username: username,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      await firestore.collection('status').doc(statusId).set(status.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      List<Contact> contacts = [];
      List<Contact> registeredContacts = [];
      var allUsers = await firestore.collection("users").get();

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      for (var i in contacts) {
        if (i.phones.toString() == "[]") continue;
        String z = i.phones[0].number.replaceAll(
          ' ',
          '',
        );
        if (z[0] != "+") {
          z = "+91$z";
        }
        for (var j in allUsers.docs) {
          UserModel k = UserModel.fromMap(j.data());
          if (z == k.phoneNumber) {
            registeredContacts.add(i);
          }
        }
      }

      for (int i = 0; i < registeredContacts.length; i++) {
        if (registeredContacts[i].phones.toString() != "[]") {
          String currPhoneNum =
              registeredContacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  );
          if (currPhoneNum[0] != "+") {
            currPhoneNum = "+91$currPhoneNum";
          }
          print(currPhoneNum);
          var statusesSnapshot = await firestore
              .collection('status')
              .where(
                'phoneNumber',
                isEqualTo: currPhoneNum,
              )
              .where(
                'createdAt',
                isGreaterThan: DateTime.now()
                    .subtract(const Duration(hours: 24))
                    .millisecondsSinceEpoch,
              )
              .get();
          print(statusesSnapshot.docs.length);
          for (var tempData in statusesSnapshot.docs) {
            Status tempStatus = Status.fromMap(tempData.data());
            print(tempStatus.whoCanSee);
            if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
              print("h");
              statusData.add(tempStatus);
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
      showSnackBar(context: context, content: e.toString());
    }
    return statusData;
  }
}
