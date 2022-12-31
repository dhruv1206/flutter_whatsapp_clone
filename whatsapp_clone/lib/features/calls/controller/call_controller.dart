// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/calls/repository/call_repository.dart';
import 'package:whatsapp_clone/features/group/controller/group_controller.dart';
import 'package:whatsapp_clone/features/group/repository/group_repository.dart';
import 'package:whatsapp_clone/models/call.dart';

final callControllerProvider = Provider(
  (ref) {
    final callRepository = ref.read(callRepositoryProvider);
    return CallController(
      callRepository: callRepository,
      auth: FirebaseAuth.instance,
      ref: ref,
    );
  },
);

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;
  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void makeCall(
    BuildContext context,
    String recieverName,
    String recieverId,
    String recieverProfilePic,
    bool isGroupChat,
  ) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value!.name,
        callerPic: value.profilePic,
        receiverId: recieverId,
        receiverName: recieverName,
        receiverPic: recieverProfilePic,
        callId: callId,
        hasDialled: true,
      );
      Call recieverCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: recieverId,
        receiverName: recieverName,
        receiverPic: recieverProfilePic,
        callId: callId,
        hasDialled: false,
      );
      if (isGroupChat) {
        callRepository.makeGroupCall(
            context: context,
            senderCallData: senderCallData,
            recieverCallData: recieverCallData);
      } else {
        callRepository.makeCall(
          context: context,
          senderCallData: senderCallData,
          recieverCallData: recieverCallData,
        );
      }
    });
  }

  void endCall(BuildContext context, String callerId, String recieverId) {
    callRepository.endCall(
        context: context, callerId: callerId, recieverId: recieverId);
  }
}
