import 'package:fluru_tools/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class StartPage extends StatelessWidget {
  final void Function(int) onSelectIndex;
  const StartPage({super.key, required this.onSelectIndex});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          final isMedium = constraints.maxWidth >= 640;
          final crossAxisCount = isWide ? 3 : (isMedium ? 2 : 1);

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: color.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.build_circle_outlined,
                              size: 40,
                              color: color.onPrimaryContainer,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Fluru Tools',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                color: color.onPrimaryContainer,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                      FutureBuilder<PackageInfo>(
                                        future: PackageInfo.fromPlatform(),
                                        builder: (context, snapshot) {
                                          final version =
                                              snapshot.data?.version ?? '...';
                                          final buildNumber =
                                              snapshot.data?.buildNumber ?? '';
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: color.onPrimaryContainer
                                                  .withValues(alpha: .08),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              'v$version+$buildNumber',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium
                                                  ?.copyWith(
                                                    color: color
                                                        .onPrimaryContainer,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!
                              .appDescription,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: color.onPrimaryContainer),
                        ),
                        SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            FilledButton.icon(
                              onPressed: () => onSelectIndex(1),
                              icon: Icon(Icons.data_object),
                              label: Text(
                                AppLocalizations.of(
                                  context,
                                )!.jsonConverterTitle,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => onSelectIndex(2),
                              icon: Icon(Icons.insert_drive_file),
                              label: Text(
                                AppLocalizations.of(context)!.fileVerifierTitle,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => onSelectIndex(3),
                              icon: Icon(Icons.integration_instructions),
                              label: Text(
                                AppLocalizations.of(context)!.requesterTitle,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => onSelectIndex(4),
                              icon: Icon(Icons.transform),
                              label: Text(
                                AppLocalizations.of(
                                  context,
                                )!.base64EncoderTitle,
                              ),
                            ),
                            SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () => _openExternal(
                                'https://igorfs10.github.io/fluru_tools/',
                              ),
                              icon: Icon(Icons.public),
                              label: Text(
                                AppLocalizations.of(context)!.webVersionTitle,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _openExternal(
                                'https://github.com/igorfs10/fluru_tools/releases/latest',
                              ),
                              icon: Icon(Icons.download),
                              label: Text(
                                AppLocalizations.of(context)!.downloadAppTitle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Grid de atalhos
                  Text(
                    AppLocalizations.of(context)!.quickAccess,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  GridView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 140,
                    ),
                    children: [
                      _ToolCard(
                        icon: Icons.data_object,
                        title: AppLocalizations.of(context)!.jsonConverterTitle,
                        subtitle: AppLocalizations.of(context)!
                            .jsonConverterDescription,
                        color: color.primary,
                        onTap: () => onSelectIndex(1),
                      ),
                      _ToolCard(
                        icon: Icons.insert_drive_file,
                        title: AppLocalizations.of(context)!.fileVerifierTitle,
                        subtitle: AppLocalizations.of(context)!
                            .fileVerifierDescription,
                        color: color.secondary,
                        onTap: () => onSelectIndex(2),
                      ),
                      _ToolCard(
                        icon: Icons.integration_instructions,
                        title: AppLocalizations.of(context)!.requesterTitle,
                        subtitle: AppLocalizations.of(context)!
                            .requesterDescription,
                        color: color.tertiary,
                        onTap: () => onSelectIndex(3),
                      ),
                      _ToolCard(
                        icon: Icons.transform,
                        title: AppLocalizations.of(context)!.base64EncoderTitle,
                        subtitle: AppLocalizations.of(context)!
                            .base64EncoderDescription,
                        color: color.error,
                        onTap: () => onSelectIndex(4),
                      ),
                      _ToolCard(
                        icon: Icons.public,
                        title: AppLocalizations.of(context)!.webVersionTitle,
                        subtitle: AppLocalizations.of(context)!
                            .webVersionDescription,
                        color: color.primary,
                        onTap: () => _openExternal(
                          'https://igorfs10.github.io/fluru_tools/',
                        ),
                      ),
                      _ToolCard(
                        icon: Icons.download,
                        title: AppLocalizations.of(context)!.downloadAppTitle,
                        subtitle: AppLocalizations.of(context)!
                            .downloadAppDescription,
                        color: color.secondary,
                        onTap: () => _openExternal(
                          'https://github.com/igorfs10/fluru_tools/releases/latest',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _openExternal(String url) async {
  final uri = Uri.parse(url);
  // Ignorar resultado; em falha poderia-se mostrar snackbar via global navigator key
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
