import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../screens/video/video_player_screen.dart';

class ContentCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final double height;

  const ContentCarousel({
    super.key,
    required this.items,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.netflixRed,
          ),
        ),
      );
    }

    return CarouselSlider.builder(
      itemCount: items.length,
      itemBuilder: (context, index, realIndex) {
        final item = items[index];
        return _buildCarouselItem(context, item);
      },
      options: CarouselOptions(
        height: height,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
        aspectRatio: 16 / 9,
        initialPage: 0,
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, Map<String, dynamic> item) {
    final backdropPath = item['backdrop_path'] as String?;
    final title = item['title'] as String? ?? item['name'] as String? ?? '';
    final id = item['id'] as int;
    final type = item['type'] as String;

    String imageUrl = '';
    if (backdropPath != null && backdropPath.isNotEmpty) {
      if (backdropPath.startsWith('http')) {
        imageUrl = backdropPath;
      } else {
        imageUrl = '${AppConstants.tmdbOriginalImageBaseUrl}$backdropPath';
      }
    }

    return GestureDetector(
      onTap: () => _onItemTap(context, id, type, title),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.netflixDarkGray,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Background Image
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
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.netflixDarkGray,
                          child: const Icon(
                            Icons.movie,
                            color: AppColors.netflixGray,
                            size: 50,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.netflixDarkGray,
                        child: const Icon(
                          Icons.movie,
                          color: AppColors.netflixGray,
                          size: 50,
                        ),
                      ),
              ),
              
              // Gradient Overlay
              Positioned.fill(
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
                      stops: [0.0, 0.7, 1.0],
                    ),
                  ),
                ),
              ),
              
              // Play Button
              const Positioned.fill(
                child: Center(
                  child: Icon(
                    Icons.play_circle_filled,
                    size: 60,
                    color: AppColors.netflixWhite,
                  ),
                ),
              ),
              
              // Title
              if (title.isNotEmpty)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.netflixWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
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