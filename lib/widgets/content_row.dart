import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../screens/video/video_player_screen.dart';

class ContentRow extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const ContentRow({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.netflixWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildContentItem(context, item);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildContentItem(BuildContext context, Map<String, dynamic> item) {
    final posterPath = item['poster_path'] as String?;
    final title = item['title'] as String? ?? item['name'] as String? ?? '';
    final id = item['id'] as int;
    final type = item['type'] as String;

    String imageUrl = '';
    if (posterPath != null && posterPath.isNotEmpty) {
      if (posterPath.startsWith('http')) {
        imageUrl = posterPath;
      } else {
        imageUrl = '${AppConstants.tmdbImageBaseUrl}$posterPath';
      }
    }

    return Container(
      width: 110,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () => _onItemTap(context, id, type, title),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.netflixDarkGray,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            color: AppColors.netflixDarkGray,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.netflixRed,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.netflixDarkGray,
                            child: const Icon(
                              Icons.movie,
                              color: AppColors.netflixGray,
                              size: 30,
                            ),
                          ),
                        )
                      : Container(
                          color: AppColors.netflixDarkGray,
                          child: const Icon(
                            Icons.movie,
                            color: AppColors.netflixGray,
                            size: 30,
                          ),
                        ),
                ),
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Title
            if (title.isNotEmpty)
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.netflixWhite,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  void _onItemTap(BuildContext context, int id, String type, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          contentId: id,
          contentType: type,
          title: title,
        ),
      ),
    );
  }
}