import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/expense_text_validator.dart';
import '../../../voice/voice_input_notifier.dart';
import '../state/expenses_controller.dart';
import '../widgets/amount_field.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _descController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(addExpenseFormProvider);
    final formNotifier = ref.read(addExpenseFormProvider.notifier);
    final voiceState = ref.watch(voiceInputProvider);
    final voiceNotifier = ref.read(voiceInputProvider.notifier);

    void showSnackMessage(String message) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.surfaceVariant,
        ),
      );
    }

    final validationSnackMessages = <String>{
      ExpenseTextValidator.invalidPredictionMessage,
      'Please enter a description',
      'Please enter an amount',
      'Please enter a description and amount',
    };

    ref.listen<String?>(
      addExpenseFormProvider.select((state) => state.errorMessage),
      (previous, next) {
        if (next == null || next == previous) {
          return;
        }
        if (validationSnackMessages.contains(next)) {
          showSnackMessage(next);
        }
      },
    );

    ref.listen<VoiceInputState>(voiceInputProvider, (previous, next) {
      if (previous?.error != next.error && next.error != null) {
        String message;
        switch (next.error!) {
          case VoiceInputError.permissionDenied:
            message = 'Microphone permission needed';
          case VoiceInputError.notRecognized:
            message = "Couldn't catch that, try again";
          case VoiceInputError.unknown:
            message = 'Voice input failed';
        }
        final action = next.error == VoiceInputError.permissionDenied
            ? SnackBarAction(
                label: 'Open Settings',
                textColor: AppColors.neonGreen,
                onPressed: () => AppSettings.openAppSettings(),
              )
            : null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.surfaceVariant,
            action: action,
          ),
        );
        voiceNotifier.clearError();
      }

      final recognized = ExpenseTextValidator.normalize(next.recognizedText);
      if (previous?.recognizedText != next.recognizedText &&
          recognized.isNotEmpty &&
          !next.isListening) {
        if (_descController.text != recognized) {
          _descController.value = TextEditingValue(
            text: recognized,
            selection: TextSelection.collapsed(offset: recognized.length),
          );
          formNotifier.setDescription(recognized);
        }
        if (!formState.isPredicting) {
          formNotifier.predict();
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
        ),
        title: const Text(
          'ADD EXPENSE',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 16,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Description
            _FieldLabel(label: 'Description'),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _descController,
                    onChanged: formNotifier.setDescription,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. Whole Foods salad',
                      prefixIcon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.textTertiary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.cardBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.cardBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.purpleLight,
                          width: 2,
                        ),
                      ),
                      hintStyle: const TextStyle(color: AppColors.textTertiary),
                    ),
                  ),
                ),
                if (voiceState.isSupported) ...[
                  const SizedBox(width: 12),
                  _VoiceMicButton(
                    isListening: voiceState.isListening,
                    onStart: voiceNotifier.startListening,
                    onEnd: voiceNotifier.stopListening,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),

            // Amount
            _FieldLabel(label: 'Amount'),
            const SizedBox(height: 8),
            AmountField(
              controller: _amountController,
              onChanged: formNotifier.setAmountText,
            ),
            const SizedBox(height: 28),

            // AI Predict button
            OutlinedButton.icon(
              onPressed: formState.isPredicting ? null : formNotifier.predict,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.purpleLight,
                side: const BorderSide(color: AppColors.purple),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: formState.isPredicting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.purpleLight,
                      ),
                    )
                  : const Icon(Icons.auto_awesome_rounded, size: 18),
              label: Text(
                formState.isPredicting
                    ? 'Predicting...'
                    : 'AI Predict Category',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            // Prediction result
            if (formState.predictedCategory != null) ...[
              const SizedBox(height: 16),
              _PredictionCard(
                category: formState.predictedCategory!,
                type: formState.predictedType ?? '',
              ),
            ],

            // Error
            if (formState.errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.roseContainer,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.rose.withAlpha(80)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.rose,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        formState.errorMessage!,
                        style: const TextStyle(
                          color: AppColors.rose,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Save button
            FilledButton.icon(
              onPressed: formState.isSaving
                  ? null
                  : () async {
                      final expense = await formNotifier.save();
                      if (expense != null && context.mounted) {
                        ref.read(historyProvider.notifier).refresh();
                        context.pop();
                      }
                    },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.neonGreen,
                foregroundColor: AppColors.neonGreenDark,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: formState.isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.neonGreenDark,
                      ),
                    )
                  : const Icon(Icons.check_rounded, size: 20),
              label: Text(
                formState.isSaving ? 'Saving...' : 'Save Expense',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _VoiceMicButton extends StatelessWidget {
  const _VoiceMicButton({
    required this.isListening,
    required this.onStart,
    required this.onEnd,
  });

  final bool isListening;
  final Future<void> Function() onStart;
  final Future<void> Function() onEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onStart(),
      onTapUp: (_) => onEnd(),
      onTapCancel: onEnd,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isListening) const _MicGlow(),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.purple,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withAlpha(80),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          const Icon(Icons.mic_rounded, color: AppColors.textPrimary, size: 22),
          if (isListening)
            const Positioned(top: 4, right: 4, child: _RecordingPulse()),
        ],
      ),
    );
  }
}

class _RecordingPulse extends StatefulWidget {
  const _RecordingPulse();

  @override
  State<_RecordingPulse> createState() => _RecordingPulseState();
}

class _MicGlow extends StatefulWidget {
  const _MicGlow();

  @override
  State<_MicGlow> createState() => _MicGlowState();
}

class _MicGlowState extends State<_MicGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.9, end: 1.2).animate(curved);
    _opacity = Tween<double>(begin: 0.2, end: 0.55).animate(curved);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.rose.withAlpha(30),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.rose.withAlpha(140),
                blurRadius: 18,
                spreadRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecordingPulseState extends State<_RecordingPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.7, end: 1.2).animate(curved);
    _opacity = Tween<double>(begin: 0.4, end: 1.0).animate(curved);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: AppColors.rose,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _PredictionCard extends StatelessWidget {
  const _PredictionCard({required this.category, required this.type});
  final String category;
  final String type;

  @override
  Widget build(BuildContext context) {
    final isNeed = type.toLowerCase() == 'need';
    final color = isNeed ? AppColors.emerald : AppColors.rose;
    final bgColor = isNeed
        ? AppColors.emeraldContainer
        : AppColors.roseContainer;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI PREDICTION',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.toUpperCase()}  •  ${isNeed ? "Need" : "Want"}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isNeed ? Icons.check_rounded : Icons.favorite_rounded,
              color: color,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}
