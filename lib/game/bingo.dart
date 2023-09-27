import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:plaktago/home/bingo_type_button.dart';
import 'package:plaktago/utils/isar_service.dart';
import 'package:plaktago/utils/game/game.dart';
import '../home/mode_button.dart';
import 'board/board.dart';
import 'game_data.dart';
import 'package:plaktago/game/board/card_name.dart';
import 'board/bingo_card.dart';
import 'dart:math';
import '../home/personalize.dart';
import 'package:another_flushbar/flushbar.dart';

class Bingo extends StatefulWidget {
  final GameData bingoParams;
  final List<PersonalizeCard> personalizeCards;
  final bool newGame;
  final IsarService isarService;
  final Id id;
  const Bingo(
      {Key? key,
      required this.bingoParams,
      required this.newGame,
      required this.isarService,
      required this.personalizeCards,
      this.id = -1})
      : super(key: key);

  @override
  State<Bingo> createState() => _Bingo();
}

class _Bingo extends State<Bingo> {
  int screenSizeRatio = 2;

  @override
  void initState() {
    super.initState();
    List<BingoCard> newBingoCards = [];

    _saveOnGoingGame();
    if (widget.newGame) {
      widget.bingoParams.setIsPlaying(true);
      widget.bingoParams.setPoints(0);
      if (widget.bingoParams.bingoParams.mode == Mode.personalize) {
        PersonalizeCard card;
        List<PersonalizeCard> cards = widget.bingoParams.personalizeCard
            .where((element) => element.isSelect == true)
            .toList();
        widget.bingoParams.setBingoCards([]);
        for (int it = 0; it < cards.length; it++) {
          card = cards.elementAt(it);
          newBingoCards
              .add((BingoCard(name: card.name, alcoolRule: '', nbShot: 1)));
        }
        newBingoCards.shuffle();
        widget.bingoParams.setBingoCards(newBingoCards);
      } else {
        CardName card;
        List<CardName> cardList = <CardName>[];
        cardList = cardNameListPlaque
            .where((element) =>
                element.type.contains(widget.bingoParams.bingoParams.bingoType))
            .toList();
        for (int it = 0;
            it < widget.bingoParams.nbLines * widget.bingoParams.nbLines;
            it++) {
          if (cardList.isEmpty &&
              widget.bingoParams.bingoParams.bingoType ==
                  BingoType.exploration) {
            cardList = cardNameListPlaque
                .where((element) => element.type.contains(BingoType.kta))
                .toList();
          }
          card = cardList.elementAt(Random().nextInt(cardList.length));
          cardList.remove(card);

          newBingoCards.add(BingoCard(
              name: card.name,
              alcoolRule: card.alcoolRule,
              nbShot: card.nbShot));
        }
        newBingoCards.shuffle();
        widget.bingoParams.setBingoCards(newBingoCards);
      }
    }
  }

