import 'package:dms_app/models/player_model.dart';
import 'package:dms_app/service/data_services.dart';
import 'package:dms_app/widgets/player_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: DataServices().playersList(),
          builder: (BuildContext context,
              AsyncSnapshot<List<PlayerModel>> snapshot) {
            if (snapshot.hasData) {
              var players = snapshot.data!;
              return Column(children: [
                Stack(
                  children: [
                    //Pista
                    Image.asset('assets/pista.png'),
                    //Jugador1

                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => _showPlayerList(context, players),
                          child: const PlayerField(
                              playerName: "Pivot", imagePlayer: ""),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 190,
                      left: 40,
                      child: GestureDetector(
                        onTap: () => _showPlayerList(context, players),
                        child: const PlayerField(
                            playerName: "Ala Izq", imagePlayer: ""),
                      ),
                    ),

                    Positioned(
                      top: 190,
                      left: MediaQuery.of(context).size.width / 1.4,
                      child: GestureDetector(
                        onTap: () => _showPlayerList(context, players),
                        child: const PlayerField(
                            playerName: "Ala Der", imagePlayer: ""),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 300),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => _showPlayerList(context, players),
                          child: const PlayerField(
                              playerName: "Cierre", imagePlayer: ""),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 430),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => _showGoalkeepersList(context, players),
                          child: const PlayerField(
                              playerName: "Portero", imagePlayer: ""),
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                      child: Text("Jugadores",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red))),
                ),
                const Divider(color: Colors.red, height: 5, thickness: 2),
                ...players
                    .map((player) => Column(
                          children: [
                            ListTile(
                              title: Text('${player.name} ${player.surename}'),
                              leading: player.image == ''
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
                              subtitle: Text('Puntos: ${player.points}'),
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                          ],
                        ))
                    .toList()
              ]);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  _showPlayerList(context, players) {
    List<PlayerModel> fieldPlayers = [];
    for (var fieldPlayer in players) {
      fieldPlayer.goalkeeper ? null : fieldPlayers.add(fieldPlayer);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Text("Escoje un jugador para esta posición"),
        actions: [
          SizedBox(
            height: 350.0,
            width: 350.0,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: fieldPlayers.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                      '${fieldPlayers[index].name} ${fieldPlayers[index].surename}'),
                  leading: fieldPlayers[index].image == ''
                      ? const CircleAvatar(backgroundColor: Colors.red)
                      : FutureBuilder(
                          future: FirebaseStorage.instance
                              .ref(fieldPlayers[index].image)
                              .getDownloadURL(),
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            debugPrint(snapshot.data);
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }

                            return CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data!),
                            );
                          }),
                  subtitle: Text('Puntos: ${fieldPlayers[index].points}'),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  _showGoalkeepersList(context, players) {
    List<PlayerModel> goalkeepers = [];
    for (var goalkeeper in players) {
      goalkeeper.goalkeeper ? goalkeepers.add(goalkeeper) : null;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Text("Escoje un portero"),
        actions: [
          SizedBox(
            height: 350.0,
            width: 350.0,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: goalkeepers.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                      '${goalkeepers[index].name} ${goalkeepers[index].surename}'),
                  leading: goalkeepers[index].image == ''
                      ? const CircleAvatar(backgroundColor: Colors.red)
                      : FutureBuilder(
                          future: FirebaseStorage.instance
                              .ref(goalkeepers[index].image)
                              .getDownloadURL(),
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            debugPrint(snapshot.data);
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }

                            return CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data!),
                            );
                          }),
                  subtitle: Text('Puntos: ${goalkeepers[index].points}'),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
