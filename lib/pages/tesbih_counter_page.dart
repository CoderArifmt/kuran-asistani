import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';

class TesbihCounterPage extends StatefulWidget {
  const TesbihCounterPage({super.key});

  @override
  State<TesbihCounterPage> createState() => _TesbihCounterPageState();
}

class _TesbihCounterPageState extends State<TesbihCounterPage> {
  int _count = 0;
  int _target = 33;
  String _selectedZikir = 'Sübhanallah';
  bool _vibrateOnTap = true;

  List<String> _getZikirOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      l10n.subhanallah,
      l10n.alhamdulillah,
      l10n.allahuEkber,
      l10n.laIlaheIllallah,
      l10n.estagfirullah,
      l10n.subhanallahiVeBihamdihi,
      l10n.laHavle,
    ];
  }

  final List<int> _targetOptions = [33, 99, 100, 500, 1000];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = prefs.getInt('tesbih_count') ?? 0;
      _target = prefs.getInt('tesbih_target') ?? 33;
      _selectedZikir = prefs.getString('tesbih_zikir') ?? 'Sübhanallah';
      _vibrateOnTap = prefs.getBool('tesbih_vibrate') ?? true;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tesbih_count', _count);
    await prefs.setInt('tesbih_target', _target);
    await prefs.setString('tesbih_zikir', _selectedZikir);
    await prefs.setBool('tesbih_vibrate', _vibrateOnTap);
  }

  void _incrementCount() {
    setState(() {
      _count++;
      if (_count >= _target) {
        // Hedefe ulaşıldı - titreşim
        if (_vibrateOnTap) {
          HapticFeedback.heavyImpact();
        }
      } else {
        if (_vibrateOnTap) {
          HapticFeedback.lightImpact();
        }
      }
    });
    _savePreferences();
  }

  void _resetCount() {
    setState(() {
      _count = 0;
    });
    _savePreferences();
    if (_vibrateOnTap) {
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = _count / _target;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 56,
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).tasbihCounter,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Boşluk - simetri için
                ],
              ),
            ),

            // Content
            Expanded(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 480),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Zikir Text
                      Text(
                        _selectedZikir,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF14B866),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // Progress Ring
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 280,
                            height: 280,
                            child: CircularProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              strokeWidth: 12,
                              backgroundColor: isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color(0xFF14B866),
                              ),
                            ),
                          ),
                          // Counter Display
                          GestureDetector(
                            onTap: _incrementCount,
                            child: Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(
                                  0xFF14B866,
                                ).withValues(alpha: 0.1),
                                border: Border.all(
                                  color: const Color(0xFF14B866),
                                  width: 3,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$_count',
                                    style: TextStyle(
                                      fontSize: 64,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF14B866),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${AppLocalizations.of(context).target}: $_target',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                  if (_count >= _target)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Icon(
                                        Icons.check_circle,
                                        color: const Color(0xFF14B866),
                                        size: 32,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Reset Button
                          ElevatedButton.icon(
                            onPressed: _resetCount,
                            icon: const Icon(Icons.refresh, size: 20),
                            label: Text(AppLocalizations.of(context).reset),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200,
                              foregroundColor: isDark
                                  ? Colors.white
                                  : Colors.grey.shade800,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Increment Button
                          ElevatedButton.icon(
                            onPressed: _incrementCount,
                            icon: const Icon(Icons.add, size: 20),
                            label: Text(AppLocalizations.of(context).increment),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF14B866),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Settings Button
                      OutlinedButton.icon(
                        onPressed: () {
                          _showSettingsBottomSheet(context);
                        },
                        icon: const Icon(Icons.tune, size: 20),
                        label: Text(AppLocalizations.of(context).settings),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF14B866),
                          side: const BorderSide(
                            color: Color(0xFF14B866),
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).tasbihSettings,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Zikir Selection
                  Text(
                    AppLocalizations.of(context).selectZikr,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _getZikirOptions(context).map((zikir) {
                      final selected = _selectedZikir == zikir;
                      return ChoiceChip(
                        label: Text(zikir),
                        selected: selected,
                        onSelected: (bool value) {
                          setModalState(() {
                            setState(() {
                              _selectedZikir = zikir;
                              _savePreferences();
                            });
                          });
                        },
                        selectedColor: const Color(0xFF14B866),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Target Selection
                  Text(
                    '${AppLocalizations.of(context).target}:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _targetOptions.map((target) {
                      final selected = _target == target;
                      return ChoiceChip(
                        label: Text('$target'),
                        selected: selected,
                        onSelected: (bool value) {
                          setModalState(() {
                            setState(() {
                              _target = target;
                              _savePreferences();
                            });
                          });
                        },
                        selectedColor: const Color(0xFF14B866),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Vibrate Toggle
                  SwitchListTile(
                    title: Text(AppLocalizations.of(context).vibration),
                    subtitle: Text(AppLocalizations.of(context).vibrateOnCount),
                    value: _vibrateOnTap,
                    onChanged: (bool value) {
                      setModalState(() {
                        setState(() {
                          _vibrateOnTap = value;
                          _savePreferences();
                        });
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
