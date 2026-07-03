import 'dart:core';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/layouts/web_layout.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExternalWebView extends StatefulWidget {
  const ExternalWebView({super.key});

  @override
  State<ExternalWebView> createState() => _ExternalWebViewState();
}

class _ExternalWebViewState extends State<ExternalWebView> {
  late WebViewController controller;
  bool isInitialized = false;
  bool isLoading = false;
  Map<String, dynamic>? _extra;
  String? _url;
  String? _title;

  void handleError(dynamic error) {
    if (mounted && isLoading) {
      SimpleToast.showErrorToast("Error loading url", context);

      debugPrint(error.description ?? "");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },

          onHttpError: handleError,
          onSslAuthError: handleError,
          onWebResourceError: handleError,
        ),
      );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInitialized) {
      // Access GoRouter here instead
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;

      setState(() {
        _extra = extra;
        _url = extra?['url'] as String?;
        _title = extra?['title'] as String?;

        isInitialized = true;
        controller.loadRequest(Uri.parse(_url ?? ""));
      });
    }
  }

  void handleBackClick() async {
    if (await controller.canGoBack()) {
      controller.goBack();
    } else {
      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebLayout(
      isLoading: isLoading,
      title: _title,
      onBackClick: handleBackClick,
      child: WebViewWidget(controller: controller),
    );
  }
}
