import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:circleslate/core/errors/exceptions.dart';

class ApiBaseHelper {
  final String _baseUrl = 'http://10.10.13.27:8000/api';

  // This method now returns the raw http.Response object.
  Future<http.Response> post(String url, dynamic body) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl + url),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );
      return response;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException(
        'Server is not responding. Please try again later.',
      );
    } on HttpException {
      throw FetchDataException('Could not find the server.');
    }
  }

  // This method handles multipart requests and also returns the raw Response.
  Future<http.Response> postMultipart(
    String url,
    Map<String, String> fields, {
    File? file,
    required String fileField,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl + url));

      request.fields.addAll(fields);

      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(fileField, file.path),
        );
      }

      var streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException(
        'Server is not responding. Please try again later.',
      );
    } on HttpException {
      throw FetchDataException('Could not find the server.');
    }
  }

  // PUT method to update data on the server
  Future<http.Response> put(String url, dynamic body, {String? token}) async {
    try {
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.put(
        Uri.parse(_baseUrl + url),
        body: json.encode(body),
        headers: headers,
      );

      return response;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException(
        'Server is not responding. Please try again later.',
      );
    } on HttpException {
      throw FetchDataException('Could not find the server.');
    }
  }

  Future<http.Response> putMultipart(
    String url,
    Map<String, String> fields, {
    String? token,
    File? file,
    String fileField = 'file',
  }) async {
    try {
      final uri = Uri.parse(_baseUrl + url);
      var request = http.MultipartRequest('PUT', uri);

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields.addAll(fields);

      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(fileField, file.path),
        );
      }

      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      return await http.Response.fromStream(
        streamedResponse,
      ); // ✅ FIXED: return raw response
    } catch (e) {
      throw FetchDataException('Failed to send multipart data: $e', url);
    }
  }

  // FIX: Added the GET method
  Future<http.Response> get(String url, {String? token}) async {
    try {
      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        Uri.parse(_baseUrl + url),
        headers: headers,
      );
      return response;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException(
        'Server is not responding. Please try again later.',
      );
    } on HttpException {
      throw FetchDataException('Could not find the server.');
    }
  }
}
