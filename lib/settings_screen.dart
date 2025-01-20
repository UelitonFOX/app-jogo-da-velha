import 'package:flutter/material.dart';
import 'tic_tac_toe.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController playerXController = TextEditingController();
  final TextEditingController playerOController = TextEditingController();
  String mode = 'PvP';
  String difficulty = 'Fácil';

  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicTacToe(
          playerX: playerXController.text.isEmpty ? 'Jogador X' : playerXController.text,
          playerO: mode == 'PvP'
              ? (playerOController.text.isEmpty ? 'Jogador O' : playerOController.text)
              : 'Computador ($difficulty)',
          isPvP: mode == 'PvP',
          difficulty: difficulty,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações do Jogo'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Modo de Jogo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text('Jogador vs Jogador'),
                    value: 'PvP',
                    groupValue: mode,
                    onChanged: (value) {
                      setState(() => mode = value!);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text('Jogador vs Computador'),
                    value: 'PvC',
                    groupValue: mode,
                    onChanged: (value) {
                      setState(() => mode = value!);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: playerXController,
              decoration: const InputDecoration(
                labelText: 'Nome do Jogador X',
              ),
            ),
            if (mode == 'PvP')
              TextField(
                controller: playerOController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Jogador O',
                ),
              ),
            if (mode == 'PvC') ...[
              const SizedBox(height: 16),
              const Text(
                'Dificuldade:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: difficulty,
                items: ['Fácil', 'Difícil', 'Insano']
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => difficulty = value!);
                },
              ),
            ],
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ),
                child: const Text(
                  'Iniciar Jogo',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
