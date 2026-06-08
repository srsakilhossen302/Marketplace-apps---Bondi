import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
                "Edit Listing",
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
              "PHOTO MANAGEMENT",
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "3 / 10 Photos",
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        SizedBox(
          height: 110.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildAddPhotoButton(),
              ...controller.images.map((img) => _buildPhotoImage(img)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotoButton() {
    return CustomPaint(
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
              "Add Photo",
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoImage(String url) {
    return Container(
      width: 110.w,
      margin: EdgeInsets.only(right: 12.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.network(
              url,
              width: 110.w,
              height: 110.h,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: -5.h,
            right: -5.w,
            child: SvgPicture.asset(
              'assets/icons/Delete-icons.svg',
              width: 24.w,
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
        color: const Color(0xFF2558A8).withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Primary Information",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          _buildFieldLabel("Product Title"),
          _buildTextField(controller.titleController),
          SizedBox(height: 20.h),
          _buildFieldLabel("Price (\$)"),
          _buildTextField(controller.priceController),
          SizedBox(height: 20.h),
          _buildFieldLabel("Category"),
          _buildDropdownField(),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: EdgeInsets.all(25.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2558A8).withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
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
        color: const Color(0xFF2558A8).withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Status & Visibility",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              _buildStatusChip("Available", 'assets/icons/Available.svg', true),
              SizedBox(width: 10.w),
              _buildStatusChip(
                "Pending Trade",
                'assets/icons/Pending Trade.svg',
                false,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _buildStatusChip("Sold", 'assets/icons/Sold.svg', false),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String iconPath, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF1F4FB0).withOpacity(0.5)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF00E5FF)
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
                  ? const Color(0xFF00E5FF)
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
    );
  }

  Widget _buildTradePreferences() {
    return Container(
      padding: EdgeInsets.all(25.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2558A8).withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trade Preferences",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "+ Add Item",
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
              backgroundColor: const Color(0xFF003399),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text(
              "Save Changes",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 15.h),
        SizedBox(
          width: double.infinity,
          height: 55.h,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/icons/Delete-icons.svg',
              width: 20.w,
              colorFilter: ColorFilter.mode(
                Colors.red.shade400,
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              "Delete Listing",
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
        color: const Color(0xFF1F4FB0).withOpacity(0.3),
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1F4FB0).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            controller.category.value,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 14.sp,
            ),
          ),
          Icon(Icons.keyboard_arrow_down, color: Colors.white.withOpacity(0.2)),
        ],
      ),
    );
  }
}
