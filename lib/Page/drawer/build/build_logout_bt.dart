import 'package:authentication_repository/authentication_repository.dart';
import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_audio_player/my_audio_player.dart';
import 'package:podivy/util/dialogs/logout_dialog.dart';
import 'package:provider/provider.dart';

class BuildLogoutButton extends StatelessWidget {
  const BuildLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAudioPlayer>(builder: (context, value, child) {
      return Align(
        alignment: Alignment.center,
        child: ListTile(
          leading: const Icon(Icons.logout, size: 35, color: Colors.red),
          title: Text(
            "logOut".tr,
            style: const TextStyle(color: Colors.red),
          ),
          onTap: () async {
            final result = await showLogOutDialog(context);
            final fsp = Get.find<FirestoreServiceProvider>();
            if (result) {

              await value.player.stop();
              context.mounted
                  ? context
                      .read<AuthBloc>()
                      .add(AuthEventLogOut(fsp.info.userData.loginMethod.value))
                  : null;
               Get.deleteAll();
              
            }
          },
        ),
      );
    });
  }
}
