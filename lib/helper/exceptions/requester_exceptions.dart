class MissingBlockException implements Exception {
  final String message;
  final String blockName;

  MissingBlockException(this.blockName, [String? message])
    : message = message ?? 'Required $blockName is missing.';

  @override
  String toString() => 'MissingBlockException: $message';
}

class InvalidUrlException implements Exception {
  final String message;
  final String url;

  InvalidUrlException(this.url, [String? message])
    : message = message ?? 'The URL "$url" is invalid.';

  @override
  String toString() => 'InvalidUrlException: $message';
}

class InvalidMethodException implements Exception {
  final String message;
  final String method;

  InvalidMethodException(this.method, [String? message])
    : message = message ?? 'The HTTP method "$method" is invalid.';

  @override
  String toString() => 'InvalidMethodException: $message';
}
