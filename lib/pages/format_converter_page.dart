import 'package:flutter/material.dart';
import 'package:fluru_tools/services/text_format_converters.dart';

class FormatConverterPage extends StatefulWidget {
  const FormatConverterPage({super.key});

  @override
  State<FormatConverterPage> createState() => _FormatConverterPageState();
}

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
    setState(() {
      try {
        _outputCtrl.text = convertTextFormat(
          _inputCtrl.text,
          _inputIndex,
          _outputIndex,
        );
      } catch (e) {
        _outputCtrl.text = '$e';
      }
    });
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
        if (constraints.maxWidth < 600) {
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
                            flex: 45,
                            child: DropdownButton(
                              isExpanded: true,
                              value: _inputIndex,
                              items: [
                                DropdownMenuItem(value: 0, child: Text('JSON')),
                                DropdownMenuItem(value: 1, child: Text('CSV')),
                                DropdownMenuItem(value: 2, child: Text('YAML')),
                                DropdownMenuItem(value: 3, child: Text('XML')),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _inputIndex = v);
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 10,
                            child: SizedBox(
                              child: IconButton(
                                onPressed: _invert,
                                icon: Icon(Icons.swap_horiz),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 45,
                            child: DropdownButton(
                              isExpanded: true,
                              value: _outputIndex,
                              items: [
                                DropdownMenuItem(value: 0, child: Text('JSON')),
                                DropdownMenuItem(value: 1, child: Text('CSV')),
                                DropdownMenuItem(value: 2, child: Text('YAML')),
                                DropdownMenuItem(value: 3, child: Text('XML')),
                              ],
                              onChanged: (v) {
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

                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 45,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _inputCtrl,
                              textAlignVertical: TextAlignVertical.top,
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
                        Expanded(
                          flex: 10,
                          child: Center(
                            child: IconButton(
                              icon: Icon(Icons.arrow_downward),
                              onPressed: () => _convert(),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 45,
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
                          flex: 45,
                          child: DropdownButton(
                            isExpanded: true,
                            value: _inputIndex,
                            items: [
                              DropdownMenuItem(value: 0, child: Text('JSON')),
                              DropdownMenuItem(value: 1, child: Text('CSV')),
                              DropdownMenuItem(value: 2, child: Text('YAML')),
                              DropdownMenuItem(value: 3, child: Text('XML')),
                            ],
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _inputIndex = v);
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 10,
                          child: SizedBox(
                            child: IconButton(
                              onPressed: _invert,
                              icon: Icon(Icons.swap_horiz),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 45,
                          child: DropdownButton(
                            isExpanded: true,
                            value: _outputIndex,
                            items: [
                              DropdownMenuItem(value: 0, child: Text('JSON')),
                              DropdownMenuItem(value: 1, child: Text('CSV')),
                              DropdownMenuItem(value: 2, child: Text('YAML')),
                              DropdownMenuItem(value: 3, child: Text('XML')),
                            ],
                            onChanged: (v) {
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
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 45,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _inputCtrl,
                            textAlignVertical: TextAlignVertical.top,
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
                      Expanded(
                        flex: 10,
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: () => _convert(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 45,
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
      },
    );
  }
}
