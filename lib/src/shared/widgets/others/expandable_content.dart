import 'package:flutter/material.dart';

class ExpandableWidget extends StatefulWidget {
  final String title;
  final Widget child;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final Color? arrowColor;
  final EdgeInsets? padding;
  final Duration animationDuration;
  final bool withShadow;
  final bool defaultOpen;

  const ExpandableWidget({
    Key? key,
    required this.title,
    required this.child,
    this.titleStyle,
    this.backgroundColor = Colors.white,
    this.arrowColor,
    this.padding,
    this.animationDuration = const Duration(milliseconds: 300),
    this.withShadow = false,
    this.defaultOpen = true
  }) : super(key: key);

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.defaultOpen;

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: widget.withShadow ? BorderRadius.circular(8.0) : null,
        boxShadow: widget.withShadow ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          InkWell(
            onTap: _toggleExpand,
            borderRadius: BorderRadius.circular(8.0),
            child: Padding(
              padding: widget.padding ??
                  const EdgeInsets.all(0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: widget.titleStyle ??
                          Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  RotationTransition(
                    turns: _rotationAnimation,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: widget.arrowColor ?? Theme.of(context).iconTheme.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          AnimatedSize(
            duration: widget.animationDuration,
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: ClipRect(
              child: _isExpanded
                  ? Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: widget.child,
              )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}