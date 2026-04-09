import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/news_section.dart';
import 'demo_news.dart';

class TrendsScreen extends StatelessWidget {
  const TrendsScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('URL açılamadı: $url');
      }
    } catch (e) {
      debugPrint('URL açılırken hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewsSections.buildBreakingNewsSection(
              news: NewsData.breakingNews,
              onNewsClick: _launchURL,
            ),
            const SizedBox(height: 16),
            NewsSections.buildOtherNewsSection(
              news: NewsData.otherNews,
              onNewsClick: _launchURL,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
