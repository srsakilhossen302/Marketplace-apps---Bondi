import 'package:flutter/material.dart';
import 'package:bondi/Utils/AppColors/app_colors.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../../Community/view/community_screen.dart';
import '../../Discover/view/discover_screen.dart';
import '../../Home/view/home_screen.dart';
import '../../Profile/view/profile_screen.dart';
import '../../Sell/view/sell_screen.dart';
import '../Controller/main_controller.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());

    final List<Widget> screens = [
      const HomeScreen(),
      const DiscoverScreen(),
      const SellScreen(),
      const CommunityScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: Obx(() => screens[controller.selectedIndex.value]),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.95),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5.w),
        ),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, 'Home', AppIcons.home),
            _buildNavItem(1, 'Discover', AppIcons.discover),
            _buildSellItem(),
            _buildNavItem(3, 'community', AppIcons.community),
            _buildNavItem(4, 'Profile', AppIcons.profile),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String iconPath) {
    bool isSelected = controller.selectedIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changeIndex(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.accentColor : Colors.white,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.accentColor : Colors.white,
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSellItem() {
    bool isSelected = controller.selectedIndex.value == 2;
    return GestureDetector(
      onTap: () => controller.changeIndex(2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accentColor, width: 2.w),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentColor.withOpacity(0.3),
                  blurRadius: 10.r,
                  spreadRadius: 1.r,
                ),
              ],
            ),
            child: SvgPicture.asset(
              AppIcons.sell,
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Sell',
            style: TextStyle(
              color: isSelected ? AppColors.accentColor : Colors.white,
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
