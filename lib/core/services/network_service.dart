import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http_io; // Add this import
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sampay_wallet/core/constants/api_endpoints.dart';
import 'package:xml/xml.dart' as xml;

enum HttpStatus {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  internalServerError;

  int get code {
    switch (this) {
      case HttpStatus.badRequest:
        return 400;
      case HttpStatus.unauthorized:
        return 401;
      case HttpStatus.forbidden:
        return 403;
      case HttpStatus.notFound:
        return 404;
      case HttpStatus.internalServerError:
        return 500;
    }
  }

  String get message {
    switch (this) {
      case HttpStatus.badRequest:
        return 'Bad request';
      case HttpStatus.unauthorized:
        return 'Unauthorized';
      case HttpStatus.forbidden:
        return 'Forbidden';
      case HttpStatus.notFound:
        return 'Not found';
      case HttpStatus.internalServerError:
        return 'Internal server error';
    }
  }

  static HttpStatus fromCode(int code) {
    switch (code) {
      case 400:
        return HttpStatus.badRequest;
      case 401:
        return HttpStatus.unauthorized;
      case 403:
        return HttpStatus.forbidden;
      case 404:
        return HttpStatus.notFound;
      case 500:
        return HttpStatus.internalServerError;
      default:
        throw ArgumentError('Unknown status code: $code');
    }
  }
}

class NetworkService extends ChangeNotifier {
  late http.Client client;
  late String baseUrl;
  late StreamSubscription<InternetStatus> subscription;
  final Map<String, String>? defaultHeaders = {
    'Content-Type': 'application/json',
  };
  ValueNotifier<bool> isNetworkConnected = ValueNotifier<bool>(true);

  String buildUrl(String endpoint) => _joinUrl(baseUrl, endpoint);

  NetworkService({String? url}) {
    // Create HTTP client with SSL certificate handling
    client = _createHttpClient();
    baseUrl = url ?? ApiEndpoints.baseUrl;

    subscription = InternetConnection().onStatusChange.listen((
      InternetStatus status,
    ) {
      isNetworkConnected.value = status == InternetStatus.connected;
      notifyListeners();
    });
  }

  /// Creates an HTTP client with custom SSL certificate validation
  ///
  /// In debug mode: Accepts all certificates (for testing)
  /// In release mode: Only accepts certificates for specific domains
  http.Client _createHttpClient() {
    final httpClient = HttpClient();

    // Set the bad certificate callback
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
          // In debug mode, allow all certificates for testing
          if (kDebugMode) {
            debugPrint('🔓 SSL bypass enabled for: $host (Debug Mode)');
            return true;
          }

          // In release mode, only allow for specific domains
          // Use with caution - this still bypasses SSL validation
          if (host.contains('sampay.dev') || host.contains('sampay.com')) {
            debugPrint(
              '⚠️ SSL bypass for: $host (Release Mode - Use with caution)',
            );
            return true;
          }

          // Reject all other certificates
          debugPrint('❌ SSL certificate rejected for: $host');
          return false;
        };

