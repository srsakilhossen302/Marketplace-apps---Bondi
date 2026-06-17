import 'dart:ui';
import 'package:bondi/View/Screen/CreateGroup/view/create_group_screen.dart';
import 'package:bondi/View/Widgegt/CustomCard/custom_listing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../../Notification/view/notification_screen.dart';
import '../../Messages/view/messages_screen.dart';
import '../Controller/home_controller.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../Login/view/login_screen.dart';
import '../../ProductDetails/view/product_details_screen.dart';
import '../../../../Model/home_models.dart';
import 'all_listings_screen.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value && 
                      controller.newListings.isEmpty && 
                      controller.filteredListings.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accentColor),
                    );
                  }
                  
                  if (controller.isError.value && 
                      controller.newListings.isEmpty && 
                      controller.filteredListings.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, color: Colors.redAccent, size: 48.sp),
                            SizedBox(height: 16.h),
                            Text(
                              controller.errorMessage.value,
                              style: TextStyle(color: Colors.white, fontSize: 15.sp),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20.h),
                            ElevatedButton(
                              onPressed: () => controller.refreshData(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => controller.refreshData(),
                    color: AppColors.accentColor,
                    backgroundColor: AppColors.cardColor,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),
                          _buildSearchBar(),
                          SizedBox(height: 20.h),
                          _buildCategories(),
                          SizedBox(height: 30.h),
                          
                          if (controller.isFilterMode.value) ...[
                            _buildSectionHeader(
                              "${controller.selectedCategory.value} Listings",
                            ),
                            SizedBox(height: 15.h),
                            if (controller.isLoading.value)
                              Container(
                                height: 200.h,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(color: AppColors.accentColor),
                              )
                            else if (controller.filteredListings.isEmpty)
                              Container(
                                height: 200.h,
                                alignment: Alignment.center,
                                child: Text(
                                  'No listings found in this category.',
                                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14.sp),
                                ),
                              )
                            else
                              _buildFilteredGrid(),
                          ] else ...[
                            _buildSectionHeader(
                              StaticString.newListings,
                              onAction: () => Get.to(() => const AllListingsScreen()),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              StaticString.freshArrivalsFromYourNetwork,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13.sp,
                              ),
                            ),
                            SizedBox(height: 15.h),
                            _buildNewListings(),
                            SizedBox(height: 30.h),
                            _buildSectionHeader(StaticString.suggestedSellers),
                            SizedBox(height: 20.h),
                            _buildSuggestedSellers(),
                            SizedBox(height: 30.h),
                            _buildSectionHeader(StaticString.trendingGroups),
                            SizedBox(height: 15.h),
                            _buildTrendingGroups(),
                            SizedBox(height: 30.h),
                            _buildSectionHeader(StaticString.recommendedForYouHome),
                            SizedBox(height: 15.h),
                            _buildRecommendedList(),
                          ],
                          SizedBox(height: 30.h),
                          _buildCreateGroupCard(),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            'assets/icons/horizontal logo light bg 1.svg',
            width: 120.w,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.to(() => const NotificationScreen()),
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/Notification-Icons.svg',
                      width: 24.w,
                      colorFilter: const ColorFilter.mode(
                        AppColors.accentColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.w),
              GestureDetector(
                onTap: () => Get.to(() => const MessagesScreen()),
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: const BoxDecoration(
                    color: AppColors.inputFillColor,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/message.svg',
                    width: 20.w,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TextField(
        controller: controller.searchController,
        style: TextStyle(color: Colors.white, fontSize: 15.sp),
        decoration: InputDecoration(
          hintText: 'Search Trade & more',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 15.sp,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(14.r),
            child: SvgPicture.asset(
              'assets/icons/Search-icons.svg',
              width: 18.w,
            ),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.all(14.r),
            child: SvgPicture.asset(
              'assets/icons/Filtering-icons.svg',
              width: 18.w,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.categories.map((cat) {
            bool isSelected = controller.selectedCategory.value == cat;
            return GestureDetector(
              onTap: () => controller.onCategorySelected(cat),
              child: Container(
                margin: EdgeInsets.only(right: 10.w),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.buttonColor
                      : AppColors.cardColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getCategoryIcon(cat),
                      color: isSelected ? Colors.white : AppColors.accentColor,
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      _getCategoryText(cat),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String cat) {
    final lowercase = cat.toLowerCase();
    if (lowercase == 'all') return Icons.grid_view_rounded;
    if (lowercase.contains('electronics') || lowercase.contains('gadget') || lowercase.contains('tech')) return Icons.laptop_mac;
    if (lowercase.contains('fashion') || lowercase.contains('apparel') || lowercase.contains('clothing')) return Icons.checkroom;
    if (lowercase.contains('sneaker') || lowercase.contains('shoe')) return Icons.shopping_bag;
    if (lowercase.contains('watch') || lowercase.contains('time')) return Icons.watch;
    if (lowercase.contains('accessory') || lowercase.contains('jewelry')) return Icons.sell_outlined;
    return Icons.sell_outlined;
  }

  String _getCategoryText(String cat) {
    switch (cat) {
      case 'All':
        return StaticString.all;
      case 'Electronics':
        return StaticString.electronics;
      case 'Fashion':
        return StaticString.fashion;
      default:
        return cat;
    }
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              StaticString.viewAll,
              style: TextStyle(color: AppColors.accentColor, fontSize: 13.sp),
            ),
          ),
      ],
    );
  }

  Widget _buildNewListings() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.newListings
              .map(
                (item) => Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: CustomListingCard(
                    item: item,
                    onTap: () => _handleListingTap(item),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSuggestedSellers() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.suggestedSellers.map((seller) {
            return Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.accentColor,
                            width: 2.w,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 35.r,
                          backgroundImage: NetworkImage(seller.image),
                        ),
                      ),
                      if (seller.isVerified)
                        SvgPicture.asset(
                          'assets/icons/Verify-icons.svg',
                          width: 20.w,
                        ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    seller.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    seller.role,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTrendingGroups() {
    return Obx(
      () => Column(
        children: controller.trendingGroups.map((group) {
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
              color: AppColors.cardColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    group.icon,
                    width: 20.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.accentColor,
                      BlendMode.srcIn,
                    ),
                  ),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        "${group.members} • ${group.posts}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.add_circle_outline,
                  color: Colors.white.withOpacity(0.3),
                  size: 20.sp,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecommendedList() {
    return Obx(
      () => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15.w,
          mainAxisSpacing: 15.h,
          childAspectRatio: 0.75,
        ),
        itemCount: controller.recommendedListings.length,
        itemBuilder: (context, index) {
          final item = controller.recommendedListings[index];
          return CustomListingCard(
            item: item,
            onTap: () => _handleListingTap(item),
          );
        },
      ),
    );
  }

  Widget _buildFilteredGrid() {
    return Obx(
      () => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15.w,
          mainAxisSpacing: 15.h,
          childAspectRatio: 0.75,
        ),
        itemCount: controller.filteredListings.length,
        itemBuilder: (context, index) {
          final item = controller.filteredListings[index];
          return CustomListingCard(
            item: item,
            onTap: () => _handleListingTap(item),
          );
        },
      ),
    );
  }

  Widget _buildCreateGroupCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 30.w),
            child: Column(
              children: [
                SvgPicture.asset('assets/icons/FDAdd-icons.svg', width: 48.w),
                SizedBox(height: 25.h),
                Text(
                  StaticString.cantFindYourNiche,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  StaticString.startYourOwnCommunityConnectTraders,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 15.sp,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 35.h),
                SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => const CreateGroupScreen()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27.r),
                      ),
                    ),
                    child: Text(
                      StaticString.createNewGroup,
                      style: TextStyle(
                        color: AppColors.buttonColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleListingTap(ListingModel item) async {
    final token = await SharedPrefsHelper.getToken();
    if (token != null && token.isNotEmpty) {
      Get.to(() => const ProductDetailsScreen(), arguments: item);
    } else {
      Get.to(() => const LoginScreen());
    }
  }
}
