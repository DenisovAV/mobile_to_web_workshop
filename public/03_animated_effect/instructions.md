# Animated hover effect

In this step, let's try to make the hover effect more interesting by adding animation to it.

To begin with, we animate the shadow cast by the grid element and the color change. To do this you need to replace the widget [`PhysicalModel`](https://api.flutter.dev/flutter/widgets/PhysicalModel-class.html) with [`AnimatedPhysicalModel`](https://api.flutter.dev/flutter/widgets/AnimatedPhysicalModel-class.html), for example like this:
```dart
AnimatedPhysicalModel(
  borderRadius: BorderRadius.circular(15),
  color: _isHovered ? Colors.blueGrey : Colors.blue,
  shape: BoxShape.rectangle,
  elevation: _isHovered ? 25 : 10,
  shadowColor: Colors.black,
  duration: const Duration(milliseconds: 300),
  curve: Curves.fastOutSlowIn,
  child: Center(
    child: Text(
      '${widget.index}',
      style: const TextStyle(color: Colors.white, fontSize: 20),
    ),
  ),
)
```

## Voila! Shadow and color are animated.

But the animation can be made much more interesting, let's try not to change the color, but increase the element size and at the time the shadow size. In this way, a very interesting effect will be obtained, as if the element rises above the plane of the screen. To increase the size, you can use for example [`AnimatedScale`](https://api.flutter.dev/flutter/widgets/AnimatedScale-class.html)

```dart
AnimatedScale(
  scale: _isHovered ? 1.1 : 1.0,
  duration: const Duration(milliseconds: 300),
  child: AnimatedPhysicalModel(
  .
  .
  .
```

Let's check it out!

