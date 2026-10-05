import 'package:flutter/material.dart';

/// Shared press wrapper that provides Material ink/ripple feedback.
/// When [onTap] is null, returns [child] unchanged.
class AppPressable extends StatelessWidget {
  final VoidCallback? onTap;
  final double borderRadius;
  final Widget child;
  final bool enabled;

  const AppPressable({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 0,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap == null || !enabled) {
      return child;
    }

    final radius = BorderRadius.circular(borderRadius);

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
