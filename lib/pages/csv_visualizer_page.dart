import 'dart:math' as math;
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
  final ScrollController _hScrollController = ScrollController();

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
                          : _CsvPaginatedTable(
                              rows: _rows,
                              hController: _hScrollController,
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

  @override
  void dispose() {
    _hScrollController.dispose();
    super.dispose();
  }
}

class _CsvPaginatedTable extends StatefulWidget {
  final List<List<String>> rows;
  final ScrollController hController;

  const _CsvPaginatedTable({required this.rows, required this.hController});

  @override
  State<_CsvPaginatedTable> createState() => _CsvPaginatedTableState();
}

class _CsvPaginatedTableState extends State<_CsvPaginatedTable> {
  late _CsvDataSource _source;
  int _maxColumns = 0;
  int _rowsPerPage = 50;

  @override
  void initState() {
    super.initState();
    _maxColumns = widget.rows
        .map((r) => r.length)
        .fold<int>(0, (p, c) => c > p ? c : p);
    // Evitar acessar Theme.of(context) em initState
    _source = _CsvDataSource(widget.rows, _maxColumns);
  }

  @override
  void didUpdateWidget(covariant _CsvPaginatedTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.rows, widget.rows)) {
      _maxColumns = widget.rows
          .map((r) => r.length)
          .fold<int>(0, (p, c) => c > p ? c : p);
      _source = _CsvDataSource(widget.rows, _maxColumns);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasHeader = widget.rows.isNotEmpty;
    final header = hasHeader ? widget.rows.first : const <String>[];

    final columns = List.generate(
      _maxColumns,
      (i) => DataColumn(
        label: Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            i < header.length ? header[i] : 'Col ${i + 1}',
            style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ) ??
                const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final table = PaginatedDataTable(
          header: null,
          columns: columns,
          source: _source,
          rowsPerPage: _rowsPerPage,
          availableRowsPerPage: const [10, 25, 50, 100, 200],
          onRowsPerPageChanged: (v) {
            if (v != null) setState(() => _rowsPerPage = v);
          },
          showFirstLastButtons: true,
          horizontalMargin: 12,
          columnSpacing: 24,
          dataRowMinHeight: 40,
          dataRowMaxHeight: 56,
          headingRowColor: WidgetStatePropertyAll(
            theme.colorScheme.primary.withValues(alpha: .08),
          ),
        );

        // Largura finita estimada para evitar BoxConstraints infinitos.
        // Se o conteúdo for maior que a viewport, o scroll horizontal entra em ação.
        final estimatedPerColumn = 160.0; // padding + texto médio + spacing
        final contentWidth = math.max(
          constraints.maxWidth,
          _maxColumns * estimatedPerColumn,
        );

        final scrollable = Scrollbar(
          controller: widget.hController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: widget.hController,
            child: SizedBox(
              width: contentWidth,
              child: table,
            ),
          ),
        );

        return Material(
          type: MaterialType.transparency,
          child: scrollable,
        );
      },
    );
  }
}

class _CsvDataSource extends DataTableSource {
  final List<List<String>> rows;
  final int maxColumns;
  _CsvDataSource(this.rows, this.maxColumns);

  @override
  DataRow? getRow(int index) {
    // pula a linha de header (index 0) no corpo
    final rowIndex = index + 1;
    if (rowIndex >= rows.length) return null;
    final row = rows[rowIndex];
    return DataRow.byIndex(
      index: index,
      cells: List.generate(
        maxColumns,
        (col) => DataCell(
          Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              col < row.length ? row[col] : '',
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rows.isEmpty ? 0 : rows.length - 1; // sem header

  @override
  int get selectedRowCount => 0;
}
