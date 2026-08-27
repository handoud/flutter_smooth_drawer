import 'package:flutter/widgets.dart';

class SmoothHiddenDrawerController extends ChangeNotifier {
  bool _isOpen = false;

  bool get isOpen => _isOpen;

  void open() {
    if (!_isOpen) {
      _isOpen = true;
      notifyListeners();
    }
  }

  void close() {
    if (_isOpen) {
      _isOpen = false;
      notifyListeners();
    }
  }

  void toggle() {
    _isOpen = !_isOpen;
    notifyListeners();
  }

  /// Finds the nearest [SmoothHiddenDrawerController] up the widget tree.
  static SmoothHiddenDrawerController of(BuildContext context) {
    final SmoothHiddenDrawerProvider? provider =
        context.dependOnInheritedWidgetOfExactType<SmoothHiddenDrawerProvider>();
    assert(provider != null, 'No SmoothHiddenDrawerController found in context');
    return provider!.controller;
  }
}

class SmoothHiddenDrawerProvider extends InheritedNotifier<SmoothHiddenDrawerController> {
  const SmoothHiddenDrawerProvider({
    Key? key,
    required SmoothHiddenDrawerController controller,
    required Widget child,
  }) : super(key: key, notifier: controller, child: child);

  SmoothHiddenDrawerController get controller => notifier!;
}
