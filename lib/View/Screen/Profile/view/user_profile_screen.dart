import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../Controller/user_profile_controller.dart';
import 'add_listing_screen.dart';
import 'edit_listing_screen.dart';
import 'edit_profile_screen.dart';
import 'friends_screen.dart';
import '../../MyOrders/view/my_orders_screen.dart';

class UserProfileScreen extends GetView<UserProfileController> {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserProfileController());

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
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      _buildProfileHeader(),
                      SizedBox(height: 30.h),
                      _buildStatsGrid(),
                      SizedBox(height: 25.h),
                      _buildMyOrdersButton(),
                      SizedBox(height: 40.h),
                      _buildMyListingsHeader(),
                      SizedBox(height: 20.h),
                      _buildMyListingsGrid(),
                      SizedBox(height: 40.h),
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
                "User Profile",
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

  Widget _buildProfileHeader() {
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
                backgroundImage: NetworkImage(controller.userImage.value),
              ),
            ),
            Positioned(
              bottom: 5.h,
              right: 5.w,
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: AppColors.cardColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.verified, color: Colors.white, size: 18.sp),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        Text(
          controller.userName.value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.workspace_premium,
                color: AppColors.accentColor,
                size: 14.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                "Top Trader",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            controller.bio.value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: 25.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 50.h,
                child: ElevatedButton.icon(
                  onPressed: () => Get.to(() => const EditProfileScreen()),
                  icon: Icon(Icons.edit, size: 18.sp),
                  label: Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 15.sp, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Container(
              height: 50.h,
              width: 50.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.share_outlined,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15.h,
      crossAxisSpacing: 15.w,
      childAspectRatio: 2.0,
      children: [
        _buildStatCard(
          controller.friendsCount.value,
          "FRIENDS",
          onTap: () => Get.to(() => const FriendsScreen()),
        ),
        _buildStatCard(controller.groupsCount.value, "GROUPS"),
        _buildStatCard(controller.tradesCount.value, "TRADES"),
        _buildStatCard(controller.rating.value, "RATING", isRating: true),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label, {
    bool isRating = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.accentColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isRating) ...[
                  SizedBox(width: 4.w),
                  Icon(Icons.star, color: AppColors.accentColor, size: 16.sp),
                ],
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyOrdersButton() {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: () => Get.to(() => const MyOrdersScreen()),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          elevation: 0,
        ),
        child: Text(
          "My Orders",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMyListingsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "My Listings",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Manage All",
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildMyListingsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15.h,
        crossAxisSpacing: 15.w,
        childAspectRatio: 0.8,
      ),
      itemCount: controller.myListings.length + 1,
      itemBuilder: (context, index) {
        if (index < controller.myListings.length) {
          final item = controller.myListings[index];
          return GestureDetector(
            onTap: () => Get.to(() => const EditListingScreen()),
            child: _buildListingCard(item),
          );
        } else {
          return GestureDetector(
            onTap: () => Get.to(() => const AddListingScreen()),
            child: _buildAddListingCard(),
          );
        }
      },
    );
  }

  Widget _buildListingCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  child: Image.network(
                    item['image'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10.h,
                  left: 10.w,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: item['status'] == 'ACTIVE'
                              ? AppColors.accentColor
                              : Colors.cyan.shade700,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Text(
                          item['status'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: AppColors.accentColor,
                              size: 10.sp,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              "AI",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  item['price'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddListingCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add, color: Colors.white, size: 24.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            "Add New Listing",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Start trading",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
