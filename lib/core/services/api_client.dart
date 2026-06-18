import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rentvyn_tenant/core/Storage/auth_storage.dart';

class ApiClient {
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

  static Future<http.Response> get(
    String url, {
    bool requireAuth = false,
  }) async {
    return await http.get(Uri.parse(url), headers: await _headers(requireAuth));
  }

  static Future<http.Response> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    bool requireAuth = false,
  }) async {
    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    return await http.post(
      uri,
      headers: await _headers(requireAuth),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> put(
    String url, {
    Map<String, dynamic>? body,
    bool requireAuth = false,
  }) async {
    return await http.put(
      Uri.parse(url),
      headers: await _headers(requireAuth),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> multipartPost(
    String url, {
    required List<http.MultipartFile> files,
    Map<String, String>? fields,
    bool requireAuth = true,
  }) async {
    final uri = Uri.parse(url);

    final request = http.MultipartRequest("POST", uri);

    // GET HEADERS
    final headers = await _headers(requireAuth);

    // REMOVE CONTENT TYPE
    headers.remove("Content-Type");

    // ADD HEADERS
    request.headers.addAll(headers);

    // ADD FIELDS
    if (fields != null) {
      request.fields.addAll(fields);
    }

    // ADD FILES
    request.files.addAll(files);

    // DEBUG
    print("FILES => ${request.files.length}");
    print("FIELDS => ${request.fields}");

    final streamedResponse = await request.send();

    return await http.Response.fromStream(streamedResponse);
  }

  static Future<http.Response> patch(
    String url, {
    Map<String, dynamic>? body,
    bool requireAuth = false,
  }) async {
    return await http.patch(
      Uri.parse(url),
      headers: await _headers(requireAuth),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(
    String url, {
    bool requireAuth = false,
  }) async {
    return await http.delete(
      Uri.parse(url),
      headers: await _headers(requireAuth),
    );
  }
}
