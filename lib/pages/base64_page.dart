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
    var txtResult = '';
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: false,
      allowMultiple: false,
      withReadStream: true,
    );
    if (result == null || result.files.isEmpty) return;
    // se for maior que 20Mb estoura error
    if (result.files.first.size > 20000000) {
      if (mounted) {
        showErrorDialog(
          context,
          AppLocalizations.of(context)!.base64FileSizeError,
        );
        return;
      }
    }
    if (!mounted) return;
    showLoadingDialog(context, AppLocalizations.of(context)!.processing);
    try {
      // Encoding streaming sem acumular todos os bytes.
      final stream = result.files.first.readStream!;
      txtResult = await fileToBase64Stream(stream);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        showErrorDialog(context, '$e');
        return;
      }
    }

    if (mounted) {
      setState(() {
        _outputCtrl.text = txtResult;
      });
    }
  }

  void _toFile() async {
    if (!mounted) return;
    showLoadingDialog(context, AppLocalizations.of(context)!.processing);
    try {
      await saveBase64File(_outputCtrl.text);
      if (mounted) {
        Navigator.of(context).pop(); // fecha loading
        showSuccessDialog(context, '');
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // fecha loading
        showErrorDialog(context, '$e');
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
              child: Row(
                children: [
                  Expanded(
                    flex: 45,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildTextField(
                        controller: _outputCtrl,
                        readOnly: true,
                      ),
                    ),
                  ),
                ],
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
