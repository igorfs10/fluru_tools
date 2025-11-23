import 'package:file_picker/file_picker.dart';
import 'package:fluru_tools/custom_alert_dialog.dart';
import 'package:fluru_tools/l10n/app_localizations.dart';
import 'package:fluru_tools/services/file_verify.dart';
import 'package:flutter/material.dart';

class CsvVisualizerPage extends StatefulWidget {
  const CsvVisualizerPage({super.key});

  @override
  State<CsvVisualizerPage> createState() => _CsvVisualizerPageState();
}

class _CsvVisualizerPageState extends State<CsvVisualizerPage> {
  var _outputIndex = 0;

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
                      flex: 50,
                      child: Text(
                        AppLocalizations.of(context)!.delimiter,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      flex: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorScheme.of(
                            context,
                          ).onPrimaryContainer.withValues(alpha: .08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            isDense: true,
                            value: _outputIndex,
                            items: [
                              DropdownMenuItem(value: 0, child: Text(',')),
                              DropdownMenuItem(value: 1, child: Text(';')),
                              DropdownMenuItem(value: 2, child: Text('|')),
                            ],
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _outputIndex = v);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 20,
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
                      child: Table()
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
