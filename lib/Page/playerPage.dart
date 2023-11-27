import 'package:flutter/material.dart';



class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 500,
      height: 500,
      child: Text('PLAYERPAGE'),
    );
  }
}


