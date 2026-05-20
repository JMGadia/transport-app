import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Shows [child] as a centered modal on desktop/tablet, or as a full-screen
/// page on mobile.
///
/// Use this in place of `Navigator.push(...)` for screens that are forms,
/// detail views, or anything that should feel like an overlay on desktop
/// rather than a hard page switch.
///
///   await AppRoute.show(
///     context,
///     title: 'New Vehicle Request',
///     child: const CreateVRScreen(),
///   );
class AppRoute {
  /// Default max width when shown as a modal on desktop. Tune per call if needed.
  static const double defaultMaxWidth = 720;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget child,
    double maxWidth = defaultMaxWidth,
    double maxHeightFraction = 0.9,
  }) {
    final width = MediaQuery.of(context).size.width;

    // Mobile → push a full page (standard mobile UX).
    if (width < 700) {
      return Navigator.of(context).push<T>(
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text(title)),
            body: child,
          ),
        ),
      );
    }

    // Desktop/tablet → centered modal dialog with a header bar.
    return showDialog<T>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (ctx) {
        final maxH = MediaQuery.of(ctx).size.height * maxHeightFraction;
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxH),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 14, 8, 14),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppTheme.border)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: AppTheme.textSecondary),
                        tooltip: 'Close',
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),
                // Body
                Flexible(child: child),
              ],
            ),
          ),
        );
      },
    );
  }
}
