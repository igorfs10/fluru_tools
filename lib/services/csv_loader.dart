import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';

Future<List<List<String>>> loadCsvFromStream(
  Stream<List<int>> stream, {
  String delimiter = ',',
}) async {
  // Acumula bytes inteiros para evitar quebra de caracteres multibyte entre chunks
  final builder = BytesBuilder(copy: false);
  await for (final chunk in stream) {
    builder.add(chunk);
  }
  final bytes = builder.takeBytes();

  // Tenta UTF-8 primeiro; em caso de erro, faz fallback para latin1 (comum no Windows)
  String raw;
  try {
    raw = const Utf8Decoder().convert(bytes);
  } on FormatException {
    raw = const Latin1Decoder().convert(bytes);
  }

  // Normaliza EOL para o conversor
  raw = raw.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

  final converter = CsvCodec(
    fieldDelimiter: delimiter,
  );

  final data = converter.decode(raw);
  return data.map((row) => row.map((v) => v?.toString() ?? '').toList()).toList();
}