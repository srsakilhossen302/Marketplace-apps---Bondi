import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../Controller/connect_discover_controller.dart';

class ConnectDiscoverScreen extends GetView<ConnectDiscoverController> {
  const ConnectDiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ConnectDiscoverController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              // Header with Logo
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    'assets/icons/Component 5.svg',
                    width: 120.w,
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),

                      // User Discovery Icon
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFF002FA7).withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_search_outlined,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                      ),

                      SizedBox(height: 15.h),

                      Text(
                        "Connect & Discover",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        "Find friends, join trading hubs, and grow your network.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14.sp,
                        ),
                      ),

                      SizedBox(height: 25.h),

                      // Search Bar
                      TextField(
                        controller: controller.searchController,
                        style: TextStyle(color: Colors.white, fontSize: 15.sp),
                        decoration: InputDecoration(
                          hintText: 'Search by name or username...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white.withOpacity(0.7),
                            size: 20.sp,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF002FA7).withOpacity(0.3),
                          contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      SizedBox(height: 15.h),

                      // Sync Contacts Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () => controller.syncContacts(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0052D4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                          ),
                          child: Text(
                            'Sync Contacts',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // Discover Hubs Section
                      _buildSectionHeader("DISCOVER HUBS", onAction: () {}),
                      SizedBox(height: 15.h),
                      ...controller.hubs
                          .map((hub) => _buildHubCard(hub))
                          .toList(),

                      SizedBox(height: 30.h),

                      // Friends Section
                      _buildSectionHeader("FRIENDS ON BOND"),
                      SizedBox(height: 15.h),
                      ...controller.friends
                          .map((friend) => _buildFriendCard(friend))
                          .toList(),

                      SizedBox(height: 30.h),

                      // Invite Section
                      _buildSectionHeader(
                        "INVITE FROM CONTACTS",
                        actionLabel: "View All",
                        onAction: () {},
                      ),
                      SizedBox(height: 15.h),
                      ...controller.contacts
                          .map((contact) => _buildContactCard(contact))
                          .toList(),

                      SizedBox(height: 40.h),

                      // Continue to Feed Button
                      SizedBox(
                        width: double.infinity,
                        height: 55.h,
                        child: ElevatedButton(
                          onPressed: () => controller.continueToFeed(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0052D4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'Continue to Feed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h),
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

  Widget _buildSectionHeader(
    String title, {
    String actionLabel = "Explore All",
    VoidCallback? onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        if (onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 13.sp,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHubCard(Map<String, dynamic> hub) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: const Color(0xFF002FA7).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: const BoxDecoration(
                  color: Color(0xFF003366),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  hub['icon'] as IconData,
                  color: const Color(0xFF00E5FF),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hub['name'] as String,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    hub['members'] as String,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 36.h,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.r),
                ),
              ),
              child: Text(
                'Join Community',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendCard(Map<String, dynamic> friend) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF002FA7).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundImage: NetworkImage(friend['image'] as String),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend['name'] as String,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
                Text(
                  friend['username'] as String,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E5FF),
              minimumSize: Size(70.w, 32.h),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text(
              'Add',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(Map<String, dynamic> contact) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF002FA7).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: Colors.black,
            child: Text(
              contact['initials'] as String,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact['name'] as String,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
                Text(
                  contact['phone'] as String,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E5FF),
              minimumSize: Size(70.w, 32.h),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text(
              'Invite',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
