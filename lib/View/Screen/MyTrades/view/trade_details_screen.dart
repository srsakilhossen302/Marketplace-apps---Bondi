import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../helper/network_img/image_helper.dart';
import '../Controller/trade_details_controller.dart';

class TradeDetailsScreen extends GetView<TradeDetailsController> {
  const TradeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TradeDetailsController());

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
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accentColor),
                    );
                  }

                  final data = controller.tradeData.value;
                  if (data == null) {
                    return Center(
                      child: Text(
                        'Failed to load trade details.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 16.sp,
                        ),
                      ),
                    );
                  }

                  final trade = data['trade'] as Map<String, dynamic>;
                  final requesterProfile = data['requesterProfile'] as Map<String, dynamic>?;
                  final receiverProfile = data['receiverProfile'] as Map<String, dynamic>?;

                  final requesterListing = trade['requesterListingId'] as Map<String, dynamic>?;
                  final receiverListing = trade['receiverListingId'] as Map<String, dynamic>?;

                  final status = (trade['status'] ?? 'pending').toString().toLowerCase();
                  final lastUpdatedBy = trade['lastUpdatedBy']?.toString() ?? '';
                  final isMySentOffer = trade['requesterId'] is Map
                      ? (trade['requesterId']['_id']?.toString() == controller.currentUserId.value)
                      : (trade['requesterId']?.toString() == controller.currentUserId.value);

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildStatusSection(status),
                              SizedBox(height: 25.h),
                              
                              // Requester (Sender's Offer) Section
                              _buildItemCard(
                                title: isMySentOffer ? 'YOUR OFFERED ITEM' : 'THEIR OFFERED ITEM',
                                listing: requesterListing,
                                profile: requesterProfile,
                                accentColor: AppColors.accentColor,
                              ),
                              
                              SizedBox(height: 15.h),
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(12.r),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.swap_vert_circle_outlined,
                                    color: Colors.white,
                                    size: 32.sp,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.h),
                              
                              // Receiver (Target Item) Section
                              _buildItemCard(
                                title: isMySentOffer ? 'THEIR ITEM YOU WANT' : 'YOUR ITEM THEY WANT',
                                listing: receiverListing,
                                profile: receiverProfile,
                                accentColor: Colors.cyanAccent,
                              ),
                              
                              SizedBox(height: 25.h),
                              _buildCashAndMessageDetails(trade),
                              SizedBox(height: 30.h),
                            ],
                          ),
                        ),
                      ),
                      _buildActionButtons(status, lastUpdatedBy),
                    ],
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
                'Trade Details',
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

  Widget _buildStatusSection(String status) {
    Color badgeColor;
    Color textColor;
    switch (status) {
      case 'pending':
        badgeColor = Colors.amber.withOpacity(0.15);
        textColor = Colors.amber;
        break;
      case 'accepted':
        badgeColor = Colors.green.withOpacity(0.15);
        textColor = Colors.greenAccent;
        break;
      case 'completed':
        badgeColor = Colors.blue.withOpacity(0.15);
        textColor = Colors.blueAccent;
        break;
      case 'rejected':
      case 'cancelled':
      case 'expired':
        badgeColor = Colors.red.withOpacity(0.15);
        textColor = Colors.redAccent;
        break;
      case 'countered':
        badgeColor = Colors.purple.withOpacity(0.15);
        textColor = Colors.purpleAccent;
        break;
      default:
        badgeColor = Colors.cyan.withOpacity(0.15);
        textColor = Colors.cyanAccent;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Trade Status',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                color: textColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard({
    required String title,
    required Map<String, dynamic>? listing,
    required Map<String, dynamic>? profile,
    required Color accentColor,
  }) {
    if (listing == null) return const SizedBox.shrink();

    final titleStr = listing['title']?.toString() ?? 'No Title';
    final price = listing['price']?.toString() ?? '0';
    final desc = listing['description']?.toString() ?? 'No description provided';
    final category = listing['category']?.toString() ?? '';
    final condition = listing['condition']?.toString() ?? '';
    final city = listing['city']?.toString() ?? '';
    final country = listing['country']?.toString() ?? '';

    String image = listing['thumbnail']?.toString().replaceAll('`', '').trim() ?? '';
    if (image.isEmpty && listing['images'] != null && (listing['images'] as List).isNotEmpty) {
      image = listing['images'][0].toString().replaceAll('`', '').trim();
    }
    final formattedImage = ImageHelper.formatImageUrl(image);

    // Profile details
    final displayName = profile?['displayName']?.toString() ?? 'User';
    final username = profile?['username']?.toString() ?? 'User';
    final completedTrades = profile?['completedTrades']?.toString() ?? '0';
    final profileImg = profile?['profileImage']?.toString() ?? '';
    final formattedProfileImg = profileImg.isNotEmpty
        ? ImageHelper.formatImageUrl(profileImg)
        : 'https://i.pravatar.cc/150?u=default';

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: accentColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.network(
                  formattedImage,
                  width: 80.w,
                  height: 80.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80.w,
                    height: 80.h,
                    color: Colors.white12,
                    child: const Icon(Icons.image_not_supported, color: Colors.white30),
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleStr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '\$$price',
                      style: TextStyle(
                        color: AppColors.accentColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        if (category.isNotEmpty)
                          _buildPill(category.toUpperCase(), Colors.white24),
                        if (condition.isNotEmpty) ...[
                          SizedBox(width: 6.w),
                          _buildPill(condition.replaceAll('_', ' ').toUpperCase(), Colors.amber.withOpacity(0.2)),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            desc,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13.sp,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (city.isNotEmpty || country.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.white30, size: 14.sp),
                SizedBox(width: 4.w),
                Text(
                  [city, country].where((s) => s.isNotEmpty).join(', '),
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 15.h),
          Container(
            height: 1.h,
            color: Colors.white.withOpacity(0.08),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundImage: NetworkImage(formattedProfileImg),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@$username',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '$completedTrades Trades',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCashAndMessageDetails(Map<String, dynamic> trade) {
    final offeredCash = trade['offeredCashAmount'] as num? ?? 0;
    final requestedCash = trade['requestedCashAmount'] as num? ?? 0;
    final message = trade['message']?.toString() ?? '';

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OFFER DETAILS',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          if (offeredCash > 0)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Icon(Icons.add_circle, color: Colors.greenAccent, size: 16.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Extra Cash Offered: \$${offeredCash}',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          if (requestedCash > 0)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Icon(Icons.remove_circle, color: Colors.amberAccent, size: 16.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Extra Cash Requested: \$${requestedCash}',
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          if (message.isNotEmpty) ...[
            if (offeredCash > 0 || requestedCash > 0) SizedBox(height: 8.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.chat_bubble_outline, color: Colors.white.withOpacity(0.4), size: 16.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (offeredCash == 0 && requestedCash == 0 && message.isEmpty)
            Text(
              'No additional cash or message offered.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 13.sp,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(String status, String lastUpdatedBy) {
    final showAcceptDeclineCounter = status == 'pending' || status == 'countered';
    final isLastUpdatedByOther = lastUpdatedBy != controller.currentUserId.value;
    final showComplete = status == 'accepted';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
      ),
      child: Obx(() {
        if (controller.isActionLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accentColor),
          );
        }

        if (showAcceptDeclineCounter) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLastUpdatedByOther) ...[
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: () => controller.acceptOffer(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Accept Offer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
              ],
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () => controller.declineOffer(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Decline',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        if (showComplete) {
          return SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: () => controller.completeTrade(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Mark as Completed',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      }),
    );
  }
}
