import 'package:dms_app/models/player_model.dart';
import 'package:dms_app/service/data_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PlayerField extends StatelessWidget {
  const PlayerField(
      {super.key, required this.playerName, required this.imagePlayer, this.playerId = ""});

  final String playerName;
  final String imagePlayer;
  final String? playerId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.blue[800]!.withOpacity(0.7),
          borderRadius: const BorderRadius.all(Radius.circular(350))),
      child: playerId == ""
          ? Column(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.add),
                ),
                Text(playerName, style: const TextStyle(color: Colors.white)),
              ],
            )
          : StreamBuilder(
              stream: DataServices().playerInfo(playerId!),
              builder:
                  (BuildContext context, AsyncSnapshot<PlayerModel> snapshot) {
                    if(snapshot.hasError){
                      return Text(snapshot.error.toString());
                    }
                if (snapshot.hasData) {
                  var player = snapshot.data!;
                  return Column(
                    children: [
                        player.image == ''
                                  ? const CircleAvatar(
                                      backgroundColor: Colors.red)
                                  : FutureBuilder(
                                      future: FirebaseStorage.instance
                                          .ref(player.image)
                                          .getDownloadURL(),
                                      builder: (context,
                                          AsyncSnapshot<String> snapshot) {
                                        debugPrint(snapshot.data);
                                        if (!snapshot.hasData) {
                                          return const CircularProgressIndicator();
                                        }

                                        return CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(snapshot.data!),
                                        );
                                      }),
                                    Text(player.name, style: const TextStyle(color: Colors.white)), 
                                     Text(player.surename, style: const TextStyle(color: Colors.white)), 
                    ],
                  );
                }else{
                  return const CircularProgressIndicator();
                }
              },
            ),
    );
  }
}
