import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import 'dart:convert';

class PrayerJournalPage extends StatefulWidget {
  const PrayerJournalPage({super.key});

  @override
  State<PrayerJournalPage> createState() => _PrayerJournalPageState();
}

class _PrayerJournalPageState extends State<PrayerJournalPage> {
  List<Map<String, dynamic>> _prayers = [];

  @override
  void initState() {
    super.initState();
    _loadPrayers();
  }

  Future<void> _loadPrayers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('prayer_journal');
    if (jsonStr != null) {
      final List<dynamic> decoded = json.decode(jsonStr);
      setState(() {
        _prayers = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    }
  }

  Future<void> _savePrayers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('prayer_journal', json.encode(_prayers));
  }

  void _addPrayer() {
    showDialog(
      context: context,
      builder: (context) => _PrayerDialog(
        onSave: (title, content) {
          setState(() {
            _prayers.insert(0, {
              'id': DateTime.now().millisecondsSinceEpoch,
              'title': title,
              'content': content,
              'date': DateTime.now().toIso8601String(),
              'answered': false,
            });
          });
          _savePrayers();
        },
      ),
    );
  }

  void _editPrayer(int index) {
    final prayer = _prayers[index];
    showDialog(
      context: context,
      builder: (context) => _PrayerDialog(
        initialTitle: prayer['title'],
        initialContent: prayer['content'],
        onSave: (title, content) {
          setState(() {
            _prayers[index]['title'] = title;
            _prayers[index]['content'] = content;
          });
          _savePrayers();
        },
      ),
    );
  }

  void _toggleAnswered(int index) {
    setState(() {
      _prayers[index]['answered'] = !_prayers[index]['answered'];
    });
    _savePrayers();
  }

  void _deletePrayer(int index) {
    setState(() {
      _prayers.removeAt(index);
    });
    _savePrayers();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
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
                      AppLocalizations.of(context).prayerJournal,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: _prayers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            size: 80,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.3)
                                : Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context).noPrayersYet,
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.5)
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _prayers.length,
                      itemBuilder: (context, index) {
                        final prayer = _prayers[index];
                        return _PrayerCard(
                          prayer: prayer,
                          isDark: isDark,
                          onToggle: () => _toggleAnswered(index),
                          onEdit: () => _editPrayer(index),
                          onDelete: () => _deletePrayer(index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPrayer,
        backgroundColor: const Color(0xFF14B866),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _PrayerCard extends StatelessWidget {
  const _PrayerCard({
    required this.prayer,
    required this.isDark,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Map<String, dynamic> prayer;
  final bool isDark;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isAnswered = prayer['answered'] as bool;
    final date = DateTime.parse(prayer['date'] as String);
    final dateStr = '${date.day}/${date.month}/${date.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isAnswered
            ? const Color(0xFF14B866).withValues(alpha: 0.1)
            : (isDark ? const Color(0xFF1C2C24) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: isAnswered
            ? Border.all(color: const Color(0xFF14B866), width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              prayer['title'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isAnswered ? const Color(0xFF14B866) : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  prayer['content'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.grey,
                  ),
                ),
              ],
            ),
            trailing: isAnswered
                ? const Icon(Icons.check_circle, color: Color(0xFF14B866))
                : null,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: onToggle,
                  icon: Icon(isAnswered ? Icons.undo : Icons.check, size: 18),
                  label: Text(
                    isAnswered
                        ? AppLocalizations.of(context).undo
                        : AppLocalizations.of(context).answered,
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF14B866),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 20),
                  color: isDark ? Colors.white70 : Colors.grey.shade600,
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 20),
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerDialog extends StatefulWidget {
  const _PrayerDialog({
    this.initialTitle,
    this.initialContent,
    required this.onSave,
  });

  final String? initialTitle;
  final String? initialContent;
  final Function(String title, String content) onSave;

  @override
  State<_PrayerDialog> createState() => _PrayerDialogState();
}

class _PrayerDialogState extends State<_PrayerDialog> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(
        widget.initialTitle == null
            ? localizations.newPrayer
            : localizations.editPrayer,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: localizations.title,
              border: const OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(
              labelText: localizations.prayer,
              border: const OutlineInputBorder(),
            ),
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(localizations.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _contentController.text.isNotEmpty) {
              widget.onSave(_titleController.text, _contentController.text);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF14B866),
            foregroundColor: Colors.white,
          ),
          child: Text(localizations.save),
        ),
      ],
    );
  }
}
