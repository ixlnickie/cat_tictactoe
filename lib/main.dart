import 'package:flutter/material.dart';

void main() => runApp(const CatTicTacToe());

class CatTicTacToe extends StatelessWidget {
  const CatTicTacToe({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.filled(9, "");
  bool xTurn = true;
  String winner = "";
  int? winningLineIndex;

  final List<List<int>> lines = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6]
  ];

  void _reset() {
    setState(() {
      board = List.filled(9, "");
      xTurn = true;
      winner = "";
      winningLineIndex = null;
    });
  }

  void _handleTap(int index) {
    if (board[index] != "" || winner != "") return;
    setState(() {
      board[index] = xTurn ? "🐱" : "☁️";
      xTurn = !xTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    for (int i = 0; i < lines.length; i++) {
      var line = lines[i];
      if (board[line[0]] != "" && board[line[0]] == board[line[1]] && board[line[0]] == board[line[2]]) {
        setState(() {
          winner = board[line[0]];
          winningLineIndex = i;
        });
        return;
      }
    }
    if (!board.contains("")) setState(() => winner = "Draw");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Purr-fect Game", style: TextStyle(fontSize: 32, color: Colors.pink[300], fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 300,
                  height: 300,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                    itemCount: 9,
                    itemBuilder: (context, i) => GestureDetector(
                      onTap: () => _handleTap(i),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9FB),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.pink[50]!),
                        ),
                        child: Center(child: Text(board[i], style: const TextStyle(fontSize: 40))),
                      ),
                    ),
                  ),
                ),
                if (winningLineIndex != null)
                  IgnorePointer(
                    child: CustomPaint(
                      size: const Size(300, 300),
                      painter: LinePainter(winningLineIndex!),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Text(
            winner == "" ? "Ход: ${xTurn ? "🐱" : "☁️"}" : (winner == "Draw" ? "Ничья!" : "Победа!"),
            style: TextStyle(fontSize: 24, color: Colors.pink[400]),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _reset,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[200]),
            child: const Text("ЗАНОВО", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final int lineIndex;
  LinePainter(this.lineIndex);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.pinkAccent.withOpacity(0.8)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    double q = size.width / 3;
    double hq = q / 2;

    List<List<Offset>> points = [
      [Offset(10, hq), Offset(size.width - 10, hq)],
      [Offset(10, q + hq), Offset(size.width - 10, q + hq)],
      [Offset(10, 2 * q + hq), Offset(size.width - 10, 2 * q + hq)],
      [Offset(hq, 10), Offset(hq, size.height - 10)],
      [Offset(q + hq, 10), Offset(q + hq, size.height - 10)],
      [Offset(2 * q + hq, 10), Offset(2 * q + hq, size.height - 10)],
      [Offset(30, 30), Offset(size.width - 30, size.height - 30)],
      [Offset(size.width - 30, 30), Offset(30, size.height - 30)],
    ];

    canvas.drawLine(points[lineIndex][0], points[lineIndex][1], paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}