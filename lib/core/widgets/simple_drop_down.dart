import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';

class SimpleDropDown extends StatefulWidget {
  final String? labelText;
  final String? placeholder;
  final String? messageText;
  final IconData? icon;
  final List<String> items;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSubmitted;
  final void Function(String? value)? onValueChanged;
  final void Function(int index)? onIndexChanged;

  const SimpleDropDown({
    super.key,
    required this.items,
    this.labelText,
    this.placeholder,
    this.messageText,
    this.icon,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onValueChanged,
    this.onIndexChanged,
  });

  @override
  State<SimpleDropDown> createState() => _SimpleDropDownState();
}

class _SimpleDropDownState extends State<SimpleDropDown> {
  late String? _selectedValue;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;

    // Validate that the value exists in items
    if (_selectedValue != null && !widget.items.contains(_selectedValue)) {
      _selectedValue = null;
    }

    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void didUpdateWidget(SimpleDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _selectedValue = widget.initialValue;
      if (_selectedValue != null && !widget.items.contains(_selectedValue)) {
        _selectedValue = null;
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  String? get value => _selectedValue;

  Widget? getIcon() {
    if (widget.icon != null) {
      return Icon(
        widget.icon,
        color: _isFocused
            ? AppConstants.AppTheme(context).primary
            : Colors.grey,
      );
    }
    return null;
  }

  InputBorder _getBorder() {
    // Platform-aware border
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // iOS style: bottom border only with more spacing
      return UnderlineInputBorder(
        borderSide: BorderSide(
          color: _isFocused
              ? AppConstants.AppTheme(context).primary
              : Colors.grey.shade400,
          width: _isFocused ? 2 : 1,
        ),
      );
    } else {
      // Android style: standard underline
      return const UnderlineInputBorder();
    }
  }

  void handleOnChange(String? value) {
    widget.onValueChanged?.call(value);
    widget.onChanged?.call(value);
    final itemIndex = widget.items.indexOf(value ?? "");
    widget.onIndexChanged?.call(itemIndex);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme appTheme = AppConstants.AppTheme(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _selectedValue,
          focusNode: _focusNode,
          hint: widget.placeholder != null
              ? SimpleAppText(widget.placeholder!, color: Colors.grey.shade600)
              : null,
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: _isFocused
                  ? AppConstants.AppTheme(context).primary
                  : Colors.grey.shade600,
            ),
            suffixIcon: getIcon(),
            border: _getBorder(),
            enabledBorder: _getBorder(),
            focusedBorder: _getBorder(),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
          ),
          items: widget.items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: SimpleAppText(item),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
            handleOnChange(value);
          },
          onSaved: (value) {
            setState(() {
              _selectedValue = value;
            });
            handleOnChange(value);
          },
          validator: widget.validator,
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: _isFocused
                ? AppConstants.AppTheme(context).primary
                : Colors.grey,
          ),
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        if (widget.messageText != null && widget.messageText!.isNotEmpty)
          SimpleAppText.small(widget.messageText!, color: appTheme.grey),
      ],
    );
  }
}
