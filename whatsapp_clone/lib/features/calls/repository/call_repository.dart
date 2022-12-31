// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/calls/screens/call_scree.dart';
import 'package:whatsapp_clone/models/call.dart';

import '../../../models/group.dart';

final callRepositoryProvider = Provider(
  (ref) => CallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  CallRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection("call").doc(auth.currentUser!.uid).snapshots();
  void makeCall({
    required BuildContext context,
    required Call senderCallData,
    required Call recieverCallData,
  }) async {
    try {
      await firestore
          .collection("call")
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());

      await firestore
          .collection("call")
          .doc(senderCallData.receiverId)
          .set(recieverCallData.toMap());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            channelId: senderCallData.callId,
            call: senderCallData,
            isGroupChat: false,
          ),
        ),
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void makeGroupCall({
    required BuildContext context,
    required Call senderCallData,
    required Call recieverCallData,
  }) async {
    try {
      await firestore
          .collection("call")
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());

      var groupSnapshot = await firestore
          .collection("groups")
          .doc(senderCallData.receiverId)
          .get();

      Group group = Group.fromMap(groupSnapshot.data()!);
      for (var id in group.membersUid) {
        await firestore
            .collection("call")
            .doc(id)
            .set(recieverCallData.toMap());
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            channelId: senderCallData.callId,
            call: senderCallData,
            isGroupChat: true,
          ),
        ),
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endCall({
    required BuildContext context,
    required String callerId,
    required String recieverId,
  }) async {
    try {
      await firestore.collection("call").doc(callerId).delete();

      await firestore.collection("call").doc(recieverId).delete();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endGroupCall({
    required BuildContext context,
    required String callerId,
    required String recieverId,
  }) async {
    try {
      await firestore.collection("call").doc(callerId).delete();
      var groupSnapshot =
          await firestore.collection("groups").doc(recieverId).get();
      Group group = Group.fromMap(groupSnapshot.data()!);
      for (var id in group.membersUid) {
        await firestore.collection("call").doc(id).delete();
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
