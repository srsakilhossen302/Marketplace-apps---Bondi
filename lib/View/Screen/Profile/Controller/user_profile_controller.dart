import 'package:get/get.dart';

class UserProfileController extends GetxController {
  final userName = 'Alex Rivers'.obs;
  final userImage = 'https://randomuser.me/api/portraits/men/1.jpg'.obs;
  final bio = 'Sneaker collector and vintage tech enthusiast. Let\'s trade! Always looking for rare 90s hardware and limited releases.'.obs;
  
  final friendsCount = '1.2k'.obs;
  final groupsCount = '24'.obs;
  final tradesCount = '158'.obs;
  final rating = '4.9'.obs;

  final myListings = [
    {
      'title': 'Nike Air Max Custom',
      'price': '\$450.00',
      'status': 'ACTIVE',
      'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=500&auto=format&fit=crop',
    },
    {
      'title': 'NES Classic Edition',
      'price': '\$1,200.00',
      'status': 'SOLD',
      'image': 'https://images.unsplash.com/photo-1527189341453-2949ff271582?q=80&w=500&auto=format&fit=crop',
    },
    {
      'title': 'Bond Chronograph',
      'price': '\$325.00',
      'status': 'ACTIVE',
      'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=500&auto=format&fit=crop',
    },
  ].obs;
}
