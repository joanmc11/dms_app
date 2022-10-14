import 'package:dms_app/controller/clasification_controller.dart';
import 'package:dms_app/models/user_model.dart';
import 'package:dms_app/service/data_services.dart';
import 'package:dms_app/view/user_players_view.dart';
import 'package:dms_app/widgets/toggle_buttons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClasificationScreen extends StatelessWidget {
  ClasificationScreen({super.key});

  ClasificationController clasificationController =
      Get.put(ClasificationController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: ToggleButtonsClasification(),
              ),
              Obx(
                () => StreamBuilder<List<UserModel>>(
                    stream: clasificationController.general.value
                        ? DataServices().userGeneralList()
                        : DataServices().userJornadaList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<UserModel>> snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Text(snapshot.error.toString());
                      }
                      if (snapshot.hasData) {
                        var users = snapshot.data!;
                        print(snapshot.data);
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: users.length,
                            itemBuilder: (BuildContext context, int index) {
                              final user = users[index];
                              print(user);
                              return ListTile(
                                onTap: ()=>Get.to(() =>  UserPlayerView(userId: user.id, userName: user.name,)),
                                leading: Stack(children: [
                                  user.avatar == ''
                                      ? const Padding(
                                          padding: EdgeInsets.only(left: 32.0),
                                          child: CircleAvatar(
                                              child: Icon(Icons.sports_bar)),
                                        )
                                      : Padding(
                                        padding: const EdgeInsets.only(left: 32.0),
                                        child: FutureBuilder(
                                            future: FirebaseStorage.instance
                                                .ref(user.avatar)
                                                .getDownloadURL(),
                                            builder: (context,
                                                AsyncSnapshot<String> snapshot) {
                                              debugPrint(snapshot.data);
                                              if (!snapshot.hasData) {
                                                return const CircularProgressIndicator();
                                              }

                                              return CircleAvatar(
                                                child: CircleAvatar(
                                                  maxRadius: 200,
                                                  backgroundImage: NetworkImage(
                                                      snapshot.data!),
                                                ),
                                              );
                                            }),
                                      ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "${index + 1}.",
                                      style: const TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ]),
                                title: Text(user.name),
                                trailing: Text(
                                  clasificationController.general.value
                                      ? "${user.points}"
                                      : "${user.jornada}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            });
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
