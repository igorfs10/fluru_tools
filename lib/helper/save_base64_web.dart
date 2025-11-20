import 'package:web/web.dart' as web;

Future saveBase64File(String base64) async {
  final url = 'data:${'application/octet-stream'};base64,$base64';
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = "file.bin"
    ..style.display = 'none';
  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
}
