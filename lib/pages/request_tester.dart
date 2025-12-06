import 'package:fluru_tools/custom_alert_dialog.dart';
import 'package:fluru_tools/custom_widgets.dart';
import 'package:fluru_tools/helper/exceptions/requester_exceptions.dart';
import 'package:fluru_tools/l10n/app_localizations.dart';
import 'package:fluru_tools/services/hdoc_request.dart';
import 'package:flutter/material.dart';

class RequestTesterPage extends StatefulWidget {
  const RequestTesterPage({super.key});

  @override
  State<RequestTesterPage> createState() => _RequestTesterPageState();
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
    showLoadingDialog(context, AppLocalizations.of(context)!.processing);
    try {
      result = await makeRequest(_inputCtrl.text);
      if (mounted) {
        setState(() => _outputCtrl.text = result);
        Navigator.of(context).pop();
      }
    } on MissingBlockException catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        showErrorDialog(
          context,
          AppLocalizations.of(context)!.hdocExceptionMissingBlock(e.blockName),
        );
      }
    } on InvalidUrlException catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        showErrorDialog(
          context,
          AppLocalizations.of(context)!.hdocExceptionInvalidUrl(e.url),
        );
      }
    } on InvalidMethodException catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        showErrorDialog(
          context,
          AppLocalizations.of(context)!.hdocExceptionInvalidgMethod(e.method),
        );
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
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
                                  onPressed: _makeRequest,
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
                                  onPressed: _makeRequest,
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
