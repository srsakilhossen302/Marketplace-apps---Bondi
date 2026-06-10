import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../Controller/profile_controller.dart';
import 'edit_profile_screen.dart';
import 'friends_screen.dart';
import 'subscription_screen.dart';
import 'user_profile_screen.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

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
                      _buildUserInfoCard(),
                      SizedBox(height: 30.h),
                      _buildSectionLabel("ACCOUNT"),
                      _buildSettingsGroup([
                        _buildSettingsTile(
                          Icons.person_outline,
                          "Account Settings",
                          onTap: () => Get.to(() => const UserProfileScreen()),
                        ),
                        _buildSettingsTile(Icons.sync, "Contact Sync"),
                      ]),
                      SizedBox(height: 25.h),
                      _buildSectionLabel("SECURITY & PRIVACY"),
                      _buildSettingsGroup([
                        _buildSettingsTile(
                          Icons.shield_outlined,
                          "Privacy Controls",
                        ),
                        _buildSettingsTile(
                          Icons.block_outlined,
                          "Blocked Users",
                        ),
                      ]),
                      SizedBox(height: 25.h),
                      _buildSectionLabel("ACTIVITY"),
                      _buildSettingsGroup([
                        _buildSettingsTile(
                          Icons.notifications_none,
                          "Notifications",
                          badge: "3",
                        ),
                      ]),
                      SizedBox(height: 25.h),
                      _buildSectionLabel("FINANCE"),
                      _buildSettingsGroup([
                        _buildSettingsTile(
                          Icons.account_balance_wallet_outlined,
                          "Payments",
                        ),
                        _buildSettingsTile(
                          Icons.star_outline,
                          "Subscription",
                          subtitle: "Bond Plus",
                          onTap: () => Get.to(() => const SubscriptionScreen()),
                        ),
                      ]),
                      SizedBox(height: 25.h),
                      _buildSectionLabel("REFERRAL PROGRAM"),
                      _buildReferralCard(),
                      SizedBox(height: 30.h),
                      _buildSignOutButton(),
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
                "Settings",
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

  Widget _buildUserInfoCard() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF002FA7).withOpacity(0.4),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35.r,
            backgroundImage: NetworkImage(controller.userImage.value),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.userName.value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Bond ID: ${controller.bondId.value}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: const Color(0xFF00E5FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFF00E5FF),
              size: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, bottom: 12.h),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF002FA7).withOpacity(0.4),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: children.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.white.withOpacity(0.1),
          height: 1,
          indent: 20.w,
          endIndent: 20.w,
        ),
        itemBuilder: (context, index) => children[index],
      ),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title, {
    String? subtitle,
    String? badge,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(25.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF00E5FF), size: 24.sp),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (badge != null)
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: const BoxDecoration(
                  color: Color(0xFF0052D4),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.3),
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralCard() {
    return Container(
      padding: EdgeInsets.all(25.r),
      decoration: BoxDecoration(
        color: const Color(0xFF002FA7).withOpacity(0.4),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Share Bond, Earn Credits",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "Invite friends and get R\$ 10,00 in credits for each person who activates a paid subscription using your code.",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13.sp,
              height: 1.5,
            ),
          ),
          SizedBox(height: 30.h),
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: const Color(0xFF002FA7).withOpacity(0.3),
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "YOUR REFERRAL CODE",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      controller.referralCode.value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: controller.copyReferralCode,
                  child: Row(
                    children: [
                      Icon(
                        Icons.copy,
                        color: const Color(0xFF00E5FF),
                        size: 20.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "Copy",
                        style: TextStyle(
                          color: const Color(0xFF00E5FF),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25.h),
          SizedBox(
            width: double.infinity,
            height: 55.h,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0052D4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                elevation: 0,
              ),
              child: Text(
                "Share Invite Link",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 25.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Credits Earned",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 15.sp,
                  ),
                ),
                Text(
                  controller.creditsEarned.value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Container(
      width: double.infinity,
      height: 65.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35.r),
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFF5F5F5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: controller.signOut,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.r),
            side: BorderSide(color: Colors.red.withOpacity(0.3), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.red.shade700, size: 24.sp),
            SizedBox(width: 12.w),
            Text(
              "Sign Out",
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
