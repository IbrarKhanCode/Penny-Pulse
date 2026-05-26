import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

enum VoiceInputError { permissionDenied, notRecognized, unknown }

class VoiceInputState {
  const VoiceInputState({
    this.isListening = false,
    this.recognizedText = '',
    this.error,
    this.isSupported = true,
    this.hasInitialized = false,
  });

  final bool isListening;
  final String recognizedText;
  final VoiceInputError? error;
  final bool isSupported;
  final bool hasInitialized;

  VoiceInputState copyWith({
    bool? isListening,
    String? recognizedText,
    VoiceInputError? error,
    bool clearError = false,
    bool? isSupported,
    bool? hasInitialized,
  }) {
    return VoiceInputState(
      isListening: isListening ?? this.isListening,
      recognizedText: recognizedText ?? this.recognizedText,
      error: clearError ? null : (error ?? this.error),
      isSupported: isSupported ?? this.isSupported,
      hasInitialized: hasInitialized ?? this.hasInitialized,
    );
  }
}

class VoiceInputNotifier extends Notifier<VoiceInputState> {
  late final stt.SpeechToText _speech;
  stt.LocaleName? _selectedLocale;
  bool _initializing = false;
  bool _notSupportedDuringInit = false;
  bool _permissionDenied = false;

  @override
  VoiceInputState build() {
    _speech = stt.SpeechToText();
    ref.onDispose(() async {
      if (_speech.isListening) {
        await _speech.stop();
      }
      await _speech.cancel();
    });
    return const VoiceInputState();
  }

  Future<void> initialize({bool force = false}) async {
    if ((state.hasInitialized && !force) || _initializing) {
      return;
    }
    _initializing = true;
    _notSupportedDuringInit = false;
    _permissionDenied = false;
    await _speech.initialize(onError: _handleError, onStatus: _handleStatus);
    _selectedLocale = await _resolveLocale();
    state = state.copyWith(
      isSupported: !_notSupportedDuringInit,
      hasInitialized: true,
    );
    _initializing = false;
  }

  Future<stt.LocaleName?> _resolveLocale() async {
    try {
      final locales = await _speech.locales();
      final byId = {for (final locale in locales) locale.localeId: locale};
      if (byId.containsKey('en_PK')) {
        return byId['en_PK'];
      }
      if (byId.containsKey('en_US')) {
        return byId['en_US'];
      }
      final systemLocale = await _speech.systemLocale();
      if (systemLocale != null) {
        return systemLocale;
      }
      if (locales.isNotEmpty) {
        return locales.first;
      }
    } catch (_) {}
    return null;
  }

  Future<void> startListening() async {
    await initialize(force: _permissionDenied);
    if (!state.isSupported || state.isListening) {
      return;
    }
    final hasPermission = await _speech.hasPermission;
    if (!hasPermission) {
      _permissionDenied = true;
      state = state.copyWith(error: VoiceInputError.permissionDenied);
      return;
    }
    _permissionDenied = false;
    state = state.copyWith(
      isListening: true,
      recognizedText: '',
      clearError: true,
    );
    await _speech.listen(
      localeId: _selectedLocale?.localeId,
      listenMode: stt.ListenMode.dictation,
      onResult: (result) {
        if (result.recognizedWords.isNotEmpty) {
          state = state.copyWith(recognizedText: result.recognizedWords);
        }
        if (result.finalResult) {
          state = state.copyWith(isListening: false);
        }
      },
    );
  }

  Future<void> stopListening() async {
    if (!state.isListening) {
      return;
    }
    await _speech.stop();
    state = state.copyWith(isListening: false);
    if (state.recognizedText.trim().isEmpty) {
      state = state.copyWith(error: VoiceInputError.notRecognized);
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void _handleStatus(String status) {
    if (status == 'notListening' || status == 'done') {
      state = state.copyWith(isListening: false);
    }
  }

  void _handleError(SpeechRecognitionError error) {
    final lower = error.errorMsg.toLowerCase();
    if (lower.contains('permission')) {
      _permissionDenied = true;
      state = state.copyWith(
        isListening: false,
        error: VoiceInputError.permissionDenied,
        isSupported: true,
        hasInitialized: true,
      );
      return;
    }
    if (lower.contains('not supported') ||
        lower.contains('speech_not_supported')) {
      _notSupportedDuringInit = true;
      state = state.copyWith(
        isListening: false,
        isSupported: false,
        hasInitialized: true,
      );
      return;
    }
    if (lower.contains('no_match')) {
      state = state.copyWith(
        isListening: false,
        error: VoiceInputError.notRecognized,
      );
      return;
    }
    state = state.copyWith(isListening: false, error: VoiceInputError.unknown);
  }
}

final voiceInputProvider =
    NotifierProvider<VoiceInputNotifier, VoiceInputState>(
      VoiceInputNotifier.new,
    );
