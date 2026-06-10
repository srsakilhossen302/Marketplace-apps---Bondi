import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../Controller/community_controller.dart';

class CommunityScreen extends GetView<CommunityController> {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CommunityController());

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
                      _buildSearchBar(),
                      SizedBox(height: 30.h),
                      _buildSectionHeader("Featured Communities", showSeeAll: true),
                      SizedBox(height: 20.h),
                      _buildFeaturedList(),
                      SizedBox(height: 30.h),
                      _buildSectionHeader("My Groups", showSeeAll: false),
                      SizedBox(height: 15.h),
                      _buildMyGroupsList(),
                      SizedBox(height: 30.h),
                      _buildSectionHeader("Explore All Communities", showSeeAll: false, showIcons: true),
                      SizedBox(height: 20.h),
                      _buildExploreList(),
                      SizedBox(height: 30.h),
                      _buildLoadMoreButton(),
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
              Column(
                children: [
                  Text(
                    "Communities",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Progress-like indicator under text
                  Container(
                    width: 30.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 15.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ),
                ],
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

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2558A8).withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Colors.white.withOpacity(0.6), size: 20.sp),
          hintText: "Search Trade & more",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14.sp),
          border: InputBorder.none,
          suffixIcon: Icon(Icons.tune, color: Colors.white.withOpacity(0.6), size: 20.sp),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showSeeAll = false, bool showIcons = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showSeeAll)
          Text(
            "See All",
            style: TextStyle(color: const Color(0xFF00E5FF), fontSize: 13.sp),
          ),
        if (showIcons)
          Row(
            children: [
              Icon(Icons.filter_list, color: const Color(0xFF00E5FF).withOpacity(0.6), size: 20.sp),
              SizedBox(width: 15.w),
              Icon(Icons.grid_view, color: const Color(0xFF00E5FF).withOpacity(0.6), size: 20.sp),
            ],
          ),
      ],
    );
  }

  Widget _buildFeaturedList() {
    return SizedBox(
      height: 360.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.featuredCommunities.length,
        itemBuilder: (context, index) {
          final item = controller.featuredCommunities[index];
          return Container(
            width: 260.w,
            margin: EdgeInsets.only(right: 15.w),
            decoration: BoxDecoration(
              color: const Color(0xFF2558A8).withOpacity(0.4),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                      child: Image.network(
                        item['image']!,
                        height: 160.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 160.h,
                          color: Colors.white.withOpacity(0.1),
                          child: const Icon(Icons.image_not_supported, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15.h,
                      left: 15.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0044CC),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          item['tag']!,
                          style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 100.h),
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_user, color: const Color(0xFF00E5FF), size: 12.sp),
                            SizedBox(width: 5.w),
                            Text(
                              "Code: ${item['code']}",
                              style: TextStyle(color: Colors.white, fontSize: 10.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(15.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']!,
                        style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        item['description']!,
                        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12.sp),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['members']!,
                                style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Members",
                                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11.sp),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF003399),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                            ),
                            child: Text("Join Group", style: TextStyle(fontSize: 12.sp)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMyGroupsList() {
    return Column(
      children: controller.myGroups.map((item) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: const Color(0xFF2558A8).withOpacity(0.4),
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.network(item['image']!, width: 50.w, height: 50.h, fit: BoxFit.cover),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title']!,
                      style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item['status']!,
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
              Text(
                "Open",
                style: TextStyle(color: const Color(0xFF00E5FF), fontSize: 13.sp),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExploreList() {
    return Column(
      children: controller.exploreCommunities.map((item) {
        return Container(
          margin: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
            color: const Color(0xFF2558A8).withOpacity(0.4),
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                child: Image.network(
                  item['image']!,
                  height: 180.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180.h,
                    color: Colors.white.withOpacity(0.1),
                    child: const Icon(Icons.image_not_supported, color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title']!,
                      style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Code: ${item['code']}",
                            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11.sp),
                          ),
                          SizedBox(width: 5.w),
                          Icon(Icons.verified_user, color: const Color(0xFF00E5FF), size: 12.sp),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      item['members']!,
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12.sp),
                    ),
                    SizedBox(height: 15.h),
                    SizedBox(
                      width: double.infinity,
                      height: 45.h,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF00E5FF)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                        ),
                        child: Text(
                          "Join Community",
                          style: TextStyle(color: const Color(0xFF00E5FF), fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoadMoreButton() {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0044CC),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
        ),
        child: Text(
          "Load More Communities",
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
