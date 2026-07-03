import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sampay_wallet/core/constants/constants.dart';

class SimpleAppText extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final Color? color;
  final double? fontSize;
  final TextAlign? align;
  final FontWeight? fontWeight;
  final bool shouldWrap;
  final bool isLink;

  const SimpleAppText(
    this.title, {
    super.key,
    this.fontSize = 16,
    this.backgroundColor,
    this.align = TextAlign.start,
    this.fontWeight,
    this.color,
    this.shouldWrap = true,
    this.isLink = false,
  });

  factory SimpleAppText.title(
    String title, {
    Key? key,
    Color? backgroundColor,
    TextAlign? align,
    FontWeight? fontWeight,
    Color? color,
    bool shouldWrap = true,
    bool isLink = false,
  }) {
    return SimpleAppText(
      title,
      key: key,
      fontSize: 18,
      backgroundColor: backgroundColor,
      align: align,
      fontWeight: fontWeight,
      color: color,
      shouldWrap: shouldWrap,
      isLink: isLink,
    );
  }

  factory SimpleAppText.large(
    String title, {
    Key? key,
    Color? backgroundColor,
    TextAlign? align,
    FontWeight? fontWeight,
    Color? color,
    bool shouldWrap = true,
    bool isLink = false,
  }) {
    return SimpleAppText(
      title,
      key: key,
      fontSize: 24,
      backgroundColor: backgroundColor,
      align: align,
      fontWeight: fontWeight,
      color: color,
      shouldWrap: shouldWrap,
      isLink: isLink,
    );
  }

  factory SimpleAppText.medium(
    String title, {
    Key? key,
    Color? backgroundColor,
    TextAlign? align,
    FontWeight? fontWeight,
    Color? color,
    bool shouldWrap = true,
    bool isLink = false,
  }) {
    return SimpleAppText(
      title,
      key: key,
      fontSize: 18,
      backgroundColor: backgroundColor,
      align: align,
      fontWeight: fontWeight,
      color: color,
      shouldWrap: shouldWrap,
      isLink: isLink,
    );
  }

  factory SimpleAppText.small(
    String title, {
    Key? key,
    Color? backgroundColor,
    TextAlign? align,
    FontWeight? fontWeight,
    Color? color,
    bool shouldWrap = true,
    bool isLink = false,
  }) {
    return SimpleAppText(
      title,
      key: key,
      fontSize: 14,
      backgroundColor: backgroundColor,
      align: align,
      fontWeight: fontWeight,
      color: color,
      shouldWrap: shouldWrap,
      isLink: isLink,
    );
  }

  factory SimpleAppText.normal(
    String title, {
    Key? key,
    Color? backgroundColor,
    TextAlign? align,
    FontWeight? fontWeight,
    Color? color,
    bool shouldWrap = true,
    bool isLink = false,
  }) {
    return SimpleAppText(
      title,
      key: key,
      fontSize: 16,
      backgroundColor: backgroundColor,
      align: align,
      fontWeight: fontWeight,
      color: color,
      shouldWrap: shouldWrap,
      isLink: isLink,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.comfortaa(
        fontSize: fontSize ?? 18,
        backgroundColor: backgroundColor,
        fontWeight: fontWeight,
        color: color,
        textStyle: isLink
            ? TextStyle(
                decoration: TextDecoration.combine([TextDecoration.underline]),
                decorationColor: color,
              )
            : null,
      ),
      textAlign: align,
      softWrap: shouldWrap, // Controls whether text should wrap
      overflow: shouldWrap ? TextOverflow.visible : TextOverflow.ellipsis,
      maxLines: shouldWrap ? null : 1, // If not wrapping, limit to 1 line
    );
  }
}
