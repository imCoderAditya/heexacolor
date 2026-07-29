import 'package:flutter/material.dart';
import 'package:heexacolor/heexacolor.dart';

void main() {
  runApp(const ThemeVerseShowcaseApp());
}

class ThemeVerseShowcaseApp extends StatefulWidget {
  const ThemeVerseShowcaseApp({super.key});

  @override
  State<ThemeVerseShowcaseApp> createState() => _ThemeVerseShowcaseAppState();
}

class _ThemeVerseShowcaseAppState extends State<ThemeVerseShowcaseApp> {
  ThemeData _currentTheme = ThemeVerse.generate(
    seed: '#6750A4',
    style: ThemeStyle.material3,
  );

  void _updateTheme(ThemeData newTheme) {
    setState(() {
      _currentTheme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThemeVerse AI Design Engine',
      debugShowCheckedModeBanner: false,
      theme: _currentTheme,
      home: ThemeVerseShowcaseHome(onThemeChanged: _updateTheme),
    );
  }
}

class ThemeVerseShowcaseHome extends StatefulWidget {
  final ValueChanged<ThemeData> onThemeChanged;

  const ThemeVerseShowcaseHome({super.key, required this.onThemeChanged});

  @override
  State<ThemeVerseShowcaseHome> createState() => _ThemeVerseShowcaseHomeState();
}

class _ThemeVerseShowcaseHomeState extends State<ThemeVerseShowcaseHome> {
  int _activeNavIndex = 0;

  // Universal Color Parser state
  final TextEditingController _parserController = TextEditingController(
    text: '#6750A4',
  );
  Color _currentColor = const Color(0xFF6750A4);
  String? _parseError;

  // Token Exporter state
  String _exportFormat = 'CSS';

  final List<_NavDestinationData> _navDestinations = const [
    _NavDestinationData(
      title: 'Themes',
      icon: Icons.palette_rounded,
      activeIcon: Icons.palette,
    ),
    _NavDestinationData(
      title: 'Parser',
      icon: Icons.colorize_outlined,
      activeIcon: Icons.colorize,
    ),
    _NavDestinationData(
      title: 'Harmonies',
      icon: Icons.grid_view_rounded,
      activeIcon: Icons.grid_view,
    ),
    _NavDestinationData(
      title: 'Contrast',
      icon: Icons.accessibility_new_outlined,
      activeIcon: Icons.accessibility_new,
    ),
    _NavDestinationData(
      title: 'Effects',
      icon: Icons.auto_awesome_outlined,
      activeIcon: Icons.auto_awesome,
    ),
    _NavDestinationData(
      title: 'Export',
      icon: Icons.code_rounded,
      activeIcon: Icons.code,
    ),
    _NavDestinationData(
      title: 'DevTools',
      icon: Icons.build_circle_outlined,
      activeIcon: Icons.build_circle,
    ),
  ];

  @override
  void dispose() {
    _parserController.dispose();
    super.dispose();
  }

  void _onColorInputChanged(String input) {
    try {
      final color = input.toColor();
      setState(() {
        _currentColor = color;
        _parseError = null;
      });
      widget.onThemeChanged(
        ThemeVerse.fromSeed(color, brightness: Theme.of(context).brightness),
      );
    } catch (_) {
      setState(() {
        _parseError = 'Invalid color format';
      });
    }
  }

