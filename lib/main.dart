import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terraforming Mars player mat',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Terraforming Mars player mat'),
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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),

      ),

      body: Center(
        child: Container(
          child: Column(
            children: [
//              Padding(
//                padding: EdgeInsets.all(8.0),
//              ),
              Expanded(
                  child: new mainRow()
              ),
              Expanded(
                  child: new trackerRow(color: Colors.yellow[700], subColor: Colors.yellow[50], title: 'Megacredits')
              ),
              Expanded(
                  child: new trackerRow(color: Colors.brown[700], subColor: Colors.brown[50], title: 'Steel')
              ),
              Expanded(
                  child: new trackerRow(color: Colors.grey[700], subColor: Colors.grey[100], title: 'Titanium')
              ),
              Expanded(
                  child:new trackerRow(color: Colors.green[700], subColor: Colors.green[50], title: 'Plants')
              ),
              Expanded(
                  child:new trackerRow(color: Colors.deepPurple[700], subColor: Colors.deepPurple[50], title: 'Energy')
              ),
//              Expanded(
//                  child:new trackerRow(color: Colors.red[700], subColor: Colors.red[50], title: 'Heat')
//              ),
              Expanded(
                child: new Card(
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.yellow
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: new Text("Text in a card")
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class trackerRow extends StatelessWidget {
  const trackerRow({
    Key key,
    @required this.color,
    @required this.subColor,
    @required this.title,
  }) : super(key: key);

  final color;
  final subColor;
  final title;

  @override
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints(

    ),
    child: Column(
      children: [
        Container(
          constraints: BoxConstraints(
            minHeight: 30,
          ),
          decoration: BoxDecoration(
            color: color,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(child:Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {}
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '6',
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {}
                              ),
                            ],
                          ),
                        ]
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '12',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )),
      ],
    )
  );
}

class mainRow extends StatelessWidget {
  const mainRow({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) => Container(
      constraints: BoxConstraints(

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: 30,
            ),
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Terraforming Rating',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child:Container(

            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('tracker1'),
                    Text('Tracker2'),
                  ],
                ),
              ],
            ),
          )),
        ],
      )
  );
}
