import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/utils/category_colors.dart';
import 'package:expense_tracker/utils/category_icons.dart';
import 'package:flutter/material.dart';

class CategoryFormScreen extends StatefulWidget {
  const CategoryFormScreen({super.key, this.category});

  final Category? category;

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String _iconKey;
  late int _colorValue;

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    _nameController = TextEditingController(text: category?.name);
    _iconKey = category?.iconKey ?? categoryIcons.keys.first;
    _colorValue = category?.colorValue ?? categoryColors.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      Category(
        id: widget.category?.id,
        name: _nameController.text.trim(),
        iconKey: _iconKey,
        colorValue: _colorValue,
        isDeleted: widget.category?.isDeleted ?? false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category == null ? l10n.newCategory : l10n.editCategory,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Color(_colorValue).withAlpha(40),
                  child: Icon(
                    iconFor(_iconKey),
                    size: 32,
                    color: Color(_colorValue),
                  ),
                ),
              ),
              TextFormField(
                controller: _nameController,
                maxLength: 20,
                decoration: InputDecoration(labelText: l10n.name),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.enterName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(l10n.icon, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categoryIcons.entries
                    .map(
                      (entry) => ChoiceChip(
                        label: Icon(entry.value),
                        showCheckmark: false,
                        selected: _iconKey == entry.key,
                        onSelected: (_) => setState(() => _iconKey = entry.key),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
              Text(l10n.color, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: categoryColors
                    .map(
                      (value) => GestureDetector(
                        onTap: () => setState(() => _colorValue = value),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(value),
                          child: _colorValue == value
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                )
                              : null,
                        ),
                      ),
                    )
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(l10n.cancel),
                  ),
                  TextButton(onPressed: _save, child: Text(l10n.save)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
