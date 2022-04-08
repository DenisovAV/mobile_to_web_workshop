# Difference in behavior between Web and Desktop

In the first step you learned that you can use the `Tab` key to move between `Focus` widgets on Flutter Web, but you can use both the `Tab` key _and_ cursors keys on Flutter Desktop. Why do they work differently? And what if you want to control focus on the web using the keyboard cursor key? Let's figure it out.

The root of our application is the [`MaterialApp`](https://api.flutter.dev/flutter/material/MaterialApp-class.html) widget, which uses [`WidgetApp`](https://api.flutter.dev/flutter/widgets/WidgetsApp-class.html) under the hood. If you look into the `WidgetsApp` implementation, you will see the initialization of default shortcuts. The default set of Flutter Web shortcuts is different than set of Flutter Desktop shortcuts.

* Web defaults:
```dart
   // Keyboard traversal.
   SingleActivator(LogicalKeyboardKey.tab): NextFocusIntent(),
   SingleActivator(LogicalKeyboardKey.tab, shift: true): PreviousFocusIntent(),
```

* Desktop defaults:
```dart
   // Keyboard traversal.
   SingleActivator(LogicalKeyboardKey.tab): NextFocusIntent(),
   SingleActivator(LogicalKeyboardKey.tab, shift: true): PreviousFocusIntent(),
   SingleActivator(LogicalKeyboardKey.arrowLeft): DirectionalFocusIntent(TraversalDirection.left),
   SingleActivator(LogicalKeyboardKey.arrowRight): DirectionalFocusIntent(TraversalDirection.right),
   SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(TraversalDirection.down),
   SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(TraversalDirection.up),
```

So, in order to control focus using the arrow keys, you only need to add 4 shortcuts to the `_shortcuts` map after making sure that the application is running on the Web by checking the `kIsWeb` variable.

You can prepare map of additional shortcuts, for example, this way:
```dart
const _cursorShortcuts = kIsWeb ? <ShortcutActivator, Intent>{
 SingleActivator(LogicalKeyboardKey.arrowLeft): DirectionalFocusIntent(TraversalDirection.left),
 SingleActivator(LogicalKeyboardKey.arrowRight): DirectionalFocusIntent(TraversalDirection.right),
 SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(TraversalDirection.down),
 SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(TraversalDirection.up),
} : <ShortcutActivator, Intent>{};
```

Let's try to do this and cheсk.
