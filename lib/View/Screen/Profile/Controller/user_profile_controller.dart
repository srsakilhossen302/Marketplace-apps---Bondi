import 'dart:convert';
import 'package:get/get.dart';
import '../../../../service/api_url.dart';
import '../../../../service/api_client.dart';
import '../../../../helper/network_img/image_helper.dart';

class UserProfileController extends GetxController {
  final userName = ''.obs;
  final displayName = ''.obs;
  final userImage = 'https://i.pravatar.cc/150?u=default'.obs;
  final bio = ''.obs;

  final friendsCount = '0'.obs;
  final groupsCount = '0'.obs;
  final tradesCount = '0'.obs;
  final rating = '0.0'.obs;

  final myListings = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchMyListings();
  }

  Future<void> fetchProfile() async {
    try {
      final response = await ApiClient.get(ApiUrl.profile);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final profileData = data['data'];

        if (profileData != null) {
          displayName.value = profileData['displayName'] ?? 'User';
          userName.value = profileData['username'] ?? 'User';
          bio.value = profileData['bio'] ?? 'No bio yet';
          friendsCount.value = profileData['totalFriends']?.toString() ?? '0';
          groupsCount.value = profileData['totalGroups']?.toString() ?? '0';
          tradesCount.value = profileData['totalTrades']?.toString() ?? '0';

          if (profileData['profileImage'] != null &&
              profileData['profileImage'].toString().isNotEmpty) {
            userImage.value = ImageHelper.formatImageUrl(profileData['profileImage'].toString());
          }
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> fetchMyListings() async {
    try {
      print('Fetching my listings...');
      final response = await ApiClient.get(ApiUrl.myListings);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final listings = data['data'] as List<dynamic>;
        print('Number of listings: ${listings.length}');

        myListings.clear();
        for (var listing in listings) {
          // Clean up image URL (remove backticks and spaces)
          String thumbnail =
              listing['thumbnail']?.toString().replaceAll('`', '').trim() ?? '';
          if (thumbnail.isEmpty &&
              listing['images'] != null &&
              (listing['images'] as List).isNotEmpty) {
            thumbnail = listing['images'][0]
                .toString()
                .replaceAll('`', '')
                .trim();
          }

          myListings.add({
            'title': listing['title'] ?? 'No Title',
            'price': '\$${listing['price']?.toString() ?? '0'}',
            'status': (listing['status'] ?? 'ACTIVE').toString().toUpperCase(),
            'image': thumbnail.isNotEmpty
                ? ImageHelper.formatImageUrl(thumbnail)
                : 'https://randomuser.me/api/portraits/women/5.jpg',
            'rawData': listing,
          });
        }
        print('Final listings count: ${myListings.length}');
      }
    } catch (e) {
      print('Error fetching my listings: $e');
    }
  }
}
