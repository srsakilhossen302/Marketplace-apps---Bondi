import 'dart:convert';
import 'package:get/get.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';

class MyTradesController extends GetxController {
  final segments = ['received', 'sent'].obs;
  final selectedSegment = 'received'.obs;

  final receivedTradeOffers = <Map<String, dynamic>>[].obs;
  final sentTradeOffers = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOffers();
  }

  void fetchOffers() {
    fetchReceivedTradeOffers();
    fetchSentTradeOffers();
  }

  Future<void> fetchReceivedTradeOffers() async {
    isLoading.value = true;
    try {
      final response = await ApiClient.get(ApiUrl.tradeReceived, requireAuth: true);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final List<dynamic> list = decoded['data'];
          final mappedList = list.map((e) => Map<String, dynamic>.from(e)).toList();
          mappedList.sort((a, b) {
            final aPending = (a['status']?.toString().toLowerCase() ?? '') == 'pending';
            final bPending = (b['status']?.toString().toLowerCase() ?? '') == 'pending';
            if (aPending && !bPending) return -1;
            if (!aPending && bPending) return 1;
            return 0;
          });
          receivedTradeOffers.assignAll(mappedList);
        }
      }
    } catch (e) {
      print('Error fetching received trade offers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSentTradeOffers() async {
    isLoading.value = true;
    try {
      final response = await ApiClient.get(ApiUrl.tradeSent, requireAuth: true);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final List<dynamic> list = decoded['data'];
          final mappedList = list.map((e) => Map<String, dynamic>.from(e)).toList();
          mappedList.sort((a, b) {
            final aPending = (a['status']?.toString().toLowerCase() ?? '') == 'pending';
            final bPending = (b['status']?.toString().toLowerCase() ?? '') == 'pending';
            if (aPending && !bPending) return -1;
            if (!aPending && bPending) return 1;
            return 0;
          });
          sentTradeOffers.assignAll(mappedList);
        }
      }
    } catch (e) {
      print('Error fetching sent trade offers: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
