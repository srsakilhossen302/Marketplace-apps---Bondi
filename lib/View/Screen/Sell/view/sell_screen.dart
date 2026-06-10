import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../Controller/sell_controller.dart';

class SellScreen extends GetView<SellController> {
  const SellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SellController());

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25.h),
                      _buildUploadSection(),
                      SizedBox(height: 30.h),
                      _buildFormFields(),
                      SizedBox(height: 30.h),
                      _buildOptionsSection(),
                      SizedBox(height: 30.h),
                      _buildFulfillmentSection(),
                      SizedBox(height: 30.h),
                      _buildShareSection(),
                      SizedBox(height: 40.h),
                      _buildActionButtons(),
                      SizedBox(height: 100.h),
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
            "Sell Something",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Row(
      children: [
        Expanded(
          child: _buildUploadBox("Upload Photos", Icons.camera_alt_outlined),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: _buildUploadBox("Upload Videos", Icons.videocam_outlined),
        ),
      ],
    );
  }

  Widget _buildUploadBox(String label, IconData icon) {
    return Container(
      height: 140.h,
      decoration: BoxDecoration(
        color: const Color(0xFF2558A8).withOpacity(0.4),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
          style: BorderStyle.solid, // Placeholder for dashed
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF00E5FF), size: 28.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Product Title"),
        _buildTextField(
          controller: controller.titleController,
          hint: "What are you selling?",
          prefixIcon: Icons.shopping_bag_outlined,
        ),
        SizedBox(height: 25.h),
        _buildLabel("Description"),
        _buildTextField(
          controller: controller.descriptionController,
          hint: "Describe your item's features, history, and why it's great...",
          maxLines: 4,
        ),
        SizedBox(height: 25.h),
        _buildLabel("Category"),
        _buildDropdown(),
        SizedBox(height: 25.h),
        _buildLabel("Selling Price"),
        _buildPriceField(),
        SizedBox(height: 25.h),
        _buildLabel("Condition"),
        _buildConditionSelector(),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
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
        fillColor: const Color(0xFF2558A8).withOpacity(0.3),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: const Color(0xFF00E5FF), size: 20.sp)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.all(18.r),
      ),
    );
  }

  Widget _buildDropdown() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: const Color(0xFF2558A8).withOpacity(0.3),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedCategory.value,
            dropdownColor: const Color(0xFF1E3A8A),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white.withOpacity(0.5),
            ),
            isExpanded: true,
            items: controller.categories.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/Category-icons.svg',
                      width: 18.w,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF00E5FF),
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(value, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              );
            }).toList(),
            onChanged: controller.updateCategory,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceField() {
    return TextField(
      controller: controller.priceController,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.white, fontSize: 16.sp),
      decoration: InputDecoration(
        hintText: "0.00",
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        filled: true,
        fillColor: const Color(0xFF2558A8).withOpacity(0.3),
        prefixIcon: Icon(
          Icons.payments_outlined,
          color: const Color(0xFF00E5FF),
          size: 20.sp,
        ),
        suffixText: "USD",
        suffixStyle: TextStyle(
          color: const Color(0xFF00E5FF),
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      ),
    );
  }

  Widget _buildConditionSelector() {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2558A8).withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Obx(
        () => Row(
          children: controller.conditions.map((condition) {
            bool isSelected = controller.selectedCondition.value == condition;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.updateCondition(condition),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF0044CC)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Text(
                    condition,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildOptionsSection() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2558A8).withOpacity(0.4),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        children: [
          _buildSwitchRow(
            "Allow Trade Offers",
            "Open to swapping for other items",
            controller.allowTradeOffers,
          ),
          Divider(color: Colors.white.withOpacity(0.1), height: 30.h),
          _buildSwitchRow(
            "Shipping Available",
            "List item for national delivery",
            controller.shippingAvailable,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String title, String subtitle, RxBool value) {
    String iconPath = title.contains("Trade")
        ? 'assets/icons/Allow Trade Offers.svg'
        : 'assets/icons/Category-icons.svg';

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            iconPath,
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
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => Switch(
            value: value.value,
            onChanged: (v) => value.value = v,
            activeColor: const Color(0xFF00E5FF),
            activeTrackColor: const Color(0xFF00E5FF).withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildFulfillmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Payment & Fulfillment"),
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: const Color(0xFF2558A8).withOpacity(0.4),
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.person_outline,
                color: Colors.white.withOpacity(0.5),
                size: 24.sp,
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sell Directly",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Free listing, cash on pickup",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.check_circle,
                color: const Color(0xFF0044CC),
                size: 20.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShareSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel("Share in groups"),
            Text(
              "See all",
              style: TextStyle(color: const Color(0xFF00E5FF), fontSize: 12.sp),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildGroupAvatar("Local Tech", "https://i.pravatar.cc/150?u=tech"),
            _buildGroupAvatar(
              "Vintage Finds",
              "https://i.pravatar.cc/150?u=vintage",
            ),
            _buildGroupAvatar(
              "Hike & Swap",
              "https://i.pravatar.cc/150?u=hike",
            ),
            _buildAddGroupButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildGroupAvatar(String name, String img) {
    return Column(
      children: [
        CircleAvatar(radius: 25.r, backgroundImage: NetworkImage(img)),
        SizedBox(height: 8.h),
        Text(
          name,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildAddGroupButton() {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              style: BorderStyle.none,
            ), // dashed placeholder
          ),
          child: Icon(Icons.add, color: Colors.white.withOpacity(0.5)),
        ),
        SizedBox(height: 8.h),
        Text(
          "Join More",
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11.sp,
          ),
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
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0044CC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Publish Listing",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10.w),
                Icon(Icons.arrow_forward, size: 20.sp),
              ],
            ),
          ),
        ),
        SizedBox(height: 15.h),
        SizedBox(
          width: double.infinity,
          height: 55.h,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white.withOpacity(0.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.r),
              ),
            ),
            child: Text(
              "Save as Draft",
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
        ),
      ],
    );
  }
}
