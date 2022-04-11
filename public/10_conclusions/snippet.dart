import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const WorkshopApp());
}

const _name = 'Workshop: From Mobile to Web/Desktop';

const _digits = <LogicalKeyboardKey>[
  LogicalKeyboardKey.digit0,
  LogicalKeyboardKey.digit1,
  LogicalKeyboardKey.digit2,
  LogicalKeyboardKey.digit3,
  LogicalKeyboardKey.digit4,
  LogicalKeyboardKey.digit5,
  LogicalKeyboardKey.digit6,
  LogicalKeyboardKey.digit7,
];

const _cursorShortcuts = kIsWeb
    ? <ShortcutActivator, Intent>{
  SingleActivator(LogicalKeyboardKey.arrowLeft):
  DirectionalFocusIntent(TraversalDirection.left),
  SingleActivator(LogicalKeyboardKey.arrowRight):
  DirectionalFocusIntent(TraversalDirection.right),
  SingleActivator(LogicalKeyboardKey.arrowDown):
  DirectionalFocusIntent(TraversalDirection.down),
  SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(TraversalDirection.up),
}
    : <ShortcutActivator, Intent>{};

final _shortcuts = Map<ShortcutActivator, Intent>.fromEntries(
  List.generate(
      8, (index) => MapEntry(CharacterActivator(index.toString()), FocusDigitIntent(index)))
    ..addAll(_digits.map(
            (e) => MapEntry(SingleActivator(e, meta: true), FocusDigitIntent(_digits.indexOf(e))))),
)..addAll(_cursorShortcuts);

const _cellShortcuts = <ShortcutActivator, Intent>{
  LongPressActivator(LogicalKeyboardKey.enter, isLongPress: true): LongPressActivateIntent(true),
  LongPressActivator(LogicalKeyboardKey.space, isLongPress: true): LongPressActivateIntent(true),
  LongPressActivator(LogicalKeyboardKey.enter, isLongPress: false): LongPressActivateIntent(false),
  LongPressActivator(LogicalKeyboardKey.space, isLongPress: false): LongPressActivateIntent(false),
};

class LongPressActivator extends SingleActivator {
  final bool isLongPress;
  const LongPressActivator(LogicalKeyboardKey trigger, {this.isLongPress = false}) : super(trigger);

  @override
  bool accepts(RawKeyEvent event, RawKeyboard state) {
    return (event is RawKeyDownEvent && event.repeat && isLongPress) ||
        (event is RawKeyUpEvent && !isLongPress);
  }
}

class LongPressActivateIntent extends Intent {
  final bool isLongPress;

  const LongPressActivateIntent(this.isLongPress);
}

class InfoPageDigitIntent extends Intent {
  final int index;

  const InfoPageDigitIntent(this.index);
}

class FocusDigitIntent extends Intent {
  final int index;

  const FocusDigitIntent(this.index);
}

class InfoPageDigitAction extends Action<InfoPageDigitIntent> {
  final BuildContext context;

  InfoPageDigitAction(this.context);

  @override
  void invoke(covariant InfoPageDigitIntent intent) => _showInfoPage(context, intent.index);
}

class LongPressDigitAction extends Action<LongPressActivateIntent> {
  final BuildContext context;
  final int index;

  LongPressDigitAction(this.context, this.index);

  @override
  void invoke(covariant LongPressActivateIntent intent) =>
      intent.isLongPress ? _showDialogInfo(context, index) : _showInfoPage(context, index);
}

class FocusDigitAction extends Action<FocusDigitIntent> {
  final Map<int, FocusNode> nodes;

  FocusDigitAction(this.nodes);

  @override
  void invoke(covariant FocusDigitIntent intent) => nodes[intent.index]?.requestFocus();
}

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

class WorkshopPage extends StatefulWidget {
  const WorkshopPage({Key? key}) : super(key: key);

  @override
  State<WorkshopPage> createState() => _WorkshopPageState();
}

class _WorkshopPageState extends State<WorkshopPage> {
  final _nodes = Map<int, FocusNode>.fromEntries(
    List.generate(8, (index) => MapEntry(index, FocusNode())),
  );

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      enabled: false,
      shortcuts: _shortcuts,
      actions: <Type, Action<Intent>>{
        InfoPageDigitIntent: InfoPageDigitAction(context),
        FocusDigitIntent: FocusDigitAction(_nodes),
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(_name),
        ),
        body: GridView.count(
          crossAxisCount: 4,
          children: List.generate(
            8,
                (index) {
              return Cell(
                index: index,
                node: _nodes[index],
              );
            },
          ),
        ),
      ),
    );
  }
}

class Cell extends StatefulWidget {
  final int index;
  final FocusNode? node;

  const Cell({
    required this.index,
    this.node,
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
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: FocusableActionDetector(
        shortcuts: _cellShortcuts,
        actions: <Type, Action<Intent>>{
          LongPressActivateIntent: LongPressDigitAction(context, widget.index),
        },
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: _onHoverChange,
        autofocus: widget.index == 0,
        onFocusChange: _onFocusChange,
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
    );
  }

  void _onHoverChange(bool isHovered) => setState(() {
    _isHovered = isHovered;
  });

  void _onFocusChange(bool isFocused) => setState(() {
    _isFocused = isFocused;
  });
}

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
