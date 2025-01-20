
import 'package:flutter/material.dart';
import 'tic_tac_toe.dart';

class BaseLayout extends StatefulWidget {
  const BaseLayout({super.key, required this.title});

  final String title;

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blueGrey.shade900,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            constraints: const BoxConstraints(
              maxWidth: 400.0,
              minWidth: 280.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white, // Change the container color
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const TicTacToe(
              playerX: 'Player 1',
              playerO: 'Player 2',
              isPvP: false,
              difficulty: 'Difícil',
            ),
          ),
        ),
      ),
    );
  }
}
