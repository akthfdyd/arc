import 'dart:convert';
import 'dart:io';

import 'package:arc/arc.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/io_client.dart';

enum HttpMethod { POST, PUT, GET, DELETE }

class AHttp {
  static Future<Response> request({
    required HttpMethod method,
    required String url,
    required Map<String, dynamic> param,
    Map<String, String>? header,
  }) async {
    if (header == null) {
      header = {'Content-Type': 'application/json'};
    } else {
      // header['Content-Type'] = 'application/json';
    }

    late http.Response res;
    try {
      switch (method) {
        case HttpMethod.POST:
          res = await postRequest(url, param, header);
          break;
        case HttpMethod.PUT:
          res = await putRequest(url, param, header);
          break;
        case HttpMethod.GET:
          res = await getRequest(url, param, header);
          break;
        case HttpMethod.DELETE:
          res = await deleteRequest(url, param, header);
          break;
      }
      if (kDebugMode) {
        print('http_log responseHeader << $url ${res.headers}');
        print('http_log responseBody << $url ${utf8.decode(res.bodyBytes)}');
      }

      return requestTail(
        method,
        res,
        url,
        param,
      );
    } catch (error) {
      rethrow;
    }
  }

  static Future<http.Response> postRequest(
      String path, Map<String, dynamic> param, Map<String, String> header) {
    if (kDebugMode) {
      print('postRequest');
    }
    String bodyJson = '';
    try {
      bodyJson = json.encode(param);
      if (kDebugMode) {
        print('postRequest bodyJson $bodyJson');
      }
    } catch (error, stacktrace) {
      if (kDebugMode) {
        print('HttpRequest postRequest parameter json encode failed >> ' +
            stacktrace.toString());
      }
    }
    try {
      HttpClient httpClient = HttpClient();
      setProxy(httpClient);
      IOClient ioClient = IOClient(httpClient);
      return ioClient.post(
        Uri.parse(path),
        body: bodyJson,
        headers: header,
      );
    } catch (error) {
      rethrow;
    }
  }

  static Future<http.Response> putRequest(
      String path, Map<String, dynamic> param, Map<String, String> header) {
    if (kDebugMode) {
      print('HttpRequest putRequest');
    }
    String? bodyJson;
    try {
      bodyJson = json.encode(param);
    } catch (error, stacktrace) {
      if (kDebugMode) {
        print('HttpRequest putRequest parameter json encode failed' +
            stacktrace.toString());
      }
    }
    if (kDebugMode) {
      print('putRequest bodyJson $bodyJson');
    }
    try {
      HttpClient httpClient = HttpClient();
      setProxy(httpClient);
      IOClient ioClient = IOClient(httpClient);
      return ioClient.put(
        Uri.parse(path),
        body: bodyJson,
        headers: header,
      );
    } catch (error) {
      rethrow;
    }
  }

  static Future<http.Response> getRequest(
      String path, Map<String, dynamic> param, Map<String, String> header) {
    if (kDebugMode) {
      print('HttpRequest getRequest');
    }
    try {
      var url = path + Uri(queryParameters: param).toString();
      if (kDebugMode) {
        print('http_log getRequest $url');
      }

      HttpClient httpClient = HttpClient();
      setProxy(httpClient);
      IOClient ioClient = IOClient(httpClient);

      return ioClient.get(
        Uri.parse(url),
        headers: header,
      );
    } catch (error) {
      rethrow;
    }
  }

  static Future<http.Response> deleteRequest(
      String path, Map<String, dynamic> param, Map<String, String> header) {
    if (kDebugMode) {
      print('HttpRequest deleteRequest');
    }
    try {
      var url = path + Uri(queryParameters: param).toString();
      if (kDebugMode) {
        print('http_log deleteRequest $url');
      }

      HttpClient httpClient = HttpClient();
      setProxy(httpClient);
      IOClient ioClient = IOClient(httpClient);

      return ioClient.delete(
        Uri.parse(url),
        headers: header,
      );
    } catch (error) {
      rethrow;
    }
  }

  static Future<http.Response> requestTail(
    HttpMethod httpMethod,
    http.Response res,
    String path,
    Map<String, dynamic> param,
  ) async {
    if (kDebugMode) {
      print('HttpRequest requestTail $path');
      print('HttpRequest requestTail res.statusCode == ${res.statusCode}');
    }
    if (res.statusCode == 401) {
      throw Exception('HttpRequest requestTail 401 error');
    } else if (res.statusCode ~/ 100 == 2) {
      return res;
    } else if (res.statusCode ~/ 100 == 3) {
      throw Exception('HttpRequest requestTail 3xx error');
    } else if (res.statusCode ~/ 100 == 4) {
      throw Exception('HttpRequest requestTail 4xx error');
    } else if (res.statusCode ~/ 100 == 5) {
      throw Exception('HttpRequest requestTail 5xx error');
    } else {
      throw Exception('HttpRequest requestTail etc error');
    }
  }

  static void setProxy(HttpClient httpClient) {
    if (Arc.useProxy && !kReleaseMode) {
      String proxy = Arc.proxyAddress;
      httpClient.findProxy = (uri) {
        return 'PROXY $proxy;';
      };
      httpClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) {
        return true;
      });
    }
  }
}
