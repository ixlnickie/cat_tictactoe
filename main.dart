import 'dart:io';

void main() {
  List<String> board = List.generate(9, (i) => (i + 1).toString());
  bool xTurn = true;
  int moves = 0;

  while (true) {
    print('\x1B[2J\x1B[0;0H'); 
    print('КРЕСТИКИ-НОЛИКИ\n');
    print(' ${board[0]} | ${board[1]} | ${board[2]} ');
    print('-----------');
    print(' ${board[3]} | ${board[4]} | ${board[5]} ');
    print('-----------');
    print(' ${board[6]} | ${board[7]} | ${board[8]} \n');

    if (checkWin(board)) {
      print('Игрок ${xTurn ? "O" : "X"} победил!');
      break;
    } else if (moves == 9) {
      print('Ничья!');
      break;
    }

    stdout.write('Ход ${xTurn ? "X" : "O"} (введи номер 1-9): ');
    String? input = stdin.readLineSync();
    int? choice = int.tryParse(input ?? '') != null ? int.parse(input!) - 1 : null;

    if (choice != null && choice >= 0 && choice < 9 && board[choice] != 'X' && board[choice] != 'O') {
      board[choice] = xTurn ? 'X' : 'O';
      xTurn = !xTurn;
      moves++;
    }
  }
}

bool checkWin(List<String> b) {
  List<List<int>> lines = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6]
  ];
  for (var line in lines) {
    if (b[line[0]] == b[line[1]] && b[line[1]] == b[line[2]]) return true;
  }
  return false;
}