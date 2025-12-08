import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:fluru_tools/services/base64_up_down.dart';

Future saveBase64File(String base64) async {
  final bytes = base64ToFile(base64);
  await FilePicker.platform.saveFile(fileName: "file.bin", bytes: Uint8List.fromList(bytes));
}
