import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Model/home_models.dart';
import '../../Profile/view/add_listing_screen.dart';
import '../Controller/trade_controller.dart';
import 'trade_screen.dart';

class SelectProjectScreen extends GetView<TradeController> {
  const SelectProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A89FF), Color(0xFF2558A8)],
          ),
        ),
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
                      SizedBox(height: 10.h),
                      _buildSearchBar(),
                      SizedBox(height: 20.h),
                      _buildCategories(),
                      SizedBox(height: 25.h),
                      Text(
                        "Choose one of your active listings to\ninclude in this trade offer.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _buildProductList(),
                      SizedBox(height: 20.h),
                      _buildAddNewListing(),
                      SizedBox(height: 40.h),
                      _buildUseForTradeButton(),
                      SizedBox(height: 20.h),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
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
          Expanded(
            child: Center(
              child: Text(
                "Select your project",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 40.w), // To balance the back button
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TextField(
        style: TextStyle(color: Colors.white, fontSize: 15.sp),
        decoration: InputDecoration(
          hintText: 'Search your items',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 15.sp,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(14.r),
            child: SvgPicture.asset(
              'assets/icons/Search-icons.svg',
              width: 18.w,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.categories.map((category) {
          return Obx(() {
            bool isSelected = controller.selectedCategory.value == category;
            return GestureDetector(
              onTap: () => controller.selectedCategory.value = category,
              child: Container(
                margin: EdgeInsets.only(right: 10.w),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF003399)
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          });
        }).toList(),
      ),
    );
  }

  Widget _buildProductList() {
    return Obx(
      () => Column(
        children: List.generate(controller.myProducts.length, (index) {
          final product = controller.myProducts[index];
          bool isSelected = controller.selectedProductIndex.value == index;
          return GestureDetector(
            onTap: () {
              controller.selectedProductIndex.value = index;
              controller.selectedProduct.value = ListingModel(
                title: product['title'],
                price: product['price'],
                image: product['image'],
                seller: "Me",
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 15.h),
              padding: EdgeInsets.all(15.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25.r),
                border: isSelected
                    ? Border.all(color: const Color(0xFF00E5FF), width: 2)
                    : null,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Image.network(
                      product['image'],
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product['title'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00E5FF).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                "ACTIVE",
                                style: TextStyle(
                                  color: const Color(0xFF00E5FF),
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          product['details'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          product['price'],
                          style: TextStyle(
                            color: const Color(0xFF00E5FF),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAddNewListing() {
    return GestureDetector(
      onTap: () => Get.to(() => const AddListingScreen()),
      child: CustomPaint(
        painter: DashedRectPainter(
          color: Colors.white.withOpacity(0.3),
          strokeWidth: 1,
          gap: 5,
          borderRadius: 25.r,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 25.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: Colors.white, size: 24.sp),
              ),
              SizedBox(height: 12.h),
              Text(
                "Add New Listing",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "Don't see what you want to trade?",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUseForTradeButton() {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        onPressed: () => Get.back(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF003399),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Use for Trade",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10.w),
            Icon(Icons.arrow_forward, color: Colors.white, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
