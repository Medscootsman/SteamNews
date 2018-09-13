import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'steamapp.dart';
import 'package:html/parser.dart' as parse;
import 'package:html/dom.dart' as dom;
void main() => runApp(new MyApp());

Future<SteamItem> getItems() async {
  SteamItem app = new SteamItem();
  await app.fetchTF2();
  return app;
}

String parseHTML(String content) {
  var parsed = parse.parse(content);
  print(parsed.outerHtml);
  return parsed.outerHtml;
}

String findParagraphs() {
  String paragraphedHtml;

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TF2 News',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TF2 News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<SteamItem>(
            future: getItems(),
            builder: (context, snapshot) {
              if(snapshot.data == null) {
                return new Container(
                  child: Center(
                    child: CircularProgressIndicator()
                  )
                );
              } else {
                return ListView.builder(

                  itemCount: snapshot.data.newsitems.length,
                  itemBuilder: (BuildContext cont, int index) {
                    if (snapshot.hasData) {
                      return new Card(
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new ListTile(
                                leading: const Icon(Icons.format_align_left),
                                title: Text(snapshot.data.newsitems[index].title),
                                subtitle: Text(
                                    snapshot.data.newsitems[index].feed_name),
                              ),
                              new Text(parseHTML(snapshot.data.newsitems[index].contents)),
                            ],
                          )
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner
                    return CircularProgressIndicator();
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

