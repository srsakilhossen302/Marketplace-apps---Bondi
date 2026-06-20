import 'dart:convert';
import 'package:get/get.dart';
import '../../../../Model/home_models.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';

class MyOrdersController extends GetxController {
  final segments = ['activeOrders', 'delivered', 'pickup'].obs;
  final selectedSegment = 'activeOrders'.obs;

  final sentTradeOffers = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  final deliveredOrders = <ListingModel>[].obs;
  final pickupOrders = <ListingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSentTradeOffers();
  }

  Future<void> fetchSentTradeOffers() async {
    isLoading.value = true;
    try {
      final response = await ApiClient.get(ApiUrl.tradeSent, requireAuth: true);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final List<dynamic> list = decoded['data'];
          sentTradeOffers.assignAll(list.map((e) => Map<String, dynamic>.from(e)).toList());
        }
      }
    } catch (e) {
      print('Error fetching sent trade offers: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
