import 'package:get/get.dart';
import '../../../../Model/home_models.dart';

class MyOrdersController extends GetxController {
  final segments = ['activeOrders', 'delivered', 'pickup'].obs;
  final selectedSegment = 'activeOrders'.obs;

  final activeOrders = <ListingModel>[].obs;
  final deliveredOrders = <ListingModel>[].obs;
  final pickupOrders = <ListingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMockOrders();
  }

  void loadMockOrders() {
    activeOrders.assignAll([
      ListingModel(
        title: 'iPad Air M2 - 13...',
        price: '\$950',
        seller: 'Sarah Miller',
        image: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?q=80&w=500&auto=format&fit=crop',
        isNew: true,
        isTrade: true,
      ),
      ListingModel(
        title: 'Premium Denim Jeans',
        price: '\$120',
        seller: 'John Doe',
        image: 'https://images.unsplash.com/photo-1542272604-787c3835535d?q=80&w=500&auto=format&fit=crop',
        isNew: true,
        isTrade: true,
      ),
      ListingModel(
        title: 'Modern Office Desk',
        price: '\$450',
        seller: 'Office Hub',
        image: 'https://images.unsplash.com/photo-1518455027359-f3f816b1a22a?q=80&w=500&auto=format&fit=crop',
        isNew: true,
        isTrade: true,
      ),
    ]);
  }
}
