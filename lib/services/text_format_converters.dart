import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:json2yaml/json2yaml.dart' as j2y;
import 'package:xml/xml.dart' as xml;
import 'package:yaml/yaml.dart' as y;

enum FormatConverter { json, csv, yaml, xml_;
  static FormatConverter fromInt(int v) {
    switch (v) {
      case 0:
        return FormatConverter.json;
      case 1:
        return FormatConverter.csv;
      case 2:
        return FormatConverter.yaml;
      case 3:
        return FormatConverter.xml_;
      default:
        return FormatConverter.json;
    }
  }
}

// ========= Helpers =========
String _prettyJsonEncode(dynamic value) => const JsonEncoder.withIndent('    ').convert(value);

String _valueToCell(dynamic v) {
  if (v == null) return '';
  if (v is num || v is bool) return v.toString();
  if (v is String) return v;
  // Arrays/Objetos como JSON string
  return jsonEncode(v);
}

bool _isPrimitive(dynamic v) => v == null || v is String || v is num || v is bool;

dynamic _parseTextValue(String s) {
  final t = s.trim();
  if (t.isEmpty) return '';
  if (t.toLowerCase() == 'null') return null;
  if (t.toLowerCase() == 'true') return true;
  if (t.toLowerCase() == 'false') return false;
  final i = int.tryParse(t);
  if (i != null) return i;
  final d = double.tryParse(t);
  if (d != null) return d;
  return t;
}

Map<String, dynamic> _toPlainMap(Map src) => src.map((k, v) => MapEntry(k.toString(), _toPlain(v)));
List _toPlainList(List src) => src.map(_toPlain).toList();
dynamic _toPlain(dynamic v) {
  if (v is y.YamlMap) return _toPlainMap(v);
  if (v is y.YamlList) return _toPlainList(v);
  if (v is Map) return _toPlainMap(v);
  if (v is List) return _toPlainList(v);
  return v;
}

// ========= JSON =========
String prettyJson(String input) {
  final decoded = json.decode(input);
  return _prettyJsonEncode(decoded);
}

String jsonToCsv(String input) {
  final decoded = json.decode(input);
  final rows = <List<String>>[];

  if (decoded is List) {
    final headers = <String>{};
    for (final item in decoded) {
      if (item is Map) headers.addAll(item.keys.map((e) => e.toString()));
    }
    final headerList = headers.toList()..sort();
    rows.add(headerList);
    for (final item in decoded) {
      if (item is Map) {
        rows.add(headerList.map((h) => _valueToCell(item[h])).toList());
      } else {
        rows.add([_valueToCell(item)]);
      }
    }
  } else if (decoded is Map) {
    final headerList = decoded.keys.map((e) => e.toString()).toList();
    rows.add(headerList);
    rows.add(headerList.map((h) => _valueToCell(decoded[h])).toList());
  } else {
    rows.add(['value']);
    rows.add([_valueToCell(decoded)]);
  }
  return const ListToCsvConverter().convert(rows);
}

String jsonToYaml(String input) {
  final decoded = json.decode(input);
  return j2y.json2yaml(decoded);
}

String jsonToXml(String input) {
  final decoded = json.decode(input);
  final b = xml.XmlBuilder();
  void write(String tag, dynamic v) {
    b.element(tag, nest: () {
      if (v == null) return;
      if (_isPrimitive(v)) {
        b.text(v.toString());
        return;
      }
      if (v is List) {
        for (final item in v) {
          write('item', item);
        }
        return;
      }
      if (v is Map) {
        final keys = v.keys.map((e) => e.toString()).toList()..sort();
        for (final k in keys) {
          write(k, v[k]);
        }
        return;
      }
      b.text(v.toString());
    });
  }

  write('root', decoded);
  final doc = b.buildDocument();
  return doc.toXmlString(pretty: true, indent: '    ');
}

// ========= CSV =========
String csvToJson(String input) {
  final rows = const CsvToListConverter().convert(input);
  if (rows.isEmpty) return '[]';
  final headers = rows.first.map((e) => e.toString()).toList();
  final out = <Map<String, dynamic>>[];
  for (var i = 1; i < rows.length; i++) {
    final row = rows[i];
    final map = <String, dynamic>{};
    for (var c = 0; c < headers.length; c++) {
      final val = (c < row.length) ? row[c] : '';
      map[headers[c]] = val.toString();
    }
    out.add(map);
  }
  return _prettyJsonEncode(out);
}

