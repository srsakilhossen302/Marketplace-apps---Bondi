import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../Controller/my_trades_controller.dart';

class TradeDetailsController extends GetxController {
  final String tradeId = Get.arguments as String;
  
  final isLoading = false.obs;
  final isActionLoading = false.obs;
  final tradeData = Rxn<Map<String, dynamic>>();
  final currentUserId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserIdAndFetch();
  }

  Future<void> _loadUserIdAndFetch() async {
    currentUserId.value = await SharedPrefsHelper.getUserId() ?? '';
    fetchTradeDetails();
  }

  Future<void> fetchTradeDetails() async {
    isLoading.value = true;
    try {
      final response = await ApiClient.get('${ApiUrl.tradeDetails}/$tradeId', requireAuth: true);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          tradeData.value = Map<String, dynamic>.from(decoded['data']);
        }
      }
    } catch (e) {
      print('Error fetching trade details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptOffer() async {
    isActionLoading.value = true;
    try {
      final response = await ApiClient.post('${ApiUrl.tradeAccept}/$tradeId', {}, requireAuth: true);
      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200 && decoded['success'] == true) {
        Get.snackbar(
          'Success',
          decoded['message'] ?? 'Trade offer accepted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
        fetchTradeDetails();
        _refreshListingsList();
      } else {
        Get.snackbar(
          'Error',
          decoded['message'] ?? 'Failed to accept trade offer',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error accepting trade offer: $e');
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> declineOffer() async {
    isActionLoading.value = true;
    try {
      final response = await ApiClient.post('${ApiUrl.tradeReject}/$tradeId', {}, requireAuth: true);
      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200 && decoded['success'] == true) {
        Get.snackbar(
          'Success',
          decoded['message'] ?? 'Trade offer declined successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
        fetchTradeDetails();
        _refreshListingsList();
      } else {
        Get.snackbar(
          'Error',
          decoded['message'] ?? 'Failed to decline trade offer',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error declining trade offer: $e');
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> counterOffer(double amount, String message) async {
    isActionLoading.value = true;
    try {
      final response = await ApiClient.post(
        '${ApiUrl.tradeCounter}/$tradeId',
        {
          'requestedCashAmount': amount,
          'message': message,
        },
        requireAuth: true,
      );
      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200 && decoded['success'] == true) {
        Get.snackbar(
          'Success',
          decoded['message'] ?? 'Counter offer sent successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
        fetchTradeDetails();
        _refreshListingsList();
      } else {
        Get.snackbar(
          'Error',
          decoded['message'] ?? 'Failed to send counter offer',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error sending counter offer: $e');
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> completeTrade() async {
    isActionLoading.value = true;
    try {
      final response = await ApiClient.post('${ApiUrl.tradeComplete}/$tradeId', {}, requireAuth: true);
      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200 && decoded['success'] == true) {
        Get.snackbar(
          'Success',
          decoded['message'] ?? 'Trade completed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
        fetchTradeDetails();
        _refreshListingsList();
      } else {
        Get.snackbar(
          'Error',
          decoded['message'] ?? 'Failed to complete trade',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error completing trade: $e');
    } finally {
      isActionLoading.value = false;
    }
  }

  void _refreshListingsList() {
    try {
      if (Get.isRegistered<MyTradesController>()) {
        Get.find<MyTradesController>().fetchOffers();
      }
    } catch (e) {
      // Ignore
    }
  }
}
