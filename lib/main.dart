import 'package:fluru_tools/pages/base64_page.dart';
import 'package:fluru_tools/pages/file_verifier_page.dart';
import 'package:fluru_tools/pages/format_converter_page.dart';
import 'package:fluru_tools/pages/request_tester.dart';
import 'package:fluru_tools/pages/start_page.dart';
import 'package:flutter/material.dart';
import 'locale_state.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: appLocale,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'Fluru Tools',
          theme: ThemeData(
            colorScheme: .fromSeed(seedColor: Colors.lightBlueAccent),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          home: MyHomePage(),
        );
      },
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

  final List<_NavItem> _navItems = [
    _NavItem(Icons.home, (ctx) => AppLocalizations.of(ctx)!.homeTitle),
    _NavItem(
      Icons.data_object,
      (ctx) => AppLocalizations.of(ctx)!.jsonConverterTitle,
    ),
    _NavItem(
      Icons.insert_drive_file,
      (ctx) => AppLocalizations.of(ctx)!.fileVerifierTitle,
    ),
    _NavItem(
      Icons.integration_instructions,
      (ctx) => AppLocalizations.of(ctx)!.requesterTitle,
    ),
    _NavItem(
      Icons.transform,
      (ctx) => AppLocalizations.of(ctx)!.base64EncoderTitle,
    ),
  ];

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
              appBar: AppBar(
                title: Text(_navItems[selectedIndex].label(context)),
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Center(
                        child: Text(
                          'Fluru Tools',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    for (int i = 0; i < _navItems.length; i++)
                      ListTile(
                        leading: Icon(_navItems[i].icon),
                        title: Text(_navItems[i].label(context)),
                        selected: selectedIndex == i,
                        onTap: () {
                          setState(() {
                            selectedIndex = i;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                  ],
                ),
              ),
              body: Column(
                children: [
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
                        label: Text(
                          AppLocalizations.of(context)!.jsonConverterTitle,
                        ),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.insert_drive_file),
                        label: Text(
                          AppLocalizations.of(context)!.fileVerifierTitle,
                        ),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.integration_instructions),
                        label: Text(
                          AppLocalizations.of(context)!.requesterTitle,
                        ),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.transform),
                        label: Text(
                          AppLocalizations.of(context)!.base64EncoderTitle,
                        ),
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

class _NavItem {
  final IconData icon;
  final String Function(BuildContext) label;
  const _NavItem(this.icon, this.label);
}
