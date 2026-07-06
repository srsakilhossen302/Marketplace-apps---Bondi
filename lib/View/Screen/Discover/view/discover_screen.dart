import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Model/home_models.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../../../Widgegt/CustomCard/custom_listing_card.dart';
import '../Controller/discover_controller.dart';
import '../../Notification/view/notification_screen.dart';
import '../../Login/view/login_screen.dart';
import '../../ProductDetails/view/product_details_screen.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../Search/view/search_screen.dart';

class DiscoverScreen extends GetView<DiscoverController> {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DiscoverController());

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
                      controller.trendingProducts.isEmpty && 
                      controller.filteredListings.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accentColor),
                    );
                  }

                  if (controller.isError.value && 
                      controller.trendingProducts.isEmpty && 
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
                              _buildItemsGrid(controller.filteredListings),
                          ] else ...[
                            _buildSectionHeader(
                              StaticString.trendingProducts,
                              showViewAll: true,
                            ),
                            SizedBox(height: 15.h),
                            if (controller.trendingProducts.isNotEmpty) ...[
                              _buildTrendingCard(controller.trendingProducts[0]),
                              if (controller.trendingProducts.length > 1) ...[
                                SizedBox(height: 15.h),
                                _buildItemsGrid(controller.trendingProducts.skip(1).toList()),
                              ],
                            ],
                            SizedBox(height: 30.h),
                            _buildSectionHeader(StaticString.itemsYouMayLike),
                            SizedBox(height: 15.h),
                            _buildItemsGrid(controller.itemsYouMayLike),
                            SizedBox(height: 30.h),
                            _buildSectionHeader(StaticString.recommendedForYouHome),
                            SizedBox(height: 15.h),
                            _buildItemsGrid(controller.recommendedForYou),
                          ],
                          SizedBox(height: 100.h), // Extra space for bottom bar
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
          SvgPicture.asset('assets/icons/horizontal_logo_light_bg_1.svg', width: 120.w),
          GestureDetector(
            onTap: () => Get.to(() => const NotificationScreen()),
            child: SvgPicture.asset(
              'assets/icons/Notification-Icons.svg',
              width: 24.w,
              colorFilter: const ColorFilter.mode(
                AppColors.accentColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => Get.to(() => const SearchScreen()),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.cardColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            SizedBox(width: 14.w),
            SvgPicture.asset(
              'assets/icons/Search-icons.svg',
              width: 18.w,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                StaticString.searchTradeMore,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 15.sp,
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/icons/Filtering-icons.svg',
              width: 18.w,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            SizedBox(width: 14.w),
          ],
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

  Widget _buildSectionHeader(String title, {bool showViewAll = false}) {
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
        if (showViewAll)
          Row(
            children: [
              Text(
                StaticString.seeAllShort,
                style: TextStyle(
                  color: AppColors.accentColor.withOpacity(0.6),
                  fontSize: 13.sp,
                ),
              ),
              Icon(
                Icons.arrow_right_alt,
                color: AppColors.accentColor.withOpacity(0.6),
                size: 18.sp,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTrendingCard(ListingModel item) {
    return GestureDetector(
      onTap: () => _handleListingTap(item),
      child: Container(
        width: double.infinity,
        height: 250.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          image: DecorationImage(
            image: NetworkImage(item.image),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      StaticString.hotDrop,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    item.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item.price,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsGrid(List<ListingModel> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 15.h,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return CustomListingCard(
          item: item,
          onTap: () => _handleListingTap(item),
        );
      },
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
