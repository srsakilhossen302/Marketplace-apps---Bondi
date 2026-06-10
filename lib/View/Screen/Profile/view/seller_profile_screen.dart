import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../Controller/seller_profile_controller.dart';

class SellerProfileScreen extends GetView<SellerProfileController> {
  const SellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SellerProfileController());

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
                "Seller Profile",
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

  Widget _buildSellerHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF00E5FF), width: 2.w),
              ),
              child: CircleAvatar(
                radius: 60.r,
                backgroundImage: NetworkImage(controller.sellerImage.value),
              ),
            ),
            Positioned(
              bottom: 5.h,
              right: 5.w,
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: Color(0xFF1F4FB0),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.verified, color: Colors.white, size: 18.sp),
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
            _buildBadge(Icons.verified_user, "Verified Seller"),
            SizedBox(width: 10.w),
            _buildBadge(Icons.bolt, "Top Trader"),
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
          Icon(icon, color: const Color(0xFF00E5FF), size: 12.sp),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(child: _buildButton("Add Friend", isPrimary: true)),
        SizedBox(width: 10.w),
        Expanded(child: _buildButton("Follow")),
        SizedBox(width: 10.w),
        Expanded(child: _buildButton("Text")),
      ],
    );
  }

  Widget _buildButton(String label, {bool isPrimary = false}) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFF003399) : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25.r),
        border: isPrimary ? null : Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: isPrimary ? Colors.white : const Color(0xFF00E5FF),
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2558A8).withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStat(controller.tradesCount.value, "Trades"),
          _buildStat(controller.rating.value, "Rating"),
          _buildStat(controller.followersCount.value, "Followers"),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(color: const Color(0xFF00E5FF), fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("ABOUT SELLER", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 15.h),
        Container(
          padding: EdgeInsets.all(25.r),
          decoration: BoxDecoration(
            color: const Color(0xFF2558A8).withOpacity(0.3),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.longBio.value,
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14.sp, height: 1.5),
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: const Color(0xFF00E5FF), size: 16.sp),
                  SizedBox(width: 5.w),
                  Text(
                    controller.location.value,
                    style: TextStyle(color: const Color(0xFF00E5FF), fontSize: 12.sp),
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("ACTIVE LISTINGS (12)", style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
            Text("View all", style: TextStyle(color: const Color(0xFF00E5FF), fontSize: 12.sp)),
          ],
        ),
        SizedBox(height: 15.h),
        Row(
          children: controller.activeListings.map((item) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF2558A8).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                      child: Image.network(item['image']!, height: 120.h, width: double.infinity, fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title']!, style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold), maxLines: 1),
                          SizedBox(height: 5.h),
                          Text(item['price']!, style: TextStyle(color: const Color(0xFF00E5FF), fontSize: 15.sp, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
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
        Text("MUTUAL FRIENDS", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 15.h),
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: const Color(0xFF2558A8).withOpacity(0.3),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Row(
            children: [
              SizedBox(
                height: 40.h,
                width: 80.w,
                child: Stack(
                  children: List.generate(controller.mutualFriends.length, (index) {
                    return Positioned(
                      left: index * 20.w,
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF2558A8), width: 2.w)),
                        child: CircleAvatar(radius: 18.r, backgroundImage: NetworkImage(controller.mutualFriends[index])),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  "17 mutual friends\nincluding Sarah W.",
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12.sp),
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
        Text("SHARED GROUPS", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 15.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: const Color(0xFF2558A8).withOpacity(0.3),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: controller.sharedGroups.map((group) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  children: [
                    Icon(Icons.group_outlined, color: const Color(0xFF00E5FF), size: 16.sp),
                    SizedBox(width: 10.w),
                    Text(group, style: TextStyle(color: const Color(0xFF00E5FF), fontSize: 13.sp)),
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
