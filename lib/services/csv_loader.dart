import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';

/// Lê um CSV a partir de um [Stream] de chunks de bytes.
/// Usa a biblioteca `csv` para tratar corretamente delimitadores dentro de aspas
/// e quebras de linha. Retorna todas as linhas como lista de listas de String.
///
/// [delimiter] pode ser ',', ';', '|', etc. [textDelimiter] por padrão é '"'.
Future<List<List<String>>> loadCsvFromStream(
  Stream<List<int>> stream, {
  String delimiter = ',',
  String textDelimiter = '"',
  bool shouldParseNumbers = false,
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

  final converter = CsvToListConverter(
    fieldDelimiter: delimiter,
    textDelimiter: textDelimiter,
    shouldParseNumbers: shouldParseNumbers,
    eol: '\n',
  );

  final data = converter.convert(raw);
  return data.map((row) => row.map((v) => v?.toString() ?? '').toList()).toList();
}