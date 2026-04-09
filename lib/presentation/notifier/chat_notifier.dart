import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../features/data/models/chat_message.dart';

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier() : super([]) {
    // Hoş geldin mesajı
    state = [
      ChatMessage(
        text: 'Merhaba! Ben Mimari Atlas AI asistanınızım. Size mimarlık konusunda nasıl yardımcı olabilirim?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
  }

  Future<void> sendMessage(String message) async {
    // Kullanıcı mesajı
    state = [
      ...state,
      ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ),
    ];

    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('API anahtarı bulunamadı!');
      }

      final model = GenerativeModel(
        model: 'gemini-2.5-flash', // ✅ Çalışan model
        apiKey: apiKey,
      );

      // ✅ Basitleştirilmiş prompt yapısı
      final prompt = '''Sen mimarlık konusunda uzman bir AI asistansın.
Mimarlık öğrencilerine ve profesyonellere yardımcı oluyorsun.
Mimari tasarım, mimarlık tarihi, yapı teknolojileri, ünlü mimarlar,
mimari akımlar ve stiller konusunda bilgilisin.

Cevaplarını Türkçe, anlaşılır, kısa ve profesyonel ver.
Teknik terimleri açıkla.

Soru: $message''';

      // ✅ İkinci dosyadaki gibi çağrı
      final icerik = [Content.text(prompt)];
      final response = await model.generateContent(icerik);

      state = [
        ...state,
        ChatMessage(
          text: response.text ?? 'Üzgünüm, cevap oluşturamadım.',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ];
    } catch (e) {
      // ✅ Daha detaylı hata mesajı
      state = [
        ...state,
        ChatMessage(
          text: 'Hata: ${e.toString()}\n\nLütfen API anahtarınızı kontrol edin.',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ];
    }
  }

  void clearChat() {
    state = [
      ChatMessage(
        text: 'Merhaba! Ben Mimari Atlas AI asistanınızım. Size mimarlık konusunda nasıl yardımcı olabilirim?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
  }
}
