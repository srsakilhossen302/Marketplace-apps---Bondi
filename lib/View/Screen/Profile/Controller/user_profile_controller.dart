import 'dart:convert';
import 'package:get/get.dart';
import '../../../../service/api_url.dart';
import '../../../../service/api_client.dart';

class UserProfileController extends GetxController {
  final userName = 'Alex Rivers'.obs;
  final displayName = 'Alex Rivers'.obs;
  final userImage = 'https://randomuser.me/api/portraits/men/1.jpg'.obs;
  final bio =
      'Sneaker collector and vintage tech enthusiast. Let\'s trade! Always looking for rare 90s hardware and limited releases.'
          .obs;

  final friendsCount = '1.2k'.obs;
  final groupsCount = '24'.obs;
  final tradesCount = '158'.obs;
  final rating = '4.9'.obs;

  final myListings = [
    {
      'title': 'Nike Air Max Custom',
      'price': '\$450.00',
      'status': 'ACTIVE',
      'image': 'https://randomuser.me/api/portraits/women/2.jpg',
    },
    {
      'title': 'NES Classic Edition',
      'price': '\$1,200.00',
      'status': 'SOLD',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
    },
    {
      'title': 'Bond Chronograph',
      'price': '\$325.00',
      'status': 'ACTIVE',
      'image': 'https://randomuser.me/api/portraits/women/4.jpg',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
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
            userImage.value = profileData['profileImage'];
          }
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }
}
