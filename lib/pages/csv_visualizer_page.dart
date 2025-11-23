import 'package:file_picker/file_picker.dart';
import 'package:fluru_tools/custom_alert_dialog.dart';
import 'package:fluru_tools/l10n/app_localizations.dart';
import 'package:fluru_tools/services/csv_loader.dart';
import 'package:flutter/material.dart';

class CsvVisualizerPage extends StatefulWidget {
  const CsvVisualizerPage({super.key});

  @override
  State<CsvVisualizerPage> createState() => _CsvVisualizerPageState();
}

class _CsvVisualizerPageState extends State<CsvVisualizerPage> {
  int _delimiterIndex = 0; // 0 , | 1 ; | 2 |
  List<List<String>> _rows = [];

  String get _delimiter => switch (_delimiterIndex) {
    0 => ',',
    1 => ';',
    2 => '|',
    _ => ',',
  };

  Future<void> _pickAndLoadCsv() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: false,
      allowMultiple: false,
      withReadStream: true,
    );
    if (result == null || result.files.isEmpty) return;
    if (!mounted) return;

    showLoadingDialog(context, AppLocalizations.of(context)!.processing);
    try {
      final readStream = result.files.first.readStream!;
      final data = await loadCsvFromStream(readStream, delimiter: _delimiter);
      if (!mounted) return;
      setState(() => _rows = data);
      if(mounted){
        Navigator.of(context).pop();
      }  
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
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
                      flex: 20,
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
                            value: _delimiterIndex,
                            items: [
                              DropdownMenuItem(value: 0, child: Text(',')),
                              DropdownMenuItem(value: 1, child: Text(';')),
                              DropdownMenuItem(value: 2, child: Text('|')),
                            ],
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _delimiterIndex = v);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 30,
                      child: TextButton.icon(
                        onPressed: _pickAndLoadCsv,
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
                      child: _rows.isEmpty
                          ? Center(
                              child: Text(
                                '',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            )
                          : Scrollbar(
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  child: Table(
                                    defaultColumnWidth:
                                        const IntrinsicColumnWidth(),
                                    border: TableBorder.all(
                                      color: Theme.of(
                                        context,
                                      ).dividerColor.withValues(alpha: .4),
                                      width: .5,
                                    ),
                                    children: _buildTableRows(),
                                  ),
                                ),
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

  List<TableRow> _buildTableRows() {
    final theme = Theme.of(context);
    if (_rows.isEmpty) return [];
    final maxColumns = _rows
        .map((r) => r.length)
        .fold<int>(0, (p, c) => c > p ? c : p);

    return [
      for (int i = 0; i < _rows.length; i++)
        TableRow(
          decoration: i == 0
              ? BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: .08),
                )
              : null,
          children: [
            for (int col = 0; col < maxColumns; col++)
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  col < _rows[i].length ? _rows[i][col] : '',
                  style:
                      (i == 0
                          ? theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )
                          : theme.textTheme.bodyMedium) ??
                      const TextStyle(),
                ),
              ),
          ],
        ),
    ];
  }
}
