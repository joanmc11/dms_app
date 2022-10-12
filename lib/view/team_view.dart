import 'package:dms_app/models/liga_model.dart';
import 'package:dms_app/models/player_model.dart';
import 'package:dms_app/models/user_model.dart';
import 'package:dms_app/service/data_services.dart';
import 'package:dms_app/service/user_pref_service.dart';
import 'package:dms_app/service/write_service_database.dart';
import 'package:dms_app/widgets/player_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserPreferences prefs = UserPreferences();
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: DataServices().playersList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<PlayerModel>> snapshot) {
          if (snapshot.hasData) {
            var players = snapshot.data!;
            return StreamBuilder(
              stream: DataServices().userInfo(prefs.uid),
              builder:
                  (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
                if (snapshot.hasData) {
                  var user = snapshot.data!;
                  return StreamBuilder(
                    stream: DataServices().liga(),
                    builder: (BuildContext context,
                        AsyncSnapshot<LigaModel> snapshot) {
                      if (snapshot.hasData) {
                        var liga = snapshot.data!;
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
                                    onTap: () => liga.jornada
                                        ? _showMessage(context)
                                        : _showPlayerList(
                                            context, players, "pivot"),
                                    child: PlayerField(
                                      playerName: "Pivot",
                                      imagePlayer: "",
                                      playerId: user.pivot,
                                    ),
                                  ),
                                ),
                              ),

                              Positioned(
                                top: 190,
                                left: 40,
                                child: GestureDetector(
                                  onTap: () => liga.jornada
                                      ? _showMessage(context)
                                      : _showPlayerList(
                                          context, players, "alaIzq"),
                                  child: PlayerField(
                                    playerName: "Ala Izq",
                                    imagePlayer: "",
                                    playerId: user.alaIzq,
                                  ),
                                ),
                              ),

                              Positioned(
                                top: 190,
                                left: MediaQuery.of(context).size.width / 1.4,
                                child: GestureDetector(
                                  onTap: () => liga.jornada
                                      ? _showMessage(context)
                                      : _showPlayerList(
                                          context, players, "alaDer"),
                                  child: PlayerField(
                                    playerName: "Ala Der",
                                    imagePlayer: "",
                                    playerId: user.alaDer,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 290),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () => liga.jornada
                                        ? _showMessage(context)
                                        : _showPlayerList(
                                            context, players, "cierre"),
                                    child: PlayerField(
                                      playerName: "Cierre",
                                      imagePlayer: "",
                                      playerId: user.cierre,
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 410),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () => liga.jornada
                                        ? _showMessage(context)
                                        : _showGoalkeepersList(
                                            context, players),
                                    child: PlayerField(
                                      playerName: "Portero",
                                      imagePlayer: "",
                                      playerId: user.portero,
                                    ),
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
                          const Divider(
                              color: Colors.red, height: 5, thickness: 2),
                          ...players
                              .map(
                                (player) => Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                          '${player.name} ${player.surename}'),
                                      leading: player.image == ''
                                          ? const CircleAvatar(
                                              backgroundColor: Colors.red)
                                          : FutureBuilder(
                                              future: FirebaseStorage.instance
                                                  .ref(player.image)
                                                  .getDownloadURL(),
                                              builder: (context,
                                                  AsyncSnapshot<String>
                                                      snapshot) {
                                                debugPrint(snapshot.data);
                                                if (!snapshot.hasData) {
                                                  return const CircularProgressIndicator();
                                                }

                                                return CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      snapshot.data!),
                                                );
                                              }),
                                      subtitle:
                                          Text('Puntos: ${player.points}'),
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              )
                              .toList()
                        ]);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  _showMessage(context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('La jornada ya ha empezado'),
      ),
    );
  }

  _showPlayerList(context, players, position) {
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
                  onTap: () => WriteService()
                      .updateUserPlayers(fieldPlayers[index].id, position),
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
                  onTap: () => WriteService()
                      .updateUserPlayers(goalkeepers[index].id, "portero"),
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
