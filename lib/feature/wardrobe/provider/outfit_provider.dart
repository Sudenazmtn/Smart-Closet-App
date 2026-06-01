import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/data/model/chat_message_model.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
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

  OutfitStatus get status => _status;
  List<OutfitModel> get outfits => _outfits;
  StatsModel? get stats => _stats;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == OutfitStatus.loading;
  List<ChatMessageModel> get messages => List.unmodifiable(_messages);

  List<OutfitModel> get favorites =>
      _outfits.where((o) => o.isFavorite).toList();

  List<dynamic> get lastAiItems {
    for (final msg in _messages.reversed) {
      if (msg.suggestedItems != null && msg.suggestedItems!.isNotEmpty) {
        return msg.suggestedItems!;
      }
    }
    return [];
  }

  String? get lastAiNote {
    for (final msg in _messages.reversed) {
      if (msg.styleTip != null) return msg.styleTip;
    }
    return null;
  }

  double? get lastAiScore {
    for (final msg in _messages.reversed) {
      if (msg.suggestedItems != null && msg.suggestedItems!.isNotEmpty) {
        return msg.score;
      }
    }
    return null;
  }

  void initChat(String greeting) {
    if (_messages.isEmpty) {
      _messages = [ChatMessageModel(sender: MessageSender.ai, text: greeting)];
      notifyListeners();
    }
  }

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

    // Son önerilen kıyafet ID'lerini dışla — farklı kombin üretilsin
    final lastItems = lastAiItems.whereType<ClothingModel>().toList();
    final excludeIds = lastItems.map((i) => i.id).toList();

    _setLoading();
    try {
      final aiResponse = await _repository.sendChatMessage(
        userText: userText,
        temperature: temperature,
        weatherDesc: weatherDescription,
        excludeItemIds: excludeIds.isNotEmpty ? excludeIds : null,
      );
      _messages = [
        ..._messages,
        ChatMessageModel(
          sender: MessageSender.ai,
          text: aiResponse.message,
          suggestedItems: aiResponse.items.isNotEmpty ? aiResponse.items : null,
          styleTip: aiResponse.styleTip,
          destinationCity: aiResponse.destinationCity,
          score: aiResponse.score,
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

  void clearChat(String greeting) {
    _messages = [ChatMessageModel(sender: MessageSender.ai, text: greeting)];
    notifyListeners();
  }

  Future<void> loadOutfits({bool? isFavorite}) async {
    _setLoading();
    try {
      _outfits = await _repository.getOutfits(isFavorite: isFavorite);
      _setSuccess();
    } catch (e) {
      _setError(e.toString());
    }
  }

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

  Future<void> loadStats() async {
    _setLoading();
    try {
      _stats = await _repository.getStats();
      _setSuccess();
    } catch (e) {
      _setError(e.toString());
    }
  }

  void resetState() {
    _status = OutfitStatus.idle;
    _errorMessage = null;
    _outfits = [];
    _stats = null;
    _messages = [];
    notifyListeners();
  }

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
