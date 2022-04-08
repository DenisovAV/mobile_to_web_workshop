import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const WorkshopApp());
}

const _name = 'Workshop: From Mobile to Web/Desktop';

//TODO: Create intents

//TODO: Create actions

class WorkshopApp extends StatelessWidget {
  const WorkshopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _name,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WorkshopPage(),
    );
  }
}

//Main layout widget
class WorkshopPage extends StatefulWidget {
  const WorkshopPage({Key? key}) : super(key: key);

  @override
  State<WorkshopPage> createState() => _WorkshopPageState();
}

class _WorkshopPageState extends State<WorkshopPage> {
  //TODO: Create map of keys and intents

  //TODO: Create map that match idex of element and its focus node

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_name),
      ),
      body: GridView.count(
        crossAxisCount: 4,
        children: List.generate(
          8,
              (index) {
            return Cell(index: index);
          },
        ),
      ),
    );
  }
}

//Grid element widget
class Cell extends StatefulWidget {
  final int index;

  const Cell({
    //TODO: Provide corresponding focus node to focus widget
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  static const _hoverDuration = Duration(milliseconds: 300);

  var _isHovered = false;
  var _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (_, event) {
        if ([LogicalKeyboardKey.enter, LogicalKeyboardKey.space].contains(event.logicalKey)) {
          if (event is KeyRepeatEvent) {
            _showDialogInfo(context, widget.index);
          } else if (event is KeyUpEvent) {
            _showInfoPage(context, widget.index);
          }
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      autofocus: widget.index == 0,
      onFocusChange: _onChangeFocus,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: InkWell(
          onLongPress: () => _showDialogInfo(context, widget.index),
          onTap: () => _showInfoPage(context, widget.index),
          mouseCursor: SystemMouseCursors.click,
          onHover: _onChangeHover,
          focusColor: Colors.transparent,
          canRequestFocus: false,
          child: AnimatedScale(
            scale: _isHovered ? 1.1 : 1.0,
            duration: _hoverDuration,
            child: AnimatedPhysicalModel(
              borderRadius: BorderRadius.circular(15),
              color: _isFocused ? Colors.blueGrey : Colors.blue,
              shape: BoxShape.rectangle,
              elevation: _isHovered ? 25 : 10,
              shadowColor: Colors.black,
              duration: _hoverDuration,
              curve: Curves.fastOutSlowIn,
              child: Center(
                child: Text(
                  '${widget.index}',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Callback to change hovering state
  void _onChangeHover(bool isHovered) => setState(() {
    _isHovered = isHovered;
  });

  //Callback to change focusing state
  void _onChangeFocus(bool isFocused) => setState(() {
    _isFocused = isFocused;
  });
}

//Full element info widget
class InfoPage extends StatelessWidget {
  final int index;

  const InfoPage({
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event.logicalKey == LogicalKeyboardKey.escape && event is KeyDownEvent) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detailed information $index'),
        ),
        body: Center(
          child: Text(
            index.toString(),
            style: const TextStyle(fontSize: 40),
          ),
        ),
      ),
    );
  }
}

//Method shows dialog with info about grid element
void _showDialogInfo(BuildContext context, int index) async => await showDialog<void>(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: const Text('Info'),
      content: Text('Cell number $index'),
    );
  },
);

//Method opens new page with full info about the element
void _showInfoPage(BuildContext context, int index) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => InfoPage(
      index: index,
    ),
  ),
);
