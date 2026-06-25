import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rentvyn_tenant/core/Storage/auth_storage.dart';

class ApiClient {
  // ─────────────────────────────────────────────────────────────────────────
  // DEBUG LOGGER — logs every request & response in a clean box
  // ─────────────────────────────────────────────────────────────────────────
  static void _log(
    String method,
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    http.Response? response,
    String? extra,
  }) {
    const sep = '───────────────────────────────────────────────────────';
    final buf = StringBuffer();
    buf.writeln('\n╔$sep');

    buf.writeln('║ 🌐 $method  $url');
    buf.writeln('╠$sep');

    if (headers != null && headers.isNotEmpty) {
      // Mask the bearer token for security — show only last 6 chars
      final safeHeaders = headers.map((k, v) {
        if (k == 'Authorization' && v.startsWith('Bearer ')) {
          final token = v.substring(7);
          final masked = token.length > 6
              ? '****${token.substring(token.length - 6)}'
              : '****';
          return MapEntry(k, 'Bearer $masked');
        }
        return MapEntry(k, v);
      });
      buf.writeln('║ 📤 HEADERS : $safeHeaders');
    }

    if (body != null) {
      buf.writeln('║ 📦 BODY    : ${jsonEncode(body)}');
    }

    if (extra != null) {
      buf.writeln('║ ℹ️  INFO    : $extra');
    }

    if (response != null) {
      final emoji = response.statusCode >= 200 && response.statusCode < 300
          ? '✅'
          : response.statusCode >= 400
              ? '❌'
              : '⚠️';
      buf.writeln('╠$sep');
      buf.writeln('║ $emoji STATUS  : ${response.statusCode}');
      try {
        final decoded = jsonDecode(response.body);
        buf.writeln('║ 📩 RESPONSE: ${const JsonEncoder.withIndent('  ').convert(decoded)}');
      } catch (_) {
        buf.writeln('║ 📩 RESPONSE: ${response.body}');
      }
    }

    buf.writeln('╚$sep');
    print(buf.toString());
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HEADERS
  // ─────────────────────────────────────────────────────────────────────────
  static Future<Map<String, String>> _headers(bool requireAuth) async {
    String? token;

    if (requireAuth) {
      token = await AuthStorage.getToken();
    }

    return {
      "Content-Type": "application/json",
      if (requireAuth && token != null) "Authorization": "Bearer $token",
    };
  }

  // ─────────────────────────────────────────────────────────────────────────
  // GET
  // ─────────────────────────────────────────────────────────────────────────
  static Future<http.Response> get(
    String url, {
    bool requireAuth = false,
  }) async {
    final headers = await _headers(requireAuth);
    _log('GET', url, headers: headers);
    final response = await http.get(Uri.parse(url), headers: headers);
    _log('GET', url, response: response);
    return response;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // POST
  // ─────────────────────────────────────────────────────────────────────────
  static Future<http.Response> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    bool requireAuth = false,
  }) async {
    final headers = await _headers(requireAuth);
    final uri = Uri.parse(url).replace(queryParameters: queryParams);
    _log('POST', uri.toString(), headers: headers, body: body);
    final response = await http.post(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    _log('POST', uri.toString(), response: response);
    return response;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PUT
  // ─────────────────────────────────────────────────────────────────────────
  static Future<http.Response> put(
    String url, {
    Map<String, dynamic>? body,
    bool requireAuth = false,
  }) async {
    final headers = await _headers(requireAuth);
    _log('PUT', url, headers: headers, body: body);
    final response = await http.put(
      Uri.parse(url),
      
      headers: headers,
      body: jsonEncode(body),
    );
    _log('PUT', url, response: response);
    return response;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PATCH
  // ─────────────────────────────────────────────────────────────────────────
  static Future<http.Response> patch(
    String url, {
    Map<String, dynamic>? body,
    bool requireAuth = false,
  }) async {
    final headers = await _headers(requireAuth);
    _log('PATCH', url, headers: headers, body: body);
    final response = await http.patch(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    _log('PATCH', url, response: response);
    return response;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DELETE
  // ─────────────────────────────────────────────────────────────────────────
  static Future<http.Response> delete(
    String url, {
    bool requireAuth = false,
  }) async {
    final headers = await _headers(requireAuth);
    _log('DELETE', url, headers: headers);
    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );
    _log('DELETE', url, response: response);
    return response;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // MULTIPART POST
  // ─────────────────────────────────────────────────────────────────────────
  static Future<http.Response> multipartPost(
    String url, {
    required List<http.MultipartFile> files,
    Map<String, String>? fields,
    bool requireAuth = true,
  }) async {
    final uri = Uri.parse(url);
    final request = http.MultipartRequest("POST", uri);

    final headers = await _headers(requireAuth);
    // Multipart doesn't use Content-Type (http sets it with boundary)
    headers.remove("Content-Type");
    request.headers.addAll(headers);

    if (fields != null) {
      request.fields.addAll(fields);
    }
    request.files.addAll(files);

    _log(
      'POST (multipart)',
      url,
      headers: headers,
      extra: 'Files: ${files.length}, Fields: $fields',
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    _log('POST (multipart)', url, response: response);
    return response;
  }
}
