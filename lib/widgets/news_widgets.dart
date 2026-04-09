import 'package:flutter/material.dart';
import '../features/data/models/news_item.dart';
import '../utils/responsive_size.dart';

class NewsCard extends StatelessWidget {
  final NewsItem news;
  final VoidCallback onTap;
  final bool isBreaking;

  const NewsCard({
    super.key,
    required this.news,
    required this.onTap,
    this.isBreaking = false,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    if (isBreaking) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: r.wp(80),
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.network(
                  news.image,
                  height: r.wp(80),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: r.wp(80),
                    color: Colors.grey[300],
                    child: Icon(Icons.image,
                        size: r.wp(15), color: Colors.grey[500]),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: r.wp(80),
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: r.sp(16),
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        r.verticalSpaceSmall,
                        Text(
                          news.summary,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: r.sp(12),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        r.verticalSpaceSmall,
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            news.source,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: r.sp(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  news.image,
                  height: r.wp(60),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: r.wp(60),
                    color: Colors.grey[300],
                    child: Icon(Icons.image,
                        size: r.wp(20), color: Colors.grey[500]),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: r.wp(60),
                      color: Colors.grey[200],
                      child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.title,
                        style: TextStyle(
                            fontSize: r.sp(20), fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      r.verticalSpaceSmall,
                      Expanded(
                        child: Text(
                          news.summary,
                          style: TextStyle(
                              fontSize: r.sp(16), color: Colors.grey[600]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      r.verticalSpaceSmall,
                      Row(
                        children: [
                          Icon(Icons.article_outlined,
                              size: r.wp(12), color: Colors.grey[500]),
                          r.verticalSpaceSmall,
                          Expanded(
                            child: Text(
                              news.source,
                              style: TextStyle(
                                fontSize: r.sp(10),
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
