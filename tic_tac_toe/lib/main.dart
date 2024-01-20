import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/game.dart';

void main() {
  runApp(const TictacToe());
}

class TictacToe extends StatelessWidget {
  const TictacToe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic-Tac-Toe-App',
      home: GameScreen(),
    );
  }
}
