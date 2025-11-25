import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:fluru_tools/services/base64_up_down.dart';

Future saveBase64File(String base64) async {
  // Decodifica em isolate para evitar travar UI em arquivos grandes
  final bytes = base64ToFile(base64);
  final path = await FilePicker.platform.saveFile(fileName: "file.bin");
  if (path == null) return false;
  await File(path).writeAsBytes(bytes);
}
