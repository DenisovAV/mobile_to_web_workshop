# Key long-press handling

So, currently, we can move the focus using the keyboard, and open the details page with the `Enter` or `Space` key press. But the mobile version of the application had one more feature, by a long tap on the element, a dialog with a brief description of it opened. Let's try to implement the same functionality when the `Enter` or `Space` key is long-pressed.

To implement this feature, just the `InkWell` functionality is not enough and you have to wrap it in the `Focus` widget in order to process keypress events manually.

Using the `onKey` or `onKeyEvent` callbacks, you can handle keys that are pressed when this widget or one of its children has focus. Both of them do the same, but the `onKey` is a legacy API and will be deprecated in the future. So let's use the `onKeyEvent`. This handler has the type `FocusOnKeyEventCallback`.
```dart
typedef FocusOnKeyEventCallback = KeyEventResult Function(FocusNode node, KeyEvent event);
```

In the `KeyEvent`, we get information about which key was pressed, and the event itself can be of three types:
* [`KeyDownEvent`](https://api.flutter.dev/flutter/services/KeyDownEvent-class.html), a key event representing the user pressing a key.
* [`KeyRepeatEvent`](https://api.flutter.dev/flutter/services/KeyRepeatEvent-class.html), a key event representing the user holding a key, causing repeated events.
* [`KeyUpEvent`](https://api.flutter.dev/flutter/services/KeyUpEvent-class.html), a key event representing the user releasing a key.

And you have three options to return:
* `KeyEventResult.handled` - the key event has been handled, and the event should not be propagated to other key event handlers.
* `KeyEventResult.ignored` - the key event has not been handled, and the event should continue to be propagated to other key event handlers, even non-Flutter ones.
* `KeyEventResult.skipRemainingHandlers` - the key event has not been handled, but the key event should not be propagated to other key event handlers.

Actually, to handle the `Enter` and `Space` long-presses, we need to separate such situations when a key is pressed and released at once, and the situations when it is pressed and not released for some time. So you should skip `KeyDownEvent` because this event will be produced in both cases, and in case `KeyUpEvent` you need to call `_showInfoPage` method, because it means that key was released, but in case `KeyRepeatEvent` you need to call `_showDialogInfo` because it means that key wasn’t released for some time.

To implement this you have to perform the following actions:

1. Add the `Focus` widget into the build method.
2. Set the `onKeyEvent` property of `Focus` with the handler described above.
```dart
     (node, event) {
       if ([LogicalKeyboardKey.enter, LogicalKeyboardKey.space].contains(event.logicalKey)) {
         if (event is KeyRepeatEvent) {
           _showDialogInfo(context, widget.index);
         } else if (event is KeyUpEvent) {
           _showInfoPage(context, widget.index);
         }
         return KeyEventResult.handled;
       }
       return KeyEventResult.ignored;
     }
```
3. Move the `onFocusChange` and `autofocus` properties from `InkWell` to `Focus`, in order to handle focus changing in the top `FocusNode`.
4. Set the `canRequestFocus` property of the `InkWell` to `false`. (if you don't do this, it will be necessary to press `Tab` twice to move to the next grid element, because you have two focus nodes on one widget in `InkWell` and in `Focus` widgets)


Try to implement it and check it out! Long-pressing and short-pressing of `Enter` and `Space` should work in different ways now.
