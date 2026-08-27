# flutter_smooth_drawer

A beautiful, 3D perspective hidden drawer for Flutter that features a unique capability: **Smooth Cross-Screen Animations during RTL/LTR toggles**.

When your app dynamically switches between Left-To-Right (LTR) and Right-To-Left (RTL) languages while the drawer is open, `flutter_smooth_drawer` will gracefully glide the main screen across the display over the background menu, creating a buttery smooth transition instead of an instant layout snap.

## Features
- 🚀 **Smooth RTL <-> LTR Transitions**: Automatically glides the main screen across the view when the layout direction changes.
- 🎨 **Deep Customization**: Fully customize the animation duration, slide percentage, and scale percentage.
- 🌍 **Automatic or Manual RTL Detection**: Reads `Directionality` by default, or you can manually override it via the `isRtl` property.
- 👆 **Gestures**: Tapping the scaled-down main screen automatically closes the drawer.

## Usage

First, wrap your main `Scaffold` and `Menu` in the `SmoothHiddenDrawer`.

```dart
import 'package:flutter_smooth_drawer/flutter_smooth_drawer.dart';

SmoothHiddenDrawer(
  // The background menu widget
  menu: Container(
    color: Colors.blueAccent,
    child: Center(child: Text('Menu Items')),
  ),
  // The foreground main screen
  mainScreen: Scaffold(
    appBar: AppBar(
      title: Text('Smooth Drawer'),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Trigger the drawer from anywhere inside the mainScreen
            SmoothHiddenDrawerController.of(context).toggle();
          },
        ),
      ),
    ),
    body: Center(child: Text('Main Content')),
  ),
  
  // Customization Options
  animationDuration: Duration(milliseconds: 600), // How fast it glides
  slidePercent: 0.7, // How much of the screen to slide (70%)
  scalePercent: 0.8, // How much to shrink the main screen (80%)
  
  // RTL Override (Optional)
  // If omitted, it automatically listens to Directionality.of(context)
  isRtl: false, 
)
```

## Keeping the menu in step
By default the `menu` fills the screen, so its own content decides where it
sits. If you place that content with `AlignmentDirectional` it will *snap* to
the other side the moment the language changes, because a directional
alignment has already resolved before the first frame of the transition.

Wrap it in `SmoothDrawerMenuPanel` instead and it glides across with the main
screen:

```dart
SmoothHiddenDrawer(
  menu: ColoredBox(
    color: Colors.blueGrey.shade900,
    child: SmoothDrawerMenuPanel(
      width: 300,
      child: MyMenuItems(),
    ),
  ),
  mainScreen: MyScaffold(),
)
```

Keep the background full-bleed, as above, so the area the panel does not cover
is still painted. For anything more custom, read `SmoothDrawerScope.of(context)`
directly — it carries `isRtl`, `isOpen`, `animationDuration`, `curve` and a
ready-made absolute `menuAlignment`.

How the RTL Animation works
When the drawer is open in an LTR language, the main screen slides to the right (`+slidePercent`). If you change the app's language to an RTL language, `flutter_smooth_drawer` detects the change and beautifully animates the main screen's translation to the left (`-slidePercent`), gliding over your menu layer underneath!

Enjoy building stunning, accessible apps!
