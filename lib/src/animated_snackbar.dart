import 'package:flutter/material.dart';

class AnimatedSnackbar extends StatefulWidget {
  final String message;
  final int repeatCount;
  final IconData? icon;
  final VoidCallback? action;
  final String? actionLabel;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onDismiss;

  const AnimatedSnackbar({super.key, 
    required this.message,
    required this.repeatCount,
    this.icon,
    this.action,
    this.actionLabel,
    required this.backgroundColor,
    required this.textColor,
    required this.onDismiss,
  });

  @override
  State<AnimatedSnackbar> createState() => _AnimatedSnackbarState();
}

class _AnimatedSnackbarState extends State<AnimatedSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _countController;
  late Animation<double> _countScale;

  @override
  void initState() {
    super.initState();
    _countController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _countScale = Tween(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOut)).animate(_countController);
  }

  @override
  void didUpdateWidget(covariant AnimatedSnackbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repeatCount != widget.repeatCount) {
      _countController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(12),
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null)
              Icon(widget.icon, color: widget.textColor),
            SizedBox(width: 8),
            Expanded(
              child: Text(widget.message,
                  style: TextStyle(color: widget.textColor)),
            ),
            if (widget.repeatCount > 1)
              ScaleTransition(
                scale: _countScale,
                child: Container(
                  margin: EdgeInsets.only(left: 6),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${widget.repeatCount}',
                    style: TextStyle(
                      color: widget.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (widget.action != null && widget.actionLabel != null)
              TextButton(
                onPressed: widget.action,
                child: Text(widget.actionLabel!,
                    style: TextStyle(color: widget.textColor)),
              ),
          ],
        ),
      ),
    );
  }
}
