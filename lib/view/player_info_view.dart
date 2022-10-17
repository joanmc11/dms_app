import 'package:dms_app/models/player_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerInfo extends StatelessWidget {
  const PlayerInfo({super.key, required this.player});
  final PlayerModel player;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${player.name} ${player.surename}')),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height
          ),
          child: Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                player.image == ''
                    ? Center(
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.18,
                          child: FaIcon(
                            FontAwesomeIcons.userLarge,
                            size: MediaQuery.of(context).size.width * 0.15,
                          ),
                        ),
                      )
                    : Center(
                        child: FutureBuilder(
                            future: FirebaseStorage.instance
                                .ref(player.image)
                                .getDownloadURL(),
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              debugPrint(snapshot.data);
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }
                
                              return CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.18,
                                child: CircleAvatar(
                                  maxRadius: MediaQuery.of(context).size.width * 0.18,
                                  backgroundImage: NetworkImage(snapshot.data!),
                                ),
                              );
                            }),
                      ),
                Center(
                  child: Text(
                    '${player.name} ${player.surename}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.1),
                  ),
                ),
                Center(
                  child: Text(
                    'Puntos totales: ${player.points}',
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                  ),
                ),
                
                  const Divider(),
                      const Center(
                        child: Text(
                          "Jornadas",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                      ListView.separated(
                        reverse: true,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemCount: player.jornadaList.length,
                        itemBuilder: (BuildContext context, int index) {
                          
                          return ListTile(
                            title: Text(
                              'Jornada ${index+1}',
                              style: const TextStyle(fontWeight: FontWeight.w400),
                            ),
                            trailing: Text(
                              '${player.jornadaList[index]}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: player.jornadaList[index] < 0
                                      ? Colors.red
                                      : player.jornadaList[index] < 4
                                          ? Colors.amber
                                          : player.jornadaList[index] < 9
                                              ? Colors.green
                                              : Colors.blue),
                            ),
                          );
                        },
                      )
                
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
