import 'package:flutter/material.dart';
import 'package:plaktago/Game/cardName.dart';

class BingoCard {
  String name;
  bool isSelect = false;
  int nbLineComplete = 0;

  BingoCard(this.name);
}

class Board extends StatefulWidget {
  final String gameType;
  const Board({Key? key, required this.gameType}) : super(key: key);

  @override
  State<Board> createState() => _Board();
}

class _Board extends State<Board> {
  static const nbLines = 4;
  static List<BingoCard> _bingoCard = [];

  @override
  void initState() {
    super.initState();
    for (int it = 0; it < nbLines * nbLines; it++) {
      _bingoCard.add(BingoCard(cardNameList.elementAt(it).name));
      _bingoCard.elementAt(it).isSelect = false;
      _bingoCard.elementAt(it).nbLineComplete = 0;
    }
  }

  void resetCard() {
    setState(() {
      for (int it = 0; it < nbLines * nbLines; it++) {
        _bingoCard.elementAt(it).isSelect = false;
        _bingoCard.elementAt(it).nbLineComplete = 0;
      }
    });
  }

  Color getCardColor(int index) {
    if (_bingoCard.elementAt(index).isSelect == true) {
      if (_bingoCard.elementAt(index).nbLineComplete > 0) {
        return Colors.green;
      }
      return Colors.orange;
    }
    return Colors.red;
  }

  void _checkColumn(int index, bool newState) {
    int counter = 0;
    double buffer = index - ((index / nbLines) * nbLines) + index % nbLines;
    int cardPos = buffer.round();

    for (int it = 0; it < nbLines; it++) {
      if (_bingoCard.elementAt(cardPos + (it * nbLines)).isSelect == true) {
        counter += 1;
      }
    }
    if (counter == nbLines) {
      for (int it = 0; it < nbLines; it++) {
        _bingoCard.elementAt(cardPos + (it * nbLines)).nbLineComplete += 1;
      }
    } else if (counter == nbLines - 1 && !newState) {
      for (int it = 0; it < nbLines; it++) {
        _bingoCard.elementAt(cardPos + (it * nbLines)).nbLineComplete -= 1;
      }
    }
  }

  void _checkLine(int index, bool newState) {
    int cardPos = index - (index % nbLines);
    int counter = 0;
    for (int it = 0; it < nbLines; it++) {
      if (_bingoCard.elementAt(cardPos + it).isSelect == true) {
        counter += 1;
      }
    }
    if (counter == nbLines) {
      for (int it = 0; it < nbLines; it++) {
        _bingoCard.elementAt(cardPos + it).nbLineComplete += 1;
      }
    } else if (counter == nbLines - 1 && !newState) {
      for (int it = 0; it < nbLines; it++) {
        _bingoCard.elementAt(cardPos + it).nbLineComplete -= 1;
      }
    }
  }

  void _checkDiagonal(int index, bool newState) {
    int cardPos = index;
    int counter = 0;
    int buffer = 0;
    int incrementValue = 0;
    double halLines = (nbLines / 2) - 1;

    if (index == nbLines * (halLines.round() - 1) + 1) {
      _checkDiagonal(nbLines - 1, newState);
    }
    while (cardPos >= nbLines + 1) {
      cardPos -= nbLines + 1;
    }
    if (cardPos == 0) {
      incrementValue = nbLines + 1;
    } else if (cardPos == nbLines - 1) {
      incrementValue = cardPos;
    } else {
      return;
    }
    buffer = cardPos;
    for (int it = 0; it < nbLines; it++) {
      if (_bingoCard.elementAt(buffer).isSelect) {
        counter += 1;
      }
      buffer += incrementValue;
    }
    buffer = cardPos;
    if (counter == nbLines) {
      for (int it = 0; it < nbLines; it++) {
        _bingoCard.elementAt(buffer).nbLineComplete += 1;
        buffer += incrementValue;
      }
    } else if (counter == nbLines - 1 && !newState) {
      for (int it = 0; it < nbLines; it++) {
        _bingoCard.elementAt(buffer).nbLineComplete -= 1;
        buffer += incrementValue;
      }
    }
  }

  void _onCardTapped(int index) {
    bool newState = !_bingoCard.elementAt(index).isSelect;
    setState(() {
      _bingoCard.elementAt(index).isSelect =
          !_bingoCard.elementAt(index).isSelect;
      _checkColumn(index, newState);
      _checkLine(index, newState);
      _checkDiagonal(index, newState);
    });
  }

  void refreshBoard() {
    print("refresh");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: Column(children: [
          Container(
              height: 800,
              margin: const EdgeInsets.only(bottom: 30.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: nbLines,
                  ),
                  itemCount: nbLines * nbLines,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => _onCardTapped(index),
                      child: Card(
                        color: getCardColor(index),
                        child: Center(
                            child: Text(_bingoCard.elementAt(index).name)),
                      ),
                    );
                  })),
          TextButton.icon(
            onPressed: refreshBoard,
            icon: const Icon(Icons.restart_alt),
            label: const Text('Random'),
          ),
        ]));
  }
}
