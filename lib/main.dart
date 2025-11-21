import 'package:fluru_tools/pages/base64_page.dart';
import 'package:fluru_tools/pages/file_verifier_page.dart';
import 'package:fluru_tools/pages/format_converter_page.dart';
import 'package:fluru_tools/pages/request_tester.dart';
import 'package:fluru_tools/pages/start_page.dart';
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';


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
        colorScheme: .fromSeed(seedColor: Colors.lightBlueAccent),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
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
        page = StartPage(
          onSelectIndex: (i) => setState(() => selectedIndex = i),
        );
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
      case 4:
        page = Base64Page();
        break;
      default:
        page = StartPage(
          onSelectIndex: (i) => setState(() => selectedIndex = i),
        );
    }

    return PopScope(
      canPop: selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        if (selectedIndex != 0) {
          setState(() {
            selectedIndex = 0;
          });
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Scaffold(
              body: Column(
                children: [
                  SafeArea(
                    child: NavigationBar(
                      destinations: [
                        NavigationDestination(
                          icon: Icon(Icons.home),
                          label: AppLocalizations.of(context)!.homeTitle,
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.data_object),
                          label: AppLocalizations.of(context)!.jsonConverterTitle,
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.insert_drive_file),
                          label: AppLocalizations.of(context)!.fileVerifierTitle,
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.integration_instructions),
                          label: AppLocalizations.of(context)!.requesterTitle,
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.transform),
                          label: AppLocalizations.of(context)!.base64EncoderTitle,
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
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 900,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text(AppLocalizations.of(context)!.homeTitle),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.data_object),
                        label: Text(AppLocalizations.of(context)!.jsonConverterTitle),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.insert_drive_file),
                        label: Text(AppLocalizations.of(context)!.fileVerifierTitle),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.integration_instructions),
                        label: Text(AppLocalizations.of(context)!.requesterTitle),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.transform),
                        label: Text(AppLocalizations.of(context)!.base64EncoderTitle),
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
        },
      ),
    );
  }
}
