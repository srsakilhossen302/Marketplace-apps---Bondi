import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../Controller/seller_profile_controller.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../Login/view/login_screen.dart';
import '../../ProductDetails/view/product_details_screen.dart';
import '../../../../Model/home_models.dart';
import 'seller_all_listings_screen.dart';


class SellerProfileScreen extends StatefulWidget {
  const SellerProfileScreen({super.key});

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  late final String _controllerTag;

  @override
  void initState() {
    super.initState();
    final String sellerId = Get.arguments ?? '';
    _controllerTag = identityHashCode(sellerId).toString();
    Get.put(SellerProfileController(), tag: _controllerTag);
  }

  @override
  void dispose() {
    Get.delete<SellerProfileController>(tag: _controllerTag);
    super.dispose();
  }

  SellerProfileController get controller => Get.find<SellerProfileController>(tag: _controllerTag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Obx(
                  () {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accentColor,
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          _buildSellerHeader(),
                          SizedBox(height: 25.h),
                          _buildActionButtons(),
                          SizedBox(height: 30.h),
                          _buildStatsRow(),
                          SizedBox(height: 40.h),
                          _buildAboutSection(),
                          SizedBox(height: 40.h),
                          _buildActiveListingsSection(),
                          SizedBox(height: 40.h),
                          _buildMutualFriendsSection(),
                          SizedBox(height: 40.h),
                          _buildSharedGroupsSection(),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    );
                  },
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
                StaticString.sellerProfile,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Obx(() {
                  final status = controller.relationshipStatus.value;
                  if (status == 'blocked') {
                    return const SizedBox.shrink();
                  }
                  return PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.white, size: 24.sp),
                    color: AppColors.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    onSelected: (value) {
                      if (value == 'block') {
                        controller.blockUser();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'block',
                        child: Row(
                          children: [
                            Icon(Icons.block, color: Colors.redAccent, size: 18.sp),
                            SizedBox(width: 8.w),
                            Text(
                              'Block User',
                              style: TextStyle(color: Colors.white, fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
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

  Widget _buildSellerHeader() {
    final image = controller.sellerImage.value.isNotEmpty
        ? controller.sellerImage.value
        : 'https://i.pravatar.cc/150?u=${controller.sellerName.value.hashCode}';

    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accentColor, width: 2.w),
              ),
              child: CircleAvatar(
                radius: 60.r,
                backgroundImage: NetworkImage(image),
              ),
            ),
            if (controller.isVerifiedSeller.value)
              Positioned(
                bottom: 5.h,
                right: 5.w,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: const BoxDecoration(
                    color: AppColors.cardColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.verified, color: Colors.blue, size: 18.sp),
                ),
              ),
          ],
        ),
        SizedBox(height: 15.h),
        Text(
          controller.sellerName.value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.isVerifiedSeller.value)
              _buildBadge(Icons.verified_user, StaticString.verifiedSeller)
            else
              _buildBadge(Icons.info_outline, StaticString.notVerifiedSeller),
          ],
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            controller.shortBio.value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.accentColor, size: 12.sp),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Obx(() {
      final status = controller.relationshipStatus.value;

      if (controller.isConnectionActionLoading.value) {
        return Center(
          child: SizedBox(
            height: 50.h,
            width: 50.w,
            child: const CircularProgressIndicator(color: AppColors.accentColor),
          ),
        );
      }

      if (status == 'blocked') {
        return Row(
          children: [
            Expanded(
              child: _buildButton(
                "Unblock",
                isPrimary: true,
                onTap: () => controller.unblockUser(),
              ),
            ),
          ],
        );
      }

      if (status == 'pending_received') {
        return Row(
          children: [
            Expanded(
              child: _buildButton(
                "Accept",
                isPrimary: true,
                onTap: () => controller.acceptFriendRequest(),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildButton(
                "Decline",
                isPrimary: false,
                onTap: () => controller.declineFriendRequest(),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildButton(
                "Message",
                isPrimary: false,
                onTap: () => controller.startChat(),
              ),
            ),
          ],
        );
      }

      // Default states: 'none', 'pending_sent', 'friend' (or accepted)
      String connectionLabel = "Add Friend";
      VoidCallback connectionAction = () => controller.sendFriendRequest();
      bool isPrimary = true;

      if (status == 'pending_sent') {
        connectionLabel = "Cancel Request";
        connectionAction = () => controller.cancelFriendRequest();
        isPrimary = false;
      } else if (status == 'friend' || status == 'accepted') {
        connectionLabel = "Unfriend";
        connectionAction = () => controller.removeFriend();
        isPrimary = false;
      }

      return Row(
        children: [
          Expanded(
            child: _buildButton(
              connectionLabel,
              isPrimary: isPrimary,
              onTap: connectionAction,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _buildButton(
              "Message",
              isPrimary: false,
              onTap: () => controller.startChat(),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildButton(String label, {bool isPrimary = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.buttonColor
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25.r),
          border: isPrimary
              ? null
              : Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isPrimary ? Colors.white : AppColors.accentColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStat(controller.tradesCount.value, StaticString.trades),
          _buildStat(controller.rating.value, StaticString.rating),
          _buildStat(controller.followersCount.value, StaticString.followers),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: AppColors.accentColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StaticString.aboutSeller,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        Container(
          padding: EdgeInsets.all(25.r),
          decoration: BoxDecoration(
            color: AppColors.cardColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.longBio.value,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14.sp,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.accentColor,
                    size: 16.sp,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    controller.location.value,
                    style: TextStyle(
                      color: AppColors.accentColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActiveListingsSection() {
    if (controller.activeListings.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              StaticString.activeListingsCount,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => SellerAllListingsScreen(controllerTag: _controllerTag)),
              child: Text(
                StaticString.viewAll,
                style: TextStyle(color: AppColors.accentColor, fontSize: 12.sp),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        Row(
          children: controller.activeListings.take(3).map((item) {
            final listingModel = ListingModel(
              title: item['title'] ?? '',
              price: item['price'] ?? '',
              seller: controller.sellerName.value,
              image: item['image'] ?? '',
              slug: item['slug'] ?? '',
            );
            return Expanded(
              child: GestureDetector(
                onTap: () async {
                  final token = await SharedPrefsHelper.getToken();
                  if (token != null && token.isNotEmpty) {
                    Get.to(() => const ProductDetailsScreen(), arguments: listingModel);
                  } else {
                    Get.to(() => const LoginScreen());
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10.w),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.r),
                        ),
                        child: Image.network(
                          item['image']!,
                          height: 120.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title']!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              item['price']!,
                              style: TextStyle(
                                color: AppColors.accentColor,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMutualFriendsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StaticString.mutualFriends,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.cardColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Row(
            children: [
              SizedBox(
                height: 40.h,
                width: 80.w,
                child: Stack(
                  children: List.generate(controller.mutualFriends.length, (
                    index,
                  ) {
                    return Positioned(
                      left: index * 20.w,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.cardColor,
                            width: 2.w,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 18.r,
                          backgroundImage: NetworkImage(
                            controller.mutualFriends[index],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  "${controller.mutualFriendsCount.value} Mutual Friends",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSharedGroupsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StaticString.sharedGroups,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.cardColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: controller.sharedGroups.map((group) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.group_outlined,
                      color: AppColors.accentColor,
                      size: 16.sp,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      group,
                      style: TextStyle(
                        color: AppColors.accentColor,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
