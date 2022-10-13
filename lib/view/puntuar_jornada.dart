import 'package:dms_app/models/player_model.dart';
import 'package:dms_app/service/data_services.dart';
import 'package:dms_app/service/write_service_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class PuntuarJornada extends StatefulWidget {
  const PuntuarJornada({super.key});

  @override
  State<PuntuarJornada> createState() => _PuntuarJornadaState();
}

class _PuntuarJornadaState extends State<PuntuarJornada> {
  Map goalDynamic = {};
  Map yellowDynamic = {};
  Map redDynamic = {};
  Map mvpDynamic = {};
  Map checkedDynamic = {};
  Map encDynamic = {};
  bool win = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Puntuar Jornada"),
        centerTitle: true,
        elevation: 1,
      ),
      body: StreamBuilder(
        stream: DataServices().playersList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<PlayerModel>> snapshot) {
          if (snapshot.hasData) {
            var players = snapshot.data!;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Partido ganado",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Checkbox(
                        checkColor: Colors.white,
                        value: win,
                        onChanged: (bool? value) {
                          setState(() {
                            win = value!;
                          });
                        }),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: players.length,
                    itemBuilder: (BuildContext context, int index) {
                      PlayerModel player = players[index];
                      goalDynamic[index] = goalDynamic[index] ?? 0;
                      encDynamic[index] = encDynamic[index] ?? 0;
                      yellowDynamic[index] = yellowDynamic[index] ?? false;
                      redDynamic[index] = redDynamic[index] ?? false;
                      mvpDynamic[index] = mvpDynamic[index] ?? false;
                      checkedDynamic[index] = checkedDynamic[index] ?? false;

                      return Column(
                        children: [
                          ListTile(
                            style: ListTileStyle.drawer,
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
                            subtitle: const Text('Puntua abajo este jugador'),
                            trailing: checkedDynamic[index]
                                ? const Text("Puntos subidos", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)
                                : ElevatedButton(
                                    onPressed: () {
                                      player.goalkeeper
                                          ? _showAlertDialog(context,
                                              player.name, player.surename, () {
                                              WriteService()
                                                  .updatePointsGoalkeeper(
                                                      player.id,
                                                      yellowDynamic[index],
                                                      redDynamic[index],
                                                      mvpDynamic[index],
                                                      goalDynamic[index],
                                                      win,
                                                      player.points,
                                                      encDynamic[index]);
                                              setState(() {
                                                checkedDynamic[index] = true;
                                              });
                                              Navigator.pop(context);
                                            })
                                          : _showAlertDialog(context,
                                              player.name, player.surename, () {
                                              WriteService().updatePointsPlayer(
                                                  player.id,
                                                  yellowDynamic[index],
                                                  redDynamic[index],
                                                  mvpDynamic[index],
                                                  goalDynamic[index],
                                                  win,
                                                  player.points);
                                              setState(() {
                                                checkedDynamic[index] = true;
                                              });
                                              Navigator.pop(context);
                                            });
                                    },
                                    child: const Text("Subir Puntos"),
                                  ),
                          ),
                          !checkedDynamic[index]
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        //Yellow Card
                                        Column(
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 0.0),
                                              child: Icon(
                                                Icons.square,
                                                color: Colors.amber,
                                              ),
                                            ),
                                            Checkbox(
                                                checkColor: Colors.white,
                                                value: yellowDynamic[index],
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    yellowDynamic[index] =
                                                        value!;
                                                  });
                                                }),
                                          ],
                                        ),

                                        //red card
                                        Column(
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 0.0),
                                              child: Icon(
                                                Icons.square,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Checkbox(
                                                checkColor: Colors.white,
                                                value: redDynamic[index],
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    redDynamic[index] = value!;
                                                  });
                                                }),
                                          ],
                                        ),

                                        //MVP
                                        Column(
                                          children: [
                                            const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 4.0, bottom: 2.0),
                                                child: Text(
                                                  "MVP",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                )),
                                            Checkbox(
                                                checkColor: Colors.white,
                                                value: mvpDynamic[index],
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    mvpDynamic[index] = value!;
                                                  });
                                                }),
                                          ],
                                        ),
                                      ],
                                    ),
                                    player.goalkeeper
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text(
                                                "Encajados",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              NumberPicker(
                                                  axis: Axis.vertical,
                                                  itemWidth: 20,
                                                  itemCount: 3,
                                                  value: encDynamic[index],
                                                  minValue: 0,
                                                  maxValue: 10,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      encDynamic[index] = value;
                                                    });
                                                  }),
                                              const Icon(Icons.sports_soccer),
                                              NumberPicker(
                                                  axis: Axis.vertical,
                                                  itemWidth: 30,
                                                  itemCount: 3,
                                                  value: goalDynamic[index],
                                                  minValue: 0,
                                                  maxValue: 10,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      goalDynamic[index] =
                                                          value;
                                                    });
                                                  }),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.sports_soccer),
                                              NumberPicker(
                                                  axis: Axis.vertical,
                                                  itemWidth: 100,
                                                  itemCount: 3,
                                                  value: goalDynamic[index],
                                                  minValue: 0,
                                                  maxValue: 10,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      goalDynamic[index] =
                                                          value;
                                                    });
                                                  }),
                                            ],
                                          ),
                                  ],
                                )
                              : Container(),
                          const Divider(
                            color: Colors.grey,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
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

  _showAlertDialog(
      BuildContext context, String name, String surename, Function press) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancelar"),
      onPressed: () => Navigator.pop(context),
    );
    Widget continueButton = TextButton(
      child: Text("Continuar"),
      onPressed: () => press(),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Subir puntos de $name"),
      content: Text("Quieres subir los puntos de $name $surename?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
