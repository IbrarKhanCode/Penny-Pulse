import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

class BudgetDialog extends StatefulWidget {
  const BudgetDialog({super.key, this.initialValue});

  final double? initialValue;

  static Future<double?> show(BuildContext context, {double? initialValue}) {
    return showDialog<double>(
      context: context,
      barrierDismissible: false,
      builder: (context) => BudgetDialog(initialValue: initialValue),
    );
  }

  @override
  State<BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<BudgetDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue?.toStringAsFixed(2) ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(
        widget.initialValue == null ? 'Set Your Budget' : 'Edit Budget',
        style: const TextStyle(color: AppColors.textPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter the amount you have available to spend.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'e.g. 15000',
              prefixText: 'PKR ',
              hintStyle: const TextStyle(color: AppColors.textTertiary),
              errorText: _errorText,
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.purpleLight,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.neonGreen,
            foregroundColor: AppColors.neonGreenDark,
          ),
          onPressed: () {
            final raw = _controller.text.trim();
            final value = double.tryParse(raw);
            if (value == null || value <= 0) {
              setState(() {
                _errorText = 'Enter a valid amount';
              });
              return;
            }
            Navigator.of(context).pop(value);
          },
          child: Text(widget.initialValue == null ? 'Save Budget' : 'Update'),
        ),
      ],
    );
  }
}