  void askSaveGame() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      dialogBackgroundColor: Colors.grey[300],
      title: 'Sauvegarder la partie',
      titleTextStyle:
          TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      desc: 'Voulez vous vraiment sauvegarder cette partie ?',
      descTextStyle: TextStyle(color: Colors.black),
      btnCancelText: "Annuler",
      btnCancelOnPress: () {},
      btnOkOnPress: _saveGame,
    ).show();
  }

  void _saveGame() {
    initializeDateFormatting();
    late Game game;
    if (widget.newGame) {
      game = Game(
          gameNumber: widget.bingoParams.gameNumber,
          points: widget.bingoParams.points,
          bingoType: widget.bingoParams.bingoParams.bingoType,
          time: widget.bingoParams.timer.getTime(),
          hour: DateFormat("HH:mm").format(DateTime.now()),
          date: DateFormat('d/M/y').format(DateTime.now()),
          isAlcool: widget.bingoParams.isAlcool,
          nbShot: widget.bingoParams.nbShot,
          bingoCardList: widget.bingoParams.bingoCard);
    } else {
      game = Game(
          gameNumber: widget.bingoParams.gameNumber,
          points: widget.bingoParams.points,
          bingoType: widget.bingoParams.bingoParams.bingoType,
          time: widget.bingoParams.timer.getTime(),
          hour: DateFormat("HH:mm").format(DateTime.now()),
          date: DateFormat('d/M/y').format(DateTime.now()),
          isAlcool: widget.bingoParams.isAlcool,
          nbShot: widget.bingoParams.nbShot,
          bingoCardList: widget.bingoParams.bingoCard);
    }
    widget.isarService.saveGame(game, true);
    widget.bingoParams.setIsPlaying(false);
    widget.bingoParams.resetGameData();
    Navigator.pop(context);
  }

  void _saveOnGoingGame() {
    initializeDateFormatting();
    Game game = Game(
        id: widget.id,
        gameNumber: widget.id,
        points: widget.bingoParams.points,
        bingoType: widget.bingoParams.bingoParams.bingoType,
        time: widget.bingoParams.timer.getTime(),
        hour: DateFormat("HH:mm").format(DateTime.now()),
        date: DateFormat("dd MMMM yyyy", 'fr').format(DateTime.now()),
        isAlcool: widget.bingoParams.isAlcool,
        nbShot: widget.bingoParams.nbShot,
        bingoCardList: widget.bingoParams.bingoCard);
    widget.isarService.saveGame(game, false);
  }

  void changePoints(final int newPoint, final int index) {
    setState(() {
      if (widget.bingoParams.isAlcool && newPoint > 0) {
        Flushbar(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 70),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          titleText: Center(
              child: Text("Jeux d'alcool",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black))),
          messageText: Center(
              child: Text(
            widget.bingoParams.bingoCard.elementAt(index).alcoolRule,
            style: TextStyle(fontSize: 16, color: Colors.black),
          )),
          duration: Duration(seconds: 15),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ).show(context);
        widget.bingoParams
            .addShot(widget.bingoParams.bingoCard.elementAt(index).nbShot);
      }
      if (widget.bingoParams.isAlcool && newPoint < 0) {
        widget.bingoParams
            .removeShot(widget.bingoParams.bingoCard.elementAt(index).nbShot);
      }
      widget.bingoParams.changePoints(newPoint);
      widget.bingoParams.setTime(widget.bingoParams.timer.time);
      _saveOnGoingGame();
      if (widget.bingoParams.points == 56) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(style: TextStyle(color: Colors.black), "Bingo"),
                  content: Text(
                      style: TextStyle(color: Colors.black), "Vous avez gagné"),
                  backgroundColor: Colors.yellow[300]);
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 700) {
      screenSizeRatio = 4;
    }
    return Scaffold(
        appBar: AppBar(
            title: Row(children: [
          Container(
              margin: EdgeInsets.only(right: 15),
              child: Icon(FontAwesomeIcons.dungeon)),
          Text(
            'Bingo ${widget.bingoParams.bingoParams.bingoType.name}',
          ),
          if (widget.bingoParams.isAlcool)
            Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(FontAwesomeIcons.wineGlass)), //Icons.wine_bar))
        ])),
        body: ListView(children: [
          Align(
              child: Container(
                  margin: EdgeInsets.only(top: 40),
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(maxWidth: 450),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width /
                                screenSizeRatio,
                            child: widget.bingoParams.timer),
                        SizedBox(
                            width: MediaQuery.of(context).size.width /
                                screenSizeRatio,
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: widget.bingoParams.isAlcool ? 0 : 20),
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Points : ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500)),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            widget.bingoParams.points
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w400),
                                          ))
                                    ],
                                  ),
                                  if (widget.bingoParams.isAlcool)
                                    Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("Shots : ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  widget.bingoParams.nbShot
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ))
                                          ],
                                        ))
                                ])))
                      ]))),
          Center(
              child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Board(
                    gameType: widget.bingoParams.bingoParams.bingoType.name,
                    changePoints: changePoints,
                    bingoCard: widget.bingoParams.bingoCard,
                    nbLines: widget.bingoParams.nbLines,
                    saveGame: askSaveGame,
                  ))),
        ]));
  }
}
