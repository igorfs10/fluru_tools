import 'dart:convert';

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
  final buffer = StringBuffer();
  await for (final chunk in stream) {
    buffer.write(utf8.decode(chunk));
  }
  final raw = buffer.toString();

  final converter = CsvToListConverter(
    fieldDelimiter: delimiter,
    textDelimiter: textDelimiter,
    shouldParseNumbers: shouldParseNumbers,
    eol: '\n', // A lib lida com \r\n automaticamente.
  );

  final data = converter.convert(raw);
  // Converte todos os valores para String para facilitar exibição.
  return data
      .map((row) => row.map((cell) => cell?.toString() ?? '').toList())
      .toList();
}
