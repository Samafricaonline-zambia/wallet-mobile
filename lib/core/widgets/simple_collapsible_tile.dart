import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';

class SimpleCollapsibleTile extends StatefulWidget {
  final IconData? icon;
  final String title;
  final String description;
  final Widget? child;
  final bool initiallyExpanded;
  final Color? backgroundColor;
  final Color? expandedColor;
  final EdgeInsets padding;

  const SimpleCollapsibleTile({
    super.key,
    required this.title,
    this.icon,
    this.description = "",
    this.child,
    this.initiallyExpanded = false,
    this.backgroundColor,
    this.expandedColor,
    this.padding = const EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING),
  });

  @override
  State<SimpleCollapsibleTile> createState() => _SimpleCollapsibleTileState();
}

class _SimpleCollapsibleTileState extends State<SimpleCollapsibleTile> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        // color: _isExpanded
        //     ? (widget.expandedColor ??
        //           colorScheme.primaryContainer.withOpacity(0.3))
        //     : (widget.backgroundColor ?? colorScheme.surface),
        borderRadius: BorderRadius.circular(
          AppConstants.STANDARD_BORDER_RADIUS,
        ),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          // Header / Tile
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleExpanded,
              borderRadius: BorderRadius.circular(
                AppConstants.STANDARD_BORDER_RADIUS,
              ),
              child: Padding(
                padding: widget.padding,
                child: Row(
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: colorScheme.primary, size: 24),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SimpleAppText.title(
                            widget.title,
                            fontWeight: FontWeight.w700,
                            // style: TextStyle(
                            //   fontSize: 16,
                            //   fontWeight: FontWeight.w500,
                            //   color: colorScheme.onSurface,
                            // ),
                          ),
                          if (widget.description.isNotEmpty &&
                              _isExpanded == false)
                            SimpleAppText(
                              widget.description,
                              shouldWrap: false,

                              // style: TextStyle(
                              //   fontSize: 13,
                              //   color: colorScheme.onSurfaceVariant,
                              // ),
                              // maxLines: _isExpanded ? null : 1,
                              // overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: _isExpanded ? 0.5 : 0.0,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Expandable content
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: widget.child ?? SimpleAppText(widget.description),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
