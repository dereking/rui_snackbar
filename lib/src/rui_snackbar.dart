import 'dart:async';
import 'package:flutter/material.dart';

import 'animated_snackbar.dart';

class RuiSnackbar {
  static final RuiSnackbar _instance = RuiSnackbar._internal();
  factory RuiSnackbar() => _instance;
  RuiSnackbar._internal();

  late OverlayState _overlayState;
  OverlayEntry? _overlayEntry;
  bool _initialized = false;


  Timer? _dismissTimer;

  String? _currentMessage;
  int _repeatCount = 1;

  final Duration defaultDuration = Duration(seconds: 3);
  final Duration animationDuration = Duration(milliseconds: 300);

  void init(BuildContext context) {
    _overlayState = Overlay.of(context, rootOverlay: true);
    _initialized = true;
  }

  void show({
    required String message,
    IconData? icon,
    VoidCallback? action,
    String? actionLabel,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    Duration? duration,
    bool top = false,
  }) {

    if (_initialized == false) {
      throw Exception('RuiSnackbar not initialized. Call  RuiSnackbar().init(context);  first.');
    }


    final isSameMessage = message == _currentMessage;

    if (isSameMessage && _overlayEntry != null) {
      _repeatCount++;
      _refreshCount(); // animate count
      _resetTimer(duration ?? defaultDuration);
    } else {
      _currentMessage = message;
      _repeatCount = 1;
      _overlayEntry?.remove();
      _overlayEntry = _buildOverlayEntry(
        message: message,
        icon: icon,
        action: action,
        actionLabel: actionLabel,
        backgroundColor: backgroundColor,
        textColor: textColor,
        top: top,
      );
      _overlayState.insert(_overlayEntry!);
      _resetTimer(duration ?? defaultDuration);
    }
  }

  void _resetTimer(Duration duration) {
    _dismissTimer?.cancel();
    _dismissTimer = Timer(duration, () {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _currentMessage = null;
      _repeatCount = 1;
    });
  }

  void _refreshCount() {
    // 强制刷新 overlay
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _buildOverlayEntry({
    required String message,
    IconData? icon,
    VoidCallback? action,
    String? actionLabel,
    required Color backgroundColor,
    required Color textColor,
    required bool top,
  }) {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: top ? 50.0 : null,
          bottom: top ? null : 50.0,
          left: 20,
          right: 20,
          child: AnimatedSnackbar(
            message: message,
            repeatCount: _repeatCount,
            icon: icon,
            action: action,
            actionLabel: actionLabel,
            backgroundColor: backgroundColor,
            textColor: textColor,
            onDismiss: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
              _currentMessage = null;
              _repeatCount = 1;
            },
          ),
        );
      },
    );
  }

  // 快捷方法
  void showSuccess(String message) => show(
        message: message,
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
      );

  void showError(String message) => show(
        message: message,
        backgroundColor: Colors.red,
        icon: Icons.error,
      );

  void showWarning(String message) => show(
        message: message,
        backgroundColor: Colors.orange,
        icon: Icons.warning,
      );
}
