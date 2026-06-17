import 'dart:convert';
import 'package:get/get.dart';
import '../../../../service/api_url.dart';
import '../../../../service/api_client.dart';
import '../../../../Utils/StaticString/static_string.dart';

class SellerProfileController extends GetxController {
  final userId = ''.obs;
  final isLoading = false.obs;

  final sellerName = 'Jane Doe'.obs;
  final sellerImage = ''.obs;
  final shortBio = ''.obs;
  final longBio = ''.obs;
  final location = 'New York, NY'.obs;
  final isVerifiedSeller = false.obs;

  final tradesCount = '0'.obs;
  final rating = '0.0'.obs;
  final followersCount = '0'.obs;

  final activeListings = <Map<String, String>>[].obs;
  final mutualFriends = <String>[].obs;
  final mutualFriendsCount = 0.obs;
  final sharedGroups = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is String) {
      userId.value = args;
      fetchSellerProfile();
      fetchSellerListings();
    }
  }

  Future<void> fetchSellerProfile() async {
    if (userId.isEmpty) return;
    isLoading.value = true;
    try {
      final response = await ApiClient.get('${ApiUrl.publicProfile}/${userId.value}', requireAuth: true);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final resData = data['data'];
          if (resData != null) {
            sellerName.value = resData['displayName'] ?? resData['username'] ?? 'Jane Doe';
            sellerImage.value = resData['profileImage'] ?? '';
            
            final bioText = resData['bio']?.toString() ?? '';
            shortBio.value = bioText.isNotEmpty ? bioText : 'No bio provided';
            longBio.value = bioText.isNotEmpty ? bioText : 'No additional information available';

            final city = resData['city']?.toString().trim() ?? '';
            final country = resData['country']?.toString().trim() ?? '';
            if (city.isNotEmpty && country.isNotEmpty) {
              location.value = '$city, $country';
            } else if (city.isNotEmpty) {
              location.value = city;
            } else if (country.isNotEmpty) {
              location.value = country;
            } else {
              location.value = StaticString.noAddress;
            }

            isVerifiedSeller.value = resData['isVerifiedSeller'] ?? false;
            tradesCount.value = resData['completedTrades']?.toString() ?? '0';
            rating.value = resData['averageRating']?.toString() ?? '0.0';
            followersCount.value = resData['totalFriends']?.toString() ?? '0';

            // Mutual Friends
            final List<dynamic> friendsList = resData['mutualFriends']?['data'] ?? [];
            final List<String> friendImgs = [];
            for (var friend in friendsList) {
              final img = friend['profileImage']?.toString() ?? '';
              if (img.isNotEmpty) {
                friendImgs.add(img);
              }
            }
            if (friendImgs.isNotEmpty) {
              mutualFriends.assignAll(friendImgs);
            } else {
              mutualFriends.assignAll([
                'https://randomuser.me/api/portraits/men/1.jpg',
                'https://randomuser.me/api/portraits/men/2.jpg',
                'https://randomuser.me/api/portraits/men/3.jpg',
              ]);
            }
            mutualFriendsCount.value = resData['mutualFriends']?['meta']?['total'] ?? 0;

            // Shared Groups
            final List<dynamic> groupsList = resData['sharedGroups'] ?? [];
            final List<String> groupNames = groupsList
                .map((g) => (g['name'] ?? '').toString())
                .where((name) => name.isNotEmpty)
                .toList();
            if (groupNames.isNotEmpty) {
              sharedGroups.assignAll(groupNames);
            } else {
              sharedGroups.assignAll(['Sneaker Traders', 'NYC Horology']);
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching public seller profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSellerListings() async {
    if (userId.isEmpty) return;
    try {
      final response = await ApiClient.get(ApiUrl.listing, requireAuth: false);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final listingsJson = data['data'] as List<dynamic>;
        
        final List<Map<String, String>> loadedListings = [];
        for (var json in listingsJson) {
          final sId = json['sellerId']?.toString() ?? '';
          if (sId == userId.value) {
            String thumbnail = json['thumbnail']?.toString().replaceAll('`', '').trim() ?? '';
            if (thumbnail.isEmpty && json['images'] != null && (json['images'] as List).isNotEmpty) {
              thumbnail = json['images'][0].toString().replaceAll('`', '').trim();
            }
            if (thumbnail.isEmpty) {
              thumbnail = 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=800&auto=format&fit=crop';
            }
            loadedListings.add({
              'title': json['title'] ?? 'No Title',
              'price': '\$${json['price']?.toString() ?? '0'}',
              'image': thumbnail,
              'slug': json['slug']?.toString() ?? '',
            });
          }
        }
        if (loadedListings.isNotEmpty) {
          activeListings.assignAll(loadedListings);
        } else {
          activeListings.assignAll([
            {
              'title': 'Air Max Crimson Limited',
              'price': '\$420',
              'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=500&auto=format&fit=crop',
            },
            {
              'title': 'Custom KB-88 Stealth',
              'price': '\$285',
              'image': 'https://images.unsplash.com/photo-1511467687858-23d96c32e4ae?q=80&w=500&auto=format&fit=crop',
            },
          ]);
        }
      }
    } catch (e) {
      print('Error fetching seller listings: $e');
    }
  }
}
