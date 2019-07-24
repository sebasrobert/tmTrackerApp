import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() => runApp(MyApp());

const double borderCircularRadius = 0;
const int mainColorTeint = 800;
const int subColorTeint = 50;
const double subColorOpacity = 0.2;


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terraforming Mars player mat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Terraforming Mars player mat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _showDialog(String text, Color color) {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            minValue: 1,
            maxValue: 100,
            initialIntegerValue: 5,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 24,
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),

      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: new BorderRadius.only(
                topLeft:  const  Radius.circular(0.0),
                topRight: const  Radius.circular(0.0)
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('New game'),
                  ],
                ),
              ),
              Expanded(
                  child: buildMainRow(color: Colors.blueGrey[mainColorTeint], subcolor: Colors.blueGrey[subColorTeint]),
              ),
              Expanded(
                  child: buildTrackerRow(color: Colors.yellow[mainColorTeint], subColor: Colors.yellow[subColorTeint], title: 'Megacredits')
              ),
              Expanded(
                  child: buildTrackerRow(color: Colors.brown[mainColorTeint], subColor: Colors.brown[subColorTeint], title: 'Steel')
              ),
              Expanded(
                  child: buildTrackerRow(color: Colors.grey[mainColorTeint], subColor: Colors.grey[subColorTeint], title: 'Titanium')
              ),
              Expanded(
                  child: buildTrackerRow(color: Colors.green[mainColorTeint], subColor: Colors.green[subColorTeint], title: 'Plants')
              ),
              Expanded(
                  child: buildTrackerRow(color: Colors.deepPurple[mainColorTeint], subColor: Colors.deepPurple[subColorTeint], title: 'Energy')
              ),
              Expanded(
                  child: buildTrackerRow(color: Colors.red[mainColorTeint], subColor: Colors.red[subColorTeint], title: 'Heat')
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Projects'),
                    Text('Buy card'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTrackerRow({Color color, Color subColor, String title}) => Container(
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: 20,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: new BorderRadius.only(
                  topLeft:  const  Radius.circular(borderCircularRadius),
                  topRight: const  Radius.circular(borderCircularRadius)
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child:Container(
            decoration: BoxDecoration(
              color: subColor.withOpacity(subColorOpacity),
              borderRadius: new BorderRadius.only(
                  bottomLeft:  const  Radius.circular(borderCircularRadius),
                  bottomRight: const  Radius.circular(borderCircularRadius)
              ),
              border: Border.all(
                color: color,
                width: 3,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Row(
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.remove,
                                        color: color,
                                      ),
                                      onPressed: () {}
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Text(
                                      '6',
                                      style: TextStyle(
                                        fontSize: 32,
                                        color: color, //Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.add,
                                        color: color,
                                      ),
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
                        Icon(Icons.play_arrow,
                          color: color.withOpacity(0.3),
                          size: 32,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        FlatButton(
                          onPressed: () => _showDialog(title, color),
                          child: Text(
                            '12',
                            style: TextStyle(
                              fontSize: 48,
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
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

  Widget buildMainRow({Color color, Color subcolor}) => Container(
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: 20,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: new BorderRadius.only(
                  topLeft:  const  Radius.circular(borderCircularRadius),
                  topRight: const  Radius.circular(borderCircularRadius)
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
//              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Terraforming Rating',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'Generation',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child:Container(
            decoration: BoxDecoration(
              color: subcolor.withOpacity(subColorOpacity),
              borderRadius: new BorderRadius.only(
                  bottomLeft:  const  Radius.circular(borderCircularRadius),
                  bottomRight: const  Radius.circular(borderCircularRadius)
              ),
              border: Border.all(
                color: color,
                width: 3,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.remove,
                                      color: color,
                                    ),
                                    onPressed: () {}
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: Text(
                                    '6',
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.add,
                                      color: color,
                                    ),
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
                        Icon(Icons.play_arrow,
                          color: color.withOpacity(0),
                          size: 32,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        FlatButton(
                          onPressed: () => _showDialog('', color),
                          child: Text(
                            '12',
                            style: TextStyle(
                              fontSize: 48,
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
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