    // Return IOClient with our custom HttpClient
    return http_io.IOClient(httpClient);
  }

  // ======================= DEBUG LOGGING =======================

  /// Logs an outgoing request in debug mode.
  ///
  /// The Authorization header is masked so bearer tokens are never
  /// written to the console/logs.
  void _logRequest({
    required String method,
    required String url,
    required Map<String, String> headers,
    String? body,
  }) {
    if (!kDebugMode) return;

    debugPrint('🌐 [HTTP] $method → $url');
    debugPrint('📋 [HEADERS] ${_maskSensitiveHeaders(headers)}');
    if (body != null && body.isNotEmpty) {
      debugPrint('📦 [BODY] $body');
    }
  }

  /// Logs a received response (or error) in debug mode.
  void _logResponse({
    required String method,
    required String url,
    int? statusCode,
    Map<String, String>? headers,
    String? body,
    Object? error,
  }) {
    if (!kDebugMode) return;

    if (error != null) {
      debugPrint('❌ [HTTP] $method ← $url ERROR: $error');
      return;
    }

    debugPrint('📥 [HTTP] $method ← $url [${statusCode ?? '?'}]');
    if (headers != null && headers.isNotEmpty) {
      debugPrint('🔖 [RESPONSE HEADERS] $headers');
    }
    if (body != null && body.isNotEmpty) {
      debugPrint('📄 [RESPONSE BODY] $body');
    }
  }

  /// Masks sensitive header values (e.g. Authorization bearer tokens)
  /// so they don't leak into debug logs.
  Map<String, String> _maskSensitiveHeaders(Map<String, String> headers) {
    final masked = <String, String>{};
    headers.forEach((key, value) {
      if (key.toLowerCase() == 'authorization') {
        masked[key] = value.length > 12
            ? '${value.substring(0, 12)}...'
            : '*** (masked)';
      } else {
        masked[key] = value;
      }
    });
    return masked;
  }

  /// Joins a base URL and an endpoint, avoiding duplicate slashes between
  /// them (e.g. `https://host/uat/` + `/zra/...` → `https://host/uat/zra/...`).
  ///
  /// Prevents servers from responding with a 308 redirect for `//` paths.
  /// Absolute endpoint URLs (starting with http:// or https://) are returned
  /// unchanged.
  String _joinUrl(String base, String endpoint) {
    // Endpoint is already a full URL — use it as-is.
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return endpoint;
    }

    final normalizedBase = base.endsWith('/')
        ? base.substring(0, base.length - 1)
        : base;
    final normalizedEndpoint = endpoint.startsWith('/')
        ? endpoint
        : '/$endpoint';

    return '$normalizedBase$normalizedEndpoint';
  }

  // GET request
  Future<NetworkResponse> get(
    String endpoint, {
    String? baseAddress,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? bearerToken,
  }) async {
    const method = 'GET';
    try {
      final uri = Uri.parse(_joinUrl(baseAddress ?? baseUrl, endpoint)).replace(
        queryParameters: queryParameters?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
      final mergedHeaders = _mergeHeaders(headers, bearerToken);

      _logRequest(method: method, url: uri.toString(), headers: mergedHeaders);

      final response = await client.get(uri, headers: mergedHeaders);

      _logResponse(
        method: method,
        url: uri.toString(),
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
      );
      return NetworkResponse.fromHttpResponse(response);
    } catch (e) {
      _logResponse(
        method: method,
        url: _joinUrl(baseAddress ?? baseUrl, endpoint),
        error: e,
      );
      return NetworkResponse.error(message: e.toString());
    }
  }

  // POST request
  Future<NetworkResponse> post(
    String endpoint, {
    String? baseAddress,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    String? jsonBody,
    String? bearerToken,
  }) async {
    const method = 'POST';
    try {
      final uri = Uri.parse(_joinUrl(baseAddress ?? baseUrl, endpoint));
      final mergedHeaders = _mergeHeaders(headers, bearerToken);
      final encodedBody = jsonBody ?? (body != null ? jsonEncode(body) : null);

      _logRequest(
        method: method,
        url: uri.toString(),
        headers: mergedHeaders,
        body: encodedBody,
      );

      final response = await client.post(
        uri,
        headers: mergedHeaders,
        body: encodedBody,
      );

      _logResponse(
        method: method,
        url: uri.toString(),
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
      );
      return NetworkResponse.fromHttpResponse(response);
    } catch (e) {
      _logResponse(
        method: method,
        url: _joinUrl(baseAddress ?? baseUrl, endpoint),
        error: e,
      );
      return NetworkResponse.error(message: e.toString());
    }
  }

  // PUT request
  Future<NetworkResponse> put(
    String endpoint, {
    String? baseAddress,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    String? jsonBody,
    String? bearerToken,
  }) async {
    const method = 'PUT';
    try {
      final uri = Uri.parse(_joinUrl(baseAddress ?? baseUrl, endpoint));
      final mergedHeaders = _mergeHeaders(headers, bearerToken);
      final encodedBody = jsonBody ?? (body != null ? jsonEncode(body) : null);

      _logRequest(
        method: method,
        url: uri.toString(),
        headers: mergedHeaders,
        body: encodedBody,
      );

      final response = await client.put(
        uri,
        headers: mergedHeaders,
        body: encodedBody,
      );

      _logResponse(
        method: method,
        url: uri.toString(),
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
      );
      return NetworkResponse.fromHttpResponse(response);
    } catch (e) {
      _logResponse(
        method: method,
        url: _joinUrl(baseAddress ?? baseUrl, endpoint),
        error: e,
      );
      return NetworkResponse.error(message: e.toString());
    }
  }

  // DELETE request
  Future<NetworkResponse> delete(
    String endpoint, {
    String? baseAddress,
    Map<String, String>? headers,
    String? bearerToken,
  }) async {
    const method = 'DELETE';
    try {
      final uri = Uri.parse(_joinUrl(baseAddress ?? baseUrl, endpoint));
      final mergedHeaders = _mergeHeaders(headers, bearerToken);

      _logRequest(method: method, url: uri.toString(), headers: mergedHeaders);

      final response = await client.delete(uri, headers: mergedHeaders);

      _logResponse(
        method: method,
        url: uri.toString(),
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
      );
      return NetworkResponse.fromHttpResponse(response);
    } catch (e) {
      _logResponse(
        method: method,
        url: _joinUrl(baseAddress ?? baseUrl, endpoint),
        error: e,
      );
      return NetworkResponse.error(message: e.toString());
    }
  }

  // PATCH request
  Future<NetworkResponse> patch(
    String endpoint, {
    String? baseAddress,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    String? jsonBody,
    String? bearerToken,
  }) async {
    const method = 'PATCH';
    try {
      final uri = Uri.parse(_joinUrl(baseAddress ?? baseUrl, endpoint));
      final mergedHeaders = _mergeHeaders(headers, bearerToken);
      final encodedBody = jsonBody ?? (body != null ? jsonEncode(body) : null);

      _logRequest(
        method: method,
        url: uri.toString(),
        headers: mergedHeaders,
        body: encodedBody,
      );

      final response = await client.patch(
        uri,
        headers: mergedHeaders,
        body: encodedBody,
      );

      _logResponse(
        method: method,
        url: uri.toString(),
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
      );
      return NetworkResponse.fromHttpResponse(response);
    } catch (e) {
      _logResponse(
        method: method,
        url: _joinUrl(baseAddress ?? baseUrl, endpoint),
        error: e,
      );
      return NetworkResponse.error(message: e.toString());
    }
  }

  // Helper to merge headers
  Map<String, String> _mergeHeaders(
    Map<String, String>? additionalHeaders,
    String? bearerToken,
  ) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?defaultHeaders,
      ...?additionalHeaders,
    };

    if (bearerToken != null && bearerToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $bearerToken';
    }

    return headers;
  }

  // Helper for form data headers
  Map<String, String> _mergeFormDataHeaders(
    Map<String, String>? additionalHeaders,
    String? bearerToken,
  ) {
    final headers = <String, String>{
      // Don't set Content-Type for multipart - it will be set automatically
      'Accept': 'application/json',
      ...?defaultHeaders,
      ...?additionalHeaders,
    };

    if (bearerToken != null && bearerToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $bearerToken';
    }

    return headers;
  }

  // Add this method to your NetworkService class
  Future<NetworkResponse> postFormData(
    String endpoint, {
    String? baseAddress,
    Map<String, String>? headers,
    Map<String, String>? fields,
    List<http.MultipartFile>? files,
    String? bearerToken,
  }) async {
    const method = 'POST';
    try {
      final uri = Uri.parse(_joinUrl(baseAddress ?? baseUrl, endpoint));

      // Create multipart request
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      final mergedHeaders = _mergeFormDataHeaders(headers, bearerToken);
      request.headers.addAll(mergedHeaders);

      // Add text fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Add files
      if (files != null) {
        request.files.addAll(files);
      }

      _logRequest(
        method: method,
        url: uri.toString(),
        headers: mergedHeaders,
        body:
            'multipart fields: $fields, files: '
            '${files?.map((f) => '${f.filename} (${f.contentType})').toList()}',
      );

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _logResponse(
        method: method,
        url: uri.toString(),
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
      );
      return NetworkResponse.fromHttpResponse(response);
    } catch (e) {
      _logResponse(
        method: method,
        url: _joinUrl(baseAddress ?? baseUrl, endpoint),
        error: e,
      );
      return NetworkResponse.error(message: e.toString());
    }
  }

  // Dispose method to close client
  @override
  void dispose() {
    client.close();
    subscription.cancel();
    isNetworkConnected.dispose();
    super.dispose();
  }
}

