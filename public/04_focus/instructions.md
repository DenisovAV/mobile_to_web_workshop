# Focus control

Another important point when developing a web or desktop application is keyboard control. In our case, the keyboard should control the selection of the current grid element.

Flutter has an out-of-the-box focus system that directs the keyboard input to a particular part of an application. There is an article [Understanding Flutter's focus system](https://docs.flutter.dev/development/ui/advanced/focus) that describes in detail how to work with focus. In order to add the ability to move between elements using the keyboard, we just need to wrap each element in a [`Focus`](https://api.flutter.dev/flutter/widgets/Focus-class.html) widget.

```dart
class Focus extends StatefulWidget {
 /// Creates a widget that manages a [FocusNode].
 ///
 /// The [child] argument is required and must not be null.
 ///
 /// The [autofocus] argument must not be null.
 const Focus({
   Key? key,
   required this.child,
   this.focusNode,
   this.autofocus = false,
   this.onFocusChange,
   FocusOnKeyEventCallback? onKeyEvent,
   FocusOnKeyCallback? onKey,
   bool? canRequestFocus,
   bool? skipTraversal,
   bool? descendantsAreFocusable,
   this.includeSemantics = true,
   String? debugLabel,
 })
}
```

Using the `onFocusChange` callback, you can control when the focus is gained or lost by the widget.

So we are able to switch between elements using the `Tab` key (*`Tab` key and cursor keys on Desktop*). However the highlighting of a selected element also needs to be implemented, and we can use the mentioned callback to change a highlighting state, for example, let's highlight a grid element with a different color.

To implement this functionality you need to perform the following actions:

1. Add the `_isFocused` property to `Cell` widget's state, to understand whether the widget is focused.
2. Add `Focus` into the build method.
3. Add a `_onChangeFocus` callback to change the widget state based on focus state and set `onFocusChange` property of `Focus`.
```dart
 void _onChangeFocus(bool isHovered) => setState(() {
   _isFocused = isFocused;
 });
```
4. Change `color` and `elevation` properties in the `PhysicalModel` widget depending on the focusing state.

But again, specifically in our case, you can not add a `Focus` widget, since it is also already included in the `InkWell` widget. It has an `onFocusChange` property as well. So the above instruction can be shortened as in the situation with `MouseRegion`.

1. Add the `_isFocused` property to the `Cell` widget's state, to understand whether the widget is focused.
2. Add the `_onChangeFocus` callback to change the widget state based on the focus state and set the `onFocusChange` property of `InkWell`.
3. Change `color` and `elevation` properties in the `PhysicalModel` widget depending on the focusing state.

By the way, at the beginning of the Workshop, we changed `GestureDetector` to `InkWell` in order to highlight the focused elements by default, and now we don't need the default highlight anymore, you need to remove it. You can do this, for example, by setting the `focusColor` property of `Inkwell` to `Colors.transparent`.

Also, due to the fact that we are using the `InkWell` widget, when you press enter or space on the focused grid element, the `onTap` callback will be automatically called, if we used a `Focus` widget, we would have to manually track button presses using the `onKeyEvent` or `onKey` callback. We are going to return to them in the following steps.

The last but not least feature, that you need to implement here, is at least one grid element focused by default because the application looks strange if you support focus, but no element is focused. For this purpose, you can use the `autofocus` property of a `Focus` or `Inkwell` widget. If it is set in `true`, the widget will be selected as the initial focus when no other widget in its scope is currently focused. Let's set it `true' on the first element, whose index equals zero.

So, you should implement something like this:

```dart
 InkWell(
    onLongPress: () => _showDialogInfo(context, widget.index),
    onTap: () => _showInfoPage(context, widget.index),
    mouseCursor: SystemMouseCursors.click,
    onHover: _onChangeHover,
    autofocus: widget.index == 0,
    onFocusChange: _onChangeFocus,
    focusColor: Colors.transparent,
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
 );
```

Check it out!
