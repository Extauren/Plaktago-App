import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plaktago/components/app_bar.dart';
import 'package:plaktago/components/dialog.dart';
import 'package:plaktago/components/outlined_button.dart';
import 'package:plaktago/components/table.dart';
import 'package:plaktago/data_class/app_settings.dart';
import 'package:plaktago/game/board/card_name.dart';
import 'package:plaktago/settings/github_page.dart';
import 'package:plaktago/home/bingo_type_button.dart';
import 'package:plaktago/utils/isar_service.dart';

class Settings extends StatefulWidget {
  final IsarService isarService;
  final AppSettings appSettings;
  Settings({Key? key, required this.isarService, required this.appSettings});

  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {
  List<CardName> cardsName = cardNameListPlaque;

  @override
  void initState() {
    super.initState();
    cardsName.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }

  void goToGithubPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GithubPage()));
  }

  String getType(List<BingoType> types) {
    var test = types.asNameMap();
    List<String> i = [];
    test.forEach((key, value) {
      i.add(value.name);
    });
    return i.join(', ');
  }

  void resetData() {
    PDialog(
            context: context,
            title: "Supprimer les données",
            desc: "Etes vous sur de vouloir supprimer toutes les données ?",
            bntOkOnPress: widget.isarService.deleteAllData)
        .show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PAppBar(title: Text("Paramètres")),
        body: ListView(children: [
          SizedBox(height: 40),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Plaktago est une application open source qui ne récolte aucunes données sur ces utilisateurs.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
              child: TextButton(
                  onPressed: goToGithubPage,
                  child: Text("Le code source est disponible sur Github",
                      style: TextStyle(fontSize: 16)))),
          POutlinedButton(
            label: "Supprimer toutes les données",
            onPressed: resetData,
            height: 38,
            width: 230,
            margin: EdgeInsets.symmetric(vertical: 20),
            labelFontSize: 15,
          ),
          PTable(
      headerText: cardsName.,
      rowsText: rowsText,
      nbRows: widget.nbRows,
      headingRowHeight: widget.headingRowHeight,
      dataRowHeight: widget.dataRowHeight,
    );
        ])

        //ListView(children: [
        // Container(
        //     margin: EdgeInsets.only(top: 20, bottom: 10),
        //     child: Icon(
        //       FontAwesomeIcons.github,
        //       size: 40,
        //     )),

        // TextButton(
        //     onPressed: goToGithubPage,
        //     child: Text("https://github.com/Extauren/Plaktago-App",
        //         style: TextStyle(fontSize: 17))),
        // Container(
        //     margin: const EdgeInsets.only(
        //         top: 20.0, left: 10, right: 10, bottom: 20),
        //     child: Text("Type de parties",
        //         style: Theme.of(context).textTheme.titleLarge,
        //         textAlign: TextAlign.center)),
        // Container(
        //     margin: EdgeInsets.only(top: 10, left: 30, right: 10),
        //     child:
        //         Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //       Text("Bingo Plaque : ",
        //           style: TextStyle(fontWeight: FontWeight.bold)),
        //       SizedBox(
        //           width: MediaQuery.of(context).size.width / 1.6,
        //           child: Text(
        //             "Vous cochez les cases en fonctions des actions que vous voyez des cataphiles qui descentes ou remontes",
        //           ))
        //     ])),
        // Container(
        //     margin: EdgeInsets.only(top: 10, left: 30),
        //     child:
        //         Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //       Text("Bingo KTA : ",
        //           style: TextStyle(fontWeight: FontWeight.bold)),
        //       SizedBox(
        //           width: MediaQuery.of(context).size.width - 150,
        //           child: Text(
        //             "Vous cochez les cases en fonctions des actions que vous voyez des cataphiles que vous rencontrez",
        //           ))
        //     ])),
        // Container(
        //     margin: EdgeInsets.only(top: 10, left: 30),
        //     child:
        //         Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //       Text("Bingo Explo : ",
        //           style: TextStyle(fontWeight: FontWeight.bold)),
        //       SizedBox(
        //           width: MediaQuery.of(context).size.width - 150,
        //           child: Text(
        //             "Vous explorer le réseau à la recherche des objectifs proposés par le bingo",
        //           ))
        //     ])),
        // Container(
        //     margin: const EdgeInsets.only(
        //         top: 40.0, left: 10, right: 10, bottom: 0),
        //     child: Text("Description des cartes",
        //         style: Theme.of(context).textTheme.titleLarge,
        //         textAlign: TextAlign.center)),
        //     SizedBox(
        //         //height: MediaQuery.of(context).size.height / 1.5,
        //         child: Padding(
        //   padding: const EdgeInsets.all(16),
        //   child: DataTable2(
        //       columnSpacing: 12,
        //       horizontalMargin: 12,
        //       minWidth: 450,
        //       columns: [
        //         DataColumn2(
        //           label: Text('Nom'),
        //           size: ColumnSize.S,
        //         ),
        //         DataColumn2(
        //           label: Text('Type'),
        //           size: ColumnSize.S,
        //         ),
        //         DataColumn2(
        //           label: Text('Description'),
        //           size: ColumnSize.S,
        //         ),
        //       ],
        //       rows: List<DataRow>.generate(
        //           cardsName.length,
        //           (index) => DataRow(cells: [
        //                 DataCell(Text(
        //                   cardsName.elementAt(index).name,
        //                   overflow: TextOverflow.ellipsis,
        //                   maxLines: 3,
        //                 )),
        //                 DataCell(Text(
        //                   getType(cardsName.elementAt(index).type),
        //                   overflow: TextOverflow.ellipsis,
        //                 )),
        //                 DataCell(Text(
        //                   cardsName.elementAt(index).description,
        //                   overflow: TextOverflow.ellipsis,
        //                   maxLines: 3,
        //                 )),
        //               ]))),
        // ))
        //])
        );
  }
}
