
import 'package:dms_app/models/user_model.dart';
import 'package:dms_app/service/data_services.dart';
import 'package:dms_app/widgets/player_field.dart';
import 'package:flutter/material.dart';

class UserPlayerView extends StatelessWidget {
  const UserPlayerView({super.key, required this.userId, required this.userName});
  final String userId;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(userName),),
      backgroundColor: Colors.red,
      body: SingleChildScrollView(
        child: StreamBuilder(
      stream: DataServices().userInfo(userId),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data!;

          return Stack(
            children: [
              //Pista
              Image.asset('assets/pista.png'),
              //Jugador1

              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Center(
                  child: PlayerField(
                    playerName: "Pivot",
                    imagePlayer: "",
                    playerId: user.pivot,
                  ),
                ),
              ),

              Positioned(
                top: 190,
                left: 40,
                child: PlayerField(
                  playerName: "Ala Izq",
                  imagePlayer: "",
                  playerId: user.alaIzq,
                ),
              ),

              Positioned(
                top: 190,
                left: MediaQuery.of(context).size.width / 1.5,
                child: PlayerField(
                  playerName: "Ala Der",
                  imagePlayer: "",
                  playerId: user.alaDer,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 290),
                child: Center(
                  child: PlayerField(
                    playerName: "Cierre",
                    imagePlayer: "",
                    playerId: user.cierre,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 410),
                child: Center(
                  child: PlayerField(
                    playerName: "Portero",
                    imagePlayer: "",
                    playerId: user.portero,
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    )),
    );
  }
}
