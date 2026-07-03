import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/constants.dart';
import 'package:sampay_wallet/core/constants/shadows.dart';
import 'package:sampay_wallet/core/themes/color_constants.dart';
import 'package:sampay_wallet/core/widgets/simple_app_text.dart';

class SimpleModalProgress extends StatelessWidget {
  final Widget child;
  final double blurIntensity;
  final String loadingMessage;
  final bool isLoading;

  const SimpleModalProgress(
    this.child, {
    super.key,
    this.blurIntensity = 2,
    this.loadingMessage = "",
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppConstants.AppTheme(
                  context,
                ).darkTransparent.withAlpha(20),
              ),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(
                    sigmaX: blurIntensity,
                    sigmaY: blurIntensity,
                  ),
                  child: Container(
                    color: Colors.white.withAlpha(10),

                    child: Center(
                      child: Container(
                        height: loadingMessage.isNotEmpty ? 200 : 150,
                        width: loadingMessage.isNotEmpty ? 200 : 150,
                        padding: EdgeInsets.all(50),
                        decoration: BoxDecoration(
                          color: AppConstants.AppTheme(context).light,
                          border: Border.all(
                            width: 1,
                            color: AppConstants.AppTheme(context).light,
                          ),
                          boxShadow: AppShadows.deep,
                          borderRadius: BorderRadius.circular(
                            AppConstants.STANDARD_BORDER_RADIUS,
                          ),
                        ),
                        child: loadingMessage.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircularProgressIndicator(),
                                  SimpleAppText(loadingMessage),
                                ],
                              )
                            : CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
