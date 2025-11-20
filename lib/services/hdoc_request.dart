import 'dart:async';
import 'package:http/http.dart' as http;

/// Representa os dados de uma requisição preparados a partir de um heredoc.
class RequestData {
  final String method; // sempre armazenado como maiúsculo
  final String url;
  final Map<String, String> headers;
  final String? body;

  RequestData({
    required this.method,
    required this.url,
    Map<String, String>? headers,
    this.body,
  }) : headers = headers ?? const {};
}

/// Resultado de uma requisição HTTP.
class RequestResult {
  final int statusCode;
  final Map<String, String> headers;
  final String body;

  RequestResult({
    required this.statusCode,
    required this.headers,
    required this.body,
  });
}

/// Faz o parse de um bloco heredoc no formato:
/// Blocos desconhecidos são ignorados.
/// Lança [FormatException] em caso de erro de validação.
RequestData parseHeredocRequest(String input) {
  String? method;
  String? url;
  final headers = <String, String>{};
  String? body;

  final lines = input.split(RegExp(r'\r?\n'));
  int i = 0;

  while (i < lines.length) {
    final rawLine = lines[i].trim();
    if (rawLine.startsWith('<<')) {
      final tag = rawLine.substring(2).trim();
      final buffer = StringBuffer();
      i++;
      while (i < lines.length && lines[i].trim() != tag) {
        buffer.writeln(lines[i]);
        i++;
      }
      final content = buffer.toString().trim();

      switch (tag.toUpperCase()) {
        case 'METHOD':
          method = content;
          break;
        case 'URL':
          url = content;
          break;
        case 'HEADERS':
          for (final headerLine in content.split(RegExp(r'\r?\n'))) {
            if (headerLine.trim().isEmpty) continue;
            final parts = headerLine.split(':');
            if (parts.length >= 2) {
              final k = parts.first.trim();
              final v = headerLine
                  .substring(headerLine.indexOf(':') + 1)
                  .trim();
              if (k.isNotEmpty) headers[k] = v;
            }
          }
          break;
        case 'BODY':
          body = content;
          break;
        default:
          // ignora blocos desconhecidos
          break;
      }
    }
    i++;
  }

  // validações obrigatórias
  if (method == null) {
    throw FormatException('Bloco obrigatório <<METHOD ... METHOD>> ausente');
  }
  if (url == null) {
    throw FormatException('Bloco obrigatório <<URL ... URL>> ausente');
  }
  final normalizedMethod = method.toUpperCase();
  const validMethods = {'GET', 'POST', 'PUT', 'DELETE', 'PATCH'};
  if (!validMethods.contains(normalizedMethod)) {
    throw FormatException(
      "Método HTTP inválido: '$method' (válidos: GET, POST, PUT, DELETE, PATCH)",
    );
  }
  if (!(url.startsWith('http://') || url.startsWith('https://'))) {
    throw FormatException(
      "URL inválida: '$url' (deve começar com http:// ou https://)",
    );
  }

  return RequestData(
    method: normalizedMethod,
    url: url,
    headers: headers,
    body: body,
  );
}

/// Envia a requisição baseada em [RequestData].
/// Usa a lib `http` e retorna [RequestResult]. Lança [Exception] em falhas.
Future<RequestResult> sendRequest(RequestData req) async {
  final method = req.method.toUpperCase();
  final uri = Uri.parse(req.url);
  http.Response response;

  // Decide se envia corpo
  final allowBody = switch (method) {
    'POST' => true,
    'PUT' => true,
    'PATCH' => true,
    'DELETE' => true,
    _ => false,
  };

  final body = (allowBody ? req.body : null);

  try {
    switch (method) {
      case 'POST':
        response = await http.post(uri, headers: req.headers, body: body);
        break;
      case 'PUT':
        response = await http.put(uri, headers: req.headers, body: body);
        break;
      case 'PATCH':
        response = await http.patch(uri, headers: req.headers, body: body);
        break;
      case 'DELETE':
        response = await http.delete(uri, headers: req.headers, body: body);
        break;
      case 'GET':
      default:
        response = await http.get(uri, headers: req.headers);
        break;
    }
  } catch (e) {
    throw Exception('$e');
  }

  final headerMap = <String, String>{};
  response.headers.forEach((k, v) => headerMap[k] = v);

  return RequestResult(
    statusCode: response.statusCode,
    headers: headerMap,
    body: response.body,
  );
}

Future<String> makeRequest(String input) async {
  try {
    final requestData = parseHeredocRequest(input);
    final result = await sendRequest(requestData);

    final buffer = StringBuffer();
    buffer.writeln('Status Code: ${result.statusCode}');
    buffer.writeln('Headers:');
    result.headers.forEach((k, v) => buffer.writeln('$k: $v'));
    buffer.writeln();
    buffer.writeln('Body:');
    buffer.write(result.body);
    return buffer.toString();
  } on FormatException catch (e) {
    throw Exception(e.message);
  } catch (e) {
    throw Exception('$e');
  }
}
