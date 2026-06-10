import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Model/home_models.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../Widgegt/CustomCard/custom_listing_card.dart';
import '../Controller/discover_controller.dart';

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
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      _buildSearchBar(),
                      SizedBox(height: 20.h),
                      _buildCategories(),
                      SizedBox(height: 30.h),
                      _buildSectionHeader(
                        "Trending Products",
                        showViewAll: true,
                      ),
                      SizedBox(height: 15.h),
                      _buildTrendingCard(),
                      SizedBox(height: 30.h),
                      _buildSectionHeader("Items You May Like"),
                      SizedBox(height: 15.h),
                      _buildItemsGrid(controller.itemsYouMayLike),
                      SizedBox(height: 30.h),
                      _buildSectionHeader("Recommended For You"),
                      SizedBox(height: 15.h),
                      _buildItemsGrid(controller.recommendedForYou),
                      SizedBox(height: 100.h), // Extra space for bottom bar
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

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset('assets/icons/horizontal logo light bg 1.svg', width: 120.w),
          SvgPicture.asset(
            'assets/icons/Notification-Icons.svg',
            width: 24.w,
            colorFilter: const ColorFilter.mode(
              AppColors.accentColor,
              BlendMode.srcIn,
            ),
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
                child: Text(
                  cat,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
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
                "See all",
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

  Widget _buildTrendingCard() {
    return Container(
      width: double.infinity,
      height: 250.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=800&auto=format&fit=crop',
          ),
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
                    "HOT DROP",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Grand Master 5000",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$12,400.00",
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
    );
  }

  Widget _buildItemsGrid(List<ListingModel> items) {
    return Obx(
      () => Wrap(
        spacing: 15.w,
        runSpacing: 15.h,
        children: items.map((item) => CustomListingCard(item: item)).toList(),
      ),
    );
  }
}
