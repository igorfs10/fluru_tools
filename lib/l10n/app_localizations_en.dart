// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeTitle => 'Home';

  @override
  String get jsonConverterTitle => 'Text type Convert';

  @override
  String get fileVerifierTitle => 'File Verifier';

  @override
  String get requesterTitle => 'HTTP Requester';

  @override
  String get base64EncoderTitle => 'Base64 En/Decoder';

  @override
  String get webVersionTitle => 'Web Version';

  @override
  String get downloadAppTitle => 'Download Desktop App';

  @override
  String get jsonConverterDescription =>
      'Convert and format JSON/CSV/YAML/XML data easily.';

  @override
  String get fileVerifierDescription =>
      'Verify the integrity of your files using MD5, SHA-1 or SHA-256.';

  @override
  String get requesterDescription =>
      'Send and test HTTP requests with ease using HDOC format.';

  @override
  String get base64EncoderDescription =>
      'Encode and decode Base64 strings and files quickly.';

  @override
  String get webVersionDescription => 'Access the web version of Fluru Tools.';

  @override
  String get downloadAppDescription =>
      'Download the desktop application for Fluru Tools.';

  @override
  String get quickAccess => 'Quick Access';

  @override
  String get appDescription =>
      'A set of tools to help developers and tech enthusiasts with everyday tasks.';

  @override
  String get openFile => 'Open File';

  @override
  String get saveFile => 'Save File';
}
