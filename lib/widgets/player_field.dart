import 'package:flutter/material.dart';

class PlayerField extends StatelessWidget {
  const PlayerField(
      {super.key, required this.playerName, required this.imagePlayer});

  final String playerName;
  final String imagePlayer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.blue[800]!.withOpacity(0.7),
          borderRadius: const BorderRadius.all(Radius.circular(350))),
      child: Column(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.add),
          ),
          Text(playerName, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
