# FocusableActionDetector

Everything looks almost good now! You have remade Mobile applications to Web or Desktop. You handle mouse and keyboard navigation and added some functionality specific only to devices with a hardware keyboard. The only thing that doesn't look very neat is the `Сell` widget code, with two nested `Focus` widgets. Maybe there is an opportunity to implement the same functionality a little more neatly?

There is a widget, that gives an opportunity to combine the `Shortcuts`, `Actions`, `Focus`, and `MouseRegion` widgets into one widget, its name is [`FocusableActionDetector`](https://api.flutter.dev/flutter/widgets/FocusableActionDetector-class.html). Lets try to replace some code by using it.

<!-- Once again, I'd consider removing this bit! -->
```dart
class FocusableActionDetector extends StatefulWidget {
 /// Create a const [FocusableActionDetector].
 ///
 /// The [enabled], [autofocus], [mouseCursor], and [child] arguments must not be null.
 const FocusableActionDetector({
   Key? key,
   this.enabled = true,
   this.focusNode,
   this.autofocus = false,
   this.descendantsAreFocusable = true,
   this.shortcuts,
   this.actions,
   this.onShowFocusHighlight,
   this.onShowHoverHighlight,
   this.onFocusChange,
   this.mouseCursor = MouseCursor.defer,
   required this.child,
 })  : assert(enabled != null),
       assert(autofocus != null),
       assert(mouseCursor != null),
       assert(child != null),
       super(key: key);
}
```

The simplest widgets that you can replace are `Shortcuts` and `Actions` inside the `WorkshopPage` widget. You just need to remove them, put the `FocusableActionDetector`, and set `actions` and `shortcuts` properties with the previous values.

```dart
FocusableActionDetector(
  shortcuts: _shortcuts,
  actions: <Type, Action<Intent>>{
    InfoPageDigitIntent: InfoPageDigitAction(context),
    FocusDigitIntent: FocusDigitAction(_nodes),
  },
);
```

Now, let's try to improve the `Cell` widget code. We have used `Focus` to handle long-presses, how is it possible to do it using shortcuts functionality? There is a solution, a `SingleActivator` handles only key down events, you can create your own activator that is able to handle long-presses by handling key repeat and key up events. So, you have to extend a `SingleActivator` and override the `accepts` method

```dart
class LongPressActivator extends SingleActivator {
  // Hm, this is confusing to me. Why does the LongPressActivator have an `isLongPress` variable? I thought that was the point of the class?
 final bool isLongPress;
 const LongPressActivator(LogicalKeyboardKey trigger, {this.isLongPress = false}) : super(trigger);

 @override
 bool accepts(RawKeyEvent event, RawKeyboard state) {
   return (event is RawKeyDownEvent && event.repeat && isLongPress) ||
       (event is RawKeyUpEvent && !isLongPress);
 }
}
```

Now the only thing left to do is the following:

1. Create `LongPressActivateIntent` to handle `Enter` and `Space` presses and long-presses.
```dart
class LongPressActivateIntent extends Intent {
 final bool isLongPress;

 const LongPressActivateIntent(this.isLongPress);
}
```
2. Return back `_showInfoPage` because you will need it in two actions `InfoPageDigitAction` and `LongPressDigitAction`.
3. Create `LongPressDigitAction` to process `Enter` and `Space` presses and long-presses.
```dart
class LongPressDigitAction extends Action<LongPressActivateIntent> {
 final BuildContext context;
 final int index;

 LongPressDigitAction(this.context, this.index);

 @override
 void invoke(covariant LongPressActivateIntent intent) =>
     intent.isLongPress ? _showDialogInfo(context, index) : _showInfoPage(context, index);
}
```
4. Create map to combine `LongPressActivator` and `LongPressActivateIntent` for both presses and long-presses.
```dart
const _cellShortcuts = <ShortcutActivator, Intent>{
  // Ah, ok -- I get it now. You can't use a SingleActivator here since it would always accept the first keypress, and the LongPressActivator wouldn't get to do it's job. Therefore, you need this new class.
  // Might be good to have just a little more explanation as to why a class named LogPressActivator needs the `isLongPress` variable :)
 LongPressActivator(LogicalKeyboardKey.enter, isLongPress: true): LongPressActivateIntent(true),
 LongPressActivator(LogicalKeyboardKey.enter, isLongPress: false): LongPressActivateIntent(false),
```
5. Replace `Focus` and `Inkwell` by `FocusableActionDetector`
```dart
   FocusableActionDetector(
       shortcuts: _cellShortcuts,
       actions: <Type, Action<Intent>>{
         LongPressActivateIntent: LongPressDigitAction(context, widget.index),
       },
       mouseCursor: SystemMouseCursors.click,
       onShowHoverHighlight: _onChangeHover,
       autofocus: widget.index == 0,
       onFocusChange: _onChangeFocus,
       child:
```

So, you have one neat widget, instead of two not very tidy ones, which is great!
