# Introduction

## Welcome to the journey from a mobile app to a web or desktop app.

As you can remember, since March 2021, Flutter has become a multi-platform framework, and applications can be created not only for mobile but also for web and desktop. However, web and desktop applications have a few significant differences, for example, in a mobile application, you need to support only touch screens, in a web or desktop application you need to support keyboard and mouse control as well. In this workshop, we are going to remake a simple mobile application into a desktop one, along the way, we will figure out how to manage focus properly and what hover effect is.

Let's try to remake the prototype of an e-commerce product. Let the application have a gallery with some goods, a tap on the element of the greed opens a screen with detailed information, and a long tap displays a dialog with brief details. But since we don’t have any goods, instead of them, we will use the usual numbers from 0 to 7.

![](http://localhost:8080/images/phone.png)

On a mobile device, everything works well, but if the application is launched in a browser or on a desktop, then issues in UX will immediately be visible, since, in such applications, the user expects the following:

- firstly, keyboard support, so that the keyboard can control the selection of the current element;
- secondly, when hovering the mouse, it should be clear that the element is clickable, so it should somehow be highlighted.

Let's run our application not on a mobile device, but in a [browser](https://docs.flutter.dev/get-started/web) or on a [desktop](https://docs.flutter.dev/desktop) and check. To do this, just select the appropriate target in your IDE and press Run.

None of the above is happening, so let's try to fix it.

## Support out of the box

The easiest fix for these issues is changing `GestureDetector` to `InkWell`, because `InkWell` supports focusing and hovering out of the box.

Please make this change, reload the app and check.

Now when you hover the mouse pointer to the element, the mouse cursor is changed, also you can move the focus by keyboard and open the details page by pressing Enter key. But, unfortunately, the selection of the active element is hardly noticeable, and it would be better to have a brighter hover effect, so let's figure out how to implement our own hover effect and focus control.

# Important

1. To check focus keyboard control is working, make sure to "Run" your code, click inside the "UI Output" window, then hit the `Tab` key.
2. DartPad has **Flutter for Web** under the hood, so you can use the `Tab` key only for focus moving. If you copy the code and run it in IDE for Desktop, you will be able to use cursors keys as well.


PS: If you don't need to highlight a focus and hover effect you can set [`FocusHighLightStrategy`](https://api.flutter.dev/flutter/widgets/FocusManager/highlightStrategy.html) to `FocusHighlightStrategy.alwaysTouch`, so that focus highlights will only appear on widgets that bring up a soft keyboard.

```dart
FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTouch;
```
