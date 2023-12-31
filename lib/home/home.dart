import 'package:flutter/material.dart';
import 'package:plaktago/components/border_button.dart';
import 'package:plaktago/data_class/bingo_card.dart';
import 'package:plaktago/data_class/game.dart';
import 'package:plaktago/utils/isar_service.dart';
import 'package:plaktago/data_class/app_settings.dart';
import '../game/bingo.dart';
import 'bingo_type_button.dart';
import 'mode_button.dart';
import 'personalize.dart';
import 'package:plaktago/components/dialog.dart';

class Home extends StatefulWidget {
  final Game bingoParams;
  final Function changeTheme;
  final AppSettings appSettings;
  final IsarService isarService;
  Home(
      {Key? key,
      required this.changeTheme,
      required this.appSettings,
      required this.bingoParams,
      required this.isarService})
      : super(key: key);

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  final Key bingoTypeKey = PageStorageKey('bingoType');
  final Key personalizeKey = PageStorageKey('personalizeKey');
  int nbCards = 0;
  List<PersonalizeCard> persCard = [];
  ScrollController _childScrollController = ScrollController();
  ScrollController _parentScrollController = ScrollController();
  Game activeGame = Game();
  late Future<Game?> test = Future.value(null);
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    getOnGoingGame();
    test = widget.isarService.getOnGoingGame();
  }

  void getOnGoingGame() async {
    Game? game = await widget.isarService.getOnGoingGame();
    if (game != null) {
      setState(() {
        activeGame = game;
        print(activeGame.isPlaying);
      });
    } else {
      activeGame = Game();
    }
    test = widget.isarService.getOnGoingGame();
  }

  void changeNbCardValue(int value) {
    setState(() {
      nbCards = value;
    });
  }

  void startGame() {
    if (widget.bingoParams.mode == Mode.personalize) {
      List<BingoCard> buffer = [];
      for (int it = 0; it < persCard.length; it++) {
        buffer.add(BingoCard(
            name: persCard.elementAt(it).name,
            icon: persCard.elementAt(it).icon));
      }
      buffer.shuffle();
      widget.bingoParams.bingoCards = buffer;
    }
    activeGame = widget.bingoParams;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Bingo(
                bingoParams: activeGame,
                newGame: true,
                isarService: widget.isarService,
                displayTimer: widget.appSettings.displayTimer))).then((value) {
      nbCards = 0;
      setState(() {
        test = Future.value(null);
        getOnGoingGame();
      });
    });
  }

  void launchGame() {
    final int nbCardNeed = 16 - nbCards;
    if (nbCards < 16 && widget.bingoParams.mode == Mode.personalize) {
      PDialog(
              context: context,
              desc: 'Vous devez sélectionner $nbCardNeed cases supplémentaires',
              title: "Erreur",
              bntOkOnPress: () {})
          .show();
      return;
    }
    if (isPlaying) {
      PDialog(
              context: context,
              title: 'Partie en cours',
              desc:
                  'Vous avez déja une partie en cours, êtes vous sur de vouloir la supprimer ?',
              bntOkOnPress: startGame)
          .show();
      return;
    }
    startGame();
  }

  void comeBacktoGame() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Bingo(
                bingoParams: activeGame,
                newGame: false,
                isarService: widget.isarService,
                displayTimer: widget.appSettings.displayTimer))).then((value) {
      setState(() {
        test = Future.value(null);
        getOnGoingGame();
      });
    });
  }

  void updateBingoType(final BingoType bingoType) {
    setState(() {
      widget.bingoParams.bingoType = bingoType;
    });
  }

  void setMode(final Mode mode) {
    setState(() {
      widget.bingoParams.mode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: PAppBar(
        //   borderColor: Theme.of(context).colorScheme.background,
        // ),
        // drawer: DrawerApp(
        //     changeTheme: widget.changeTheme,
        //     appSettings: widget.appSettings,
        //     isarService: widget.isarService),
        body: ListView(controller: _parentScrollController, children: [
      Container(
          margin: const EdgeInsets.only(top: 40, left: 60, right: 60),
          child: Image.asset('assets/lettrahge0_1x.png')),
      FutureBuilder<Game?>(
          future: test,
          builder: (BuildContext context, AsyncSnapshot<Game?> snapshot) {
            Widget child = Container();
            if (snapshot.hasData) {
              isPlaying = snapshot.data!.isPlaying;
              if (snapshot.data != null && activeGame.isPlaying) {
                child = Align(
                  child: Align(
                      child: Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: PBorderButton(
                            heroTag: "oldGame",
                            label: "Reprendre la partie",
                            onPressed: comeBacktoGame,
                            width: 180,
                            height: 42,
                            labelStyle:
                                TextStyle(fontSize: 16, color: Colors.black),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ))),
                );
              }
            }
            return child;
          }),
      Container(
          margin: EdgeInsets.only(top: 40, left: 0, right: 0),
          child: BingoTypeButton(
            key: bingoTypeKey,
            bingoType: widget.bingoParams.bingoType,
            updateBingoType: updateBingoType,
          )),
      Container(
          margin: EdgeInsets.only(top: 40, bottom: 0),
          child: ModeButton(
            mode: widget.bingoParams.mode,
            updateBingoMode: setMode,
          )),
      if (widget.bingoParams.mode == Mode.personalize)
        Container(
            margin: EdgeInsets.only(top: 40),
            child: NotificationListener(
                onNotification: (ScrollNotification notification) {
                  if (notification is ScrollUpdateNotification) {
                    if (notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                      _parentScrollController.animateTo(
                          _parentScrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    } else if (notification.metrics.pixels ==
                        notification.metrics.minScrollExtent) {
                      _parentScrollController.animateTo(
                          _parentScrollController.position.minScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    }
                  }
                  return true;
                },
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                      maxHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Personalize(
                        key: personalizeKey,
                        cards: persCard,
                        type: widget.bingoParams.bingoType,
                        nbCardSelect: nbCards,
                        changeNbCardValue: changeNbCardValue,
                        controller: _childScrollController)))),
      Align(
          child: Padding(
              padding: EdgeInsets.only(top: 40, bottom: 20),
              child: PBorderButton(
                heroTag: "newGame",
                label: "Jouer",
                labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                onPressed: launchGame,
                width: 120,
                height: 42,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ))),
      Container(
          margin:
              const EdgeInsets.only(bottom: 0, top: 10, left: 80, right: 80),
          child: Image.asset('assets/homePlaque.png'))
    ]));
  }
}
