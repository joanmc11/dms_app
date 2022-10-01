import 'package:dms_app/models/user_model.dart';
import 'package:dms_app/widgets/toggle_buttons.dart';
import 'package:flutter/material.dart';

class ClasificationScreen extends StatelessWidget {
  const ClasificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<UserModel> users = [
      UserModel(id: "1", admin: false, name: "Joan", players: null),
      UserModel(id: "1", admin: false, name: "User2", players: null),
      UserModel(id: "1", admin: false, name: "User3", players: null),
      UserModel(id: "1", admin: false, name: "User4", players: null),
      UserModel(id: "1", admin: false, name: "User5", players: null),
    ];

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
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = users[index];
                    return ListTile(
                      leading: user.avatar == ""
                          ? const CircleAvatar(child: Icon(Icons.sports_bar))
                          : Container(),
                      title: Text(user.name),
                      trailing: Text(
                        "${user.points}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
    );
  }
}
