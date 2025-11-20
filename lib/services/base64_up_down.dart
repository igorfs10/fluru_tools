import 'dart:convert';

String fileToBase64(List<int> fileBytes) {
  return base64Encode(fileBytes);
}

List<int> base64ToFile(String base64String) {
  return base64Decode(base64String);
}
