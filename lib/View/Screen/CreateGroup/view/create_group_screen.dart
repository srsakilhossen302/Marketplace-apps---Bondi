import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../Controller/create_group_controller.dart';

class CreateGroupScreen extends GetView<CreateGroupController> {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CreateGroupController());

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
              _buildAppBar(),
              Container(
                height: 1.h,
                width: double.infinity,
                color: Colors.white.withOpacity(0.2),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 25.h),
                      _buildMainInfoCard(),
                      SizedBox(height: 25.h),
                      _buildInviteSection(),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Text(
            "Create New Group",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 40.w), // Spacer for balance
        ],
      ),
    );
  }

  Widget _buildMainInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2558A8).withOpacity(0.4),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // Upload Photo Section
          Column(
            children: [
              SvgPicture.asset(
                'assets/icons/cemra icons.svg',
                width: 100.w,
                height: 100.h,
              ),
              SizedBox(height: 12.h),
              Text(
                "Upload Photo",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 35.h),
          // Input Fields Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Group Name",
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: controller.groupNameController,
                hint: "Enter group name",
              ),
              SizedBox(height: 25.h),
              Text(
                "Group Description",
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: controller.groupDescriptionController,
                hint: "What is this group about?",
                maxLines: 4,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: Colors.white, fontSize: 15.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 15.sp,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.all(18.r),
      ),
    );
  }

  Widget _buildInviteSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2558A8).withOpacity(0.4),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "INVITE MEMBERS",
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: TextField(
              controller: controller.searchFriendsController,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: "Search friends by name...",
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 14.sp,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(14.r),
                  child: Icon(Icons.search, color: Colors.white, size: 20.sp),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 25.h),
          Obx(
            () => Row(
              children: [
                ...controller.invitedMembers.map(
                  (member) => _buildMemberAvatar(member),
                ),
                _buildAddMoreButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberAvatar(Map<String, String> member) {
    return Padding(
      padding: EdgeInsets.only(right: 15.w),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundImage: NetworkImage(member['image']!),
          ),
          SizedBox(height: 8.h),
          Text(
            member['name']!,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreButton() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => controller.addMember(),
          child: Container(
            width: 50.w,
            height: 50.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add, color: const Color(0xFF003399), size: 24.sp),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "More",
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}
