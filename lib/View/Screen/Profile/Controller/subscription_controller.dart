import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';

class SubscriptionController extends GetxController {
  final activeSubscription = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;

  final plans = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await fetchPlans();
    await checkActiveSubscription();
  }

  Future<void> fetchPlans() async {
    isLoading.value = true;
    try {
      final response = await ApiClient.get(ApiUrl.subscriptionPlans, requireAuth: true);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final List<dynamic> list = decoded['data'];
          if (list.isNotEmpty) {
            final List<Map<String, dynamic>> parsedPlans = list.map((e) {
              final planData = Map<String, dynamic>.from(e);
              final name = planData['name'] ?? 'Plan';
              final priceVal = planData['price'];
              final price = priceVal != null ? (priceVal == 0 ? 'Free' : '\$$priceVal') : 'Free';
              final badge = planData['badge']?.toString() ?? 'Popular';
              final description = planData['description']?.toString() ?? '';
              
              final displayFeatures = planData['displayFeatures'] != null
                  ? List<String>.from(planData['displayFeatures'])
                  : <String>[];
              
              return {
                '_id': planData['_id'],
                'name': name,
                'tag': badge,
                'price': price,
                'priceSuffix': description,
                'isCurrent': false,
                'features': displayFeatures,
              };
            }).toList();
            plans.assignAll(parsedPlans);
          }
        }
      }
    } catch (e) {
      print('Error fetching subscription plans: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkActiveSubscription() async {
    isLoading.value = true;
    try {
      final response = await ApiClient.get(ApiUrl.mySubscription, requireAuth: true);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final activeSubData = Map<String, dynamic>.from(decoded['data']);
          activeSubscription.value = activeSubData;
          _updateCurrentPlanState(activeSubData);
        } else {
          activeSubscription.value = null;
          _resetCurrentPlanStateToFree();
        }
      } else {
        activeSubscription.value = null;
        _resetCurrentPlanStateToFree();
      }
    } catch (e) {
      print('Error checking active subscription: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateCurrentPlanState(Map<String, dynamic> activeSubData) {
    final activePlan = activeSubData['planId'];
    if (activePlan == null) return;
    
    final activePlanId = (activePlan is Map ? activePlan['_id'] : activePlan.toString()).toString();
    final activePlanType = activeSubData['planType']?.toString().toLowerCase() ?? '';
    
    final updatedPlans = plans.map((p) {
      final planMap = Map<String, dynamic>.from(p);
      final id = planMap['_id']?.toString() ?? '';
      final name = planMap['name']?.toString().toLowerCase() ?? '';
      
      bool isMatch = false;
      if (id.isNotEmpty && id == activePlanId) {
        isMatch = true;
      } else if (name.contains(activePlanType) || (activePlanType == 'premium' && name.contains('diamond'))) {
        isMatch = true;
      }
      
      planMap['isCurrent'] = isMatch;
      return planMap;
    }).toList();
    
    plans.assignAll(updatedPlans);
  }

  void _resetCurrentPlanStateToFree() {
    final updatedPlans = plans.map((p) {
      final planMap = Map<String, dynamic>.from(p);
      final name = planMap['name']?.toString().toLowerCase() ?? '';
      planMap['isCurrent'] = (name == 'free');
      return planMap;
    }).toList();
    plans.assignAll(updatedPlans);
  }

  Future<void> subscribeToPlan(String planId) async {
    if (planId == 'free_plan') return;
    
    isLoading.value = true;
    try {
      final intentResponse = await ApiClient.post(
        ApiUrl.createIntent,
        {'planId': planId},
        requireAuth: true,
      );
      
      if (intentResponse.statusCode != 200 && intentResponse.statusCode != 201) {
        final errorMsg = jsonDecode(intentResponse.body)['message'] ?? 'Failed to prepare payment intent.';
        Get.snackbar(
          'Payment Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
        );
        return;
      }
      
      final intentDecoded = jsonDecode(intentResponse.body);
      if (intentDecoded['success'] != true || intentDecoded['data'] == null) {
        Get.snackbar(
          'Payment Error',
          'Failed to retrieve payment details.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
        );
        return;
      }
      
      final intentData = intentDecoded['data'];
      final clientSecret = intentData['clientSecret']?.toString() ?? '';
      final paymentIntentId = intentData['paymentIntentId']?.toString() ?? '';
      
      if (clientSecret.isEmpty || paymentIntentId.isEmpty) {
        Get.snackbar(
          'Payment Error',
          'Invalid payment intent received.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
        );
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Bondi Marketplace',
          style: ThemeMode.dark,
        ),
      );
      
      await Stripe.instance.presentPaymentSheet();
      
      final verifyResponse = await ApiClient.post(
        ApiUrl.verifySubscription,
        {
          'planId': planId,
          'paymentIntentId': paymentIntentId,
        },
        requireAuth: true,
      );
      
      if (verifyResponse.statusCode == 200 || verifyResponse.statusCode == 201) {
        final verifyDecoded = jsonDecode(verifyResponse.body);
        if (verifyDecoded['success'] == true) {
          await checkActiveSubscription();
          _showSuccessDialog();
          return;
        }
      }
      
      Get.snackbar(
        'Verification Failed',
        'Could not verify your payment. Please contact support.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    } on StripeException catch (e) {
      final errorMsg = e.error.localizedMessage ?? 'Payment Failed or Cancelled.';
      print('StripeException: $errorMsg');
      Get.snackbar(
        'Payment Info',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error in subscription flow: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred during payment.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccessDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Container(
          padding: EdgeInsets.all(25.r),
          decoration: BoxDecoration(
            color: AppColors.cardColor.withOpacity(0.95),
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: const BoxDecoration(
                  color: AppColors.accentColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Subscribed Successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Your subscription has been activated successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 25.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Go to Dashboard',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
