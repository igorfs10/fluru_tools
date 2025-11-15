import 'package:fluru_tools/pages/file_verifier_page.dart';
import 'package:fluru_tools/pages/format_converter_page.dart';
import 'package:fluru_tools/pages/request_tester.dart';
import 'package:flutter/material.dart';
import 'package:fluru_tools/pages/empty_page.dart';
import 'package:fluru_tools/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluru Tools',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.lightBlueAccent),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = EmptyPage();
        break;
      case 1:
        page = FormatConverterPage();
        break;
      case 2:
        page = FileVerifierPage();
        break;
      case 3:
        page = RequestTesterPage();
        break;
      default:
        page = EmptyPage();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.data_object),
                      label: Text('Text formart converter'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.insert_drive_file),
                      label: Text('File Verifier'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.integration_instructions),
                      label: Text('Request Tester'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
