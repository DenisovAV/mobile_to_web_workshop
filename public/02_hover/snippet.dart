import 'package:flutter/material.dart';

void main() {
  runApp(const WorkshopApp());
}

const _name = 'Workshop: From Mobile to Web/Desktop';

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

// TODO: Convert the Cell widget into a StatefulWidget that stores an _isHovered
// variable.
//
// Tip: Place your cursor over the word "Cell" and press alt + enter on
// Windows/Linux or option + return on Mac. Select "Convert to StatefulWidget"
// from the dropdown.
class Cell extends StatelessWidget {
  final int index;

  const Cell({
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: InkWell(
        // TODO: Add a callback function to handle `onHover`
        onLongPress: () => _showDialogInfo(context, index),
        onTap: () => _showInfoPage(context, index),
        child: PhysicalModel(
          //TODO: Change color and elevation depending on the hovering state
          color: Colors.blue,
          elevation: 10,
          borderRadius: BorderRadius.circular(15),          
          shadowColor: Colors.black,
          child: Center(
            child: Text(
              '$index',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Detailed information $index'),
      ),
      body: Center(
        child: Text(
          index.toString(),
          style: const TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}

//Method shows dialog with info about grid element
void _showDialogInfo(BuildContext context, int index) => showDialog<void>(
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
