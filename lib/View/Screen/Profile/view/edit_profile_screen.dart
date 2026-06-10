import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../Controller/edit_profile_controller.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(EditProfileController());

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
                      _buildCoverAndAvatar(),
                      SizedBox(height: 25.h),
                      _buildThemeSelector(),
                      SizedBox(height: 30.h),
                      _buildSectionHeader("Personal Information"),
                      SizedBox(height: 20.h),
                      _buildInputField("Username", controller.usernameController, icon: Icons.alternate_email),
                      SizedBox(height: 20.h),
                      _buildInputField("Display Name", controller.displayNameController, icon: Icons.person_outline),
                      SizedBox(height: 20.h),
                      _buildBioField(),
                      SizedBox(height: 30.h),
                      _buildSectionHeader("Contact & Privacy"),
                      SizedBox(height: 20.h),
                      _buildContactPrivacyCard(),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionHeader("Financial Details"),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00E5FF),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              "BRAZIL MARKET",
                              style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _buildFinancialFields(),
                      SizedBox(height: 40.h),
                      _buildActionButtons(),
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
                "Edit Profile",
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

  Widget _buildCoverAndAvatar() {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF0052D4).withOpacity(0.4), const Color(0xFF00E5FF).withOpacity(0.2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundImage: const NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0052D4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 16.sp),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 15.h,
            right: 15.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF0052D4),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Text(
                "Update Cover",
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF002FA7).withOpacity(0.4),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Header Theme Color",
            style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              ...List.generate(controller.themeColors.length, (index) {
                return Obx(() => GestureDetector(
                  onTap: () => controller.selectedColorIndex.value = index,
                  child: Container(
                    margin: EdgeInsets.only(right: 12.w),
                    width: 35.w,
                    height: 35.w,
                    decoration: BoxDecoration(
                      color: controller.themeColors[index],
                      shape: BoxShape.circle,
                      border: controller.selectedColorIndex.value == index
                          ? Border.all(color: Colors.white, width: 2.w)
                          : null,
                    ),
                  ),
                ));
              }),
              Container(
                width: 35.w,
                height: 35.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Icon(Icons.colorize, color: Colors.white.withOpacity(0.4), size: 18.sp),
              ),
              const Spacer(),
              Text(
                "Electric\nBlue",
                textAlign: TextAlign.center,
                style: TextStyle(color: const Color(0xFF00E5FF).withOpacity(0.6), fontSize: 10.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInputField(String label, TextEditingController textController, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13.sp),
        ),
        SizedBox(height: 10.h),
        TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF00E5FF), size: 20.sp) : null,
            filled: true,
            fillColor: const Color(0xFF002FA7).withOpacity(0.3),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.r), borderSide: BorderSide.none),
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          ),
        ),
      ],
    );
  }

  Widget _buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bio",
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13.sp),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: const Color(0xFF002FA7).withOpacity(0.4),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: controller.bioController,
                maxLines: 4,
                style: TextStyle(color: Colors.white, fontSize: 14.sp, height: 1.5),
                decoration: const InputDecoration(border: InputBorder.none),
              ),
              Text(
                "108 / 160",
                style: TextStyle(color: const Color(0xFF00E5FF).withOpacity(0.6), fontSize: 11.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactPrivacyCard() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF002FA7).withOpacity(0.4),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField("Phone Number", controller.phoneNumberController, icon: Icons.phone_outlined),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Icon(Icons.visibility_outlined, color: const Color(0xFF00E5FF), size: 22.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Public Visibility", style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      Text("Allow traders to call you directly", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11.sp)),
                    ],
                  ),
                ),
                Obx(() => Switch(
                  value: controller.publicVisibility.value,
                  onChanged: (v) => controller.publicVisibility.value = v,
                  activeColor: const Color(0xFF00E5FF),
                  activeTrackColor: const Color(0xFF0052D4),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialFields() {
    return Column(
      children: [
        _buildInputField("Pix Key Type", TextEditingController(text: controller.pixKeyType.value)), // Simplified for UI
        SizedBox(height: 20.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("CPF (Tax ID)", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13.sp)),
            SizedBox(height: 10.h),
            TextField(
              controller: controller.cpfController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.badge_outlined, color: const Color(0xFF00E5FF), size: 20.sp),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.copy, color: const Color(0xFF00E5FF), size: 18.sp),
                    SizedBox(width: 5.w),
                    Text("Copy", style: TextStyle(color: const Color(0xFF00E5FF), fontSize: 14.sp)),
                    SizedBox(width: 15.w),
                  ],
                ),
                filled: true,
                fillColor: const Color(0xFF002FA7).withOpacity(0.3),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.r), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          "These details are encrypted and only used for secure payment processing on the Bond platform.",
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11.sp, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55.h,
          child: ElevatedButton.icon(
            onPressed: controller.saveChanges,
            icon: Icon(Icons.check_circle_outline, size: 20.sp),
            label: Text("Save Changes", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0052D4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
            ),
          ),
        ),
        SizedBox(height: 15.h),
        SizedBox(
          width: double.infinity,
          height: 55.h,
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF0052D4)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
            ),
            child: Text("Discard Changes", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16.sp)),
          ),
        ),
      ],
    );
  }
}
