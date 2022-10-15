import 'package:dms_app/models/user_model.dart';
import 'package:dms_app/service/data_services.dart';
import 'package:dms_app/widgets/player_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserPlayerView extends StatelessWidget {
  const UserPlayerView(
      {super.key, required this.userId, required this.userName});
  final String userId;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
      ),
      body: SingleChildScrollView(
          child: StreamBuilder(
        stream: DataServices().userInfo(userId),
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data!;

            return Column(
              children: [
                Stack(
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
                ),
                
                user.avatar == ''
                    ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.18,
                            child: FaIcon(
                              FontAwesomeIcons.userLarge,
                              size: MediaQuery.of(context).size.width * 0.15,
                            ),
                          ),
                        ),
                    )
                    : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                          child: FutureBuilder(
                              future: FirebaseStorage.instance
                                  .ref(user.avatar)
                                  .getDownloadURL(),
                              builder: (context, AsyncSnapshot<String> snapshot) {
                                debugPrint(snapshot.data);
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }

                                return CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: CircleAvatar(
                                    maxRadius:
                                        MediaQuery.of(context).size.width * 0.15,
                                    backgroundImage: NetworkImage(snapshot.data!),
                                  ),
                                );
                              }),
                        ),
                    ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "Puntos totales: ${user.points}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
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
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: user.jornadaList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        'Jornada ${index+1}',
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                      trailing: Text(
                        '${user.jornadaList[index]}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: user.jornadaList[index] < 0
                                ? Colors.red
                                : user.jornadaList[index] < 4
                                    ? Colors.amber
                                    : user.jornadaList[index] < 9
                                        ? Colors.green
                                        : Colors.blue),
                      ),
                    );
                  },
                )
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
