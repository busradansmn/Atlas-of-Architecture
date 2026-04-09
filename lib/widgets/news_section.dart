import 'package:flutter/material.dart';
import '../features/data/models/news_item.dart';
import 'news_widgets.dart';

class NewsSections {
  static Widget buildBreakingNewsSection({
    required List<NewsItem> news,
    required Function(String) onNewsClick,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "SON DAKİKA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Güncel Haberler",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: news.length,
              itemBuilder: (context, index) {
                return NewsCard(
                  news: news[index],
                  onTap: () => onNewsClick(news[index].url),
                  isBreaking: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildOtherNewsSection({
    required List<NewsItem> news,
    required Function(String) onNewsClick,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Diğer Haberler",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: news.length,
            itemBuilder: (context, index) {
              return NewsCard(
                news: news[index],
                onTap: () => onNewsClick(news[index].url),
                isBreaking: false,
              );
            },
          ),
        ),
      ],
    );
  }
}
