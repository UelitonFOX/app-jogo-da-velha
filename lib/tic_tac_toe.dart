import 'package:flutter/material.dart';
import 'dart:math';

class TicTacToe extends StatefulWidget {
  final String playerX;
  final String playerO;
  final bool isPvP;
  final String difficulty;

  const TicTacToe({
    Key? key,
    required this.playerX,
    required this.playerO,
    required this.isPvP,
    required this.difficulty,
  }) : super(key: key);

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<String> board = List.generate(9, (_) => '');
  bool isXTurn = true;
  bool isGameOver = false;

  int xWins = 0;
  int oWins = 0;
  int draws = 0;

  void _handleTap(int index) {
    if (isGameOver || board[index] != '') return;

    setState(() {
      board[index] = isXTurn ? 'X' : 'O';
      if (_checkWinner(board[index])) {
        _updateScore(board[index]);
        _showWinnerDialog(board[index]);
        isGameOver = true;
      } else if (!board.contains('')) {
        draws++;
        _showWinnerDialog(null); // Empate
        isGameOver = true;
      } else {
        isXTurn = !isXTurn; // Alternar turno
        if (!isXTurn && !widget.isPvP) {
          _computerMove(); // Computador joga automaticamente
        }
      }
    });
  }

  void _computerMove() async {
    // Aguardar 500ms para simular o tempo de "pensar" do computador
    await Future.delayed(const Duration(milliseconds: 500));

    int move;
    if (widget.difficulty == 'Difícil') {
      move = _strategicMove();
    } else {
      move = _randomMove();
    }

    setState(() {
      board[move] = 'O';
      if (_checkWinner('O')) {
        _updateScore('O');
        _showWinnerDialog('O');
        isGameOver = true;
      } else if (!board.contains('')) {
        draws++;
        _showWinnerDialog(null); // Empate
        isGameOver = true;
      } else {
        isXTurn = true; // Retorna o turno ao jogador
      }
    });
  }

  void _updateScore(String winner) {
    if (winner == 'X') {
      xWins++;
    } else if (winner == 'O') {
      oWins++;
    }
  }

  int _strategicMove() {
    String currentPlayer = 'O';
    String opponentPlayer = 'X';

    // 1. Check for a winning move
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = currentPlayer;
        if (_checkWinner(currentPlayer)) {
          board[i] = ''; // Undo
          return i;
        }
        board[i] = ''; // Undo
      }
    }

    // 2. Block opponent's winning move
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = opponentPlayer;
        if (_checkWinner(opponentPlayer)) {
          board[i] = ''; // Undo
          return i;
        }
        board[i] = ''; // Undo
      }
    }

    // 3. Prioritize center
    if (board[4] == '') {
      return 4;
    }

    // 4. Prioritize corners
    List<int> corners = [0, 2, 6, 8];
    for (int corner in corners) {
      if (board[corner] == '') {
        return corner;
      }
    }

    // 5. Random move
    return _randomMove();
  }

  int _randomMove() {
    final emptyCells = board.asMap().entries.where((e) => e.value == '').map((e) => e.key).toList();
    return emptyCells[Random().nextInt(emptyCells.length)];
  }

  bool _checkWinner(String player) {
    const winConditions = [
      [0, 1, 2], // Rows
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6], // Columns
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8], // Diagonais
      [2, 4, 6],
    ];

    for (var condition in winConditions) {
      if (condition.every((index) => board[index] == player)) {
        return true;
      }
    }
    return false;
  }

  void _showWinnerDialog(String? winner) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(winner == null ? 'Empate!' : 'Vitória!'),
        content: Text(
          winner == null ? 'Ninguém venceu!' : '$winner venceu!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      board = List.generate(9, (_) => '');
      isXTurn = true;
      isGameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final boardSize = min(screenSize.width, screenSize.height) * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.playerX} vs ${widget.playerO}'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Placar',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${widget.playerX}: $xWins',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  '${widget.playerO}: $oWins',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  'Empates: $draws',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: boardSize,
              height: boardSize,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _handleTap(index),
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          board[index],
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              child: const Text(
                'Reiniciar Jogo',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
