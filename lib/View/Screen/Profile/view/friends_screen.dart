import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../Controller/friends_controller.dart';
import 'seller_profile_screen.dart';

class FriendsScreen extends GetView<FriendsController> {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FriendsController());

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        "Manage your network and discover new\nconnections.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14.sp,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _buildInviteButton(),
                      SizedBox(height: 25.h),
                      _buildSearchBar(),
                      SizedBox(height: 25.h),
                      _buildTabs(),
                      SizedBox(height: 20.h),
                      _buildFriendsList(),
                      SizedBox(height: 30.h),
                      _buildRecommendedHeader(),
                      SizedBox(height: 20.h),
                      _buildRecommendedList(),
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
                "Friends",
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

  Widget _buildInviteButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_add_alt_1,
            color: AppColors.accentColor,
            size: 18.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            "Invite Contacts",
            style: TextStyle(
              color: AppColors.accentColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(
            Icons.search,
            color: Colors.white.withOpacity(0.6),
            size: 20.sp,
          ),
          hintText: "Search people or username",
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14.sp,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = ["Friends", "Following", "Requests", "Suggested"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          int idx = entry.key;
          String text = entry.value;
          return Obx(
            () => GestureDetector(
              onTap: () => controller.selectedTab.value = idx,
              child: Container(
                margin: EdgeInsets.only(right: 25.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          text,
                          style: TextStyle(
                            color: controller.selectedTab.value == idx
                                ? AppColors.accentColor
                                : Colors.white.withOpacity(0.5),
                            fontSize: 14.sp,
                            fontWeight: controller.selectedTab.value == idx
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        if (text == "Requests") ...[
                          SizedBox(width: 5.w),
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (controller.selectedTab.value == idx)
                      Container(
                        margin: EdgeInsets.only(top: 8.h),
                        height: 2.h,
                        width: 40.w,
                        color: AppColors.accentColor,
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFriendsList() {
    return Obx(() {
      List<Map<String, String>> currentList;
      switch (controller.selectedTab.value) {
        case 0:
          currentList = controller.friends;
          break;
        case 1:
          currentList = controller.following;
          break;
        case 2:
          currentList = controller.requests;
          break;
        case 3:
          currentList = controller.suggested;
          break;
        default:
          currentList = controller.friends;
      }

      return Column(
        children: currentList.map((item) {
          if (controller.selectedTab.value == 2) {
            // Requests view (based on Image 1)
            return GestureDetector(
              onTap: () => Get.to(() => const SellerProfileScreen()),
              child: Container(
                margin: EdgeInsets.only(bottom: 15.h),
                padding: EdgeInsets.all(15.r),
                decoration: BoxDecoration(
                  color: AppColors.cardColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25.r,
                          backgroundImage: NetworkImage(item['image']!),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                item['mutual']!,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40.h,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                              ),
                              child: Text(
                                "Accept",
                                style: TextStyle(fontSize: 14.sp,  color: Color(0xffFFFFFF)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: SizedBox(
                            height: 40.h,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                              ),
                              child: Text(
                                "Decline",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          // Other views (Friends, Following, Suggested)
          return GestureDetector(
            onTap: () => Get.to(() => const SellerProfileScreen()),
            child: Container(
              margin: EdgeInsets.only(bottom: 15.h),
              padding: EdgeInsets.all(15.r),
              decoration: BoxDecoration(
                color: AppColors.cardColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25.r,
                    backgroundImage: NetworkImage(item['image']!),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          item['mutual']!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildActionWidget(),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildActionWidget() {
    switch (controller.selectedTab.value) {
      case 1: // Following
        return Text(
          "Unfollow",
          style: TextStyle(
            color: AppColors.accentColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        );
      case 3: // Suggested
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.buttonColor,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Text(
            "Add Friend",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      default: // Friends
        return Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.chat_bubble_outline,
            color: AppColors.accentColor,
            size: 18.sp,
          ),
        );
    }
  }

  Widget _buildRecommendedHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Recommended for you",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "View all",
          style: TextStyle(color: AppColors.accentColor, fontSize: 13.sp),
        ),
      ],
    );
  }

  Widget _buildRecommendedList() {
    return Row(
      children: controller.recommended.map((item) {
        return Expanded(
          child: GestureDetector(
            onTap: () => Get.to(() => const SellerProfileScreen()),
            child: Container(
              margin: EdgeInsets.only(right: 15.w),
              padding: EdgeInsets.all(15.r),
              decoration: BoxDecoration(
                color: AppColors.cardColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 35.r,
                        backgroundImage: NetworkImage(item['image']!),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: const BoxDecoration(
                            color: AppColors.accentColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.bolt,
                            color: Colors.white,
                            size: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    item['name']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item['mutual']!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  SizedBox(
                    width: double.infinity,
                    height: 35.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      child: Text(
                        "Add Friend",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Color(0xffFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
