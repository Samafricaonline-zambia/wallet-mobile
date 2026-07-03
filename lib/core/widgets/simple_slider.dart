// lib/core/widgets/custom_slider.dart
import 'package:flutter/material.dart';

enum SlideDirection { leftToRight, rightToLeft, topToBottom, bottomToTop }

class SimpleSlider extends StatefulWidget {
  final List<Widget> children;
  final int activeIndex;
  final Duration transitionDuration;
  final Curve transitionCurve;
  final SlideDirection slideDirection;
  final bool showTransition;
  final VoidCallback? onTransitionComplete;
  final double height;

  const SimpleSlider({
    super.key,
    required this.children,
    required this.activeIndex,
    required this.height,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.transitionCurve = Curves.easeInOut,
    this.slideDirection = SlideDirection.rightToLeft,
    this.showTransition = true,
    this.onTransitionComplete,
  });

  @override
  State<SimpleSlider> createState() => _SimpleSliderState();
}

class _SimpleSliderState extends State<SimpleSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  int _previousIndex = 0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.activeIndex;
    _previousIndex = _currentIndex;

    _controller = AnimationController(
      duration: widget.transitionDuration,
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onTransitionComplete?.call();
      }
    });

    _updateAnimations();
  }

  @override
  void didUpdateWidget(SimpleSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeIndex != widget.activeIndex) {
      _previousIndex = _currentIndex;
      _currentIndex = widget.activeIndex;
      _updateAnimations();
      _controller.forward(from: 0.0);
    }
  }

  void _updateAnimations() {
    final isGoingForward = _currentIndex > _previousIndex;

    Offset beginOffset;
    switch (widget.slideDirection) {
      case SlideDirection.leftToRight:
        beginOffset = isGoingForward
            ? const Offset(-1.0, 0.0)
            : const Offset(1.0, 0.0);
        break;
      case SlideDirection.rightToLeft:
        beginOffset = isGoingForward
            ? const Offset(1.0, 0.0)
            : const Offset(-1.0, 0.0);
        break;
      case SlideDirection.topToBottom:
        beginOffset = isGoingForward
            ? const Offset(0.0, -1.0)
            : const Offset(0.0, 1.0);
        break;
      case SlideDirection.bottomToTop:
        beginOffset = isGoingForward
            ? const Offset(0.0, 1.0)
            : const Offset(0.0, -1.0);
        break;
    }

    _slideAnimation = Tween<Offset>(begin: beginOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _controller, curve: widget.transitionCurve),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.transitionCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showTransition) {
      return IntrinsicWidth(
        child: SizedBox(
          height: widget.height,
          child: widget.children[widget.activeIndex],
        ),
      );
    }

    return IntrinsicWidth(
      child: AnimatedContainer(
        duration: widget.transitionDuration,
        curve: widget.transitionCurve,
        height: widget.height,
        child: ClipRect(
          child: Stack(
            fit: StackFit.loose,
            alignment: .center,
            clipBehavior: Clip.hardEdge,
            children: [
              if (_previousIndex != _currentIndex && _controller.isAnimating)
                Positioned.fill(
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 1.0,
                      end: 0.0,
                    ).animate(_controller),
                    child: widget.children[_previousIndex],
                  ),
                ),
              if (!_controller.isAnimating)
                widget.children[_currentIndex]
              else
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: widget.children[_currentIndex],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
