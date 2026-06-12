import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../../../Widgegt/CustomCard/custom_listing_card.dart';
import '../Controller/my_orders_controller.dart';

class MyOrdersScreen extends GetView<MyOrdersController> {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyOrdersController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        StaticString.trackYourPurchasesViewOrderHistory,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      _buildSegments(),
                      SizedBox(height: 30.h),
                      _buildOrdersList(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                  ),
                ),
              ),
              Text(
                StaticString.myOrders,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1.h,
          width: double.infinity,
          color: Colors.white.withOpacity(0.1),
        ),
      ],
    );
  }

  Widget _buildSegments() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.segments.map((segmentKey) {
          return Obx(() {
            bool isSelected = controller.selectedSegment.value == segmentKey;
            String getSegmentText(String key) {
              switch (key) {
                case 'activeOrders':
                  return StaticString.activeOrders;
                case 'delivered':
                  return StaticString.delivered;
                case 'pickup':
                  return StaticString.pickup;
                default:
                  return key;
              }
            }

            return GestureDetector(
              onTap: () => controller.selectedSegment.value = segmentKey,
              child: Container(
                margin: EdgeInsets.only(right: 15.w),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.selectColor
                      : AppColors.cardColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Text(
                  getSegmentText(segmentKey),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          });
        }).toList(),
      ),
    );
  }

  Widget _buildOrdersList() {
    return Obx(() {
      final selected = controller.selectedSegment.value;
      final list = selected == 'activeOrders'
          ? controller.activeOrders
          : selected == 'delivered'
          ? controller.deliveredOrders
          : controller.pickupOrders;

      if (list.isEmpty) {
        return Container(
          height: 300.h,
          alignment: Alignment.center,
          child: Text(
            StaticString.noOrdersFound,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16.sp,
            ),
          ),
        );
      }

      return Wrap(
        spacing: 12.w,
        runSpacing: 15.h,
        children: list.map((item) => CustomListingCard(item: item)).toList(),
      );
    });
  }
}
