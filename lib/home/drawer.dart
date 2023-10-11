import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plaktago/bug_report.dart';
import 'package:plaktago/utils/isar_service.dart';
import 'package:plaktago/utils/app_settings.dart';

class DrawerApp extends StatefulWidget {
  final Function changeTheme;
  final AppSettings appSettings;
  final IsarService isarService;
  const DrawerApp(
      {Key? key,
      required this.changeTheme,
      required this.appSettings,
      required this.isarService});

  @override
  State<DrawerApp> createState() => _Drawer();
}

class _Drawer extends State<DrawerApp> {
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _darkMode = widget.appSettings.darkMode;
  }

  void resetData() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      dialogBackgroundColor: Colors.grey[300],
      title: 'Supprimer les données',
      titleTextStyle:
          TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      desc: 'Etes vous sur de vouloir supprimer toutes les données ?',
      descTextStyle: TextStyle(color: Colors.black),
      btnOkOnPress: widget.isarService.deleteAllData,
      btnCancelText: "Annuler",
      btnCancelOnPress: () => {},
    ).show();
  }

  void reportBug() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BugReport()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: MediaQuery.of(context).size.width / 2,
        child: Stack(alignment: Alignment.center, children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Text('Paramètres',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  DefaultTextStyle.merge(
                      child: IconTheme.merge(
                          data: IconThemeData(color: Colors.white),
                          child: AnimatedToggleSwitch<bool>.dual(
                            current: _darkMode,
                            first: false,
                            second: true,
                            spacing: 0.0,
                            animationCurve: Curves.easeInOut,
                            animationDuration:
                                const Duration(milliseconds: 600),
                            style: ToggleStyle(
                              borderColor: Colors.transparent,
                              indicatorColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundColor: Colors.black,
                            ),
                            styleBuilder: (value) => ToggleStyle(
                                backgroundColor: value
                                    ? Colors.grey[700]
                                    : Colors.grey[350]),
                            borderWidth: 3.0,
                            height: 40.0,
                            onChanged: (b) => setState(
                                () => {_darkMode = b, widget.changeTheme()}),
                            iconBuilder: (value) => value
                                ? Icon(FontAwesomeIcons.solidMoon,
                                    size: 18.0, color: Colors.black)
                                : Icon(FontAwesomeIcons.solidSun,
                                    size: 18.0, color: Colors.black),
                          ))),
                ]),
                Container(
                    constraints: BoxConstraints(maxWidth: 180),
                    margin: EdgeInsets.only(top: 10),
                    height: 30,
                    child: ElevatedButton(
                        onPressed: reportBug,
                        child: Text(
                          "Signaler un bug",
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSecondary),
                        )))
              ])
            ],
          ),
          Positioned(
              bottom: 0,
              child: Column(children: [
                Container(
                    constraints: BoxConstraints(maxWidth: 180),
                    margin: EdgeInsets.symmetric(vertical: 15),
                    height: 30,
                    width: MediaQuery.of(context).size.width / 2 - 27,
                    child: ElevatedButton(
                        onPressed: resetData,
                        child: Text(
                          "Supprimer les données",
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSecondary),
                        ))),
                Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Text("Version 0.1 beta"))
              ]))
        ]));
  }
}
