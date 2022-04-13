# Focus control

Another important point when developing a web or desktop application is keyboard control. In our case, the keyboard should control the selection of the current grid element.

Flutter has an out-of-the-box focus system that directs the keyboard input to a particular part of an application. The article "[Understanding Flutter's focus system](https://docs.flutter.dev/development/ui/advanced/focus)" describes in detail how to work with focus. In order to add the ability to move between elements using the keyboard, you just need to wrap each element in a [`Focus`](https://api.flutter.dev/flutter/widgets/Focus-class.html) widget.

Using the `onFocusChange` callback, you can control when the focus is gained or lost by the widget.

```dart
Focus(
   onFocusChange: _onFocusChange,
 )
```

So you are able to switch between elements using the `Tab` key (*`Tab` key and arrow keys on Desktop*). However the highlighting of a selected element also needs to be implemented, and you can use the mentioned callback to change a highlighting state, for example, let's highlight a grid element with a different color.

To implement this functionality you need to perform the following actions:

1. Add the `_isFocused` property to `Cell` widget's state, to understand whether the widget is focused.
2. Add `Focus` into the build method.
3. Add a `_onFocusChange` callback to change the widget state based on focus state and set `onFocusChange` property of `Focus`.
```dart
 void _onFocusChange(bool isFocused) => setState(() {
   _isFocused = isFocused;
 });
```
4. Change `color` and `elevation` properties in the `PhysicalModel` widget depending on the focusing state.

But again, like MouseRegion, you can not add a `Focus` widget, since it is also already included in the `InkWell` widget. It has an `onFocusChange` property as well. 

1. Add the `_isFocused` property to the `Cell` widget's state, to understand whether the widget is focused.
2. Add the `_onChangeFocus` callback to change the widget state based on the focus state and set the `onFocusChange` property of `InkWell`.
3. Change `color` and `elevation` properties in the `PhysicalModel` widget depending on the focusing state.

Also, if you use the `InkWell` widget, when you press enter or space on the focused grid element, the `onTap` callback will be automatically called. If you use the `Focus` widget, you have to manually track button presses using the `onKeyEvent` or `onKey` callback. You can handle keys that are pressed when this widget or one of its children has focus. Both callbacks do the same, but the `onKey` is a legacy API and will be deprecated in the future. So let's use the `onKeyEvent`. This handler has the type `FocusOnKeyEventCallback`.

```dart
typedef FocusOnKeyEventCallback = KeyEventResult Function(FocusNode node, KeyEvent event);
```

In the `KeyEvent`, you get information about which key was pressed, and the event itself can be of three types:
* [`KeyDownEvent`](https://api.flutter.dev/flutter/services/KeyDownEvent-class.html), a key event representing the user pressing a key.
* [`KeyRepeatEvent`](https://api.flutter.dev/flutter/services/KeyRepeatEvent-class.html), a key event representing the user holding a key, causing repeated events.
* [`KeyUpEvent`](https://api.flutter.dev/flutter/services/KeyUpEvent-class.html), a key event representing the user releasing a key.

And you have three options to return:
* `KeyEventResult.handled` - the key event has been handled, and the event should not be propagated to other key event handlers.
* `KeyEventResult.ignored` - the key event has not been handled, and the event should continue to be propagated to other key event handlers, even non-Flutter ones.
* `KeyEventResult.skipRemainingHandlers` - the key event has not been handled, but the key event should not be propagated to other key event handlers.

Let's try to handle the `Enter` and `Space` presses.

```dart
    Focus(
        onKeyEvent: (_, event) {
          if ([LogicalKeyboardKey.enter, LogicalKeyboardKey.space].contains(event.logicalKey) &&
              event is KeyDownEvent) {
            _showInfoPage(context, widget.index);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
    )
```

## Autofocus

The last but not least feature you need to implement here, is at least one grid element focused by default because the application looks strange if you support focus, but no element is focused. For this purpose, you can use the `autofocus` property of a `Focus` or `Inkwell` widget. If it is set in `true`, the widget will be selected as the initial focus when no other widget in its scope is currently focused. Let's set it `true` on the first element, whose index equals zero.
So, you should implement something like this:

```dart
   Focus(
        autofocus: widget.index == 0,
        onFocusChange: _onChangeFocus,
        onKeyEvent: (_, event) {
          if ([LogicalKeyboardKey.enter, LogicalKeyboardKey.space].contains(event.logicalKey) &&
              event is KeyDownEvent) {
            _showInfoPage(context, widget.index);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
   )
```

Check it out!
