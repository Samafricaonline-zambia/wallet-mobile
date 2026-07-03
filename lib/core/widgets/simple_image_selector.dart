import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/decorations.dart';
import 'package:sampay_wallet/core/themes/app_theme.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_buttons.dart';
import 'package:sampay_wallet/core/widgets/simple_flex.dart';
import 'package:sampay_wallet/core/widgets/simple_form.dart';

class SimpleImageSelector extends StatefulWidget {
  final bool isShowPreview;
  final bool isEanbleCameraCapture;
  final bool isEanbleGallery;
  final Function(File file)? onSelect;
  final String actionTitle;

  const SimpleImageSelector({
    super.key,
    this.isShowPreview = true,
    this.isEanbleCameraCapture = true,
    this.isEanbleGallery = true,
    this.onSelect,
    this.actionTitle = "Select",
  });

  @override
  State<SimpleImageSelector> createState() => _SimpleImageSelectorState();
}

class _SimpleImageSelectorState extends State<SimpleImageSelector> {
  late final MobileScannerController controller;
  File selectedImage = File("");

  void setSelectedImage(File value) {
    setState(() {
      selectedImage = value;
    });
  }

  void handleOpenCamera() {
    final picker = ImagePicker();
    // Pick an image.
    picker.pickImage(source: ImageSource.camera).then((image) {
      setState(() {
        if (image != null) {
          setSelectedImage(File(image.path));
          widget.onSelect?.call(File(image.path));
        }
      });
    });
  }

  void handleOpenGallery() async {
    final picker = ImagePicker();
    // Pick an image.
    picker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        if (image != null) {
          setSelectedImage(File(image.path));
          widget.onSelect?.call(File(image.path));
        }
      });
    });
  }

  Widget? buildPreview() {
    if (widget.isShowPreview) {}

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.color(AppTheme.currentTheme.colorScheme.light),
      padding: EdgeInsets.all(AppConstants.STANDARD_PAGE_PADDING),
      child: SimpleForm(
        actionSpace: EmptySpace.none(),
        actionTitle: widget.actionTitle,
        children: [
          if (selectedImage.path.isNotEmpty && widget.isShowPreview) ...[
            Image.file(
              selectedImage,
              height: AppUtils().getScreenWidth(context),
            ),
            EmptySpace(),
          ],
          SimpleFlex(
            leftChild: widget.isEanbleCameraCapture
                ? SimpleButtons.small(
                    "Take photo",
                    onClick: handleOpenCamera,
                    backgroundColor: AppTheme.currentTheme.colorScheme.info,
                  )
                : null,
            rightChild: widget.isEanbleCameraCapture
                ? SimpleButtons.small(
                    "Choose from gallery",
                    onClick: handleOpenGallery,
                    backgroundColor: AppTheme.currentTheme.colorScheme.warning,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
