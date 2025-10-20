import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';
import '../models/user.dart';
import '../models/watch_history.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User operations
  static Future<void> createOrUpdateUser(AppUser user) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('Error creating/updating user: $e');
    }
  }

  static Future<AppUser?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        return AppUser.fromJson(doc.data()!);
      }
    } catch (e) {
      print('Error getting user: $e');
    }
    return null;
  }

  // Favorites operations
  static Future<void> addToFavorites(String userId, int contentId, String contentType) async {
    try {
      final userRef = _firestore.collection(AppConstants.usersCollection).doc(userId);
      
      if (contentType == 'movie') {
        await userRef.update({
          'favoriteMovies': FieldValue.arrayUnion([contentId])
        });
      } else if (contentType == 'tv') {
        await userRef.update({
          'favoriteTvShows': FieldValue.arrayUnion([contentId])
        });
      }
    } catch (e) {
      print('Error adding to favorites: $e');
    }
  }

  static Future<void> removeFromFavorites(String userId, int contentId, String contentType) async {
    try {
      final userRef = _firestore.collection(AppConstants.usersCollection).doc(userId);
      
      if (contentType == 'movie') {
        await userRef.update({
          'favoriteMovies': FieldValue.arrayRemove([contentId])
        });
      } else if (contentType == 'tv') {
        await userRef.update({
          'favoriteTvShows': FieldValue.arrayRemove([contentId])
        });
      }
    } catch (e) {
      print('Error removing from favorites: $e');
    }
  }

  static Future<bool> isFavorite(String userId, int contentId, String contentType) async {
    try {
      final user = await getUser(userId);
      if (user != null) {
        if (contentType == 'movie') {
          return user.favoriteMovies.contains(contentId);
        } else if (contentType == 'tv') {
          return user.favoriteTvShows.contains(contentId);
        }
      }
    } catch (e) {
      print('Error checking if favorite: $e');
    }
    return false;
  }

  static Future<List<int>> getFavoriteMovies(String userId) async {
    try {
      final user = await getUser(userId);
      return user?.favoriteMovies ?? [];
    } catch (e) {
      print('Error getting favorite movies: $e');
      return [];
    }
  }

  static Future<List<int>> getFavoriteTvShows(String userId) async {
    try {
      final user = await getUser(userId);
      return user?.favoriteTvShows ?? [];
    } catch (e) {
      print('Error getting favorite TV shows: $e');
      return [];
    }
  }

  // Watch history operations
  static Future<void> updateWatchHistory(WatchHistory watchHistory) async {
    try {
      await _firestore
          .collection(AppConstants.watchHistoryCollection)
          .doc(watchHistory.id)
          .set(watchHistory.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('Error updating watch history: $e');
    }
  }

  static Future<List<WatchHistory>> getWatchHistory(String userId, {int limit = 20}) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.watchHistoryCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('lastWatchedAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => WatchHistory.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting watch history: $e');
      return [];
    }
  }

  static Future<List<WatchHistory>> getContinueWatching(String userId, {int limit = 10}) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.watchHistoryCollection)
          .where('userId', isEqualTo: userId)
          .where('watchedDuration', isGreaterThan: 0)
          .orderBy('watchedDuration')
          .orderBy('lastWatchedAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => WatchHistory.fromJson(doc.data()))
          .where((history) => !history.isCompleted) // Only incomplete items
          .toList();
    } catch (e) {
      print('Error getting continue watching: $e');
      return [];
    }
  }

  static Future<WatchHistory?> getWatchHistoryItem(String userId, int contentId, String contentType, {int? seasonNumber, int? episodeNumber}) async {
    try {
      String docId = '${userId}_${contentId}_$contentType';
      if (seasonNumber != null && episodeNumber != null) {
        docId += '_s${seasonNumber}_e$episodeNumber';
      }

      final doc = await _firestore
          .collection(AppConstants.watchHistoryCollection)
          .doc(docId)
          .get();

      if (doc.exists) {
        return WatchHistory.fromJson(doc.data()!);
      }
    } catch (e) {
      print('Error getting watch history item: $e');
    }
    return null;
  }

  static Future<void> removeFromWatchHistory(String historyId) async {
    try {
      await _firestore
          .collection(AppConstants.watchHistoryCollection)
          .doc(historyId)
          .delete();
    } catch (e) {
      print('Error removing from watch history: $e');
    }
  }

  // Helper method to create watch history ID
  static String createWatchHistoryId(String userId, int contentId, String contentType, {int? seasonNumber, int? episodeNumber}) {
    String id = '${userId}_${contentId}_$contentType';
    if (seasonNumber != null && episodeNumber != null) {
      id += '_s${seasonNumber}_e$episodeNumber';
    }
    return id;
  }
}