import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../screens/video/video_player_screen.dart';

class ContentGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final int crossAxisCount;

  const ContentGrid({
    super.key,
    required this.items,
    this.crossAxisCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildGridItem(context, item);
      },
    );
  }

  Widget _buildGridItem(BuildContext context, Map<String, dynamic> item) {
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

    return GestureDetector(
      onTap: () => _onItemTap(context, id, type, title),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.netflixDarkGray,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // Poster Image
              Positioned.fill(
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
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
                            size: 40,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.netflixDarkGray,
                        child: const Icon(
                          Icons.movie,
                          color: AppColors.netflixGray,
                          size: 40,
                        ),
                      ),
              ),
              
              // Gradient Overlay for Title
              if (title.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0x80000000),
                          Color(0xFF000000),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.netflixWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              
              // Play Icon Overlay
              const Positioned.fill(
                child: Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    color: AppColors.netflixWhite,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
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