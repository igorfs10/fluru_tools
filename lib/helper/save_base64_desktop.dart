import 'package:file_picker/file_picker.dart';
import 'dart:io';

Future saveBase64File(List<int> bytes) async {
  final path = await FilePicker.platform.saveFile(fileName: "file.bin");
  if (path == null) return false;
  await File(path).writeAsBytes(bytes);
}
