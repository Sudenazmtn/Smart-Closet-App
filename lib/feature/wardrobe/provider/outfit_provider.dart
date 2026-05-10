import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/data/model/chat_message_model.dart';
import 'package:smart_closet_app/product/data/model/outfit_model.dart';
import 'package:smart_closet_app/product/data/model/stats_model.dart';
import 'package:smart_closet_app/product/data/repositories/outfit_repository.dart';
import 'package:smart_closet_app/product/utils/enums/outfit_status_enum.dart';

class OutfitProvider extends ChangeNotifier {
  OutfitProvider() : _repository = OutfitRepository();

  final OutfitRepository _repository;

  OutfitStatus _status = OutfitStatus.idle;
  List<OutfitModel> _outfits = [];
  StatsModel? _stats;
  String? _errorMessage;
  List<ChatMessageModel> _messages = [];

  // ── Getters ───────────────────────────────────────────────────────────────
  OutfitStatus get status => _status;
  List<OutfitModel> get outfits => _outfits;
  StatsModel? get stats => _stats;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == OutfitStatus.loading;
  List<ChatMessageModel> get messages => List.unmodifiable(_messages);

  List<OutfitModel> get favorites =>
      _outfits.where((o) => o.isFavorite).toList();

  // ── Chat başlat ───────────────────────────────────────────────────────────
  void initChat(String greeting) {
    if (_messages.isEmpty) {
      _messages = [ChatMessageModel(sender: MessageSender.ai, text: greeting)];
      notifyListeners();
    }
  }

  // ── Mesaj gönder + kural tabanlı AI yanıt al ─────────────────────────────
  Future<void> sendMessage({
    required String userText,
    required String aiErrorText,
    double? temperature,
    String? weatherDescription,
  }) async {
    _messages = [
      ..._messages,
      ChatMessageModel(sender: MessageSender.user, text: userText),
    ];
    notifyListeners();

    _setLoading();
    try {
      final aiResponse = await _repository.sendChatMessage(
        userText   : userText,
        temperature: temperature,
        weatherDesc: weatherDescription,
      );
      _messages = [
        ..._messages,
        ChatMessageModel(
          sender        : MessageSender.ai,
          text          : aiResponse.message,
          suggestedItems: aiResponse.items.isNotEmpty ? aiResponse.items : null,
          styleTip      : aiResponse.styleTip,
        ),
      ];
      _setSuccess();
    } catch (e) {
      _messages = [
        ..._messages,
        ChatMessageModel(sender: MessageSender.ai, text: aiErrorText),
      ];
      _setError(e.toString());
    }
  }

  // ── Chat sıfırla ──────────────────────────────────────────────────────────
  void clearChat(String greeting) {
    _messages = [ChatMessageModel(sender: MessageSender.ai, text: greeting)];
    notifyListeners();
  }

  // ── Kombinleri yükle ──────────────────────────────────────────────────────
  Future<void> loadOutfits({bool? isFavorite}) async {
    _setLoading();
    try {
      _outfits = await _repository.getOutfits(isFavorite: isFavorite);
      _setSuccess();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ── Kombin kaydet ─────────────────────────────────────────────────────────
  Future<void> saveOutfit({
    required List<int> itemIds,
    String? name,
    String? eventType,
    String? aiNote,
  }) async {
    _setLoading();
    try {
      final newOutfit = await _repository.saveOutfit(
        itemIds: itemIds,
        name: name,
        eventType: eventType,
        aiNote: aiNote,
      );
      _outfits.insert(0, newOutfit);
      _setSuccess();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ── Favori toggle ─────────────────────────────────────────────────────────
  Future<void> toggleFavorite(int outfitId) async {
    try {
      final updated = await _repository.toggleFavorite(outfitId);
      final index = _outfits.indexWhere((o) => o.id == outfitId);
      if (index != -1) {
        _outfits[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ── Kombin sil ────────────────────────────────────────────────────────────
  Future<void> deleteOutfit(int outfitId) async {
    _setLoading();
    try {
      await _repository.deleteOutfit(outfitId);
      _outfits.removeWhere((o) => o.id == outfitId);
      _setSuccess();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ── İstatistikleri yükle ──────────────────────────────────────────────────
  Future<void> loadStats() async {
    _setLoading();
    try {
      _stats = await _repository.getStats();
      _setSuccess();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ── Kullanıcı çıkışında tüm state'i temizle ──────────────────────────────
  void resetState() {
    _status = OutfitStatus.idle;
    _errorMessage = null;
    _outfits = [];
    _stats = null;
    _messages = [];
    notifyListeners();
  }

  // ── Reset ─────────────────────────────────────────────────────────────────
  void resetStatus() {
    _status = OutfitStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading() {
    _status = OutfitStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setSuccess() {
    _status = OutfitStatus.success;
    notifyListeners();
  }

  void _setError(String message) {
    _status = OutfitStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}
