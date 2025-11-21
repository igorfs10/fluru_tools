import 'package:crypto/crypto.dart' as c;

/// Wrapper para uso em isolate via `compute`.
/// Espera um Map com chaves 'data' (List) e 'selected' (int).
String fileVerifyIsolate(Map<String, dynamic> args) {
  final data = args['data'] as List<int>;
  final selected = args['selected'] as int;
  return fileVerify(data, selected);
}

/// selected: 0 = MD5, 1 = SHA1, qualquer outro = SHA256.
String fileVerify(List<int> data, int selected) {
  final digest = switch (selected) {
    0 => c.md5.convert(data),
    1 => c.sha1.convert(data),
    _ => c.sha256.convert(data),
  };
  // Converte bytes para hex em minúsculas (02x equivalente)
  final buffer = StringBuffer();
  for (final b in digest.bytes) {
    buffer.write(b.toRadixString(16).padLeft(2, '0'));
  }
  return buffer.toString();
}

/// Versão streaming que não precisa manter todos os bytes em memória.
/// Recebe um stream de chunks (List) e calcula o hash incremental.
class _SingleDigestSink implements Sink<c.Digest> {
  c.Digest? value;
  @override
  void add(c.Digest data) => value = data;
  @override
  void close() {}
}

Future<String> fileVerifyStream(Stream<List<int>> stream, int selected) async {
  final digestSink = _SingleDigestSink();
  final algo = switch (selected) { 0 => c.md5, 1 => c.sha1, _ => c.sha256 };
  final byteSink = algo.startChunkedConversion(digestSink);
  await for (final chunk in stream) {
    byteSink.add(chunk);
  }
  byteSink.close();
  final digest = digestSink.value!;
  final buffer = StringBuffer();
  for (final b in digest.bytes) {
    buffer.write(b.toRadixString(16).padLeft(2, '0'));
  }
  return buffer.toString();
}
