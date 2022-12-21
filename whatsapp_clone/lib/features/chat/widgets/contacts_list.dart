import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatControllerProvider).chatContacts(),
          builder: (context, snapshot) {
            print(snapshot.toString());
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data != null ? snapshot.data!.length : 0,
              itemBuilder: (context, index) {
                var chatContactData = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        MobileChatScreen.routeName,
                        arguments: {
                          "name": chatContactData.name,
                          "uid": chatContactData.contactId,
                        },
                      );
                    },
                    child: ListTile(
                      title: Text(
                        chatContactData.name,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          chatContactData.lastMessage,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          chatContactData.profilePic,
                        ),
                      ),
                      trailing: Text(
                        DateFormat.Hm().format(chatContactData.timeSent),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
