import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../Controller/community_controller.dart';
import '../../Messages/view/chat_detail_screen.dart';
import '../../Search/view/search_screen.dart';
import '../../Main/Controller/main_controller.dart';

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
                      _buildSectionHeader(StaticString.myGroups, showSeeAll: false),
                      SizedBox(height: 15.h),
                      _buildMyGroupsList(),
                      SizedBox(height: 30.h),
                      _buildSectionHeader(StaticString.exploreAllCommunities, showSeeAll: false, showIcons: true),
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
                  onTap: () => Get.find<MainController>().changeIndex(0),
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
                    StaticString.communities,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
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
    return GestureDetector(
      onTap: () => Get.to(() => const SearchScreen()),
      child: Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          color: AppColors.cardColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.white.withValues(alpha: 0.6), size: 20.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                StaticString.searchTradeMore,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
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
            StaticString.seeAll,
            style: TextStyle(color: AppColors.accentColor, fontSize: 13.sp),
          ),
        if (showIcons)
          Obx(() => Row(
                children: [
                  GestureDetector(
                    onTap: () => controller.isGridView.value = !controller.isGridView.value,
                    child: Icon(
                      controller.isGridView.value ? Icons.view_list : Icons.grid_view,
                      color: controller.isGridView.value
                          ? AppColors.accentColor
                          : Colors.white.withValues(alpha: 0.6),
                      size: 20.sp,
                    ),
                  ),
                ],
              )),
      ],
    );
  }

Widget _buildMyGroupsList() {
    return Obx(() {
      if (controller.isMyGroupsLoading.value && controller.myGroups.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: AppColors.accentColor),
          ),
        );
      }
      if (controller.myGroups.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Text(
              'No groups joined yet',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      }
      return Column(
        children: controller.myGroups.map((item) {
          return GestureDetector(
            onTap: () {
              Get.to(
                () => const ChatDetailScreen(),
                arguments: {
                  'conversationId': item['_id'] ?? '',
                  'name': item['title'] ?? '',
                  'image': item['image'] ?? '',
                  'conversationType': 'group',
                  'isGroup': true,
                },
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.cardColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: Image.network(
                      item['image']!,
                      width: 50.w,
                      height: 50.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 50.w,
                        height: 50.h,
                        color: Colors.white.withOpacity(0.1),
                        child: const Icon(Icons.group, color: Colors.white),
                      ),
                    ),
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
                    StaticString.open,
                    style: TextStyle(color: AppColors.accentColor, fontSize: 13.sp),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildExploreList() {
    return Obx(() {
      if (controller.isExploreLoading.value && controller.exploreCommunities.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: AppColors.accentColor),
          ),
        );
      }
      if (controller.exploreCommunities.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Text(
              controller.searchQuery.value.isNotEmpty
                  ? 'No matching groups found'
                  : 'No public groups available',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      }

      if (controller.isGridView.value) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15.w,
            mainAxisSpacing: 15.h,
            childAspectRatio: 0.65,
          ),
          itemCount: controller.exploreCommunities.length,
          itemBuilder: (context, index) {
            return _buildExploreGridCard(controller.exploreCommunities[index]);
          },
        );
      }

      return Column(
        children: controller.exploreCommunities.map((item) {
          return _buildExploreListCard(item);
        }).toList(),
      );
    });
  }

  Widget _buildExploreListCard(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.4),
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
                      Icon(Icons.verified_user, color: AppColors.accentColor, size: 12.sp),
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
                    onPressed: () {
                      if (item['hasRequestedToJoin'] == true) {
                        controller.cancelJoinRequest(item['_id'] ?? '', item['title'] ?? '');
                      } else {
                        controller.joinGroup(item['_id'] ?? '', item['title'] ?? '');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: item['hasRequestedToJoin'] == true
                            ? Colors.redAccent
                            : AppColors.accentColor,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                    ),
                    child: Text(
                      item['hasRequestedToJoin'] == true
                          ? 'Cancel join Requested'
                          : StaticString.joinCommunity,
                      style: TextStyle(
                        color: item['hasRequestedToJoin'] == true
                            ? Colors.redAccent
                            : AppColors.accentColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreGridCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              child: Stack(
                children: [
                  Image.network(
                    item['image']!,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.white.withValues(alpha: 0.1),
                      child: Icon(Icons.image_not_supported, color: Colors.white.withValues(alpha: 0.5)),
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_user, color: AppColors.accentColor, size: 10.sp),
                          SizedBox(width: 3.w),
                          Text(
                            item['code'] ?? '',
                            style: TextStyle(color: Colors.white, fontSize: 9.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']!,
                  style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  item['members']!,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: double.infinity,
                  height: 32.h,
                  child: OutlinedButton(
                    onPressed: () {
                      if (item['hasRequestedToJoin'] == true) {
                        controller.cancelJoinRequest(item['_id'] ?? '', item['title'] ?? '');
                      } else {
                        controller.joinGroup(item['_id'] ?? '', item['title'] ?? '');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: item['hasRequestedToJoin'] == true
                            ? Colors.redAccent
                            : AppColors.accentColor,
                      ),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                    ),
                    child: Text(
                      item['hasRequestedToJoin'] == true ? 'Cancel' : 'Join',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: item['hasRequestedToJoin'] == true
                            ? Colors.redAccent
                            : AppColors.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Obx(() {
      if (controller.currentPage.value >= controller.totalPage.value) {
        return const SizedBox.shrink();
      }
      return SizedBox(
        width: double.infinity,
        height: 55.h,
        child: ElevatedButton(
          onPressed: () {
            if (!controller.isExploreLoading.value) {
              controller.fetchExploreGroups(loadMore: true);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
          ),
          child: controller.isExploreLoading.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Text(
                  StaticString.loadMoreCommunities,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold,  color: Color(0xffFFFFFF)),
                ),
        ),
      );
    });
  }
}
