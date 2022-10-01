import 'package:dms_app/models/player_model.dart';
import 'package:dms_app/widgets/player_field.dart';
import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget {
  TeamScreen({super.key});

  final List<Player> players = [
    Player(
        id: 1,
        name: "Player 1",
        surename: "Player 1",
        points: 0,
        image: "",
        goalkeeper: false),
    Player(
        id: 1,
        name: "Player 2",
        surename: "Player 2",
        points: 0,
        image: "",
        goalkeeper: false),
    Player(
        id: 1,
        name: "Player 3",
        surename: "Player 3",
        points: 0,
        image: "",
        goalkeeper: false),
    Player(
        id: 1,
        name: "Player 4",
        surename: "Player 4",
        points: 0,
        image: "",
        goalkeeper: false),
    Player(
        id: 1,
        name: "Goalkeeper 1",
        surename: "Goalkeeper 1",
        points: 0,
        image: "",
        goalkeeper: true),
    Player(
        id: 1,
        name: "Player 5",
        surename: "Player 5",
        points: 0,
        image: "",
        goalkeeper: false),
    Player(
        id: 1,
        name: "Player 6",
        surename: "Player 6",
        points: 0,
        image: "",
        goalkeeper: false),
    Player(
        id: 1,
        name: "Goalkeeper 2",
        surename: "Goalkeeper 2",
        points: 0,
        image: "",
        goalkeeper: true),
    
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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

          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: Text("Jugadores DMS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))),
          ),
          const Divider(color: Colors.red, height: 5, thickness: 2),

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
            height: 350.0,
            width: 350.0,
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
            height: 350.0,
            width: 350.0,
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
