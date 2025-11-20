import 'package:file_picker/file_picker.dart';
import 'package:fluru_tools/services/base64_up_down.dart';
import 'package:flutter/material.dart';
import 'package:fluru_tools/helper/save_base64_file.dart';

class Base64Page extends StatefulWidget {
  const Base64Page({super.key});

  @override
  State<Base64Page> createState() => _Base64PageState();
}

class _Base64PageState extends State<Base64Page> {
  late final TextEditingController _outputCtrl;

  @override
  void initState() {
    super.initState();
    _outputCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _outputCtrl.dispose();
    super.dispose();
  }

  void _toBase64() async {
    var txtResult = '';
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: false,
      allowMultiple: false,
      withReadStream: true,
    );
    if (result == null || result.files.isEmpty) {
      return;
    }
    List<int> fileBytes = [];
    try {
      PlatformFile file = result.files.first;
      await for (final chunk in file.readStream!) {
        fileBytes.addAll(chunk);
      }
      txtResult = fileToBase64(fileBytes);
    } catch (e) {
      txtResult = '$e';
    }

    setState(() {
      _outputCtrl.text = txtResult;
    });
  }

  void _toFile() async {
    final ctx = context;
    try {
      await saveBase64File(_outputCtrl.text);
      if (ctx.mounted) {
        showDialog(
          context: ctx,
          builder: (dialogContext) => AlertDialog(
            title: Text('✓'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (ctx.mounted) {
        showDialog(
          context: ctx,
          builder: (dialogContext) => AlertDialog(
            title: Text('X'),
            content: Text('$e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: _toBase64,
                        icon: Icon(Icons.file_upload),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 45,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _outputCtrl,
                        textAlignVertical: TextAlignVertical.top,
                        readOnly: false,
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 70,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: _toFile,
                        icon: Icon(Icons.file_download),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