class NetworkResponse {
  final int statusCode;
  final String body;
  final dynamic data;
  final bool isSuccess;
  final String? errorMessage;
  final Map<String, String>? headers;
  final int? contentLength;
  final bool isXml; // New property

  NetworkResponse({
    required this.statusCode,
    required this.body,
    this.data,
    required this.isSuccess,
    this.errorMessage,
    this.headers,
    this.contentLength,
    this.isXml = false, // Default to false
  });

  NetworkResponse.error({required String message})
    : statusCode = -1,
      body = '',
      data = null,
      isSuccess = false,
      errorMessage = message,
      headers = null,
      contentLength = null,
      isXml = false;

  // Factory method from http.Response
  factory NetworkResponse.fromHttpResponse(http.Response response) {
    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;
    dynamic parsedData;
    bool isXml = false;

    // Check if response is XML
    final contentType = response.headers['content-type'] ?? '';
    if (contentType.contains('xml') ||
        response.body.trim().startsWith('<?xml')) {
      isXml = true;
      try {
        final document = xml.XmlDocument.parse(response.body);
        parsedData = _xmlToMap(document);
      } catch (e) {
        parsedData = response.body;
      }
    } else {
      // Try to parse as JSON
      try {
        parsedData = jsonDecode(response.body);
      } catch (e) {
        parsedData = response.body;
      }
    }

    return NetworkResponse(
      statusCode: response.statusCode,
      body: response.body,
      data: parsedData,
      isSuccess: isSuccess,
      isXml: isXml,
      headers: response.headers,
      contentLength: response.contentLength,
    );
  }

