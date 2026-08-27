## 0.0.2

* `SmoothDrawerScope`: publishes the resolved direction, open state, duration
  and curve to everything inside the drawer, so a menu can animate in step
  with the main screen.
* `SmoothDrawerMenuPanel`: a fixed-width menu panel that glides across on an
  RTL/LTR change instead of snapping. A menu positioned with
  `AlignmentDirectional` resolves the instant `Directionality` flips, which
  left the menu jumping while the main screen was still travelling.
* `curve` and `openCornerRadius` are now configurable.
* Optional `controller`, for opening the drawer from outside its subtree. A
  controller passed in is owned by the caller and is no longer disposed by the
  drawer.
* The menu is excluded from the semantics tree while the drawer is closed.
* Reads `MediaQuery.sizeOf` instead of `MediaQuery.of(context).size`.

## 0.0.1

* Initial release of `flutter_smooth_drawer`.
* 3D perspective hidden drawer with smooth open/close animations.
* Smooth cross-screen animation when the layout direction changes between RTL and LTR while the drawer is open.
* Customizable animation duration, slide percentage, and scale percentage.
* Automatic or manual RTL detection via `Directionality` or the `isRtl` property.
* Tap the scaled-down main screen to close the drawer.
