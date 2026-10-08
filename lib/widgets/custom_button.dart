import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum ButtonStyleType { filled, outlined }

/// A single reusable button used across the whole site
/// (Hero CTAs, section CTAs, footer CTA banner, etc.)
class CustomButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonStyleType type;
  final Color? color;
  final Color? textColor;
  final IconData? icon; // optional leading icon (e.g. phone icon)

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = ButtonStyleType.filled,
    this.color,
    this.textColor,
    this.icon,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final bool filled = widget.type == ButtonStyleType.filled;
    final Color baseColor = widget.color ?? AppColors.primaryRed;
    final Color contentColor =
        filled ? AppColors.white : (widget.textColor ?? AppColors.white);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: filled
                  ? (_hovering
                      ? baseColor.withValues(alpha: 0.88)
                      : baseColor)
                  : Colors.transparent,
              border: filled
                  ? null
                  : Border.all(
                      color: widget.textColor ?? AppColors.white, width: 1.5),
              borderRadius: BorderRadius.circular(4),
              boxShadow: filled && _hovering
                  ? [
                      BoxShadow(
                        color: baseColor.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      )
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 15, color: contentColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: AppTextStyles.button(color: contentColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
