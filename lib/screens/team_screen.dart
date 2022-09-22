import 'package:dms_app/models/player_model.dart';
import 'package:dms_app/widgets/player_field.dart';
import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget {
  TeamScreen({super.key});

  final List<Player> players = [
    Player(
        id: 1,
        name: "Joan",
        surename: "Marine",
        points: 0,
        image: "",
        goalkeeper: false),
    Player(
        id: 1,
        name: "Alvaro",
        surename: "Cercos",
        points: 0,
        image: "",
        goalkeeper: false),
    Player(
        id: 1,
        name: "Gerard",
        surename: "Solé",
        points: 0,
        image: "",
        goalkeeper: false),
    Player(
        id: 1,
        name: "Marc",
        surename: "Jauregui",
        points: 0,
        image: "",
        goalkeeper: false),
    Player(
        id: 1,
        name: "Marc",
        surename: "Solá",
        points: 0,
        image: "",
        goalkeeper: true),
    Player(
        id: 1,
        name: "Marc",
        surename: "Grau",
        points: 0,
        image: "",
        goalkeeper: false),
    Player(
        id: 1,
        name: "Jan",
        surename: "Aranyó",
        points: 0,
        image: "",
        goalkeeper: false),
    Player(
        id: 1,
        name: "Imanol",
        surename: "Cognom",
        points: 0,
        image: "",
        goalkeeper: true),
    Player(
        id: 1,
        name: "Imanol",
        surename: "Cognom",
        points: 0,
        image: "",
        goalkeeper: true),
    Player(
        id: 1,
        name: "Imanol",
        surename: "Cognom",
        points: 0,
        image: "",
        goalkeeper: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Mi Equipo')),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            children: [
              //Pista
              Image.asset('assets/pista.png'),
              //Jugador1

              Padding(
                padding: EdgeInsets.only(top: 60),
                child: Center(
                  child: GestureDetector(
                    onTap: () => _showPlayerList(context),
                    child: PlayerField(playerName: "Pivot", imagePlayer: ""),
                  ),
                ),
              ),

              Positioned(
                top: 190,
                left: 40,
                child: GestureDetector(
                  onTap: () => _showPlayerList(context),
                  child: PlayerField(playerName: "Ala Izq", imagePlayer: ""),
                ),
              ),

              Positioned(
                top: 190,
                left: MediaQuery.of(context).size.width / 1.4,
                child: GestureDetector(
                  onTap: () => _showPlayerList(context),
                  child: PlayerField(playerName: "Ala Der", imagePlayer: ""),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 300),
                child: Center(
                  child: GestureDetector(
                    onTap: () => _showPlayerList(context),
                    child: PlayerField(playerName: "Cierre", imagePlayer: ""),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 430),
                child: Center(
                  child: GestureDetector(
                    onTap: () => _showGoalkeepersList(context),
                    child: PlayerField(playerName: "Portero", imagePlayer: ""),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(child: Text("Jugadores DMS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))),
          ),
          Divider(color: Colors.red, height: 5, thickness: 2),

          ...players
              .map((player) => Column(
                    children: [
                      ListTile(
                        title: Text('${player.name} ${player.surename}'),
                        leading:
                            const CircleAvatar(backgroundColor: Colors.red),
                        subtitle: Text('Puntos: ${player.points}'),
                        trailing: Text("Partidos jugados: 2"),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                    ],
                  ))
              .toList()
        ]),
      ),
    );
  }

  _showPlayerList(context) {
    List<Player> fieldPlayers = [];
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
            height: 400.0,
            width: 400.0,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: fieldPlayers.length,
              itemBuilder: (BuildContext context, int index) {
                
                return ListTile(
                  title:
                      Text('${fieldPlayers[index].name} ${fieldPlayers[index].surename}'),
                  leading: const CircleAvatar(backgroundColor: Colors.red),
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

  _showGoalkeepersList(context) {
    List<Player> goalkeepers = [];
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
            height: 400.0,
            width: 400.0,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: goalkeepers.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title:
                      Text('${goalkeepers[index].name} ${goalkeepers[index].surename}'),
                  leading: const CircleAvatar(backgroundColor: Colors.red),
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
