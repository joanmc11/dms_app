import 'package:dms_app/models/player_model.dart';
import 'package:dms_app/service/data_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: players.length,
              itemBuilder: (BuildContext context, int index) {
                PlayerModel player = players[index];
                goalDynamic[index] = goalDynamic[index] ?? 0;
                yellowDynamic[index] = yellowDynamic[index] ?? false;
                redDynamic[index] = redDynamic[index] ?? false;
                mvpDynamic[index] = mvpDynamic[index] ?? false;

                return Column(
                  children: [
                    ListTile(
                      style: ListTileStyle.drawer,
                      title: Text('${player.name} ${player.surename}'),
                      leading: player.image == ''
                          ? const CircleAvatar(backgroundColor: Colors.red)
                          : FutureBuilder(
                              future: FirebaseStorage.instance
                                  .ref(player.image)
                                  .getDownloadURL(),
                              builder:
                                  (context, AsyncSnapshot<String> snapshot) {
                                debugPrint(snapshot.data);
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }

                                return CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data!),
                                );
                              }),
                      subtitle: const Text('Puntua abajo este jugador'),
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Icon(Icons.sports_soccer),
                        ),
                        NumberPicker(
                            value: goalDynamic[index],
                            minValue: 0,
                            maxValue: 10,
                            onChanged: (value) {
                              setState(() {
                                goalDynamic[index] = value;
                              });
                            }),

                            //Yellow Card
                       Column(children: [
                         const Padding(
                          padding: EdgeInsets.only(left: 0.0),
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
                                yellowDynamic[index] = value!;
                              });
                            }),
                       ],),

                            //red card
                          Column(children: [
                              const Padding(
                          padding: EdgeInsets.only(left: 0.0),
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
                          ],),

                          //MVP
                        Column(children: [
                             const Padding(
                          padding: EdgeInsets.only(left: 0.0),
                          child: Text("MVP:")
                        ),

                        
                        Checkbox(
                            checkColor: Colors.white,
                            value: mvpDynamic[index],
                            onChanged: (bool? value) {
                              setState(() {
                                mvpDynamic[index] = value!;
                              });
                            }),
                        ],),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(onPressed: (){}, child: Text("subir"), ),
                        )

                        
                          
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                  ],
                );
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
}
