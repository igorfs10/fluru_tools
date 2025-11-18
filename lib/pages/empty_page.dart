import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmptyPage extends StatelessWidget {
  final void Function(int) onSelectIndex;
  const EmptyPage({super.key, required this.onSelectIndex});

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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: color.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.build_circle_outlined, size: 40, color: color.onPrimaryContainer),
                          const SizedBox(width: 12),
                          Text(
                            'Fluru Tools',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: color.onPrimaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Utilitários para conversão de formatos, verificação de arquivos e testes de requisições.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: color.onPrimaryContainer,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          FilledButton.icon(
                            onPressed: () => onSelectIndex(1),
                            icon: const Icon(Icons.data_object),
                            label: const Text('Abrir JSON Converter'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => onSelectIndex(2),
                            icon: const Icon(Icons.insert_drive_file),
                            label: const Text('Abrir File Verifier'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => onSelectIndex(3),
                            icon: const Icon(Icons.integration_instructions),
                            label: const Text('Abrir Request Tester'),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () => _openExternal('https://igorfs10.github.io/fluru_tools/'),
                            icon: const Icon(Icons.public),
                            label: const Text('Versão Web'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => _openExternal('https://github.com/igorfs10/fluru_tools/releases/latest'),
                            icon: const Icon(Icons.download),
                            label: const Text('Download Desktop'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Grid de atalhos
                Text(
                  'Acessos rápidos',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 140,
                  ),
                  children: [
                    _ToolCard(
                      icon: Icons.data_object,
                      title: 'JSON / CSV / YAML / XML',
                      subtitle: 'Converter e "pretty print" entre formatos',
                      color: color.primary,
                      onTap: () => onSelectIndex(1),
                    ),
                    _ToolCard(
                      icon: Icons.insert_drive_file,
                      title: 'Verificador de Arquivos',
                      subtitle: 'MD5, SHA-1, SHA-256 de arquivos locais',
                      color: color.secondary,
                      onTap: () => onSelectIndex(2),
                    ),
                    _ToolCard(
                      icon: Icons.integration_instructions,
                      title: 'Request Tester (Heredoc)',
                      subtitle: 'Monte requisições HTTP com blocos <<METHOD/URL/HEADERS/BODY>>',
                      color: color.tertiary,
                      onTap: () => onSelectIndex(3),
                    ),
                    _ToolCard(
                      icon: Icons.public,
                      title: 'Versão Web',
                      subtitle: 'Abrir no navegador (GitHub Pages)',
                      color: color.primary,
                      onTap: () => _openExternal('https://igorfs10.github.io/fluru_tools/'),
                    ),
                    _ToolCard(
                      icon: Icons.download,
                      title: 'Download Desktop',
                      subtitle: 'Último release no GitHub',
                      color: color.secondary,
                      onTap: () => _openExternal('https://github.com/igorfs10/fluru_tools/releases/latest'),
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
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
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

// (removido _TipTile não utilizado)