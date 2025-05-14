import 'package:flutter/material.dart';

class DropdownItem {
  final String id;
  final String name;

  DropdownItem({required this.id, required this.name});
}

class CustomDropdown extends StatefulWidget {
  final List<DropdownItem> items;
  final int? limit;
  final String dropdownLabel;
  final Function(DropdownItem) onSelected;
  final bool showAllAsDefault;
  final String? defaultId;

  const CustomDropdown({
    Key? key,
    required this.items,
    this.limit,
    this.dropdownLabel = 'Item lainnya',
    required this.onSelected,
    this.showAllAsDefault = true,
    this.defaultId,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown>
    with SingleTickerProviderStateMixin {
  String? selectedItemId;
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    // Set initial selection based on parameters
    if (widget.defaultId != null) {
      selectedItemId = widget.defaultId;
    } else if (widget.showAllAsDefault && widget.items.isNotEmpty) {
      selectedItemId = widget.items[0].id;
    } else if (widget.items.isNotEmpty) {
      selectedItemId = widget.items[0].id;
    }

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = widget.limit == null
        ? widget.items
        : widget.items.take(widget.limit!).toList();

    final expandableItems = (widget.limit != null && widget.items.length > widget.limit!)
        ? widget.items.sublist(widget.limit!)
        : <DropdownItem>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown container
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Primary items (always visible)
                ...visibleItems.map((item) => _buildDropdownItem(item)),

                // Dropdown toggle if there are more items
                if (expandableItems.isNotEmpty)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _toggleExpanded,
                      child: Ink(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.dropdownLabel,
                              style: const TextStyle(fontSize: 16),
                            ),
                            RotationTransition(
                              turns: _rotateAnimation,
                              child: const Icon(Icons.keyboard_arrow_down),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Expandable section with animation
                if (expandableItems.isNotEmpty)
                  SizeTransition(
                    sizeFactor: _expandAnimation,
                    axisAlignment: -1.0,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: Column(
                        children: expandableItems.map((item) => _buildDropdownItem(item)).toList(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownItem(DropdownItem item) {
    final isSelected = item.id == selectedItemId;

    return Material(
      color: isSelected ? Colors.blue : Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedItemId = item.id;
          });
          widget.onSelected(item);
        },
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          decoration: BoxDecoration(
            border: Border(
              top: item == widget.items.first
                  ? BorderSide.none
                  : BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Text(
            item.name,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}