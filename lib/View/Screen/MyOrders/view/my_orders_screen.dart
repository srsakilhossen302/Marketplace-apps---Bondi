import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../../../../helper/network_img/image_helper.dart';
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

      if (selected == 'activeOrders') {
        if (controller.isLoading.value) {
          return SizedBox(
            height: 200.h,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.accentColor),
            ),
          );
        }
        final list = controller.sentTradeOffers;
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
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final offer = list[index];
            return _buildTradeOfferCard(offer);
          },
        );
      }

      final list = selected == 'delivered'
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

  Widget _buildTradeOfferCard(Map<String, dynamic> offer) {
    final requester = offer['requesterListingId'] as Map<String, dynamic>?;
    final receiver = offer['receiverListingId'] as Map<String, dynamic>?;

    final requesterImg = _getItemImage(requester);
    final receiverImg = _getItemImage(receiver);

    final requesterTitle = requester?['title']?.toString() ?? 'Unknown Product';
    final receiverTitle = receiver?['title']?.toString() ?? 'Unknown Product';

    final requesterPrice = requester?['price']?.toString() ?? '0';
    final receiverPrice = receiver?['price']?.toString() ?? '0';

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trade Request',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildStatusBadge(offer['status']?.toString() ?? 'pending'),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR OFFER',
                      style: TextStyle(
                        color: AppColors.accentColor,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.network(
                            requesterImg,
                            width: 50.w,
                            height: 50.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 50.w,
                              height: 50.h,
                              color: Colors.white12,
                              child: const Icon(Icons.image_not_supported, color: Colors.white30),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                requesterTitle,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '\$$requesterPrice',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Icon(
                  Icons.swap_horiz,
                  color: Colors.white.withOpacity(0.4),
                  size: 24.sp,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FOR THEIR ITEM',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.network(
                            receiverImg,
                            width: 50.w,
                            height: 50.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 50.w,
                              height: 50.h,
                              color: Colors.white12,
                              child: const Icon(Icons.image_not_supported, color: Colors.white30),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                receiverTitle,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '\$$receiverPrice',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if ((offer['offeredCashAmount'] != null && (offer['offeredCashAmount'] as num) > 0) ||
              (offer['message'] != null && offer['message'].toString().trim().isNotEmpty)) ...[
            SizedBox(height: 12.h),
            Container(
              height: 1.h,
              width: double.infinity,
              color: Colors.white.withOpacity(0.08),
            ),
            SizedBox(height: 12.h),
            if (offer['offeredCashAmount'] != null && (offer['offeredCashAmount'] as num) > 0)
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.greenAccent,
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Extra Cash Offered: \$${offer['offeredCashAmount']}',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            if (offer['message'] != null && offer['message'].toString().trim().isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white.withOpacity(0.4),
                    size: 14.sp,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      offer['message'].toString().trim(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }

  String _getItemImage(Map<String, dynamic>? item) {
    if (item == null) return '';
    String img = item['thumbnail']?.toString().replaceAll('`', '').trim() ?? '';
    if (img.isEmpty && item['images'] != null && (item['images'] as List).isNotEmpty) {
      img = item['images'][0].toString().replaceAll('`', '').trim();
    }
    return ImageHelper.formatImageUrl(img);
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    switch (status.toLowerCase()) {
      case 'pending':
        bgColor = Colors.amber.withOpacity(0.15);
        textColor = Colors.amber;
        break;
      case 'accepted':
      case 'completed':
        bgColor = Colors.green.withOpacity(0.15);
        textColor = Colors.greenAccent;
        break;
      case 'rejected':
      case 'cancelled':
      case 'expired':
        bgColor = Colors.red.withOpacity(0.15);
        textColor = Colors.redAccent;
        break;
      case 'countered':
        bgColor = Colors.purple.withOpacity(0.15);
        textColor = Colors.purpleAccent;
        break;
      default:
        bgColor = Colors.cyan.withOpacity(0.15);
        textColor = Colors.cyanAccent;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