String csvToYaml(String input) => jsonToYaml(csvToJson(input));
String prettyCsv(String input) => jsonToCsv(csvToJson(input));
String csvToXml(String input) => jsonToXml(csvToJson(input));

// ========= YAML =========
String yamlToJson(String input) {
  if (input.trim().isEmpty) {
    return "";
  }
  final doc = y.loadYaml(input);
  if (doc == null) {
    return "";
  }
  final plain = _toPlain(doc);
  return _prettyJsonEncode(plain);
}

String yamlToCsv(String input) => jsonToCsv(yamlToJson(input));
String yamlToXml(String input) => jsonToXml(yamlToJson(input));
String prettyYaml(String input) => jsonToYaml(yamlToJson(input));

// ========= XML =========
String xmlToJson(String input) {
  final document = xml.XmlDocument.parse(input);

  dynamic nodeToJson(xml.XmlElement e) {
    final childrenElements = e.children.whereType<xml.XmlElement>().toList();
    final textNodes = e.children.whereType<xml.XmlText>().toList();
    final text = textNodes.map((t) => t.value).join('').trim();

    if (childrenElements.isEmpty) {
      if (text.isNotEmpty) return _parseTextValue(text);
      return '';
    }

    final map = <String, dynamic>{};
    // agrupa por nome
    final groups = <String, List<xml.XmlElement>>{};
    for (final child in childrenElements) {
      groups.putIfAbsent(child.name.local, () => []).add(child);
    }
    for (final entry in groups.entries) {
      final name = entry.key;
      final list = entry.value.map(nodeToJson).toList();
      map[name] = list.length == 1 ? list.first : list;
    }

    if (text.isNotEmpty) {
      map['_text'] = _parseTextValue(text);
    }

    if (map.length == 1 && map.containsKey('_text')) {
      return map['_text'];
    }
    return map;
  }

  final rootObj = nodeToJson(document.rootElement);
  // Normaliza caso root tenha apenas <item>...
  if (rootObj is Map && rootObj.length == 1 && rootObj.containsKey('item') && rootObj['item'] is List) {
    return _prettyJsonEncode(rootObj['item']);
  }
  return _prettyJsonEncode(rootObj);
}

String prettyXml(String input) => jsonToXml(xmlToJson(input));
String xmlToCsv(String input) => jsonToCsv(xmlToJson(input));
String xmlToYaml(String input) => jsonToYaml(xmlToJson(input));

// ========= API pública compatível =========
String convertTextFormat(String input, int inputFormat, int outputFormat) {
  final from = FormatConverter.fromInt(inputFormat);
  final to = FormatConverter.fromInt(outputFormat);

  switch ((from, to)) {
    case (FormatConverter.json, FormatConverter.json):
      return prettyJson(input);
    case (FormatConverter.json, FormatConverter.csv):
      return jsonToCsv(input);
    case (FormatConverter.json, FormatConverter.yaml):
      return jsonToYaml(input);
    case (FormatConverter.json, FormatConverter.xml_):
      return jsonToXml(input);

    case (FormatConverter.csv, FormatConverter.json):
      return csvToJson(input);
    case (FormatConverter.csv, FormatConverter.csv):
      return prettyCsv(input);
    case (FormatConverter.csv, FormatConverter.yaml):
      return csvToYaml(input);
    case (FormatConverter.csv, FormatConverter.xml_):
      return csvToXml(input);

    case (FormatConverter.yaml, FormatConverter.json):
      return yamlToJson(input);
    case (FormatConverter.yaml, FormatConverter.csv):
      return yamlToCsv(input);
    case (FormatConverter.yaml, FormatConverter.yaml):
      return prettyYaml(input);
    case (FormatConverter.yaml, FormatConverter.xml_):
      return yamlToXml(input);

    case (FormatConverter.xml_, FormatConverter.json):
      return xmlToJson(input);
    case (FormatConverter.xml_, FormatConverter.csv):
      return xmlToCsv(input);
    case (FormatConverter.xml_, FormatConverter.yaml):
      return xmlToYaml(input);
    case (FormatConverter.xml_, FormatConverter.xml_):
      return prettyXml(input);
  }
}
