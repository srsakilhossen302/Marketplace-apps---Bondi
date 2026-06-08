import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Model/home_models.dart';
import '../Controller/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/img.png'),
            fit: BoxFit.cover,
          ),
        ),
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
                      _buildSectionHeader("New Listings", onAction: () {}),
                      SizedBox(height: 4.h),
                      Text(
                        "Fresh arrivals from your network",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      _buildNewListings(),
                      SizedBox(height: 30.h),
                      _buildSectionHeader("Suggested Sellers"),
                      SizedBox(height: 20.h),
                      _buildSuggestedSellers(),
                      SizedBox(height: 30.h),
                      _buildSectionHeader("Trending Groups"),
                      SizedBox(height: 15.h),
                      _buildTrendingGroups(),
                      SizedBox(height: 30.h),
                      _buildSectionHeader("Recommended For You"),
                      SizedBox(height: 15.h),
                      _buildRecommendedList(),
                      SizedBox(height: 30.h),
                      _buildCreateGroupCard(),
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

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset('assets/icons/Component 5.svg', width: 120.w),
          Stack(
            children: [
              SvgPicture.asset(
                'assets/icons/Notification-Icons.svg',
                width: 24.w,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF00E5FF),
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
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: const Color(0xFF2558A8).withOpacity(0.3),
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
                      ? const Color(0xFF0044CC)
                      : const Color(0xFF2558A8).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    if (cat == 'All') ...[
                      Icon(
                        Icons.grid_view_rounded,
                        color: const Color(0xFF00E5FF),
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                    ],
                    if (cat == 'Electronics') ...[
                      Icon(Icons.laptop_mac, color: Colors.white, size: 16.sp),
                      SizedBox(width: 8.w),
                    ],
                    if (cat == 'Fashion') ...[
                      Icon(Icons.checkroom, color: Colors.white, size: 16.sp),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      cat,
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
              "View All",
              style: TextStyle(color: const Color(0xFF00E5FF), fontSize: 13.sp),
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
                (item) =>
                    SizedBox(width: 150.w, child: _buildListingCard(item)),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildListingCard(ListingModel item) {
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2558A8).withOpacity(0.3),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
                child: Image.network(
                  item.image,
                  height: 90.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 90.h,
                    color: Colors.grey.withOpacity(0.2),
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
              if (item.isNew)
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E5FF),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      "NEW",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (item.isTrade)
                Positioned(
                  bottom: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0044CC),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.sync, color: Colors.white, size: 8.sp),
                        SizedBox(width: 2.w),
                        Text(
                          "Trade",
                          style: TextStyle(color: Colors.white, fontSize: 8.sp),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  item.price,
                  style: TextStyle(
                    color: const Color(0xFF00E5FF),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(radius: 8.r, backgroundColor: Colors.grey),
                        SizedBox(width: 4.w),
                        Text(
                          item.seller.split(' ')[0],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 9.sp,
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      'assets/icons/Love-icons.svg',
                      width: 12.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedSellers() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: controller.suggestedSellers.map((seller) {
          return Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF00E5FF),
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
          );
        }).toList(),
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
              color: const Color(0xFF2558A8).withOpacity(0.3),
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
                      Color(0xFF00E5FF),
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
          crossAxisCount: 3,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 15.h,
          childAspectRatio: 0.52,
        ),
        itemCount: controller.newListings.length * 2,
        itemBuilder: (context, index) {
          final item =
              controller.newListings[index % controller.newListings.length];
          return _buildListingCard(item);
        },
      ),
    );
  }

  Widget _buildCreateGroupCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2558A8).withOpacity(0.4),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        children: [
          SvgPicture.asset('assets/icons/FDAdd-icons.svg', width: 48.w),
          SizedBox(height: 20.h),
          Text(
            "Can't find your niche?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Start your own community and connect with like-minded traders.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 30.h),
          SizedBox(
            width: 200.w,
            height: 48.h,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              child: Text(
                'Create New Group',
                style: TextStyle(
                  color: const Color(0xFF003399),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
