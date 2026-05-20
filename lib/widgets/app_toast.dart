import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Top-right slide-in notification.
///
/// Replaces SnackBar on desktop/tablet (SnackBar slides up from the bottom
/// like a mobile toast, which feels wrong on a wide browser).
///
/// On narrow viewports (<700px) it falls back to a regular SnackBar so mobile
/// users get the platform-correct behavior.
///
/// Usage:
///   AppToast.show(context, 'VR #2803 created.');
///   AppToast.show(context, 'Failed to save.', kind: ToastKind.error);
class AppToast {
  static void show(
    BuildContext context,
    String message, {
    ToastKind kind = ToastKind.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final width = MediaQuery.of(context).size.width;

    // Mobile → use standard SnackBar (correct for narrow viewports).
    if (width < 700) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: kind._color,
          duration: duration,
        ),
      );
      return;
    }

    // Desktop / tablet → slide in from top-right.
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (ctx) => _ToastWidget(
        message: message,
        kind: kind,
        duration: duration,
      ),
    );
    overlay.insert(entry);
    Future.delayed(duration + const Duration(milliseconds: 400), entry.remove);
  }
}

enum ToastKind {
  info,
  success,
  error;

  Color get _color {
    switch (this) {
      case ToastKind.info:
        return AppTheme.primary;
      case ToastKind.success:
        return AppTheme.success;
      case ToastKind.error:
        return AppTheme.danger;
    }
  }

  IconData get _icon {
    switch (this) {
      case ToastKind.info:
        return Icons.info_outline;
      case ToastKind.success:
        return Icons.check_circle_outline;
      case ToastKind.error:
        return Icons.error_outline;
    }
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final ToastKind kind;
  final Duration duration;

  const _ToastWidget({
    required this.message,
    required this.kind,
    required this.duration,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  late final Animation<Offset> _slide =
      Tween<Offset>(begin: const Offset(1.2, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  late final Animation<double> _fade =
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();
    _ctrl.forward();
    // Reverse before removal to get a clean exit animation.
    Future.delayed(widget.duration, () {
      if (mounted) _ctrl.reverse();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 360),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.kind._icon, color: widget.kind._color, size: 20),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
