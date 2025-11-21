import 'dart:convert';

String fileToBase64(List<int> fileBytes) {
  return base64Encode(fileBytes);
}

List<int> base64ToFile(String base64String) {
  return base64Decode(base64String);
}

/// Converte um stream de chunks de bytes para uma única string Base64
/// sem precisar manter todos os bytes num List grande antes da conversão.
Future<String> fileToBase64Stream(Stream<List<int>> stream) async {
  final buffer = StringBuffer();
  final stringSink = StringConversionSink.from(_SimpleStringSink(buffer));
  final byteSink = const Base64Codec().encoder.startChunkedConversion(stringSink);
  await for (final chunk in stream) {
    byteSink.add(chunk);
  }
  byteSink.close();
  return buffer.toString();
}

class _SimpleStringSink implements Sink<String> {
  final StringBuffer buffer;
  _SimpleStringSink(this.buffer);
  @override
  void add(String data) => buffer.write(data);
  @override
  void close() {}
}
