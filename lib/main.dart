import 'package:flutter/material.dart';

void main() {
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
                  child: FormatConverterContainer(),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class MyAppState extends ChangeNotifier {
  var selectedIndex = 0;
}


class FormatConverterContainer extends StatefulWidget {
  const FormatConverterContainer({
    super.key,
  });

  @override
  State<FormatConverterContainer> createState() =>
      _FormatConverterContainerState();
}

class _FormatConverterContainerState extends State<FormatConverterContainer> {
  var _inputIndex = 0;
  var _outputIndex = 0;


  void _invert() {
    setState(() {
      var tmpIndex = _inputIndex;
      _inputIndex = _outputIndex;
      _outputIndex = tmpIndex;
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
                child:Row(
                children: [
                  Expanded(
                    flex: 45,
                    child: DropdownButton(
                      isExpanded: true,
                      value: _inputIndex,
                      items: [
                        DropdownMenuItem(value: 0, child: Text('JSON'),),
                        DropdownMenuItem(value: 1, child: Text('CSV'),), 
                        DropdownMenuItem(value: 2, child: Text('YAML'),),
                        DropdownMenuItem(value: 3, child: Text('XML'),),
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
                        DropdownMenuItem(value: 0, child: Text('JSON'),),
                        DropdownMenuItem(value: 1, child: Text('CSV'),), 
                        DropdownMenuItem(value: 2, child: Text('YAML'),),
                        DropdownMenuItem(value: 3, child: Text('XML'),),
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

            // Área principal: [TextField entrada] [Executar] [TextField saída (read-only)]
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 45,
                    child: Padding(
                      padding: EdgeInsets.all(8.0 ),
                      child: TextField(
                        controller: TextEditingController(text: _inputIndex.toString()),
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
                        onPressed: () { },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 45,
                    child: Padding(
                      padding: EdgeInsets.all(8.0 ),
                      child: TextField(
                        controller: TextEditingController(text: _outputIndex.toString()),
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