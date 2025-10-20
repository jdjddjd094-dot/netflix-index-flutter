import '../constants/app_constants.dart';

class VideoService {
  static String getMovieStreamUrl(int tmdbId) {
    return '${AppConstants.superEmbedBaseUrl}/?video_id=$tmdbId&tmdb=1';
  }

  static String getTvShowStreamUrl(int tmdbId, int season, int episode) {
    return '${AppConstants.superEmbedBaseUrl}/?video_id=$tmdbId&tmdb=1&s=$season&e=$episode';
  }

  static String getVipMovieStreamUrl(int tmdbId) {
    return '${AppConstants.superEmbedVipUrl}?video_id=$tmdbId&tmdb=1';
  }

  static String getVipTvShowStreamUrl(int tmdbId, int season, int episode) {
    return '${AppConstants.superEmbedVipUrl}?video_id=$tmdbId&tmdb=1&s=$season&e=$episode';
  }

  static Future<bool> checkVipAvailability(int tmdbId, {int? season, int? episode}) async {
    try {
      String url = '${AppConstants.superEmbedVipUrl}?video_id=$tmdbId&tmdb=1&check=1';
      if (season != null && episode != null) {
        url += '&s=$season&e=$episode';
      }
      
      // This would require an HTTP request to check availability
      // For now, we'll assume VIP is available for popular content
      return true;
    } catch (e) {
      print('Error checking VIP availability: $e');
      return false;
    }
  }

  static String addSubtitles(String baseUrl, String subtitleUrl, String subtitleLabel) {
    final encodedSubUrl = Uri.encodeComponent(subtitleUrl);
    final encodedSubLabel = Uri.encodeComponent(subtitleLabel);
    return '$baseUrl&sub_url=$encodedSubUrl&sub_label=$encodedSubLabel';
  }

  // Helper method to determine the best streaming option
  static Future<String> getBestStreamUrl(int tmdbId, {int? season, int? episode}) async {
    bool vipAvailable = await checkVipAvailability(tmdbId, season: season, episode: episode);
    
    if (vipAvailable) {
      if (season != null && episode != null) {
        return getVipTvShowStreamUrl(tmdbId, season, episode);
      } else {
        return getVipMovieStreamUrl(tmdbId);
      }
    } else {
      if (season != null && episode != null) {
        return getTvShowStreamUrl(tmdbId, season, episode);
      } else {
        return getMovieStreamUrl(tmdbId);
      }
    }
  }
}