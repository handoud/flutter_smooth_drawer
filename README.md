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

## How the RTL Animation works
When the drawer is open in an LTR language, the main screen slides to the right (`+slidePercent`). If you change the app's language to an RTL language, `flutter_smooth_drawer` detects the change and beautifully animates the main screen's translation to the left (`-slidePercent`), gliding over your menu layer underneath!

Enjoy building stunning, accessible apps!
