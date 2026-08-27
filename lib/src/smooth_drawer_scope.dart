import 'package:flutter/widgets.dart';

/// The drawer's direction and animation settings, published to everything
/// inside it.
///
/// The main screen glides when the layout direction changes, but a menu built
/// with `AlignmentDirectional` resolves the instant `Directionality` flips —
/// so the menu snaps to the other side while the screen above it is still
/// travelling. Reading this scope lets the menu animate with exactly the same
/// duration and curve, so both halves move as one.
class SmoothDrawerScope extends InheritedWidget {
  const SmoothDrawerScope({
    super.key,
    required this.isRtl,
    required this.isOpen,
    required this.animationDuration,
    required this.curve,
    required super.child,
  });

  /// Whether the drawer resolved the layout as right-to-left.
  final bool isRtl;

  /// Whether the drawer is currently open.
  final bool isOpen;

  /// The duration the drawer animates with.
  final Duration animationDuration;

  /// The curve the drawer animates with.
  final Curve curve;

  /// The side the drawer uncovers, as an absolute alignment.
  ///
  /// Absolute rather than [AlignmentDirectional] on purpose: a directional
  /// alignment cannot be animated across a direction change, because it has
  /// already resolved to the new side by the time the first frame is built.
  Alignment get menuAlignment =>
      isRtl ? Alignment.centerRight : Alignment.centerLeft;

  /// The nearest scope, or null when there is no [SmoothHiddenDrawer] above.
  static SmoothDrawerScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SmoothDrawerScope>();

  /// The nearest scope. Asserts when there is no [SmoothHiddenDrawer] above.
  static SmoothDrawerScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'No SmoothHiddenDrawer found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(SmoothDrawerScope oldWidget) =>
      oldWidget.isRtl != isRtl ||
      oldWidget.isOpen != isOpen ||
      oldWidget.animationDuration != animationDuration ||
      oldWidget.curve != curve;
}

/// A fixed-width menu panel that stays on the side the drawer uncovers, and
/// glides across when the direction changes.
///
/// Use it inside [SmoothHiddenDrawer.menu] when the menu content should be a
/// panel rather than fill the screen:
///
/// ```dart
/// SmoothHiddenDrawer(
///   menu: ColoredBox(
///     color: Colors.blueGrey.shade900,
///     child: SmoothDrawerMenuPanel(
///       width: 300,
///       child: MyMenuItems(),
///     ),
///   ),
///   mainScreen: MyScaffold(),
/// )
/// ```
///
/// Keep the background full-bleed (as above) so the area the panel does not
/// cover is still painted.
class SmoothDrawerMenuPanel extends StatelessWidget {
  const SmoothDrawerMenuPanel({
    super.key,
    required this.width,
    required this.child,
  });

  /// How wide the panel is. Keep it inside the uncovered area, which is
  /// roughly `slidePercent + (1 - scalePercent) / 2` of the screen width.
  final double width;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scope = SmoothDrawerScope.of(context);

    return AnimatedAlign(
      alignment: scope.menuAlignment,
      duration: scope.animationDuration,
      curve: scope.curve,
      child: SizedBox(width: width, child: child),
    );
  }
}
