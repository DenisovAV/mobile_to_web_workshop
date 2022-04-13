# Keyboard listener

Another thing you haven't implemented yet is closing the `InfoPage` widget using the keyboard. It would be great to close it and return to the main page using the `Esc` button.

There are a couple of widgets that run a callback whenever the user presses or releases a key on a keyboard. These are a [`KeyboardListener`](https://api.flutter.dev/flutter/widgets/KeyboardListener-class.html) and [`RawKeyboardListener`](https://api.flutter.dev/flutter/widgets/RawKeyboardListener-class.html), they are useful for listening to key events and hardware buttons that are represented as keys. These widgets are typically used by games and other apps that use keyboards for purposes other than text entry. The `RawKeyboardListener` is different from `KeyboardListener` in that `RawKeyboardListener` uses the legacy `RawKeyboard` API. The Flutter team recommends using `KeyboardListener` if possible. So let's try to wrap `InfoPage` into `KeyboardListener` and handle the pressing of `Esc` key.

To implement the mentioned functionality you need to do the following:

1. Add the `KeyboardListener` widget into the build method.
2. Set the `onKeyEvent` property of `KeyboardListener` with the handler like in the fourth step, but for the `Esc` key.
```dart
     (event) {
        if (event.logicalKey == LogicalKeyboardKey.escape && event is KeyDownEvent) {
          Navigator.of(context).pop();
        }
     }
```
3. Set the `autofocus` property to `true`, in order to have focus after page opening.
4. Set the `focusNode` property to the new `FocusNode`, because you need the focus node to handle keyboard events.

So, let's get started!

