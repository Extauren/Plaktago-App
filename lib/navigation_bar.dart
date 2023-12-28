import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plaktago/data_class/app_settings.dart';
import 'package:plaktago/data_class/game.dart';
import 'package:plaktago/utils/check_update.dart';
import 'package:plaktago/utils/isar_service.dart';
import 'home/home.dart';
import 'statistic/statistic.dart';
import 'settings/settings.dart';

class NavigationBarApp extends StatefulWidget {
  final Function changeTheme;
  final AppSettings appSettings;
  final IsarService isarService;
  const NavigationBarApp(
      {Key? key,
      required this.changeTheme,
      required this.appSettings,
      required this.isarService})
      : super(key: key);

  @override
  State<NavigationBarApp> createState() => _NavigationBar();
}

class _NavigationBar extends State<NavigationBarApp> {
  int _selectedIndex = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  List<Widget> pages = [];
  final Key homeKey = PageStorageKey('home');

  @override
  void initState() {
    super.initState();
    pages = getPages();
    Update(
            context: context,
            settings: widget.appSettings,
            isarService: widget.isarService)
        .checkForUpdate();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    widget.appSettings.version =
        info.version.substring(0, info.version.lastIndexOf('.') + 1);
    widget.isarService.saveAppSettings(widget.appSettings);
  }

  // GoRouter router() {
  //   return GoRouter(
  //     initialLocation: '/home',
  //     routes: [
  //       GoRoute(
  //           path: '/home',
  //           builder: (context, state) =>
  //               Consumer<GameData>(builder: (context, provider, child) {
  //                 GameData gameData = context.watch<GameData>();
  //                 return Home(
  //                     key: homeKey,
  //                     changeTheme: widget.changeTheme,
  //                     appSettings: widget.appSettings,
  //                     bingoParams: gameData,
  //                     playingGame: playingGame,
  //                     isarService: isarService);
  //               })),
  //       GoRoute(
  //         path: '/statistic',
  //         builder: (context, state) => const Statistic(),
  //       ),
  //     ],
  //   );
  // }

  List<Widget> getPages() {
    return [
      Home(
        key: homeKey,
        changeTheme: widget.changeTheme,
        appSettings: widget.appSettings,
        bingoParams: Game(),
        isarService: widget.isarService,
      ),
      Statistic(appSettings: widget.appSettings),
      Settings(
        isarService: widget.isarService,
        appSettings: widget.appSettings,
      )
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Theme.of(context).colorScheme.surface,
                      width: 1.0))),
          child: BottomNavigationBar(
            elevation: 0.0,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.graphic_eq),
                label: 'Statistiques',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Paramètres',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ));
  }
}
