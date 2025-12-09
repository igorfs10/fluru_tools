import 'package:fluru_tools/pages/base64_page.dart';
import 'package:fluru_tools/pages/csv_visualizer_page.dart';
import 'package:fluru_tools/pages/file_verifier_page.dart';
import 'package:fluru_tools/pages/format_converter_page.dart';
import 'package:fluru_tools/pages/request_tester.dart';
import 'package:fluru_tools/pages/start_page.dart';
import 'package:fluru_tools/theme_state.dart';
import 'package:flutter/material.dart';
import 'locale_state.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carregar preferências salvas
  await Future.wait([loadSavedTheme(), loadSavedLocale()]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appLocale,
      builder: (context, locale, _) {
        return ValueListenableBuilder(
          valueListenable: appTheme,
          builder: (context, theme, _) {
            return MaterialApp(
              title: 'Fluru Tools',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.lightBlueAccent,
                  brightness: Brightness.light,
                ),
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.lightBlueAccent,
                  brightness: Brightness.dark,
                ),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: locale,
              themeMode: theme,
              home: const MyHomePage(),
            );
          },
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
    _NavItem(
      Icons.table_chart,
      (ctx) => AppLocalizations.of(ctx)!.csvVisualizerTitle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Widget page = switch (selectedIndex) {
      1 => const FormatConverterPage(),
      2 => const FileVerifierPage(),
      3 => const RequestTesterPage(),
      4 => const Base64Page(),
      5 => const CsvVisualizerPage(),
      _ => StartPage(onSelectIndex: (i) => setState(() => selectedIndex = i)),
    };

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
      child: Scaffold(
        appBar: AppBar(
          title: Text(_navItems[selectedIndex].label(context)),
          actions: [
            Builder(
              builder: (context) {
                if (selectedIndex != 0) {
                  return IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              SizedBox(
                height: 65,
                child: DrawerHeader(
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
        body: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: page,
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String Function(BuildContext) label;
  const _NavItem(this.icon, this.label);
}
