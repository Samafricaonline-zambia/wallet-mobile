import 'dart:core';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sampay_wallet/core/layouts/web_layout.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_toast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExternalWebView extends StatefulWidget {
  final VoidCallback? onExit;
  const ExternalWebView({super.key, this.onExit});

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
  String? _exitOn;
  late String _exitTo;
  bool _hasExited = false;

  void handleError(dynamic error) {
    if (mounted && isLoading) {
      SimpleToast.showErrorToast("Error loading url", context);

      debugPrint(error.description ?? "");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Check if we should exit based on current URL
  bool _matchesExitUrl(String url) {
    final exitOn = _exitOn;
    if (exitOn == null || exitOn.isEmpty || _hasExited) return false;

    final current = Uri.tryParse(url);
    final target = Uri.tryParse(exitOn);
    if (current == null || target == null) return false;

    return current.scheme == target.scheme &&
        current.host == target.host &&
        current.path == target.path &&
        (target.query.isEmpty || current.query == target.query);
  }

  // Check if we should exit based on current URL
  void _checkExitCondition(String url) {
    if (_matchesExitUrl(url)) {
      debugPrint('Exit condition met! URL: $url contains: $_exitOn');

      setState(() {
        _hasExited = true;
      });
      // Show a success toast or message
      if (mounted && context.canPop() && _exitTo.isEmpty) {
        context.pop();
      } else if (_exitTo.isNotEmpty) {
        context.go(_exitTo);
      }

      widget.onExit?.call();
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

            // Check exit condition on page start
            _checkExitCondition(url);
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });

            // Check exit condition on page finish (in case of redirects)
            _checkExitCondition(url);
          },
          onUrlChange: (change) {
            // This is the most reliable way to monitor URL changes
            final url = change.url;
            if (url != null) {
              // Check exit condition on URL change
              _checkExitCondition(url);
            }
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
        _exitOn = extra?['exitOn'] as String?;
        _exitTo = AppUtils().valueOrDefault(extra?['exitTo']);

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
