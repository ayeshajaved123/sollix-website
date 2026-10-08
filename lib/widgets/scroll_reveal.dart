import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Wrap ANY section/widget with this to get a professional
/// "fade + slide up" reveal animation the first time it scrolls
/// into view. Used across the whole site for a consistent feel.
///
/// Usage:
///   ScrollReveal(child: ServicesSection(...))
///
/// Optional `delay` lets you stagger multiple items inside the
/// same section (e.g. service cards appearing one after another).
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double slideOffset;

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.slideOffset = 40,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _played = false;

  // Unique key required by VisibilityDetector — identity-based so it
  // never clashes with other ScrollReveal instances on the page.
  late final Key _visibilityKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: Offset(0, widget.slideOffset / 100),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    // Trigger once the widget is ~15% visible, and only ever once —
    // re-triggering on every scroll up/down would feel gimmicky rather
    // than professional.
    if (!_played && info.visibleFraction > 0.15) {
      _played = true;
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: _onVisibilityChanged,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: widget.child,
        ),
      ),
    );
  }
}
