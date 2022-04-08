# Shortcuts and Actions

So, let's now add one more interesting feature to the application. Since each element of the grid has a number, we can implement keyboard controls using shortcuts. By pressing the digit key, the corresponding element becomes active, and by pressing the Command + digit key, the corresponding `InfoPage` opens.

There is a system to bind physical keyboard events to actions in the user interface. The article "[Using Actions and Shortcuts](https://docs.flutter.dev/development/ui/advanced/actions_and_shortcuts)" describes how to work with the system in detail.

First of all, you need to create intents. An intent is a generic action that the user wishes to perform, and an [`Intent`](https://api.flutter.dev/flutter/widgets/Intent-class.html) class instance represents these user intents in Flutter. Let's create two:
* FocusDigitIntent to represent activation of the element (focusing on it)
* InfoPageDigitIntent to represent opening of `InfoPage`

Both of them have to depend on the index of the element.

```dart
class FocusDigitIntent extends Intent {
 final int index;

 const FocusDigitIntent(this.index);
}
// Is there supposed to be an InfoPageDigitIntent here?
```

Next, you should define key combinations that represent the user’s intent when that key combination is pressed. There is an interface [`ShortcutActivator`](https://api.flutter.dev/flutter/widgets/ShortcutActivator-class.html) to define the keyboard key combination to trigger a shortcut and a few implementations of it:
* [`SingleActivator`](https://api.flutter.dev/flutter/widgets/SingleActivator-class.html), an implementation that represents a single key combined with modifiers (control, shift, alt, meta).
* [`CharacterActivator`](https://api.flutter.dev/flutter/widgets/CharacterActivator-class.html), an implementation that represents key combinations that result in the specified character, such as question mark.
* [`LogicalKeySet`](https://api.flutter.dev/flutter/widgets/LogicalKeySet-class.html), an implementation that requires one or more LogicalKeyboardKeys to be pressed at the same time. (This is legacy. Prefer SingleActivator when possible).

It would be most convenient to use the CharacterActivator for pressing digits and the SingleActivator for Command + digit combinations. To indicate that the key is pressed in combination with the Command key, you need to set the `meta` property to `true`:

```dart
const _shortcuts = <ShortcutActivator, Intent>{
 CharacterActivator('0'): FocusDigitIntent(0),
 SingleActivator(LogicalKeyboardKey.digit0, meta: true): InfoPageDigitIntent(0),
 .
 .
}
```

Actually, you don't need to add all combinations manually. You can add all of them to the loop, like this:

```dart
final _shortcuts = Map<ShortcutActivator, Intent>.fromEntries(
 List.generate(
     8, (index) => MapEntry(CharacterActivator(index.toString()), FocusDigitIntent(index)))

    // What is this _digits thing? Looks like a mysterious `Set<LogicalKeyboardKey>`, e.g. {LogicalKeyboardKey.digit0, LogicalKeyboardKey.digit1} etc?
   ..addAll(_digits.map(
       (e) => MapEntry(SingleActivator(e, meta: true), FocusDigitIntent(_digits.indexOf(e))))),
);
```

Now you need to create actions that process the intents created above and that directly move the focus to the desired element or open the corresponding `InfoPage`.
* `FocusDigitAction` to handle `FocusDigitIntent`
* `InfoPageDigitAction` to handle `InfoPageDigitIntent`

The action class has to extend from the [`Action`](https://api.flutter.dev/flutter/widgets/Action-class.html) interface and implement its `invoke` method. With the `InfoPageDigitAction`, everything is quite simple, to open the corresponding `InfoPage` you only need to pass the `BuildContext` to the class, and get the index of the element page from the intent:

```dart
class InfoPageDigitAction extends Action<InfoPageDigitIntent> {
 final BuildContext context;

 InfoPageDigitAction(this.context);

 @override
 void invoke(covariant InfoPageDigitIntent intent) => Navigator.push(
   context,
   MaterialPageRoute(
     builder: (context) => InfoPage(
       index: intent.index,
     ),
   ),
 );
}
```

With the `FocusDigitAction`, everything is a bit more complicated. To activate the corresponding element you need to request its focus, so that you can pass its `FocusNode`. In order to do this, we need to create a map for matching an element's index with its node.

```dart
class FocusDigitAction extends Action<FocusDigitIntent> {
 final Map<int, FocusNode> nodes;

 FocusDigitAction(this.nodes);

 @override
 void invoke(covariant FocusDigitIntent intent) => nodes[intent.index]?.requestFocus();
}
```

So, there is very little left to do:

1. Add [`Shortcuts`](https://api.flutter.dev/flutter/widgets/Shortcuts-class.html) widget into the build method of the `WorkshopPage` and set its `shortcuts` property with the `_shortcuts` map.
2. Create the map for matching elements' indexes and focus nodes:
```dart
 final _nodes = Map<int, FocusNode>.fromEntries(
   List.generate(8, (index) => MapEntry(index, FocusNode())),
 );
```
3. Add [`Actions`](https://api.flutter.dev/flutter/widgets/Actions-class.html) widget as `Shortcuts` child and set `actions` property with map matches intents and actions:
```dart
 actions: <Type, Action<Intent>>{
           InfoPageDigitIntent: InfoPageDigitAction(context),
           FocusDigitIntent: FocusDigitAction(_nodes),
 }
```
4. Add the `focusNode` parameter to the `Cell` widget, in order to provide focus nodes from the map.
5. Set the `focusNode` property of the `Focus` widget with the `FocusNode` provided above

By the way, you can do one more thing. You don't need the `_showInfoPage` anymore, so you can remove it using the action handler instead.

```dart
   final _actionHandler =
   Actions.handler<InfoPageDigitIntent>(context, InfoPageDigitIntent(widget.index));
```

That's it. Everything should work. You can run the application and check it by pressing digit keys or Control + digit.
