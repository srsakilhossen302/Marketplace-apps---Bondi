import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
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
        color: AppColors.backgroundColor,
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
                      SizedBox(height: 35.h),
                      _buildCreateButton(),
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
            StaticString.createNewGroup,
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
        color: AppColors.cardColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // Upload Photo Section
          GestureDetector(
            onTap: () => controller.pickGroupImage(),
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                Obx(() {
                  final file = controller.selectedImage.value;
                  if (file != null) {
                    return Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: FileImage(file),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(color: AppColors.accentColor, width: 2.w),
                      ),
                    );
                  }
                  return SvgPicture.asset(
                    'assets/icons/cemra icons.svg',
                    width: 100.w,
                    height: 100.h,
                  );
                }),
                SizedBox(height: 12.h),
                Text(
                  StaticString.uploadPhoto,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 35.h),
          // Input Fields Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StaticString.groupName,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: controller.groupNameController,
                hint: StaticString.enterGroupName,
              ),
              SizedBox(height: 25.h),
              Text(
                StaticString.groupDescription,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: controller.groupDescriptionController,
                hint: StaticString.whatIsGroupAbout,
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
        color: AppColors.cardColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StaticString.inviteMembers,
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
                hintText: StaticString.searchFriendsHint,
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
            () => Wrap(
              spacing: 15.w,
              runSpacing: 15.h,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...controller.invitedFriendsList.take(5).map(
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
    final img = member['image'] ?? '';
    final name = member['name'] ?? 'User';
    return SizedBox(
      width: 50.w,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundImage: NetworkImage(img.isNotEmpty ? img : 'https://i.pravatar.cc/150?u=$name'),
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
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
            child: Icon(Icons.add, color: AppColors.buttonColor, size: 24.sp),
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() {
          final count = controller.invitedFriendsList.length;
          final label = count > 5 ? '+${count - 5} ${StaticString.more}' : StaticString.more;
          return Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11.sp,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCreateButton() {
    return Obx(() {
      final isSubmitting = controller.isSubmitting.value;
      return SizedBox(
        width: double.infinity,
        height: 55.h,
        child: ElevatedButton(
          onPressed: isSubmitting ? null : () => controller.createGroup(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonColor,
            disabledBackgroundColor: AppColors.buttonColor.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.r),
            ),
          ),
          child: isSubmitting
              ? const CircularProgressIndicator(color: Colors.white)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StaticString.createGroup,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      Icons.arrow_forward,
                      size: 20.sp,
                      color: Colors.white,
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
