import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
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
                      _buildStatsRow(),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
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
              Text(
                StaticString.userProfile,
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
              bottom: 4.h,
              right: 4.w,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(1.r),
                child: Icon(
                  Icons.verified,
                  color: const Color(0xFF1E5EF3),
                  size: 22.sp,
                ),
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
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFF0C1B3A),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: const Color(0xFF1E5EF3).withOpacity(0.3),
              width: 1.w,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: const Color(0xFF1E5EF3),
                size: 11.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                StaticString.topTraderLabel,
                style: TextStyle(
                  color: const Color(0xFF1E5EF3),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
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
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const EditProfileScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0040C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        StaticString.editProfileButton,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.edit, size: 14.sp, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Container(
              height: 48.h,
              width: 48.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF002FA7),
                  width: 1.2.w,
                ),
              ),
              child: Icon(
                Icons.share_outlined,
                color: const Color(0xFF0052D4),
                size: 18.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildStatCard(
            controller.friendsCount.value,
            StaticString.friends.toUpperCase(),
            onTap: () => Get.to(() => const FriendsScreen()),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildStatCard(
            controller.groupsCount.value,
            StaticString.groups.toUpperCase(),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildStatCard(
            controller.tradesCount.value,
            StaticString.trades.toUpperCase(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 75.h,
        decoration: BoxDecoration(
          color: const Color(0xFF00195C).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFF004ECC), width: 1.2.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                color: const Color(0xFF00D8F6),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
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
          StaticString.myOrders,
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
          StaticString.myListings,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          StaticString.manageAll,
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
        color: const Color(
          0xFF0C1B3A,
        ).withOpacity(0.2), // Dark transparent background
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: const Color(0xFF002FA7).withOpacity(0.5),
          width: 1.2.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(14.r),
                    ),
                    child: Image.network(item['image'], fit: BoxFit.cover),
                  ),
                ),
                // Status Badge
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getBadgeColor(item['status'], item['title']),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      item['status'],
                      style: TextStyle(
                        color: _getBadgeTextColor(
                          item['status'],
                          item['title'],
                        ),
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color:
                  AppColors.cardColor, // Royal blue background for info section
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(14.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  item['price'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
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

  Color _getBadgeColor(String status, String title) {
    if (status == 'SOLD') {
      return const Color(0xFF00D8F6); // Cyan
    }
    if (title.contains('Bond')) {
      return Colors.white; // White
    }
    return const Color(0xFF00E5FF); // Bright cyan
  }

  Color _getBadgeTextColor(String status, String title) {
    if (title.contains('Bond')) {
      return const Color(0xFF000039); // Deep dark navy
    }
    return Colors.white;
  }

  Widget _buildAddListingCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(
          0xFF0C1B3A,
        ).withOpacity(0.2), // Dark transparent background
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: const Color(0xFF002FA7).withOpacity(0.5),
          width: 1.2.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plus Icon Section
          Expanded(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5.w),
                ),
                child: Icon(Icons.add, color: Colors.white, size: 20.sp),
              ),
            ),
          ),
          // Info Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.cardColor, // Royal blue background
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(14.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StaticString.addNewListing,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  StaticString.startTrading,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
