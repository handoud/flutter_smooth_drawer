import 'package:flutter/material.dart';
import 'smooth_hidden_drawer_controller.dart';

class SmoothHiddenDrawer extends StatefulWidget {
  /// The background menu widget.
  final Widget menu;

  /// The main foreground screen widget.
  final Widget mainScreen;

  /// Width percentage (0.0 to 1.0) of the screen to slide the main screen when open. Default is 0.7 (70%).
  final double slidePercent;

  /// Scale percentage (0.0 to 1.0) of the main screen when open. Default is 0.8 (80%).
  final double scalePercent;

  /// Duration for the open/close and RTL/LTR animations. Default is 400ms.
  final Duration animationDuration;

  /// If null, it automatically reads the Directionality of the context. If true, treats the app as RTL manually.
  final bool? isRtl;

  const SmoothHiddenDrawer({
    Key? key,
    required this.menu,
    required this.mainScreen,
    this.slidePercent = 0.7,
    this.scalePercent = 0.8,
    this.animationDuration = const Duration(milliseconds: 600),
    this.isRtl,
  }) : super(key: key);

  @override
  SmoothHiddenDrawerState createState() => SmoothHiddenDrawerState();
}

class SmoothHiddenDrawerState extends State<SmoothHiddenDrawer> with SingleTickerProviderStateMixin {
  late final SmoothHiddenDrawerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SmoothHiddenDrawerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine RTL dynamically based on either the manual override or the inherited Directionality
    final bool rtl = widget.isRtl ?? Directionality.of(context) == TextDirection.rtl;

    return SmoothHiddenDrawerProvider(
      controller: _controller,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final isOpen = _controller.isOpen;

          // Slide amount calculation
          final screenWidth = MediaQuery.of(context).size.width;
          final maxSlide = screenWidth * widget.slidePercent;
          
          // RTL changes the direction of the slide.
          // If LTR, slide Right (positive X).
          // If RTL, slide Left (negative X).
          final targetX = isOpen ? (rtl ? -maxSlide : maxSlide) : 0.0;
          final targetScale = isOpen ? widget.scalePercent : 1.0;

          return Stack(
            children: [
              // 1. Menu Layer (Background)
              // The menu spans the full screen so gradients and backgrounds look correct.
              Positioned.fill(
                child: widget.menu,
              ),

              // 2. Main Screen Layer (Foreground)
              // This is positioned above the menu. When the RTL direction changes while open,
              // the AnimatedContainer smoothly glides across the screen!
              AnimatedContainer(
                duration: widget.animationDuration,
                curve: Curves.easeInOutCubic,
                transform: Matrix4.identity()
                  ..translate(targetX, 0.0)
                  ..scale(targetScale, targetScale),
                transformAlignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: isOpen ? BorderRadius.circular(30) : BorderRadius.zero,
                  boxShadow: isOpen
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(rtl ? 10 : -10, 0),
                          )
                        ]
                      : [],
                ),
                clipBehavior: isOpen ? Clip.antiAlias : Clip.none,
                child: GestureDetector(
                  onTap: () {
                    // Tap main screen to close if open
                    if (isOpen) _controller.close();
                  },
                  child: AbsorbPointer(
                    absorbing: isOpen,
                    child: widget.mainScreen,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