  // Helper to convert XML to Map
  static Map<String, dynamic> _xmlToMap(xml.XmlDocument document) {
    final result = <String, dynamic>{};

    for (final child in document.rootElement.children) {
      if (child is xml.XmlElement) {
        if (child.children.length == 1 && child.children[0] is xml.XmlText) {
          result[child.name.local] = child.text;
        } else {
          final nested = <String, dynamic>{};
          for (final subChild in child.children) {
            if (subChild is xml.XmlElement) {
              nested[subChild.name.local] = subChild.text;
            }
          }
          result[child.name.local] = nested.isEmpty ? child.text : nested;
        }
      }
    }

    return result;
  }

  // XML-specific getters
  String? get xmlCode {
    if (isXml && data is Map) {
      return data['code']?.toString();
    }
    return null;
  }

  String? get xmlMessage {
    if (isXml && data is Map) {
      return data['message']?.toString();
    }
    return null;
  }

  // JSON-specific getters
  bool get hasData => data != null;
  bool get isJson => data is Map || data is List;

  // Get response status from JSON body (for APIs that return status field)
  bool get jsonStatus => data is Map && data['status'] == true;

  // Get message from JSON body
  String? get jsonMessage {
    if (data is Map) {
      return data['message']?.toString();
    }
    return null;
  }

  // Get access token from response (for login responses)
  String? get accessToken {
    if (data is Map) {
      return data['access_token']?.toString();
    }
    return null;
  }

  // Get token type
  String? get tokenType {
    if (data is Map) {
      return data['token_type']?.toString();
    }
    return null;
  }

  // Get full token (Bearer + token)
  String? get fullToken {
    if (accessToken != null && tokenType != null) {
      return '$tokenType $accessToken';
    }
    return accessToken;
  }

  // Get user data from response
  Map<String, dynamic>? get userData {
    if (data is Map && data['user'] is Map) {
      return Map<String, dynamic>.from(data['user']);
    }
    return null;
  }

  bool get hasError => errorMessage != null;

  // Check if XML response indicates success
  bool get xmlSuccess {
    if (isXml && xmlCode != null) {
      // Common success codes: 6000, 0000, 00
      return xmlCode! == '6000' || xmlCode! == '0000' || xmlCode! == '00';
    }
    return false;
  }

  // Override display message to handle XML responses
  String get displayMessage {
    if (errorMessage != null) return errorMessage!;

    // Handle XML responses
    if (isXml && xmlMessage != null) {
      return xmlMessage!;
    }

    if (jsonMessage != null) return jsonMessage!;
    return _getDefaultMessageForStatusCode();
  }

  String _getDefaultMessageForStatusCode() {
    try {
      final HttpStatus httpStatus = HttpStatus.fromCode(statusCode);
      return httpStatus.message;
    } catch (e) {
      return 'Request completed with status $statusCode';
    }
  }

  @override
  String toString() {
    return 'NetworkResponse(statusCode: $statusCode, isSuccess: $isSuccess, message: $displayMessage, errorMessage: $errorMessage, isXml: $isXml)';
  }

  // For debugging
  Map<String, dynamic> toDebugInfo() {
    return {
      'statusCode': statusCode,
      'isSuccess': isSuccess,
      'message': displayMessage,
      'hasData': hasData,
      'isJson': isJson,
      'isXml': isXml,
      'contentLength': contentLength,
      'headers': headers,
    };
  }
}

// Extension helper for http.Response
extension HttpResponseExtension on http.Response {
  NetworkResponse toNetworkResponse() {
    return NetworkResponse.fromHttpResponse(this);
  }
}
