import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluru_tools/src/rust/services/api.dart';


class FileVerifierPage extends StatefulWidget {
  const FileVerifierPage({
    super.key,
  });

  @override
  State<FileVerifierPage> createState() =>
      _FileVerifierPageState();
}

class _FileVerifierPageState extends State<FileVerifierPage> {
  var _outputIndex = 0;
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

  void _fileVerify() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) {
      return;
    }
    setState(() {
      try {
        PlatformFile file = result.files.first;
        file.readStream;
        _outputCtrl.text = fileVerify(
          data: file.bytes!,
          selected: _outputIndex
        );
      } catch (e) {
        _outputCtrl.text = '$e';
      }
    });
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
                child:Row(
                children: [
                  Expanded(
                    flex: 85,
                    child: DropdownButton(
                      isExpanded: true,
                      value: _outputIndex,
                      items: [
                        DropdownMenuItem(value: 0, child: Text('MD5'),),
                        DropdownMenuItem(value: 1, child: Text('SHA1'),),
                        DropdownMenuItem(value: 2, child: Text('SHA256'),),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => _outputIndex = v);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: IconButton(
                      onPressed: _fileVerify, 
                      icon: Icon(Icons.file_upload)
                      )
                  ),
                ],
              ),
              ),
            ),
            // Área principal: [TextField entrada] [Executar] [TextField saída (read-only)]
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 45,
                    child: Padding(
                      padding: EdgeInsets.all(8.0 ),
                      child: TextField(
                        controller: _outputCtrl,
                        textAlignVertical: TextAlignVertical.top,
                        readOnly: true,
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
          ],
        ),
      ),
    );
  }
}
