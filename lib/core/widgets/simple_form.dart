import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_buttons.dart';

class SimpleForm extends StatefulWidget {
  final List<Widget>? stickyChildren;
  final List<Widget>? children;
  final String actionTitle;
  final bool isFullWidth;
  final bool isFormToBeValidated;
  final VoidCallback? onSubmit;
  final MainAxisAlignment align;
  final CrossAxisAlignment hAlign;
  final bool isLoading;
  final Widget? actionSpace;

  const SimpleForm({
    super.key,
    this.children,
    this.stickyChildren,
    this.actionTitle = "Submit",
    this.isFullWidth = true,
    this.isFormToBeValidated = true,
    this.onSubmit,
    this.align = .center,
    this.hAlign = .center,
    this.isLoading = false,
    this.actionSpace,
  });

  @override
  State<SimpleForm> createState() => _SimpleFormState();
}

class _SimpleFormState extends State<SimpleForm> {
  final _formKey = GlobalKey<FormState>();

  void handleActionClick() {
    AppUtils().hideKeyboard(context);
    if (widget.isFormToBeValidated) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }

    if (widget.onSubmit != null) {
      widget.onSubmit!();
    }
  }

  Widget buildAction() {
    if (widget.onSubmit == null) {
      return EmptySpace(height: 1);
    }

    if (widget.isFullWidth) {
      return SimpleButtons.fullWidth(
        widget.actionTitle,
        onClick: handleActionClick,
        isLoading: widget.isLoading,
      );
    }

    return SimpleButtons(
      widget.actionTitle,
      onClick: handleActionClick,
      isLoading: widget.isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: widget.align,
        crossAxisAlignment: widget.hAlign,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...widget.stickyChildren ?? [],

          if (widget.isLoading) CircularProgressIndicator(),

          if (!widget.isLoading) ...widget.children ?? [],

          widget.actionSpace ?? EmptySpace.large(),
          buildAction(),
        ],
      ),
    );
  }
}
