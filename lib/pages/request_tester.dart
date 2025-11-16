import 'package:fluru_tools/src/services/hdoc_request.dart';
import 'package:flutter/material.dart';


class RequestTesterPage extends StatefulWidget {
  const RequestTesterPage({
    super.key,
  });

  @override
  State<RequestTesterPage> createState() =>
      _RequestTesterPageState();
}

class _RequestTesterPageState extends State<RequestTesterPage> {
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

  void _makeRequest() async {
    var result = "";
    try{
      result = await makeRequest(_inputCtrl.text);
    } catch (e) {
      result = '$e';
    }
    setState(() {
      _outputCtrl.text = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Área principal: [TextField entrada] [Executar] [TextField saída (read-only)]
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 45,
                    child: Padding(
                      padding: EdgeInsets.all(8.0 ),
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
                        onPressed: () => _makeRequest(),
                      ),
                    ),
                  ),
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
