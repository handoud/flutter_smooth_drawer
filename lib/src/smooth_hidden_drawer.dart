import 'package:flutter/material.dart';

import 'smooth_drawer_scope.dart';
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

  /// Duration for the open/close and RTL/LTR animations. Default is 600ms.
  final Duration animationDuration;

  /// Curve for the open/close and RTL/LTR animations. Default is [Curves.easeInOutCubic].
  final Curve curve;

  /// Corner radius applied to the main screen while the drawer is open.
  final double openCornerRadius;

  /// If null, it automatically reads the Directionality of the context. If true, treats the app as RTL manually.
  final bool? isRtl;

  /// An externally owned controller, when the drawer must be opened from
  /// outside its own subtree. One is created internally when this is null.
  final SmoothHiddenDrawerController? controller;

  const SmoothHiddenDrawer({
    super.key,
    required this.menu,
    required this.mainScreen,
    this.slidePercent = 0.7,
    this.scalePercent = 0.8,
    this.animationDuration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOutCubic,
    this.openCornerRadius = 30,
    this.isRtl,
    this.controller,
  });

  @override
  SmoothHiddenDrawerState createState() => SmoothHiddenDrawerState();
}

class SmoothHiddenDrawerState extends State<SmoothHiddenDrawer>
    with SingleTickerProviderStateMixin {
  late SmoothHiddenDrawerController _controller;

  /// True when this state created the controller and therefore owns it.
  late bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? SmoothHiddenDrawerController();
  }

  @override
  void didUpdateWidget(SmoothHiddenDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (_ownsController) _controller.dispose();
      _ownsController = widget.controller == null;
      _controller = widget.controller ?? SmoothHiddenDrawerController();
    }
  }

  @override
  void dispose() {
    // Only dispose a controller this state created: one passed in belongs to
    // the caller, and disposing it here would break a later open().
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine RTL dynamically based on either the manual override or the inherited Directionality
    final bool rtl =
        widget.isRtl ?? Directionality.of(context) == TextDirection.rtl;

    return SmoothHiddenDrawerProvider(
      controller: _controller,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final isOpen = _controller.isOpen;

          // Slide amount calculation. sizeOf rather than of(context).size, so
          // this only rebuilds when the size itself changes.
          final screenWidth = MediaQuery.sizeOf(context).width;
          final maxSlide = screenWidth * widget.slidePercent;

          // RTL changes the direction of the slide.
          // If LTR, slide Right (positive X).
          // If RTL, slide Left (negative X).
          final targetX = isOpen ? (rtl ? -maxSlide : maxSlide) : 0.0;
          final targetScale = isOpen ? widget.scalePercent : 1.0;

          return SmoothDrawerScope(
            isRtl: rtl,
            isOpen: isOpen,
            animationDuration: widget.animationDuration,
            curve: widget.curve,
            child: Stack(
              children: [
                // 1. Menu Layer (Background)
                // The menu spans the full screen so gradients and backgrounds look correct.
                // Wrap its content in a SmoothDrawerMenuPanel to have it glide
                // across on a direction change instead of snapping.
                Positioned.fill(
                  // Hidden behind the main screen when closed: keep it out of
                  // the semantics tree so a screen reader does not announce a
                  // menu the user cannot see.
                  child: ExcludeSemantics(
                    excluding: !isOpen,
                    child: widget.menu,
                  ),
                ),

                // 2. Main Screen Layer (Foreground)
                // This is positioned above the menu. When the RTL direction changes while open,
                // the AnimatedContainer smoothly glides across the screen!
                AnimatedContainer(
                  duration: widget.animationDuration,
                  curve: widget.curve,
                  transform: Matrix4.identity()
                    ..translate(targetX, 0.0)
                    ..scale(targetScale, targetScale),
                  transformAlignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: isOpen
                        ? BorderRadius.circular(widget.openCornerRadius)
                        : BorderRadius.zero,
                    boxShadow: isOpen
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: Offset(rtl ? 10 : -10, 0),
                            )
                          ]
                        : const [],
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
            ),
          );
        },
      ),
    );
  }
}
