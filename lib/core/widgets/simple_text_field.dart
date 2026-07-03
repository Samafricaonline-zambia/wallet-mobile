import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';

class SimpleTextField extends StatefulWidget {
  final String? labelText;
  final String? placeholder;
  final String? prefixText;
  final String? messageText;
  final IconData? icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final String? initialValue;
  final bool isPasswordField;
  final bool isDateField;
  final bool isDisabled;

  // Callback to expose current value to parent
  final void Function(String value)? onValueChanged;

  const SimpleTextField({
    super.key,
    this.labelText,
    this.prefixText,
    this.placeholder,
    this.icon,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.initialValue,
    this.onValueChanged,
    this.isPasswordField = false,
    this.isDateField = false,
    this.messageText = "",
    this.isDisabled = false,
  });

  @override
  State<SimpleTextField> createState() => _SimpleAppTextFormFieldState();
}

class _SimpleAppTextFormFieldState extends State<SimpleTextField> {
  late TextEditingController _controller;
  bool isPasswordHidden = true;
  late FocusNode _focusNode;
  bool _isFocused = false;

  Color getDisabledColor() =>
      widget.isDisabled ? Colors.grey.shade300 : Colors.grey.shade600;

  void selectDate() async {
    setState(() {
      _isFocused = false;
    });

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(
        widget.initialValue ?? DateTime.now().toIso8601String(),
      ),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      //final newValue = selectedDate.toLocal().toString().split(' ')[0];
      final newValue = AppUtils().formatDate(selectedDate.toIso8601String());
      _controller.setText(newValue);

      widget.onChanged?.call(newValue);
      widget.onValueChanged?.call(newValue);
      widget.onSubmitted?.call(newValue);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: AppUtils()
          .valueOrDefault(widget.initialValue)
          .replaceAll(widget.prefixText ?? "", ""),
    );
    _controller.addListener(() {
      widget.onValueChanged?.call(_controller.text);
    });

    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String get value => _controller.text;

  Widget? getIcon() {
    if (widget.isPasswordField) {
      return InkWell(
        onTap: () {
          setState(() {
            isPasswordHidden = !isPasswordHidden;
          });
        },
        child: isPasswordHidden
            ? Icon(
                AppIcons.view,
                color: _isFocused
                    ? AppConstants.AppTheme(context).primary
                    : getDisabledColor(),
              )
            : Icon(
                AppIcons.closedEye,
                color: _isFocused
                    ? AppConstants.AppTheme(context).primary
                    : getDisabledColor(),
              ),
      );
    }

    if (widget.isDateField) {
      return InkWell(
        onTap: () {
          selectDate();
        },
        child: Icon(
          AppIcons.calendar,
          color: _isFocused
              ? AppConstants.AppTheme(context).primary
              : getDisabledColor(),
        ),
      );
    }

    return widget.icon != null
        ? Icon(
            widget.icon,
            color: _isFocused
                ? AppConstants.AppTheme(context).primary
                : getDisabledColor(),
          )
        : null;
  }

  InputBorder _getBorder() {
    // Platform-aware border
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // iOS style: bottom border only with more spacing
      return UnderlineInputBorder(
        borderSide: BorderSide(
          color: _isFocused
              ? AppConstants.AppTheme(context).primary
              : widget.isDisabled
              ? Colors.grey.shade300
              : Colors.grey.shade400,
          width: _isFocused ? 2 : 1,
        ),
      );
    } else {
      // Android style: standard underline
      return const UnderlineInputBorder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          enabled: !widget.isDisabled,
          readOnly: widget.isDateField,
          controller: _controller,
          focusNode: _focusNode,
          obscureText: widget.isPasswordField && isPasswordHidden,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: _isFocused
                  ? AppConstants.AppTheme(context).primary
                  : getDisabledColor(),
            ),
            prefixText: widget.prefixText,
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
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: (value) {
            AppUtils().hideKeyboard(context);
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }

            if (widget.onSubmitted != null) {
              widget.onSubmitted!(value);
            }
          },
          onTap: () {
            if (widget.isDateField) {
              selectDate();
            }
          },
        ),
        if (widget.messageText!.isNotEmpty) ...[
          EmptySpace.small(),
          SimpleAppText.small(
            widget.messageText!,
            color: AppConstants.AppTheme(context).grey,
          ),
        ],
      ],
    );
  }
}
