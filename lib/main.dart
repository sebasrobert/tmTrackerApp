import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() => runApp(MyApp());

const int MAIN_COLOR_TEINT = 800;
const int SUB_COLOR_TEINT = 50;
const double SUB_COLOR_OPACITY = 0.3;
const double BORDER_WITH = 0;
const double RESOURCE_FONT_SIZE= 42;

const String RESOURCE_TERRAFORMING_RATING = 'Terraforming Rating';
const String RESOURCE_MEGACREDITS = 'Megacredits';
const String RESOURCE_STEEL = 'Steel';
const String RESOURCE_TITANIUM = 'Titanium';
const String RESOURCE_PLANTS = 'Plants';
const String RESOURCE_ENERGY = 'Energy';
const String RESOURCE_HEAT = 'Heat';

const int NEW_GAME_STANDARD = 1;
const int NEW_GAME_CORPORATE_ERA = 2;
const int NEW_GAME_SOLO = 3;

const int GREENERY_PLANTS_ACTION = 1;
const int RAISE_HEAT_ACTION = 2;

const RESOURCES = [RESOURCE_TERRAFORMING_RATING, RESOURCE_MEGACREDITS, RESOURCE_STEEL, RESOURCE_TITANIUM, RESOURCE_PLANTS, RESOURCE_ENERGY, RESOURCE_HEAT];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TM player companion',
      theme: ThemeData(
        primarySwatch: Colors.grey,
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

class UndoState {
  Map<String, int> _resourceProductions = new Map();
  Map<String, int> _resourceAmounts = new Map();
  int _generation = 1;
  String _actionName;
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, int> _resourceProductions = new Map();
  Map<String, int> _resourceAmounts = new Map();
  int _generation = 1;
  List<UndoState> _previousStates = new List();
  Map<String, int> _minResourceProductions = new Map();

  @override
  void initState() {
    super.initState();
    _minResourceProductions[RESOURCE_TERRAFORMING_RATING] = 0;
    _minResourceProductions[RESOURCE_MEGACREDITS] = -5;
    _minResourceProductions[RESOURCE_STEEL] = 0;
    _minResourceProductions[RESOURCE_TITANIUM] = 0;
    _minResourceProductions[RESOURCE_PLANTS] = 0;
    _minResourceProductions[RESOURCE_ENERGY] = 0;
    _minResourceProductions[RESOURCE_HEAT] = 0;


    _reset();
  }

  void _persistCurrentState(String actionName) {
    setState(() {
      UndoState state = new UndoState();
      state._resourceAmounts.addAll(_resourceAmounts);
      state._resourceProductions.addAll(_resourceProductions);
      state._generation = _generation;
      state._actionName = actionName;
      _previousStates.add(state);
    });
  }

  void _restorePreviousState() {
    UndoState previousState;
    setState(() {
      previousState = _previousStates.removeLast();

      _resourceProductions.clear();
      _resourceProductions.addAll(previousState._resourceProductions);

      _resourceAmounts.clear();
      _resourceAmounts.addAll(previousState._resourceAmounts);

      _generation = previousState._generation;
    });

    Flushbar(
      title:  "Undone",
      message:  previousState._actionName,
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.blue[300],
      ),
      duration:  Duration(seconds: 3),
      margin: EdgeInsets.all(8),
      borderRadius: 8,
    )..show(context);

  }

  void _incrementGeneration() {
    setState(() {
      _persistCurrentState('Next generation');

      _resourceAmounts[RESOURCE_HEAT] = _resourceAmounts[RESOURCE_HEAT] + _resourceAmounts[RESOURCE_ENERGY];
      _resourceAmounts[RESOURCE_ENERGY] = 0;

      _resourceAmounts[RESOURCE_MEGACREDITS] = _resourceAmounts[RESOURCE_MEGACREDITS] + _resourceProductions[RESOURCE_MEGACREDITS] + _resourceProductions[RESOURCE_TERRAFORMING_RATING];
      _resourceAmounts[RESOURCE_STEEL] = _resourceAmounts[RESOURCE_STEEL] + _resourceProductions[RESOURCE_STEEL];
      _resourceAmounts[RESOURCE_TITANIUM] = _resourceAmounts[RESOURCE_TITANIUM] + _resourceProductions[RESOURCE_TITANIUM];
      _resourceAmounts[RESOURCE_PLANTS] = _resourceAmounts[RESOURCE_PLANTS] + _resourceProductions[RESOURCE_PLANTS];
      _resourceAmounts[RESOURCE_ENERGY] = _resourceAmounts[RESOURCE_ENERGY] + _resourceProductions[RESOURCE_ENERGY];
      _resourceAmounts[RESOURCE_HEAT] = _resourceAmounts[RESOURCE_HEAT] + _resourceProductions[RESOURCE_HEAT];


      RESOURCES.forEach((resource) => {
        if (_resourceAmounts[resource] < 0) {
          _resourceAmounts[resource] = 0
        }
      });

      _generation++;
    });
  }

  void _setResourceAmount(String type, int amount) {
    setState(() {
      if (amount != null) {
        _persistCurrentState('${type} amount updated from ${_resourceAmounts[type]} to ${amount}');
        _resourceAmounts[type] = amount;
      }
    });
  }

  int _getResourceAmount(String type) {
    return _resourceAmounts[type];
  }

  void _incrementResourceProduction(String resource) {
    setState(() {
      _persistCurrentState('${resource} production incremented');
      _resourceProductions[resource] = _resourceProductions[resource] + 1;
    });
  }

  void _decrementResourceProductions(String resource) {
    setState(() {
      _persistCurrentState('${resource} production decremented');
      _resourceProductions[resource] = _resourceProductions[resource] - 1;
    });
  }

  int _getResourceProductions(String type) {
    return _resourceProductions[type];
  }

  void _buyCards(int numberOfCards) {
    setState(() {
      _persistCurrentState('Buy ${numberOfCards} card(s)');
      _resourceAmounts[RESOURCE_MEGACREDITS] = _resourceAmounts[RESOURCE_MEGACREDITS] - (numberOfCards * 3);
    });
  }

  void _newGame(int gameMode) {
    setState(() {
      if (gameMode == NEW_GAME_STANDARD) {
        _resourceProductions[RESOURCE_TERRAFORMING_RATING] = 20;
        _resourceProductions[RESOURCE_MEGACREDITS] = 1;
        _resourceProductions[RESOURCE_STEEL] = 1;
        _resourceProductions[RESOURCE_TITANIUM] = 1;
        _resourceProductions[RESOURCE_PLANTS] = 1;
        _resourceProductions[RESOURCE_ENERGY] = 1;
        _resourceProductions[RESOURCE_HEAT] = 1;

        _resourceAmounts[RESOURCE_TERRAFORMING_RATING] = 0;
        _resourceAmounts[RESOURCE_MEGACREDITS] = 0;
        _resourceAmounts[RESOURCE_STEEL] = 0;
        _resourceAmounts[RESOURCE_TITANIUM] = 0;
        _resourceAmounts[RESOURCE_PLANTS] = 0;
        _resourceAmounts[RESOURCE_ENERGY] = 0;
        _resourceAmounts[RESOURCE_HEAT] = 0;
      } else if (gameMode == NEW_GAME_CORPORATE_ERA) {
        _resourceProductions[RESOURCE_TERRAFORMING_RATING] = 20;
        _resourceProductions[RESOURCE_MEGACREDITS] = 0;
        _resourceProductions[RESOURCE_STEEL] = 0;
        _resourceProductions[RESOURCE_TITANIUM] = 0;
        _resourceProductions[RESOURCE_PLANTS] = 0;
        _resourceProductions[RESOURCE_ENERGY] = 0;
        _resourceProductions[RESOURCE_HEAT] = 0;

        _resourceAmounts[RESOURCE_TERRAFORMING_RATING] = 0;
        _resourceAmounts[RESOURCE_MEGACREDITS] = 0;
        _resourceAmounts[RESOURCE_STEEL] = 0;
        _resourceAmounts[RESOURCE_TITANIUM] = 0;
        _resourceAmounts[RESOURCE_PLANTS] = 0;
        _resourceAmounts[RESOURCE_ENERGY] = 0;
        _resourceAmounts[RESOURCE_HEAT] = 0;
      } else if (gameMode == NEW_GAME_SOLO) {
        _resourceProductions[RESOURCE_TERRAFORMING_RATING] = 14;
        _resourceProductions[RESOURCE_MEGACREDITS] = 0;
        _resourceProductions[RESOURCE_STEEL] = 0;
        _resourceProductions[RESOURCE_TITANIUM] = 0;
        _resourceProductions[RESOURCE_PLANTS] = 0;
        _resourceProductions[RESOURCE_ENERGY] = 0;
        _resourceProductions[RESOURCE_HEAT] = 0;

        _resourceAmounts[RESOURCE_TERRAFORMING_RATING] = 0;
        _resourceAmounts[RESOURCE_MEGACREDITS] = 0;
        _resourceAmounts[RESOURCE_STEEL] = 0;
        _resourceAmounts[RESOURCE_TITANIUM] = 0;
        _resourceAmounts[RESOURCE_PLANTS] = 0;
        _resourceAmounts[RESOURCE_ENERGY] = 0;
        _resourceAmounts[RESOURCE_HEAT] = 0;
      }

      _generation = 1;
      _previousStates.clear();
    });
  }

  String _getProjectName(int value) {
    if (value == 11) {
      return 'Power plant';
    }

    if (value == 14) {
      return 'Asteroid';
    }

    if (value == 18) {
      return 'Aquifier';
    }

    if (value == 23) {
      return 'Greenery';
    }

    if (value == 25) {
      return 'City';
    }

    if (value == 1) {
      return 'Greenery (8 plants)';
    }

    if (value == 2) {
      return 'Raise heat';
    }
    return '';
  }

  void _executeProject(int value) {
    setState(() {
      _persistCurrentState('Execute project ${_getProjectName(value)}');

      if (value == GREENERY_PLANTS_ACTION) {
        _resourceAmounts[RESOURCE_PLANTS] = _resourceAmounts[RESOURCE_PLANTS] - 8;

      } else if (value == RAISE_HEAT_ACTION) {
        _resourceAmounts[RESOURCE_HEAT] = _resourceAmounts[RESOURCE_HEAT] - 8;
      } else {
        _resourceAmounts[RESOURCE_MEGACREDITS] = _resourceAmounts[RESOURCE_MEGACREDITS] - (value);
      }
    });
  }

  void _reset() {
    setState(() {
      _resourceProductions[RESOURCE_TERRAFORMING_RATING] = 0;
      _resourceProductions[RESOURCE_MEGACREDITS] = 0;
      _resourceProductions[RESOURCE_STEEL] = 0;
      _resourceProductions[RESOURCE_TITANIUM] = 0;
      _resourceProductions[RESOURCE_PLANTS] = 0;
      _resourceProductions[RESOURCE_ENERGY] = 0;
      _resourceProductions[RESOURCE_HEAT] = 0;

      _resourceAmounts[RESOURCE_TERRAFORMING_RATING] = 0;
      _resourceAmounts[RESOURCE_MEGACREDITS] = 0;
      _resourceAmounts[RESOURCE_STEEL] = 0;
      _resourceAmounts[RESOURCE_TITANIUM] = 0;
      _resourceAmounts[RESOURCE_PLANTS] = 0;
      _resourceAmounts[RESOURCE_ENERGY] = 0;
      _resourceAmounts[RESOURCE_HEAT] = 0;

      _generation = 1;

      _previousStates.clear();
    });
  }

  Widget _projectsPopupButton() => PopupMenuButton<int>(
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
          'Execute project',
        ),
    ),
    onSelected: (value) => _executeProject(value),
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 11,
        enabled: _resourceAmounts[RESOURCE_MEGACREDITS] >= 11,
        child: Text("Power plant (11)"),
      ),
      PopupMenuItem(
        value: 14,
        enabled: _resourceAmounts[RESOURCE_MEGACREDITS] >= 14,
        child: Text("Asteroid (14)"),
      ),
      PopupMenuItem(
        value: 18,
        enabled: _resourceAmounts[RESOURCE_MEGACREDITS] >= 18,
        child: Text("Aquifier (18)"),
      ),
      PopupMenuItem(
        value: 23,
        enabled: _resourceAmounts[RESOURCE_MEGACREDITS] >= 23,
        child: Text("Greenery (23)"),
      ),
      PopupMenuItem(
        value: 25,
        enabled: _resourceAmounts[RESOURCE_MEGACREDITS] >= 25,
        child: Text("City (25)"),
      ),
      PopupMenuDivider(),
      PopupMenuItem(
        value: 1,
        enabled: _resourceAmounts[RESOURCE_PLANTS] >= 8,
        child: Text("Greenery (8 plants)"),
      ),
      PopupMenuItem(
        value: 2,
        enabled: _resourceAmounts[RESOURCE_HEAT] >= 8,
        child: Text("Raise heat (8 heat)"),
      ),
    ],
  );

  Widget _buyCardsPopupButton() => PopupMenuButton<int>(
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Buy cards',
      ),
    ),
    onSelected: (value) => _buyCards(value),
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        enabled: _resourceAmounts[RESOURCE_MEGACREDITS] >= 3,
        child: Text("Buy 1 card (3)"),
      ),
      PopupMenuItem(
        value: 2,
        enabled: _resourceAmounts[RESOURCE_MEGACREDITS] >= 6,
        child: Text("Buy 2 cards (6)"),
      ),
      PopupMenuItem(
        value: 3,
        enabled: _resourceAmounts[RESOURCE_MEGACREDITS] >= 9,
        child: Text("Buy 3 cards (9)"),
      ),
      PopupMenuItem(
        value: 4,
        enabled: _resourceAmounts[RESOURCE_MEGACREDITS] >= 12,
        child: Text("Buy 4 cards (12)"),
      ),
    ],
  );

  Widget _newGamePopupButton() => PopupMenuButton<int>(
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'New game',
      ),
    ),
    onSelected: (value) => _newGame(value),
    itemBuilder: (context) => [
      PopupMenuItem(
        value: NEW_GAME_STANDARD,
        child: Text("Standard"),
      ),
      PopupMenuItem(
        value: NEW_GAME_CORPORATE_ERA,
        child: Text("Corporate Era"),
      ),
      PopupMenuItem(
        value: NEW_GAME_SOLO,
        child: Text("Solo"),
      ),
    ],
  );

  void _showDialog(String resource, Color color) {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            minValue: 0,
            maxValue: 1000,
            initialIntegerValue: _getResourceAmount(resource),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  getImageForResource(resource),
                  height: 24,
                  width: 24,
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                ),
                Text(
                  resource,
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
      _setResourceAmount(resource, value)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  actionButton(text: 'Undo', onPressed: (_previousStates.length > 0 ? _restorePreviousState : null)),
                  _newGamePopupButton(),
                ],
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
                  child: trackerPanel(color: Colors.orange[MAIN_COLOR_TEINT], subColor: Colors.red[SUB_COLOR_TEINT], resource: RESOURCE_HEAT)
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: _projectsPopupButton(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(.0),
                    child:  _buyCardsPopupButton(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget actionButton({@required String text, @required VoidCallback onPressed}) => FlatButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  String getImageForResource(String title) {
    if (title == RESOURCE_MEGACREDITS) {
      return 'assets/megacredits.png';
    } else if (title == RESOURCE_STEEL) {
      return 'assets/steel.png';
    } else if (title == RESOURCE_PLANTS) {
      return 'assets/plant.png';
    } else if (title == RESOURCE_ENERGY) {
      return 'assets/energy.png';
    } else if (title == RESOURCE_HEAT) {
      return 'assets/heat.png';
    } else {
      return 'assets/titanium.png';
    }
  }

  Widget trackerHeader({String title, Color color}) => Container(
    constraints: BoxConstraints(
      minHeight: 22,
    ),
    decoration: BoxDecoration(
      color: color,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: 8,
          ),
          child: Opacity(
            opacity: 1,
            child: Image.asset(
              getImageForResource(title),
              height: 16,
              width: 16,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
      ],
    ),
  );

  Widget productionRow({Color color, String resource}) {
    return Row(
      children: [
        IconButton(
            icon: Icon(Icons.remove,
              color: color,
            ),
            onPressed: _getResourceProductions(resource) > _minResourceProductions[resource] ? () => {_decrementResourceProductions(resource)} : null,
        ),
        Container(
          constraints: BoxConstraints(
            minWidth: 60,
          ),
          child: Text(
            '${_getResourceProductions(resource)}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              color: color, //Colors.black,
            ),
          ),
        ),
        IconButton(
            icon: Icon(Icons.add,
              color: color,
            ),
            onPressed: () => {_incrementResourceProduction(resource)}
        ),
      ]
  );
  }

  Widget trackerPanel({Color color, Color subColor, String resource}) => Column(
    children: [
      trackerHeader(
        color: color,
        title: resource,
      ),
      Expanded(child:Container(
        decoration: BoxDecoration(
          color: subColor.withOpacity(SUB_COLOR_OPACITY),
          border: Border(
            left: BorderSide(
              color: color,
              width: BORDER_WITH,
            ),
            right: BorderSide(
              color: color,
              width: BORDER_WITH,
            ),
            bottom: BorderSide(
              color: color,
              width: BORDER_WITH,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                productionRow(color: color, resource: resource),
                Icon(Icons.play_arrow,
                  color: color.withOpacity(0.2),
                  size: 32,
                ),
                FlatButton(
                  onPressed: () => _showDialog(resource, color),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(20.0)
                      ),
                  ),
                  child: Text(
                    '${_getResourceAmount(resource)}',
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
      )),
    ],
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
