import 'dart:js_interop';
import 'package:web/web.dart' as web;

Future<bool> saveBase64File(List<int> bytes) async {
  JSArray<JSNumber> jsArray = bytes.map((b) => b.toJS).toList().toJS;
  final blob = web.Blob(jsArray);
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = "file.bin"
    ..style.display = 'none';
  web.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  web.URL.revokeObjectURL(url);
  return true;
}
