import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../../Trade/view/trade_screen.dart';
import '../Controller/edit_listing_controller.dart';

class EditListingScreen extends GetView<EditListingController> {
  const EditListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(EditListingController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundColor,
        child: SafeArea(
          child: Obx(
            () => Stack(
              children: [
                Column(
                  children: [
                    _buildAppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            _buildPhotoManagement(),
                            SizedBox(height: 30.h),
                            _buildPrimaryInformation(),
                            SizedBox(height: 25.h),
                            _buildDescriptionSection(),
                            SizedBox(height: 25.h),
                            _buildStatusVisibility(),
                            SizedBox(height: 25.h),
                            _buildTradePreferences(),
                            SizedBox(height: 30.h),
                            _buildActionButtons(),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (controller.isLoading.value)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
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
                StaticString.editListing,
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

  Widget _buildPhotoManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              StaticString.photoManagement,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Obx(
              () => Text(
                "${controller.images.length}/10 Photos",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 11.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        SizedBox(
          height: 110.h,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.images.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildAddPhotoButton();
                }
                final img = controller.images[index - 1];
                return _buildPhotoImage(img, index - 1);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: controller.pickImages,
      child: CustomPaint(
        painter: DashedRectPainter(
          color: Colors.white.withOpacity(0.3),
          strokeWidth: 1,
          gap: 5,
          borderRadius: 20.r,
        ),
        child: Container(
          width: 110.w,
          margin: EdgeInsets.only(right: 12.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                color: Colors.white.withOpacity(0.4),
                size: 24.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                StaticString.addPhoto,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoImage(dynamic img, int index) {
    return Container(
      width: 110.w,
      margin: EdgeInsets.only(right: 12.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: img is String
                ? Image.network(
                    img,
                    width: 110.w,
                    height: 110.h,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(img.path),
                    width: 110.w,
                    height: 110.h,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            top: -5.h,
            right: -5.w,
            child: GestureDetector(
              onTap: () => controller.removeImage(index),
              child: SvgPicture.asset(
                'assets/icons/Delete-icons.svg',
                width: 24.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryInformation() {
    return Container(
      padding: EdgeInsets.all(25.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StaticString.primaryInformation,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          _buildFieldLabel(StaticString.productTitle),
          _buildTextField(controller.titleController),
          SizedBox(height: 20.h),
          _buildFieldLabel(StaticString.price),
          _buildTextField(controller.priceController),
          SizedBox(height: 20.h),
          _buildFieldLabel(StaticString.category),
          _buildDropdownField(),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: EdgeInsets.all(25.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StaticString.description,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: TextField(
              controller: controller.descriptionController,
              maxLines: 6,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13.sp,
                height: 1.5,
              ),
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusVisibility() {
    return Container(
      padding: EdgeInsets.all(25.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StaticString.statusVisibility,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Obx(
            () => Row(
              children: [
                _buildStatusChip(
                  StaticString.available,
                  'assets/icons/Available.svg',
                  controller.status.value == 'Available',
                  onTap: () => controller.status.value = 'Available',
                ),
                SizedBox(width: 10.w),
                _buildStatusChip(
                  StaticString.pendingTrade,
                  'assets/icons/Pending Trade.svg',
                  controller.status.value == 'Pending Trade',
                  onTap: () => controller.status.value = 'Pending Trade',
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Obx(
            () => _buildStatusChip(
              StaticString.sold,
              'assets/icons/Sold.svg',
              controller.status.value == 'Sold',
              onTap: () => controller.status.value = 'Sold',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String iconPath, bool isSelected, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.cardColor.withOpacity(0.5)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? AppColors.accentColor
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 16.w,
              colorFilter: ColorFilter.mode(
                isSelected
                    ? AppColors.accentColor
                    : Colors.white.withOpacity(0.4),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTradePreferences() {
    return Container(
      padding: EdgeInsets.all(25.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                StaticString.tradePreferencesShort,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                StaticString.addItem,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildTradePrefItem(
            controller.tradePreferences[0]['title']!,
            controller.tradePreferences[0]['subtitle']!,
            'assets/icons/Jordan 1 Retro High.svg',
          ),
          _buildTradePrefItem(
            controller.tradePreferences[1]['title']!,
            controller.tradePreferences[1]['subtitle']!,
            'assets/icons/Apple Watch Series 8.svg',
          ),
        ],
      ),
    );
  }

  Widget _buildTradePrefItem(String title, String subtitle, String iconPath) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              iconPath,
              width: 18.w,
              colorFilter: const ColorFilter.mode(
                AppColors.accentColor,
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
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            'assets/icons/Delete-icons.svg',
            width: 18.w,
            colorFilter: ColorFilter.mode(
              Colors.red.withOpacity(0.5),
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55.h,
          child: ElevatedButton(
            onPressed: controller.saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text(
              StaticString.saveChanges,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 15.h),
        SizedBox(
          width: double.infinity,
          height: 55.h,
          child: OutlinedButton.icon(
            onPressed: controller.confirmDelete,
            icon: SvgPicture.asset(
              'assets/icons/Delete-icons.svg',
              width: 20.w,
              colorFilter: ColorFilter.mode(
                Colors.red.shade400,
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              StaticString.deleteListing,
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12.sp),
      ),
    );
  }

  Widget _buildTextField(TextEditingController textController) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: TextField(
        controller: textController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          color: AppColors.cardColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.category.value,
            dropdownColor: const Color(0xFF1E3A8A),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white.withOpacity(0.2),
            ),
            isExpanded: true,
            items: controller.categories.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                controller.category.value = val;
              }
            },
          ),
        ),
      ),
    );
  }
}
