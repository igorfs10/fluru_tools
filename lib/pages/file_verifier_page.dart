import 'package:file_picker/file_picker.dart';
import 'package:fluru_tools/custom_alert_dialog.dart';
import 'package:fluru_tools/l10n/app_localizations.dart';
import 'package:fluru_tools/services/file_verify.dart';
import 'package:flutter/material.dart';

class FileVerifierPage extends StatefulWidget {
  const FileVerifierPage({super.key});

  @override
  State<FileVerifierPage> createState() => _FileVerifierPageState();
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
    var txtResult = '';
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: false,
      allowMultiple: false,
      withReadStream: true,
    );
    if (result == null || result.files.isEmpty) {
      return;
    }
    if (!mounted) return;
    showLoadingDialog(context, AppLocalizations.of(context)!.processing);
    try {
      // Hash streaming sem acumular todos os bytes.
      final stream = result.files.first.readStream!;
      txtResult = await fileVerifyStream(stream, _outputIndex);
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // fecha loading
        showErrorDialog(context, '$e');
        return;
      }
    } finally {
      if (mounted) Navigator.of(context).pop(); // fecha loading
    }

    setState(() {
      _outputCtrl.text = txtResult;
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
                child: Row(
                  children: [
                    Expanded(
                      flex: 65,
                      child: DropdownButton(
                        isExpanded: true,
                        value: _outputIndex,
                        items: [
                          DropdownMenuItem(value: 0, child: Text('MD5')),
                          DropdownMenuItem(value: 1, child: Text('SHA1')),
                          DropdownMenuItem(value: 2, child: Text('SHA256')),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => _outputIndex = v);
                          }
                        },
                      ),
                    ),
                    Expanded(
                      flex: 45,
                      child: TextButton.icon(
                        onPressed: _fileVerify,
                        icon: Icon(Icons.folder_open),
                        label: Text(AppLocalizations.of(context)!.openFile),
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
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
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
