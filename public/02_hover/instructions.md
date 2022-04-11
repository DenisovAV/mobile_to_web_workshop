# Custom hover effect

Let's start with customizing the hover effect.

In order to control the appearance of the widget depending on the behavior of the mouse, there is a special widget - `MouseRegion`. [`MouseRegion`](https://api.flutter.dev/flutter/widgets/MouseRegion-class.html) is a widget that forwards mouse events to callbacks.

Using the `onEnter`, `onHover` and `onExit` callbacks, you can control when the mouse cursor enters the widget and when the cursor leaves the widget.

- `onEnter` is triggered when the pointer, with or without buttons pressed, has started to be contained by the region of this widget.
- `onHover` is triggered when a pointer moves into a position within this widget without buttons pressed.
- `onExit` is triggered when the pointer, with or without buttons pressed, has stopped being contained by the region of this widget, except when the exit is caused by the disappearance of this widget.

```dart
MouseRegion(
   onEnter: _onEnter,
   onExit: _onExit,
   onHover _onHover,
)
```

## Cursor

In addition, using the `cursor` property, you can determine what the cursor will look like while it is on the widget.

```dart
MouseRegion(
   cursor: SystemMouseCursors.grab,
)
```

In order to improve our application and make each product change color when the mouse hovers over it you need to perform the following actions:

1. Change the widget type of `Cell` to a stateful widget, and add the `_isHovered` property to its state, to show whether the mouse is currently hovering over the widget or not.
2. Add `MouseRegion` into the build method.
3. Add a `_onHoverChange` callback to change the state based on mouse hover and set `onHover` and `onExit` properties of MouseRegion.
```dart
 void _onChangeHover(bool isHovered) => setState(() {
   _isHovered = isHovered;
 });
```
4. Change `color` and `elevation` properties in the `PhysicalModel` widget depending on the hovering state.
5. Changr `InkWell` widget back to `GestureDetector` in order to avoid mixing standart and custom effects.

```dart
      GestureDetector(
        onLongPress: () => _showDialogInfo(context, widget.index),
        onTap: () => _showInfoPage(context, widget.index),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onHover: (_) => _onHoverChange(true),
          onExit: (_) => _onHoverChange(false),
          child: PhysicalModel(
            borderRadius: BorderRadius.circular(15),
            color: _isHovered ? Colors.blueGrey : Colors.blue,
            elevation: _isHovered ? 25 : 10,
            shadowColor: Colors.black,
            child: Center(
              child: Text(
                '${widget.index}',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      )
```

Actually, you can not add the `MouseRegion` widget, since it is already included in the `InkWell` widget that we are using. It has a `mouseCursor` property, which is equivalent to MouseRegion's `cursor`, and an `onHover` callback that can be used to control the moment when the mouse cursor hovers over the widget. 

1. Change the widget type of `Cell` to a stateful widget, and add the `_isHovered` property to its state, to show whether the mouse is currently hovering over the widget or not.
2. Add a `_onHoverChange` callback to change the state based on mouse hover and set `onHover` property of InkWell.
3. Change `color` and `elevation` properties in the `PhysicalModel` widget depending on the hovering state.

```dart
     InkWell(
       onLongPress: () => _showDialogInfo(context, widget.index),
       onTap: () => _showInfoPage(context, widget.index),
       mouseCursor: SystemMouseCursors.click,
       onHover: (value) => _onHoverChange(value),
       child: PhysicalModel(
         borderRadius: BorderRadius.circular(15),
         color: _isHovered ? Colors.blueGrey : Colors.blue,
         elevation: _isHovered ? 25 : 10,
         shadowColor: Colors.black,
         child: Center(
           child: Text(
             '${widget.index}',
             style: const TextStyle(color: Colors.white, fontSize: 20),
           ),
         ),
       ),
     )
```
