import 'package:flutter/material.dart';

class ExpandableContent extends StatefulWidget {
  final Widget child;
  final double collapsedHeight;
  final double? expandedHeight;
  final String expandText;
  final String collapseText;
  final TextStyle? buttonTextStyle;
  final Duration animationDuration;
  final Color? backgroundColor;

  const ExpandableContent({
    Key? key,
    required this.child,
    required this.collapsedHeight,
    this.expandedHeight,
    this.expandText = 'Read more',
    this.collapseText = 'Show less',
    this.buttonTextStyle,
    this.animationDuration = const Duration(milliseconds: 300),
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<ExpandableContent> createState() => _ExpandableContentState();
}

class _ExpandableContentState extends State<ExpandableContent>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _heightFactor = _animationController.drive(CurveTween(curve: Curves.easeInOut));
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
    final theme = Theme.of(context);
    final buttonStyle = widget.buttonTextStyle ??
        TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w500,
        );

    return Container(
      color: widget.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: _isExpanded
                      ? (widget.expandedHeight ?? double.infinity)
                      : widget.collapsedHeight,
                ),
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: _isExpanded ? 1.0 : null,
                    child: widget.child,
                  ),
                ),
              );
            },
          ),
          // Show fade gradient only when collapsed
          if (!_isExpanded)
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    (widget.backgroundColor ?? theme.scaffoldBackgroundColor).withOpacity(0.0),
                    (widget.backgroundColor ?? theme.scaffoldBackgroundColor),
                  ],
                ),
              ),
            ),
          InkWell(
            onTap: _toggleExpand,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isExpanded ? widget.collapseText : widget.expandText,
                  style: buttonStyle,
                ),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: buttonStyle.color,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}