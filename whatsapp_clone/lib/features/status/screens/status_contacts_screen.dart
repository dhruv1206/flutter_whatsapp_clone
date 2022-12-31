import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/status/screens/status_screen.dart';

import '../../../colors.dart';
import '../../../common/widgets/loader.dart';
import '../../../models/status_model.dart';
import '../controller/status_controller.dart';

class StatusContactsScreen extends ConsumerStatefulWidget {
  const StatusContactsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StatusContactsScreen> createState() =>
      _StatusContactsScreenState();
}

class _StatusContactsScreenState extends ConsumerState<StatusContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Status>>(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var statusData = snapshot.data![index];
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    StatusScreen.routeName,
                    arguments: statusData,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      statusData.username,
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        statusData.profilePic,
                      ),
                      radius: 30,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
