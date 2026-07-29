import 'package:flutter/material.dart';
import '../themes/theme_style.dart';
import '../themes/themeverse_generator.dart';
import '../extensions/color_extensions.dart';

/// Live In-App Theme Builder & Editor Widget.
class LiveThemeBuilder extends StatefulWidget {
  final ValueChanged<ThemeData>? onThemeChanged;

  const LiveThemeBuilder({super.key, this.onThemeChanged});

  @override
  State<LiveThemeBuilder> createState() => _LiveThemeBuilderState();
}

class _LiveThemeBuilderState extends State<LiveThemeBuilder> {
  final Color _seedColor = const Color(0xFF6750A4);
  ThemeStyle _selectedStyle = ThemeStyle.material3;
  Brightness _brightness = Brightness.light;

  late ThemeData _currentTheme;

  @override
  void initState() {
    super.initState();
    _rebuildTheme(notifyParent: false);
  }

  void _rebuildTheme({bool notifyParent = true}) {
    _currentTheme = ThemeVerse.generate(
      seedColor: _seedColor,
      style: _selectedStyle,
      brightness: _brightness,
    );
    if (notifyParent && widget.onThemeChanged != null) {
      widget.onThemeChanged!(_currentTheme);
    }
  }

  @override
  Widget build(BuildContext context) {
    final parentTheme = Theme.of(context);
    final colorScheme = parentTheme.colorScheme;

    return Theme(
      data: _currentTheme,
      child: Card(
        margin: const EdgeInsets.all(12.0),
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Live Theme Builder',
                      style: parentTheme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Toggle Theme Brightness',
                    icon: Icon(_brightness == Brightness.dark
                        ? Icons.light_mode
                        : Icons.dark_mode),
                    onPressed: () {
                      setState(() {
                        _brightness = _brightness == Brightness.dark
                            ? Brightness.light
                            : Brightness.dark;
                        _rebuildTheme(notifyParent: true);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Style Selector
              Text('Style Preset:', style: parentTheme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: ThemeStyle.values.map((style) {
                    final isSelected = style == _selectedStyle;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(style.name.toUpperCase()),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedStyle = style;
                              _rebuildTheme(notifyParent: true);
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // Live Preview Container
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _currentTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _currentTheme.colorScheme.outlineVariant),
                ),
                child: Column(
                  children: [
                    Text('Theme Component Preview', style: _currentTheme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Elevated'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: () {},
                            child: const Text('Filled'),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text('Outlined'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SelectableText(
                  'ThemeVerse.generate(seed: "${_seedColor.toHex()}", style: ThemeStyle.${_selectedStyle.name});',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'monospace',
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
