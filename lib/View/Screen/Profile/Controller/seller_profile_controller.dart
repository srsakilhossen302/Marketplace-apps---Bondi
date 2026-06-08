import 'package:get/get.dart';

class SellerProfileController extends GetxController {
  final sellerName = 'Marcus G.'.obs;
  final sellerImage = 'https://randomuser.me/api/portraits/men/32.jpg'.obs;
  final shortBio = 'Collector of rare sneakers and vintage watches. Always looking for unique trades in the city.'.obs;
  final longBio = 'Based in Downtown, Marcus has been an active member of the Bond community since 2021. Specializing in high-end horology and limited footwear releases. Known for rapid shipping and authentic verification.'.obs;
  final location = 'New York, NY • 2.4 miles away'.obs;

  final tradesCount = '124'.obs;
  final rating = '4.9'.obs;
  final followersCount = '2k+'.obs;

  final activeListings = [
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
  ].obs;

  final mutualFriends = [
    'https://randomuser.me/api/portraits/men/1.jpg',
    'https://randomuser.me/api/portraits/men/2.jpg',
    'https://randomuser.me/api/portraits/men/3.jpg',
  ].obs;

  final sharedGroups = ['Sneaker Traders', 'NYC Horology'].obs;
}
