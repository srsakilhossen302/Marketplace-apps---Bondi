import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../Trade/view/trade_screen.dart';
import '../Controller/add_listing_controller.dart';

class AddListingScreen extends GetView<AddListingController> {
  const AddListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddListingController());

    return Scaffold(
      backgroundColor: const Color(0xFF2A70E0),
      body: SafeArea(
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
                    _buildMediaSection(),
                    SizedBox(height: 30.h),
                    _buildItemDetails(),
                    SizedBox(height: 25.h),
                    _buildDescriptionSection(),
                    SizedBox(height: 25.h),
                    _buildTradePreferences(),
                    SizedBox(height: 30.h),
                    _buildLocationDelivery(),
                    SizedBox(height: 40.h),
                    _buildPublishButton(),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
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
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
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
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                  ),
                ),
              ),
              Text(
                "Add New Listing",
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
          color: Colors.white.withOpacity(0.5),
        ),
      ],
    );
  }

  Widget _buildMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Media",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Up to 10 photos, 1 video",
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        SizedBox(
          height: 120.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildAddMediaButton(),
              ...controller.images.map((img) => _buildMediaImage(img)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddMediaButton() {
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
              Icons.add_a_photo_outlined,
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

  Widget _buildMediaImage(String url) {
    return Container(
      width: 110.w,
      margin: EdgeInsets.only(right: 12.w),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.network(
              url,
              width: 110.w,
              height: 120.h,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(4.r),
              decoration: const BoxDecoration(
                color: Color(0xFF00E5FF),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetails() {
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
            "ITEM DETAILS",
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          _buildFieldLabel("Product Title"),
          _buildTextField(
            controller.titleController,
            hint: "What are you selling?",
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel("Category"),
                    _buildDropdownField(),
                  ],
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel("Price (\$)"),
                    _buildTextField(controller.priceController, hint: "0.00"),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildFieldLabel("Condition"),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: [
              _buildConditionChip("New"),
              _buildConditionChip("Like New"),
              _buildConditionChip("Fair"),
              _buildConditionChip("Good"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConditionChip(String label) {
    return Obx(() {
      bool isSelected = controller.condition.value == label;
      return GestureDetector(
        onTap: () => controller.condition.value = label,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF003399)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
              fontSize: 13.sp,
            ),
          ),
        ),
      );
    });
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
            "Detailed Description",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
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
              maxLines: 5,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13.sp,
              ),
              decoration: InputDecoration(
                hintText:
                    "Describe features, flaws, or include a story about the item...",
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 13.sp,
                ),
                border: InputBorder.none,
              ),
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
            children: [
              Icon(Icons.swap_horiz, color: Colors.white, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                "TRADE PREFERENCES",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildFieldLabel("Looking for..."),
          _buildTextField(
            controller.tradePrefController,
            hint: "e.g. Vintage cameras, mechanical keyboards",
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Obx(
                () => GestureDetector(
                  onTap: () => controller.openToOffers.value =
                      !controller.openToOffers.value,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF00E5FF),
                        width: 1.5.w,
                      ),
                      color: controller.openToOffers.value
                          ? const Color(0xFF00E5FF)
                          : Colors.transparent,
                    ),
                    child: controller.openToOffers.value
                        ? Icon(Icons.check, color: Colors.white, size: 12.sp)
                        : null,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "Open to offers outside of\npreferences",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDelivery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Location & Delivery",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.h),
        _buildFieldLabel("Meetup Location"),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            color: const Color(0xFF2558A8).withOpacity(0.3),
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.5)),
          ),
          child: TextField(
            controller: controller.locationController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              icon: Icon(
                Icons.location_on_outlined,
                color: const Color(0xFF00E5FF),
                size: 20.sp,
              ),
              hintText: "Enter city or neighborhood",
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 14.sp,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 25.h),
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: const Color(0xFF2558A8).withOpacity(0.3),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Column(
            children: [
              _buildSwitchRow(
                Icons.local_shipping_outlined,
                "Available for Shipping",
                "You'll print a label through Bond",
                controller.availableForShipping,
              ),
              SizedBox(height: 20.h),
              _buildSwitchRow(
                Icons.location_on_outlined,
                "Local Pickup",
                "Coordinate a safe meetup",
                controller.localPickup,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchRow(
    IconData icon,
    String title,
    String subtitle,
    RxBool value,
  ) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF00E5FF), size: 22.sp),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
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
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF00E5FF),
          ),
        ),
      ],
    );
  }

  Widget _buildPublishButton() {
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton(
        onPressed: controller.publishListing,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0052D4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Publish Listing",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10.w),
            Icon(Icons.arrow_forward, size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController textController, {String? hint}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1F4FB0).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: TextField(
        controller: textController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 14.sp,
          ),
          border: InputBorder.none,
        ),
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
          Obx(
            () => Text(
              controller.category.value,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14.sp,
              ),
            ),
          ),
          Icon(Icons.keyboard_arrow_down, color: Colors.white.withOpacity(0.2)),
        ],
      ),
    );
  }
}
