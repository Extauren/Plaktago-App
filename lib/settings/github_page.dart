import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class GithubPage extends StatefulWidget {
  GithubPage({
    Key? key,
  }) : super(key: key);

  @override
  State<GithubPage> createState() => _GithubPage();
}

class _GithubPage extends State<GithubPage> {
  late final WebViewController _controller;
  var loadingPercentage = 0;
  late Future<bool> internet;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onWebResourceError: (WebResourceError error) {
            Text("Error");
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://github.com/Extauren/Plaktago-App'));
  }

  void checkInternetConnection() {
    internet = InternetConnection().hasInternetAccess;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Page Github")),
        body: FutureBuilder<bool>(
            future: internet,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              List<Widget> children = <Widget>[];
              if (snapshot.hasData) {
                if (!snapshot.data!) children = <Widget>[Text("Pas internet")];
                if (snapshot.data!) {
                  children = <Widget>[
                    SizedBox(
                        height: MediaQuery.of(context).size.height - 110,
                        child: Stack(children: [
                          WebViewWidget(
                            controller: _controller,
                          ),
                          if (loadingPercentage < 100 && snapshot.data!)
                            LinearProgressIndicator(
                              value: loadingPercentage / 100.0,
                            ),
                        ]))
                  ];
                }
              } else if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                ];
              }
              return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children));
            }));
  }
}
