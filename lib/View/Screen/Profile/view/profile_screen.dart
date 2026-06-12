import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../Controller/profile_controller.dart';
import 'edit_profile_screen.dart';
import 'friends_screen.dart';
import 'subscription_screen.dart';
import 'user_profile_screen.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  void _changeLanguage(Locale locale) {
    Get.updateLocale(locale);
  }

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
                      _buildSectionLabel(StaticString.account),
                      _buildSettingsGroup([
                        _buildSettingsTile(
                          Icons.person_outline,
                          StaticString.accountSettings,
                          onTap: () => Get.to(() => const UserProfileScreen()),
                        ),
                        _buildSettingsTile(Icons.sync, StaticString.contactSync),
                        _buildSettingsTile(
                          Icons.language,
                          StaticString.language,
                          subtitle: _getCurrentLanguage(),
                          onTap: () => _showLanguageDialog(context),
                        ),
                      ]),
                      SizedBox(height: 25.h),
                      _buildSectionLabel(StaticString.securityPrivacy),
                      _buildSettingsGroup([
                        _buildSettingsTile(
                          Icons.shield_outlined,
                          StaticString.privacyControls,
                        ),
                        _buildSettingsTile(
                          Icons.block_outlined,
                          StaticString.blockedUsers,
                        ),
                      ]),
                      SizedBox(height: 25.h),
                      _buildSectionLabel(StaticString.activity),
                      _buildSettingsGroup([
                        _buildSettingsTile(
                          Icons.notifications_none,
                          StaticString.notifications,
                          badge: "3",
                        ),
                      ]),
                      SizedBox(height: 25.h),
                      _buildSectionLabel(StaticString.finance),
                      _buildSettingsGroup([
                        _buildSettingsTile(
                          Icons.account_balance_wallet_outlined,
                          StaticString.payments,
                        ),
                        _buildSettingsTile(
                          Icons.star_outline,
                          StaticString.subscription,
                          subtitle: StaticString.bondPlus,
                          onTap: () => Get.to(() => const SubscriptionScreen()),
                        ),
                      ]),
                      SizedBox(height: 25.h),
                      _buildSectionLabel(StaticString.referralProgram),
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

  String _getCurrentLanguage() {
    final locale = Get.locale;
    if (locale?.languageCode == 'pt') {
      return StaticString.portuguese;
    }
    return StaticString.english;
  }

  void _showLanguageDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.cardColor,
        title: Text(
          StaticString.language,
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                StaticString.english,
                style: TextStyle(color: Colors.white),
              ),
              trailing: Get.locale?.languageCode == 'en'
                  ? Icon(Icons.check, color: AppColors.accentColor)
                  : null,
              onTap: () {
                _changeLanguage(const Locale('en', 'US'));
                Get.back();
              },
            ),
            ListTile(
              title: Text(
                StaticString.portuguese,
                style: TextStyle(color: Colors.white),
              ),
              trailing: Get.locale?.languageCode == 'pt'
                  ? Icon(Icons.check, color: AppColors.accentColor)
                  : null,
              onTap: () {
                _changeLanguage(const Locale('pt', 'BR'));
                Get.back();
              },
            ),
          ],
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
                StaticString.settings,
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
        color: AppColors.cardColor.withOpacity(0.4),
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
              color: AppColors.accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.accentColor,
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
        color: AppColors.cardColor.withOpacity(0.4),
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
            Icon(icon, color: AppColors.accentColor, size: 24.sp),
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
                  color: AppColors.buttonColor,
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
        color: AppColors.cardColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StaticString.shareBondEarnCredits,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            StaticString.referralDescription,
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
              color: AppColors.cardColor.withOpacity(0.3),
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
                      StaticString.yourReferralCode,
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
                        color: AppColors.accentColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        StaticString.copy,
                        style: TextStyle(
                          color: AppColors.accentColor,
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
                backgroundColor: AppColors.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                elevation: 0,
              ),
              child: Text(
                StaticString.shareInviteLink,
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
                  StaticString.creditsEarned,
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
              StaticString.signOut,
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
