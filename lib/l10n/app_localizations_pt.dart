// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get homeTitle => 'Início';

  @override
  String get jsonConverterTitle => 'Conversor de texto';

  @override
  String get fileVerifierTitle => 'Verificador de Arquivos';

  @override
  String get requesterTitle => 'Requisitador HTTP';

  @override
  String get base64EncoderTitle => 'Base64 En/Decoder';

  @override
  String get webVersionTitle => 'Versão Web';

  @override
  String get downloadAppTitle => 'Download Versão Desktop';

  @override
  String get sourceCodeTitle => 'Código Fonte';

  @override
  String get jsonConverterDescription =>
      'Converte e formata dados JSON/CSV/YAML/XML facilmente.';

  @override
  String get fileVerifierDescription =>
      'Verifique a integridade dos seus arquivos usando MD5, SHA-1 ou SHA-256.';

  @override
  String get requesterDescription =>
      'Envie e teste requisições HTTP facilmente usando o formato HDOC.';

  @override
  String get base64EncoderDescription =>
      'Codifique e decodifique strings e arquivos Base64 rapidamente.';

  @override
  String get webVersionDescription => 'Acesse a versão web do Fluru Tools.';

  @override
  String get downloadAppDescription => 'Baixe a versão desktop do Fluru Tools.';

  @override
  String get sourceCodeDescription =>
      'Explore o código fonte do Fluru Tools no GitHub.';

  @override
  String by(Object author) {
    return 'Por $author';
  }

  @override
  String developedBy(Object author) {
    return 'Desenvolvido por $author';
  }

  @override
  String get quickAccess => 'Acesso Rápido';

  @override
  String get appDescription =>
      'Um conjunto de ferramentas para ajudar desenvolvedores e entusiastas de tecnologia com tarefas diárias.';

  @override
  String get hereDocRequestExample => 'Exemplo de requisição HDOC:';

  @override
  String get openFile => 'Abrir Arquivo';

  @override
  String get saveFile => 'Salvar Arquivo';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get homeTitle => 'Início';

  @override
  String get jsonConverterTitle => 'Conversor de texto';

  @override
  String get fileVerifierTitle => 'Verificador de Arquivos';

  @override
  String get requesterTitle => 'Requisitador HTTP';

  @override
  String get base64EncoderTitle => 'Base64 En/Decoder';

  @override
  String get webVersionTitle => 'Versão Web';

  @override
  String get downloadAppTitle => 'Download Versão Desktop';

  @override
  String get sourceCodeTitle => 'Código Fonte';

  @override
  String get jsonConverterDescription =>
      'Converte e formata dados JSON/CSV/YAML/XML facilmente.';

  @override
  String get fileVerifierDescription =>
      'Verifique a integridade dos seus arquivos usando MD5, SHA-1 ou SHA-256.';

  @override
  String get requesterDescription =>
      'Envie e teste requisições HTTP facilmente usando o formato HDOC.';

  @override
  String get base64EncoderDescription =>
      'Codifique e decodifique strings e arquivos Base64 rapidamente.';

  @override
  String get webVersionDescription => 'Acesse a versão web do Fluru Tools.';

  @override
  String get downloadAppDescription => 'Baixe a versão desktop do Fluru Tools.';

  @override
  String get sourceCodeDescription =>
      'Explore o código fonte do Fluru Tools no GitHub.';

  @override
  String by(Object author) {
    return 'Por $author';
  }

  @override
  String developedBy(Object author) {
    return 'Desenvolvido por $author';
  }

  @override
  String get quickAccess => 'Acesso Rápido';

  @override
  String get appDescription =>
      'Um conjunto de ferramentas para ajudar desenvolvedores e entusiastas de tecnologia com tarefas diárias.';

  @override
  String get hereDocRequestExample => 'Exemplo de requisição HDOC:';

  @override
  String get openFile => 'Abrir Arquivo';

  @override
  String get saveFile => 'Salvar Arquivo';
}
