import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/info.dart';
import 'package:whatsapp_clone/screens/mobile_chat_screen.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.separated(
        separatorBuilder: (_, index) {
          return const Divider(
            color: dividerColor,
            indent: 85,
          );
        },
        shrinkWrap: true,
        itemCount: info.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MobileChatScreen(index: index),
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  info[index]["name"].toString(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    info[index]["message"].toString(),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    info[index]["profilePic"].toString(),
                  ),
                ),
                trailing: Text(
                  info[index]["time"].toString(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
