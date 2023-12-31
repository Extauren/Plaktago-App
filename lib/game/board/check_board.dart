import 'package:plaktago/data_class/bingo_card.dart';

class CheckBoard {
  final int nbLines;

  CheckBoard({required this.nbLines});

  int checkColumn(List<BingoCard> bingoCard, int index, bool newState) {
    int counter = 0;
    double buffer = index - ((index / nbLines) * nbLines) + index % nbLines;
    int cardPos = buffer.round();
    for (int it = 0; it < nbLines; it++) {
      if (bingoCard.elementAt(cardPos + (it * nbLines)).isSelect == true) {
        counter += 1;
      }
    }
    if (counter == nbLines) {
      for (int it = 0; it < nbLines; it++) {
        bingoCard.elementAt(cardPos + (it * nbLines)).nbLineComplete += 1;
      }
      return 4;
    } else if (counter == nbLines - 1 && !newState) {
      for (int it = 0; it < nbLines; it++) {
        bingoCard.elementAt(cardPos + (it * nbLines)).nbLineComplete -= 1;
      }
      return -4;
    }
    return 0;
  }

  int checkLine(List<BingoCard> bingoCard, int index, bool newState) {
    int cardPos = index - (index % nbLines);
    int counter = 0;
    for (int it = 0; it < nbLines; it++) {
      if (bingoCard.elementAt(cardPos + it).isSelect == true) {
        counter += 1;
      }
    }
    if (counter == nbLines) {
      for (int it = 0; it < nbLines; it++) {
        bingoCard.elementAt(cardPos + it).nbLineComplete += 1;
      }
      return 4;
    } else if (counter == nbLines - 1 && !newState) {
      for (int it = 0; it < nbLines; it++) {
        bingoCard.elementAt(cardPos + it).nbLineComplete -= 1;
      }
      return -4;
    }
    return 0;
  }

  int checkDiagonal(
      List<BingoCard> bingoCard, int index, bool newState, int incrementValue) {
    int counter = 0;
    int buffer = 0;

    buffer = index;
    for (int it = 0; it < nbLines; it++) {
      if (bingoCard.elementAt(buffer).isSelect) {
        counter += 1;
      }
      buffer += incrementValue;
    }
    buffer = index;
    if (counter == nbLines) {
      for (int it = 0; it < nbLines; it++) {
        bingoCard.elementAt(buffer).nbLineComplete += 1;
        buffer += incrementValue;
      }
      return 4;
    } else if (counter == nbLines - 1 && !newState) {
      for (int it = 0; it < nbLines; it++) {
        bingoCard.elementAt(buffer).nbLineComplete -= 1;
        buffer += incrementValue;
      }
      return -4;
    }
    return 0;
  }
}