  String _getExportedContent(ColorScheme scheme) {
    switch (_exportFormat) {
      case 'CSS':
        return TokenExporter.toCSS(scheme);
      case 'Tailwind':
        return TokenExporter.toTailwind(scheme);
      case 'JSON':
        return TokenExporter.toJSON(scheme);
      case 'Figma':
        return TokenExporter.toFigma(scheme);
      default:
        return TokenExporter.toCSS(scheme);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final accessibilityReport = _currentColor.accessibilityReport(
      colorScheme.surface,
    );

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 18,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'ThemeVerse Engine',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface.withValues(alpha: 0.85),
        actions: [
          IconButton(
            tooltip: 'Toggle Dark/Light Mode',
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDark),
              ),
            ),
            onPressed: () {
              final newBrightness = isDark ? Brightness.light : Brightness.dark;
              widget.onThemeChanged(
                ThemeVerse.fromSeed(_currentColor, brightness: newBrightness),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _buildSelectedView(accessibilityReport, colorScheme, theme),
      ),

      // Overflow-proof Floating Glassmorphic Scrollable Navigation Bar
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: GlassContainer(
            height: 64,
            borderRadius: 32,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            baseColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            opacity: isDark ? 0.80 : 0.90,
            borderColor: colorScheme.outline.withValues(alpha: 0.2),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(_navDestinations.length, (index) {
                  final item = _navDestinations[index];
                  final isSelected = index == _activeNavIndex;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        setState(() {
                          _activeNavIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.35,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isSelected ? item.activeIcon : item.icon,
                              size: 18,
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? colorScheme.onPrimary
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedView(
    AccessibilityReport accessibilityReport,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    switch (_activeNavIndex) {
      case 0:
        return _buildThemesTab(theme, colorScheme);
      case 1:
        return _buildParserTab(theme, colorScheme, accessibilityReport);
      case 2:
        return _buildHarmoniesTab(theme, colorScheme);
      case 3:
        return _buildAccessibilityTab(theme, colorScheme, accessibilityReport);
      case 4:
        return _buildEffectsTab(theme, colorScheme);
      case 5:
        return _buildExportTab(theme, colorScheme);
      case 6:
      default:
        return _buildDevToolsTab(theme, colorScheme);
    }
  }

  // 1. AI Theme Styles & Moods View
  Widget _buildThemesTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      key: const ValueKey('ThemesTab'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroBanner(
            title: 'AI Theme Generator',
            subtitle:
                'Generate complete Flutter ThemeData from seed colors, design styles, or emotional moods.',
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 20),

          Text(
            'Design System Styles',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ThemeStyle.values.map((style) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    avatar: const Icon(Icons.style_outlined, size: 16),
                    label: Text(style.name.toUpperCase()),
                    onPressed: () {
                      widget.onThemeChanged(
                        ThemeVerse.generate(
                          style: style,
                          brightness: theme.brightness,
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'AI Emotional Mood Themes',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: Mood.values.map((mood) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    avatar: const Icon(Icons.emoji_emotions_outlined, size: 16),
                    label: Text(mood.name.toUpperCase()),
                    onPressed: () {
                      widget.onThemeChanged(
                        ThemeVerse.fromMood(mood, brightness: theme.brightness),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Universal Parser View
  Widget _buildParserTab(
    ThemeData theme,
    ColorScheme colorScheme,
    AccessibilityReport accessibilityReport,
  ) {
    return SingleChildScrollView(
      key: const ValueKey('ParserTab'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroBanner(
            title: 'Universal Color Parser',
            subtitle:
                'Parses Hex, RGB, HSL, CMYK, LAB, OKLAB, 140+ CSS Names, and Tailwind Colors in pure Dart.',
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 20),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _parserController,
                    decoration: InputDecoration(
                      labelText: 'Color Input String',
                      hintText: 'e.g. #FF5722, rgb(33,150,243), royalblue',
                      errorText: _parseError,
                      prefixIcon: const Icon(Icons.colorize),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: _onColorInputChanged,
                  ),
                  const SizedBox(height: 16),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 110,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _currentColor,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: _currentColor.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: FittedBox(
                        child: Text(
                          _currentColor.toHex(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: accessibilityReport.recommendedTextColor,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Derived Smart State Colors:',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildStateChip('Hover', _currentColor.hoverColor),
                      _buildStateChip('Pressed', _currentColor.pressedColor),
                      _buildStateChip('Disabled', _currentColor.disabledColor),
                      _buildStateChip('Selected', _currentColor.selectedColor),
                      _buildStateChip('Border', _currentColor.borderColor),
                      _buildStateChip('Shadow', _currentColor.shadowColor),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Harmonies & Palettes View
  Widget _buildHarmoniesTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      key: const ValueKey('HarmoniesTab'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroBanner(
            title: 'Color Harmonies & Palettes',
            subtitle:
                'Generate Complementary, Analogous, Triadic, Tetradic, Monochromatic, Tints, Shades, and Tones.',
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 20),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complementary Pair',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildColorBox(_currentColor, 'Base Color'),
                      const SizedBox(width: 8),
                      _buildColorBox(
                        _currentColor.complementary,
                        'Complementary',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Triadic Harmony',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: _currentColor.triadic().map((c) {
                      return Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: c,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tints (Lightness Steps)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: _currentColor.tints(count: 6).map((c) {
                      return Expanded(
                        child: Container(
                          height: 30,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: c,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Shades (Darkness Steps)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: _currentColor.shades(count: 6).map((c) {
                      return Expanded(
                        child: Container(
                          height: 30,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: c,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Accessibility Studio View
  Widget _buildAccessibilityTab(
    ThemeData theme,
    ColorScheme colorScheme,
    AccessibilityReport accessibilityReport,
  ) {
    return SingleChildScrollView(
      key: const ValueKey('AccessibilityTab'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroBanner(
            title: 'WCAG 2.1 & APCA Studio',
            subtitle:
                'Real-time WCAG 2.1 AA/AAA compliance checks, contrast ratios, and APCA scores.',
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 20),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Contrast Ratio'),
                    subtitle: const Text(
                      'Relative luminance contrast against surface',
                    ),
                    trailing: Text(
                      '${accessibilityReport.contrastRatio.toStringAsFixed(2)}:1',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      _buildStatusBadge(
                        'WCAG AA',
                        accessibilityReport.isWcagAANormalText,
                      ),
                      _buildStatusBadge(
                        'WCAG AAA',
                        accessibilityReport.isWcagAAANormalText,
                      ),
                      _buildStatusBadge(
                        'APCA: ${accessibilityReport.apcaScore.toStringAsFixed(0)}',
                        accessibilityReport.apcaScore.abs() > 45,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 5. Effects & Gradients View
  Widget _buildEffectsTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      key: const ValueKey('EffectsTab'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroBanner(
            title: 'Glassmorphism & GPU Gradients',
            subtitle:
                'Backdrop blur glass containers, Aurora, Metallic, and Mesh multi-color GPU gradients.',
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 20),

          GlassContainer(
            height: 120,
            padding: const EdgeInsets.all(16),
            baseColor: colorScheme.primary,
            opacity: 0.2,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.blur_on_rounded, size: 32),
                  SizedBox(height: 6),
                  Text(
                    'GlassContainer Backdrop Blur',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: GradientEngine.aurora(
                      colors: [_currentColor, colorScheme.secondary],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Aurora Gradient',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: GradientEngine.metallic(
                      seedColor: const Color(0xFFD4AF37),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Metallic Gold',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 6. Token Exporter View
  Widget _buildExportTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      key: const ValueKey('ExportTab'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroBanner(
            title: 'Design Token Exporter',
            subtitle:
                'Export your design system tokens instantly to CSS Variables, Tailwind, JSON, or Figma.',
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 20),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'CSS', label: Text('CSS')),
                        ButtonSegment(
                          value: 'Tailwind',
                          label: Text('Tailwind'),
                        ),
                        ButtonSegment(value: 'JSON', label: Text('JSON')),
                        ButtonSegment(value: 'Figma', label: Text('Figma')),
                      ],
                      selected: {_exportFormat},
                      onSelectionChanged: (val) {
                        setState(() {
                          _exportFormat = val.first;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(
                      _getExportedContent(colorScheme),
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 7. Live Builder & DevTools View
  Widget _buildDevToolsTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      key: const ValueKey('DevToolsTab'),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
      child: Column(
        children: [
          LiveThemeBuilder(onThemeChanged: widget.onThemeChanged),
          ThemeVerseDevTools(
            inspectColor: colorScheme.primary,
            backgroundColor: colorScheme.surface,
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner({
    required String title,
    required String subtitle,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: GradientEngine.aurora(
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget _buildColorBox(Color color, String label) {
    return Expanded(
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String label, bool passed) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          passed ? Icons.check_circle : Icons.cancel,
          color: passed ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}

class _NavDestinationData {
  final String title;
  final IconData icon;
  final IconData activeIcon;

  const _NavDestinationData({
    required this.title,
    required this.icon,
    required this.activeIcon,
  });
}
