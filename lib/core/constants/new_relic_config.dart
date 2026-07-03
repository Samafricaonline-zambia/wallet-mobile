import 'dart:io';

import 'package:flutter/material.dart';
import 'package:newrelic_mobile/config.dart';
import 'package:newrelic_mobile/newrelic_mobile.dart';

class NewRelicConfig {
  late final String appToken;

  NewRelicConfig() {
    if (Platform.isIOS) {
      appToken = 'AAe286b852302eb6b902e3e397417d8542bd60adea-NRMA';
    } else if (Platform.isAndroid) {
      appToken = 'AA32f3a02c7fa4f68c8c209bed2a1d7367f01143f4-NRMA';
    }
  }

  void init() {
    // Don't await - let it initialize in background
    NewrelicMobile.instance
        .start(getConfig(), () {
          // This callback runs after New Relic initializes
          // Don't put runApp here!
          debugPrint('New Relic initialized successfully');
        })
        .catchError((error) {
          debugPrint('New Relic initialization failed: $error');
        });
  }

  Config getConfig() {
    return Config(
      accessToken: appToken,

      // Android specific option
      // Optional: Enable or disable collection of event data.
      analyticsEventEnabled: true,

      // iOS specific option
      // Optional: Enable or disable automatic instrumentation of WebViews.
      webViewInstrumentation: true,

      // Optional: Enable or disable reporting successful HTTP requests to the MobileRequest event type.
      networkErrorRequestEnabled: true,

      // Optional: Enable or disable reporting network and HTTP request errors to the MobileRequestError event type.
      networkRequestEnabled: true,

      // Optional: Enable or disable crash reporting.
      crashReportingEnabled: true,

      // Optional: Enable or disable interaction tracing. Trace instrumentation still occurs, but no traces are harvested. This will disable default and custom interactions.
      interactionTracingEnabled: true,

      // Optional: Enable or disable capture of HTTP response bodies for HTTP error traces, and MobileRequestError events.
      httpResponseBodyCaptureEnabled: true,

      // Optional: Enable or disable agent logging.
      loggingEnabled: true,

      // Optional: Enable or disable print statements as Analytics Events.
      printStatementAsEventsEnabled: true,

      // Optional: Enable or disable automatic instrumentation of HTTP requests.
      httpInstrumentationEnabled: true,
    );
  }
}
