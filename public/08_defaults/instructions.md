# Difference in behavior between Web and Desktop

In the **Introduction** step it was already mentioned, that you can use the `Tab` key to move `Focus` on the Web, and use the `Tab` key and cursors keys on a Desktop. Why does it work differently? And what if you want to control focus on the web using the keyboard cursor key? Let's figure it out.

Actually, at the root of the widget tree of our application, there is the [`MaterialApp`](https://api.flutter.dev/flutter/material/MaterialApp-class.html) widget, which uses [`WidgetApp`](https://api.flutter.dev/flutter/widgets/WidgetsApp-class.html) inside, and if you look into its implementation, you will see the initialization of default shortcuts, and the set of them is different for the Web and for the Desktop.

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

So, in order to be able to control focus using the keyboard cursor, you only need to add 4 shortcuts to the `_shortcuts` map, after making sure that the application is running on the Web by checking the `kIsWeb` variable.

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
