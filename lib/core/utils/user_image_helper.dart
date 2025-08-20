import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:circleslate/presentation/common_providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../network/endpoints.dart';

/// Utility class to handle user profile images
class UserImageHelper {
  static const String _baseUrl = '${Urls.baseUrl}';
  
  /// Get the current user's profile image URL
  static String? getCurrentUserImageUrl(BuildContext context) {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userProfile = authProvider.userProfile;
      
      if (userProfile != null && userProfile['profile_photo'] != null) {
        String imageUrl = userProfile['profile_photo'].toString();
        
        // If it's already a full URL, return as is
        if (imageUrl.startsWith('http')) {
          return imageUrl;
        }
        
        // If it's a relative path, make it absolute
        if (imageUrl.startsWith('/')) {
          return '$_baseUrl$imageUrl';
        }
        
        // If it's just a filename, construct the full URL
        return '$_baseUrl/media/$imageUrl';
      }
    } catch (e) {
      debugPrint('[UserImageHelper] Error getting current user image: $e');
    }
    
    return null;
  }
  
  /// Get a user's profile image URL by user ID
  static Future<String?> getUserImageUrl(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      
      if (token == null) return null;
      
      // Make API call to get user profile
      final response = await http.get(
        Uri.parse('$_baseUrl/api/auth/user/$userId/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        final profilePhoto = userData['profile_photo'];
        
        if (profilePhoto != null && profilePhoto.toString().isNotEmpty) {
          String imageUrl = profilePhoto.toString();
          
          // If it's already a full URL, return as is
          if (imageUrl.startsWith('http')) {
            return imageUrl;
          }
          
          // If it's a relative path, make it absolute
          if (imageUrl.startsWith('/')) {
            return '$_baseUrl$imageUrl';
          }
          
          // If it's just a filename, construct the full URL
          return '$_baseUrl/media/$imageUrl';
        }
      }
    } catch (e) {
      debugPrint('[UserImageHelper] Error fetching user image: $e');
    }
    
    return null;
  }
  
  /// Build a CircleAvatar widget with user image or fallback icon
  static Widget buildUserAvatar({
    required String? imageUrl,
    double radius = 16,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Colors.grey[200],
        backgroundImage: NetworkImage(imageUrl),
        onBackgroundImageError: (exception, stackTrace) {
          debugPrint('[UserImageHelper] Error loading image: $exception');
        },
        child: null,
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Colors.grey[300],
        child: Icon(
          Icons.person,
          color: iconColor ?? Colors.grey[600],
          size: radius * 0.8,
        ),
      );
    }
  }

  /// Build a CircleAvatar widget with user image or fallback icon (with error handling)
  static Widget buildUserAvatarWithErrorHandling({
    required String? imageUrl,
    double radius = 16,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Colors.grey[200],
        child: ClipOval(
          child: Image.network(
            imageUrl,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('[UserImageHelper] Error loading image: $error');
              return Container(
                width: radius * 2,
                height: radius * 2,
                color: backgroundColor ?? Colors.grey[300],
                child: Icon(
                  Icons.person,
                  color: iconColor ?? Colors.grey[600],
                  size: radius * 0.8,
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: radius * 2,
                height: radius * 2,
                color: backgroundColor ?? Colors.grey[200],
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Colors.grey[300],
        child: Icon(
          Icons.person,
          color: iconColor ?? Colors.grey[600],
          size: radius * 0.8,
        ),
      );
    }
  }
  
  /// Build a CircleAvatar widget with current user's image
  static Widget buildCurrentUserAvatar({
    required BuildContext context,
    double radius = 16,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    final imageUrl = getCurrentUserImageUrl(context);
    return buildUserAvatar(
      imageUrl: imageUrl,
      radius: radius,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
    );
  }
  
  /// Build a CircleAvatar widget for a specific user by ID
  static Future<Widget> buildUserAvatarById({
    required String userId,
    double radius = 16,
    Color? backgroundColor,
    Color? iconColor,
  }) async {
    final imageUrl = await getUserImageUrl(userId);
    return buildUserAvatar(
      imageUrl: imageUrl,
      radius: radius,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
    );
  }
}
