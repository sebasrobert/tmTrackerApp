import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() => runApp(MyApp());

const double BORDER_CIRCULAR_RADIUS = 0;
const int MAIN_COLOR_TEINT = 800;
const int SUB_COLOR_TEINT = 50;
const double SUB_COLOR_OPACITY = 0.3;
const double BORDER_WITH = 2;
const double RESOURCE_FONT_SIZE= 42;

const RESOURCE_TERRAFORMING_RATING = 'Terraforming Rating';
const RESOURCE_MEGACREDITS = 'Megacredits';
const RESOURCE_STEEL = 'Steel';
const RESOURCE_TITANIUM = 'Titanium';
const RESOURCE_PLANTS = 'Plants';
const RESOURCE_ENERGY = 'Energy';
const RESOURCE_HEAT = 'Heat';

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
  Map<String, int> _productions = new Map();
  Map<String, int> _amounts = new Map();
  int _generation = 1;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _incrementGeneration() {
    setState(() {
      _productions.keys.forEach((String key) => {
        _amounts[key] = _getAmount(key) + _productions[key]
      });
      _amounts[RESOURCE_MEGACREDITS] = _amounts[RESOURCE_MEGACREDITS] + _getProductions(RESOURCE_TERRAFORMING_RATING);
      _generation++;
    });
  }

  void _setResourceAmount(String type, int amount) {
    setState(() {
      if (amount != null) {
        _amounts[type] = amount;
      }
    });
  }

  int _getAmount(String type) {
    return _amounts[type] != null ? _amounts[type] : 0;
  }

  void _incrementProductions(String type) {
    setState(() {
      int currentValue = _productions[type];
      if (currentValue == null) {
        currentValue = 0;
      }
      _productions[type] = currentValue + 1;
    });
  }

  void _decrementProductions(String type) {
    setState(() {
      int currentValue = _productions[type];
      if (currentValue == null) {
        currentValue = 0;
      }
      _productions[type] = currentValue - 1;
    });
  }

  int _getProductions(String type) {
    return _productions[type] != null ? _productions[type] : 0;
  }

  void _reset() {
    setState(() {
      _productions[RESOURCE_TERRAFORMING_RATING] = 14;
      _productions[RESOURCE_MEGACREDITS] = 0;
      _productions[RESOURCE_STEEL] = 0;
      _productions[RESOURCE_TITANIUM] = 0;
      _productions[RESOURCE_PLANTS] = 0;
      _productions[RESOURCE_ENERGY] = 0;
      _productions[RESOURCE_HEAT] = 0;

      _amounts[RESOURCE_TERRAFORMING_RATING] = 14;
      _amounts[RESOURCE_MEGACREDITS] = 0;
      _amounts[RESOURCE_STEEL] = 0;
      _amounts[RESOURCE_TITANIUM] = 0;
      _amounts[RESOURCE_PLANTS] = 0;
      _amounts[RESOURCE_ENERGY] = 0;
      _amounts[RESOURCE_HEAT] = 0;
      
      _generation = 1;
    });
  }

  void _showDialog(String name, Color color) {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            minValue: 0,
            maxValue: 1000,
            initialIntegerValue: _amounts[name] != null ? _amounts[name] : 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 32,
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        }
    ).then((int value) => {
      _setResourceAmount(name, value)
    });
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
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    actionButton(text: 'Undo'),
                    actionButton(text: 'New game'),
                  ],
                ),
              ),
              Expanded(
                  child: mainPanel(color: Colors.blueGrey[MAIN_COLOR_TEINT], subcolor: Colors.blueGrey[SUB_COLOR_TEINT]),
              ),
              Expanded(
                  child: trackerPanel(color: Colors.yellow[MAIN_COLOR_TEINT], subColor: Colors.yellow[SUB_COLOR_TEINT], resource: RESOURCE_MEGACREDITS)
              ),
              Expanded(
                  child: trackerPanel(color: Colors.brown[MAIN_COLOR_TEINT], subColor: Colors.brown[SUB_COLOR_TEINT], resource: RESOURCE_STEEL)
              ),
              Expanded(
                  child: trackerPanel(color: Colors.grey[MAIN_COLOR_TEINT], subColor: Colors.grey[SUB_COLOR_TEINT], resource: RESOURCE_TITANIUM)
              ),
              Expanded(
                  child: trackerPanel(color: Colors.green[MAIN_COLOR_TEINT], subColor: Colors.green[SUB_COLOR_TEINT], resource: RESOURCE_PLANTS)
              ),
              Expanded(
                  child: trackerPanel(color: Colors.deepPurple[MAIN_COLOR_TEINT], subColor: Colors.deepPurple[SUB_COLOR_TEINT], resource: RESOURCE_ENERGY)
              ),
              Expanded(
                  child: trackerPanel(color: Colors.red[MAIN_COLOR_TEINT], subColor: Colors.red[SUB_COLOR_TEINT], resource: RESOURCE_HEAT)
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    actionButton(text: 'Projects'),
                    actionButton(text: 'Buy card'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget actionButton({String text}) => FlatButton(
    onPressed: _reset,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
          Radius.circular(20.0)
      ),
    ),
    child: Text(
      text,
    ),
  );

  Widget rowHeader({String title, Color color}) => Container(
    constraints: BoxConstraints(
      minHeight: 24,
    ),
    decoration: BoxDecoration(
      color: color,
      borderRadius: new BorderRadius.only(
          topLeft:  const  Radius.circular(BORDER_CIRCULAR_RADIUS),
          topRight: const  Radius.circular(BORDER_CIRCULAR_RADIUS)
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
  );

  Widget productionRow({Color color, String resource}) {
    return Row(
      children: [
        Column(
          children: [
            IconButton(
                icon: Icon(Icons.remove,
                  color: color,
                ),
                onPressed:  () => {_decrementProductions(resource)}
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
              child: Container(

                constraints: BoxConstraints(
                  minWidth: 44,
                ),
                child: Text(
                  '${_productions[resource] != null ? _productions[resource] : 0}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    color: color, //Colors.black,
                  ),
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
                onPressed: () => {_incrementProductions(resource)}
            ),
          ],
        ),
      ]
  );
  }

  Widget trackerPanel({Color color, Color subColor, String resource}) => Container(
      child: Column(
        children: [
          rowHeader(
            color: color,
            title: resource,
          ),
          Expanded(child:Container(
            decoration: BoxDecoration(
              color: subColor.withOpacity(SUB_COLOR_OPACITY),
              borderRadius: new BorderRadius.only(
                  bottomLeft:  const  Radius.circular(BORDER_CIRCULAR_RADIUS),
                  bottomRight: const  Radius.circular(BORDER_CIRCULAR_RADIUS)
              ),
              border: Border.all(
                color: color,
                width: BORDER_WITH,
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
                        productionRow(color: color, resource: resource),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.play_arrow,
                          color: color.withOpacity(0.2),
                          size: 32,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        FlatButton(
                          onPressed: () => _showDialog(resource, color),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20.0)
                              ),
                          ),
                          child: Text(
                            '${_amounts[resource] != null ? _amounts[resource] : 0}',
                            style: TextStyle(
                              fontSize: RESOURCE_FONT_SIZE,
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

  Widget mainPanel({Color color, Color subcolor}) => Container(
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: 24,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: new BorderRadius.only(
                  topLeft:  const  Radius.circular(BORDER_CIRCULAR_RADIUS),
                  topRight: const  Radius.circular(BORDER_CIRCULAR_RADIUS)
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
              color: subcolor.withOpacity(SUB_COLOR_OPACITY),
              borderRadius: new BorderRadius.only(
                  bottomLeft:  const  Radius.circular(BORDER_CIRCULAR_RADIUS),
                  bottomRight: const  Radius.circular(BORDER_CIRCULAR_RADIUS)
              ),
              border: Border.all(
                color: color,
                width: BORDER_WITH,
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
                        productionRow(color: color, resource: RESOURCE_TERRAFORMING_RATING),
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
                          onPressed: _incrementGeneration,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20.0)
                            ),
                          ),
                          child: Text(
                            '${_generation}',
                            style: TextStyle(
                              fontSize: RESOURCE_FONT_SIZE,
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
