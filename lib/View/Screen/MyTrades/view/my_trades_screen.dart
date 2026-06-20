import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../helper/network_img/image_helper.dart';
import '../Controller/my_trades_controller.dart';

class MyTradesScreen extends GetView<MyTradesController> {
  const MyTradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyTradesController());

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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: _buildSegments(),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accentColor),
                    );
                  }

                  final isReceived = controller.selectedSegment.value == 'received';
                  final list = isReceived
                      ? controller.receivedTradeOffers
                      : controller.sentTradeOffers;

                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.swap_horizontal_circle_outlined,
                            size: 80.sp,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            isReceived ? 'No received offers found' : 'No sent offers found',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Your active and pending trades will appear here.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.3),
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final offer = list[index];
                      return _buildTradeOfferCard(offer, isReceived);
                    },
                  );
                }),
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
                    child: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
                  ),
                ),
              ),
              Text(
                'My Trades',
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
    return Row(
      children: controller.segments.map((segmentKey) {
        return Obx(() {
          bool isSelected = controller.selectedSegment.value == segmentKey;
          String getSegmentText(String key) {
            switch (key) {
              case 'received':
                return 'Received Offers';
              case 'sent':
                return 'Sent Offers';
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
    );
  }

  Widget _buildTradeOfferCard(Map<String, dynamic> offer, bool isReceived) {
    final requester = offer['requesterListingId'] as Map<String, dynamic>?;
    final receiver = offer['receiverListingId'] as Map<String, dynamic>?;

    final requesterImg = _getItemImage(requester);
    final receiverImg = _getItemImage(receiver);

    final requesterTitle = requester?['title']?.toString() ?? 'Unknown Product';
    final receiverTitle = receiver?['title']?.toString() ?? 'Unknown Product';

    final requesterPrice = requester?['price']?.toString() ?? '0';
    final receiverPrice = receiver?['price']?.toString() ?? '0';

    // Parse user username
    String partnerName = 'User';
    if (isReceived) {
      final reqUser = offer['requesterId'];
      if (reqUser is Map) {
        partnerName = reqUser['username']?.toString() ?? 'User';
      } else if (reqUser != null) {
        partnerName = reqUser.toString();
      }
    } else {
      final recUser = offer['receiverId'];
      if (recUser is Map) {
        partnerName = recUser['username']?.toString() ?? 'User';
      } else if (recUser != null) {
        partnerName = recUser.toString();
      }
    }

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trade Request',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    isReceived ? 'From: @$partnerName' : 'To: @$partnerName',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
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
                      isReceived ? 'THEIR OFFER' : 'YOUR OFFER',
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
                      isReceived ? 'FOR YOUR ITEM' : 'FOR THEIR ITEM',
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
