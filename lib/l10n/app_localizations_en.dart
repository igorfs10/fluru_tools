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
  String get csvVisualizerTitle => 'CSV Visualizer';

  @override
  String get webVersionTitle => 'Web Version';

  @override
  String get downloadAppTitle => 'Download Desktop App';

  @override
  String get sourceCodeTitle => 'Source Code';

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
  String get csvVisualizerDescription =>
      'Visualize and analyze CSV data with customizable delimiters.';

  @override
  String get webVersionDescription => 'Access the web version of Fluru Tools.';

  @override
  String get downloadAppDescription =>
      'Download the desktop application for Fluru Tools.';

  @override
  String get sourceCodeDescription =>
      'Explore the source code of Fluru Tools on GitHub.';

  @override
  String developedBy(Object author) {
    return 'Developed by $author';
  }

  @override
  String get quickAccess => 'Quick Access';

  @override
  String get appDescription =>
      'A set of tools to help developers and tech enthusiasts with everyday tasks.';

  @override
  String get hereDocRequestExample => 'HDOC request example:';

  @override
  String get hereDocRequestInfo =>
      'Required blocks: METHOD, URL. Supported blocks: HEADERS, BODY.';

  @override
  String get hereDocRequestCopy => 'Copy HDOC Example';

  @override
  String get hereDocRequestCopied => 'HDOC Example Copied to Clipboard';

  @override
  String get openFile => 'Open File';

  @override
  String get saveFile => 'Save File';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get processing => 'Processing...';

  @override
  String get base64FileSizeError => 'File size exceeds 20MB limit.';

  @override
  String latestVersion(Object version) {
    return 'Latest: v$version';
  }

  @override
  String hdocExceptionInvalidgMethod(Object method) {
    return 'Invalid HTTP Method. $method';
  }

  @override
  String hdocExceptionMissingBlock(Object blockName) {
    return 'Missing $blockName block.';
  }

  @override
  String hdocExceptionInvalidUrl(Object url) {
    return 'Invalid URL format. $url';
  }

  @override
  String get delimiter => 'Delimiter';
}
