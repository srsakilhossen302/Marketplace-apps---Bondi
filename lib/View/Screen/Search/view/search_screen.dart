import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../../../../View/Widgegt/CustomCard/custom_listing_card.dart';
import '../../Profile/view/seller_profile_screen.dart';
import '../../Messages/view/chat_detail_screen.dart';
import '../../../../Model/home_models.dart';
import '../Controller/search_controller.dart' as custom_search;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late custom_search.SearchController controller;
  late TabController tabController;

  final ScrollController listingsScrollController = ScrollController();
  final ScrollController sellersScrollController = ScrollController();
  final ScrollController groupsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(custom_search.SearchController());
    tabController = TabController(length: 4, vsync: this);

    listingsScrollController.addListener(() {
      if (listingsScrollController.position.pixels >= listingsScrollController.position.maxScrollExtent - 200) {
        controller.loadMoreListings();
      }
    });

    sellersScrollController.addListener(() {
      if (sellersScrollController.position.pixels >= sellersScrollController.position.maxScrollExtent - 200) {
        controller.loadMoreSellers();
      }
    });

    groupsScrollController.addListener(() {
      if (groupsScrollController.position.pixels >= groupsScrollController.position.maxScrollExtent - 200) {
        controller.loadMoreGroups();
      }
    });
  }

  @override
  void dispose() {
    listingsScrollController.dispose();
    sellersScrollController.dispose();
    groupsScrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

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
              _buildTopBar(context),
              Expanded(
                child: Obx(() {
                  if (controller.searchQuery.value.trim().isEmpty) {
                    return _buildDefaultView();
                  }

                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accentColor),
                    );
                  }

                  return _buildResultsView();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.cardColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: TextField(
                controller: controller.searchController,
                autofocus: true,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(color: Colors.white, fontSize: 15.sp),
                decoration: InputDecoration(
                  hintText: StaticString.searchTradeMore,
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 15.sp,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: SvgPicture.asset(
                      'assets/icons/Search-icons.svg',
                      width: 18.w,
                      colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn),
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 42.w,
                    maxHeight: 18.h,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                onChanged: controller.onSearchChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultView() {
    return Obx(() {
      if (controller.recentSearches.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_outlined,
                size: 64.r,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              SizedBox(height: 15.h),
              Text(
                'Type to start searching',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.clearRecentSearches(),
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: AppColors.accentColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: controller.recentSearches.map((term) {
                return GestureDetector(
                  onTap: () => controller.selectRecentOrPopularSearch(term),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.cardColor.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    child: Text(
                      term,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildResultsView() {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          indicatorColor: AppColors.accentColor,
          labelColor: AppColors.accentColor,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
          labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Items'),
            Tab(text: 'People'),
            Tab(text: 'Groups'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              _buildAllTab(),
              _buildItemsTab(),
              _buildPeopleTab(),
              _buildGroupsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAllTab() {
    final listingsList = controller.listings.take(3).toList();
    final sellersList = controller.sellers.take(3).toList();
    final groupsList = controller.groups.take(3).toList();

    if (listingsList.isEmpty && sellersList.isEmpty && groupsList.isEmpty) {
      return _buildNoResults();
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Items Preview
          if (listingsList.isNotEmpty) ...[
            _buildSectionHeader('Items', () => tabController.animateTo(1)),
            SizedBox(height: 12.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15.w,
                mainAxisSpacing: 15.h,
                childAspectRatio: 0.68,
              ),
              itemCount: listingsList.length,
              itemBuilder: (context, index) {
                return CustomListingCard(item: listingsList[index]);
              },
            ),
            SizedBox(height: 25.h),
          ],

          // People Preview
          if (sellersList.isNotEmpty) ...[
            _buildSectionHeader('People', () => tabController.animateTo(2)),
            SizedBox(height: 12.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sellersList.length,
              itemBuilder: (context, index) {
                return _buildSellerItem(sellersList[index]);
              },
            ),
            SizedBox(height: 25.h),
          ],

          // Groups Preview
          if (groupsList.isNotEmpty) ...[
            _buildSectionHeader('Groups', () => tabController.animateTo(3)),
            SizedBox(height: 12.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groupsList.length,
              itemBuilder: (context, index) {
                return _buildGroupItem(groupsList[index]);
              },
            ),
            SizedBox(height: 20.h),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onViewAllTap) {
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
        GestureDetector(
          onTap: onViewAllTap,
          child: Text(
            'See All',
            style: TextStyle(
              color: AppColors.accentColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsTab() {
    return Obx(() {
      if (controller.listings.isEmpty) {
        return _buildNoResults();
      }

      return ListView(
        controller: listingsScrollController,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.w,
              mainAxisSpacing: 15.h,
              childAspectRatio: 0.68,
            ),
            itemCount: controller.listings.length,
            itemBuilder: (context, index) {
              return CustomListingCard(item: controller.listings[index]);
            },
          ),
          if (controller.isLoadingMoreListings.value) ...[
            SizedBox(height: 20.h),
            const Center(child: CircularProgressIndicator(color: AppColors.accentColor)),
          ],
        ],
      );
    });
  }

  Widget _buildPeopleTab() {
    return Obx(() {
      if (controller.sellers.isEmpty) {
        return _buildNoResults();
      }

      return ListView.builder(
        controller: sellersScrollController,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        itemCount: controller.sellers.length + (controller.isLoadingMoreSellers.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.sellers.length) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accentColor));
          }
          return _buildSellerItem(controller.sellers[index]);
        },
      );
    });
  }

  Widget _buildGroupsTab() {
    return Obx(() {
      if (controller.groups.isEmpty) {
        return _buildNoResults();
      }

      return ListView.builder(
        controller: groupsScrollController,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        itemCount: controller.groups.length + (controller.isLoadingMoreGroups.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.groups.length) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accentColor));
          }
          return _buildGroupItem(controller.groups[index]);
        },
      );
    });
  }

  Widget _buildSellerItem(SellerModel seller) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            backgroundImage: seller.image.isNotEmpty ? NetworkImage(seller.image) : null,
            child: seller.image.isEmpty
                ? Icon(Icons.person, color: Colors.white.withValues(alpha: 0.6), size: 24.sp)
                : null,
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      seller.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (seller.isVerified) ...[
                      SizedBox(width: 5.w),
                      Icon(Icons.verified, color: AppColors.accentColor, size: 16.sp),
                    ],
                  ],
                ),
                if (seller.role.isNotEmpty)
                  Text(
                    seller.role,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12.sp,
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.to(() => const SellerProfileScreen(), arguments: seller.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentColor,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'Profile',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupItem(GroupModel group) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            backgroundImage: group.icon.isNotEmpty ? NetworkImage(group.icon) : null,
            child: group.icon.isEmpty
                ? Icon(Icons.group, color: Colors.white.withValues(alpha: 0.6), size: 24.sp)
                : null,
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  group.members,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.to(() => const ChatDetailScreen(), arguments: {
              'conversationId': group.id,
              'name': group.name,
              'image': group.icon,
              'conversationType': 'group',
              'isGroup': true
            }),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentColor,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'Join',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_outlined,
            size: 64.r,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          SizedBox(height: 15.h),
          Text(
            'No results found for "${controller.searchQuery.value}"',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }
}
