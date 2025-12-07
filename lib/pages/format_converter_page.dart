import 'package:fluru_tools/custom_alert_dialog.dart';
import 'package:fluru_tools/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluru_tools/services/text_format_converters.dart';

class FormatConverterPage extends StatefulWidget {
  const FormatConverterPage({super.key});

  @override
  State<FormatConverterPage> createState() => _FormatConverterPageState();
}

const List<DropdownMenuItem<int>> dropItens = [
  DropdownMenuItem(value: 0, child: Text('JSON')),
  DropdownMenuItem(value: 1, child: Text('CSV')),
  DropdownMenuItem(value: 2, child: Text('YAML')),
  DropdownMenuItem(value: 3, child: Text('XML')),
];

class _FormatConverterPageState extends State<FormatConverterPage> {
  var _inputIndex = 0;
  var _outputIndex = 0;
  late final TextEditingController _inputCtrl;
  late final TextEditingController _outputCtrl;

  @override
  void initState() {
    super.initState();
    _inputCtrl = TextEditingController();
    _outputCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _outputCtrl.dispose();
    super.dispose();
  }

  void _convert() {
    try {
      final result = convertTextFormat(
        _inputCtrl.text,
        _inputIndex,
        _outputIndex,
      );
      setState(() => _outputCtrl.text = result);
    } catch (e) {
      showErrorDialog(context, '$e');
    }
  }

  void _invert() {
    setState(() {
      var tmpIndex = _inputIndex;
      _inputIndex = _outputIndex;
      _outputIndex = tmpIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Header com dropdowns
                SizedBox(
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 45,
                          child: buildFormatDropdown(
                            context,
                            _inputIndex,
                            dropItens,
                            (v) {
                              if (v != null) {
                                setState(() => _inputIndex = v);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 10,
                          child: IconButton(
                            onPressed: _invert,
                            icon: const Icon(Icons.swap_horiz),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 45,
                          child: buildFormatDropdown(
                            context,
                            _outputIndex,
                            dropItens,
                            (v) {
                              if (v != null) {
                                setState(() => _outputIndex = v);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Área de conversão (Column para mobile, Row para desktop)
                Expanded(
                  child: isWide
                      ? Row(
                          children: [
                            Expanded(
                              flex: 45,
                              child: buildTextField(controller: _inputCtrl),
                            ),
                            Expanded(
                              flex: 10,
                              child: Center(
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_forward),
                                  onPressed: _convert,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 45,
                              child: buildTextField(
                                controller: _outputCtrl,
                                readOnly: true,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Expanded(
                              flex: 45,
                              child: buildTextField(controller: _inputCtrl),
                            ),
                            Expanded(
                              flex: 10,
                              child: Center(
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_downward),
                                  onPressed: _convert,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 45,
                              child: buildTextField(
                                controller: _outputCtrl,
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
