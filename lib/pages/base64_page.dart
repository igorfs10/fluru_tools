import 'package:file_picker/file_picker.dart';
import 'package:fluru_tools/custom_alert_dialog.dart';
import 'package:fluru_tools/custom_widgets.dart';
import 'package:fluru_tools/l10n/app_localizations.dart';
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: false,
      allowMultiple: false,
      withReadStream: true,
    );
    if (result == null || result.files.isEmpty) return;
    
    // se for maior que 20Mb estoura error
    if (result.files.first.size > 20000000) {
      if (!mounted) return;
      showErrorDialog(
        context,
        AppLocalizations.of(context)!.base64FileSizeError,
      );
      return;
    }
    
    if (!mounted) return;
    showLoadingDialog(context, AppLocalizations.of(context)!.processing);
    
    try {
      // Encoding streaming sem acumular todos os bytes.
      final stream = result.files.first.readStream!;
      final txtResult = await fileToBase64Stream(stream);
      if (!mounted) return;
      Navigator.of(context).pop();
      setState(() => _outputCtrl.text = txtResult);
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      showErrorDialog(context, '$e');
    }
  }

  void _toFile() async {
    if (!mounted) return;
    showLoadingDialog(context, AppLocalizations.of(context)!.processing);
    try {
      await saveBase64File(_outputCtrl.text);
      if (!mounted) return;
      Navigator.of(context).pop();
      showSuccessDialog(context, '');
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      showErrorDialog(context, '$e');
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: _toBase64,
                        icon: const Icon(Icons.folder_open),
                        label: Text(AppLocalizations.of(context)!.openFile),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildTextField(
                  controller: _outputCtrl,
                  readOnly: true,
                ),
              ),
            ),
            SizedBox(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: _toFile,
                        icon: const Icon(Icons.save),
                        label: Text(AppLocalizations.of(context)!.saveFile),
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
