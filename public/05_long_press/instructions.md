# Key long-press handling

Currently, we can move the focus using the keyboard, and open the details page with the `Enter` or `Space` key press. However, the mobile version of the application had one more feature: long tapping on a product opens a dialog. Let's try to implement the same functionality when the `Enter` or `Space` key is long-pressed.

To handle the `Enter` and `Space` long-presses, we need to separate when a key is quickly pressed and released from the situations when a key is pressed and held down. If a `KeyUpEvent` occurs, you need to call `_showInfoPage` method, because it means that key was quickly pressed then released. If a `KeyRepeatEvent` occurs, you need to call `_showDialogInfo` because it means that key was pressed and held down. You can skip `KeyDownEvent` because this event will be produced in both cases.

To implement this you have to perform only one action:

1. Change the `onKeyEvent` property of `Focus` with the handler described above.
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

Try to implement it and check it out! Long-pressing and short-pressing of `Enter` and `Space` should work in different ways now.
