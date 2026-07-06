import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../Controller/sell_controller.dart';
import '../../Discover/view/discover_screen.dart';
import '../../Main/Controller/main_controller.dart';
import '../../../../helper/network_img/image_helper.dart';

class SellScreen extends StatelessWidget {
  final String? tag;
  const SellScreen({super.key, this.tag});

  SellController get controller => Get.find<SellController>(tag: tag);

  @override
  Widget build(BuildContext context) {
    Get.put(SellController(), tag: tag);

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
                    Container(
                      height: 1.h,
                      width: double.infinity,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 25.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildUploadSection(),
                            SizedBox(height: 30.h),
                            _buildFormFields(),
                            SizedBox(height: 30.h),
                            _buildOptionsSection(),
                            SizedBox(height: 30.h),
                            _buildFulfillmentSection(),
                            SizedBox(height: 30.h),
                            _buildShareInGroupsSection(context),
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
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
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
            onTap: () {
              if (!controller.isDraftSaved) {
                controller.clearFields();
              } else {
                controller.isDraftSaved = false;
              }
              Get.find<MainController>().changeIndex(0);
            },
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
            controller.isEditMode ? StaticString.editListing : StaticString.sellSomething,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.selectedImages.isNotEmpty) _buildSelectedImages(),
        if (controller.selectedVideos.isNotEmpty) ...[
          SizedBox(height: 10.h),
          _buildSelectedVideos(),
        ],
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: _buildUploadBox(
                StaticString.uploadPhotos,
                Icons.camera_alt_outlined,
                onTap: controller.pickImages,
                maxCount: 10,
                currentCount: controller.selectedImages.length,
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: _buildUploadBox(
                StaticString.uploadVideos,
                Icons.videocam_outlined,
                onTap: controller.pickVideos,
                maxCount: 1,
                currentCount: controller.selectedVideos.length,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectedImages() {
    return SizedBox(
      height: 120.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.selectedImages.length,
        separatorBuilder: (context, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final image = controller.selectedImages[index];
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: image is String
                    ? Image.network(
                        image,
                        width: 100.w,
                        height: 100.h,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(image.path),
                        width: 100.w,
                        height: 100.h,
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () => controller.removeImage(index),
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 16.sp),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSelectedVideos() {
    return SizedBox(
      height: 120.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.selectedVideos.length,
        separatorBuilder: (context, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final video = controller.selectedVideos[index];
          return Stack(
            children: [
              Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Icon(
                  Icons.videocam,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () => controller.removeVideo(index),
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 16.sp),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUploadBox(
    String label,
    IconData icon, {
    required VoidCallback onTap,
    required int maxCount,
    required int currentCount,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140.h,
        decoration: BoxDecoration(
          color: AppColors.cardColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
            style: BorderStyle.solid,
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
              child: Icon(icon, color: AppColors.accentColor, size: 28.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "$currentCount/$maxCount",
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

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(StaticString.productTitle),
        _buildTextField(
          controller: controller.titleController,
          hint: StaticString.whatAreYouSelling,
          prefixIcon: Icons.shopping_bag_outlined,
        ),
        SizedBox(height: 25.h),
        _buildLabel(StaticString.description),
        _buildTextField(
          controller: controller.descriptionController,
          hint: StaticString.describeYourItemsFeaturesHistoryWhyItsGreat,
          maxLines: 4,
        ),
        SizedBox(height: 25.h),
        _buildLabel(StaticString.category),
        _buildDropdown(),
        SizedBox(height: 25.h),
        _buildLabel(StaticString.price),
        _buildPriceField(),
        SizedBox(height: 25.h),
        _buildLabel(StaticString.condition),
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
        fillColor: AppColors.cardColor.withOpacity(0.3),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.accentColor, size: 20.sp)
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
          color: AppColors.cardColor.withOpacity(0.3),
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
                child: Text(value.tr, style: const TextStyle(color: Colors.white)),
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
      focusNode: controller.priceFocusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        DecimalTextInputFormatter(decimalRange: 2),
      ],
      style: TextStyle(color: Colors.white, fontSize: 16.sp),
      decoration: InputDecoration(
        hintText: StaticString.priceHint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        filled: true,
        fillColor: AppColors.cardColor.withOpacity(0.3),
        prefixIcon: Icon(
          Icons.payments_outlined,
          color: AppColors.accentColor,
          size: 20.sp,
        ),
        suffixText: "BRL",
        suffixStyle: TextStyle(
          color: AppColors.accentColor,
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
        color: AppColors.cardColor.withOpacity(0.3),
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
                        ? AppColors.buttonColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Text(
                    condition.tr,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(StaticString.transactionType),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: AppColors.cardColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Obx(
            () => Row(
              children: controller.transactionTypes.map((type) {
                bool isSelected =
                    controller.selectedTransactionType.value == type;
                IconData icon = type == 'Trade'
                    ? Icons.swap_horiz
                    : type == 'Sell'
                    ? Icons.shopping_cart_outlined
                    : Icons.shopping_bag_outlined;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => controller.updateTransactionType(type),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 10.w,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.buttonColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            icon,
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                            size: 24.sp,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            type.tr,
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
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFulfillmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(StaticString.paymentFulfillment),
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.cardColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Column(
            children: [
              _buildSwitchRow(
                StaticString.allowTradeOffers,
                StaticString.openToSwappingForOtherItems,
                controller.allowTradeOffers,
              ),
              Divider(color: Colors.white.withOpacity(0.1), height: 30.h),
              _buildSwitchRow(
                StaticString.shippingAvailable,
                StaticString.listItemForNationalDelivery,
                controller.shippingAvailable,
              ),
              Divider(color: Colors.white.withOpacity(0.1), height: 30.h),
              _buildSwitchRow(
                StaticString.sellDirectly,
                StaticString.freeListingCashOnPickup,
                controller.availableForPickup,
              ),
            ],
          ),
        ),
      ],
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
            activeColor: AppColors.accentColor,
            activeTrackColor: AppColors.accentColor.withOpacity(0.3),
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
            onPressed: () => controller.submitListing(isDraft: false),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.isEditMode ? StaticString.saveChanges : StaticString.publishListing,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffFFFFFF),
                  ),
                ),
                SizedBox(width: 10.w),
                Icon(
                  controller.isEditMode ? Icons.check : Icons.arrow_forward,
                  size: 20.sp,
                  color: const Color(0xffFFFFFF),
                ),
              ],
            ),
          ),
        ),
        if (controller.isEditMode) ...[
          SizedBox(height: 15.h),
          SizedBox(
            width: double.infinity,
            height: 55.h,
            child: OutlinedButton.icon(
              onPressed: () => controller.confirmDelete(),
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
                  borderRadius: BorderRadius.circular(28.r),
                ),
              ),
            ),
          ),
        ],
        if (!controller.isEditMode) ...[
          SizedBox(height: 15.h),
          SizedBox(
            width: double.infinity,
            height: 55.h,
            child: OutlinedButton(
              onPressed: () => controller.submitListing(isDraft: true),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.r),
                ),
              ),
              child: Text(
                StaticString.saveAsDraft,
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildShareInGroupsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Share in groups",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () => _showGroupSelectionBottomSheet(context),
              child: Text(
                "See All",
                style: TextStyle(
                  color: AppColors.accentColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        Obx(() {
          if (controller.isGroupsLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.accentColor,
              ),
            );
          }

          final allGroups = controller.myGroups;
          final selectedGroups = allGroups.where((g) => controller.selectedGroupIds.contains(g['_id'])).toList();

          return SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedGroups.length + 1,
              itemBuilder: (context, index) {
                if (index == selectedGroups.length) {
                  return GestureDetector(
                    onTap: () => _showGroupSelectionBottomSheet(context),
                    child: Container(
                      margin: EdgeInsets.only(right: 15.w),
                      child: Column(
                        children: [
                          Container(
                            width: 60.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                style: BorderStyle.solid,
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Join More",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final group = selectedGroups[index];
                final groupId = group['_id'] ?? '';
                final groupName = group['groupName'] ?? 'Group';
                final groupImg = ImageHelper.formatImageUrl(group['groupImage']?.toString());

                return GestureDetector(
                  onTap: () => controller.toggleGroupSelection(groupId),
                  child: Container(
                    margin: EdgeInsets.only(right: 15.w),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.r),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.accentColor,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 28.r,
                                backgroundImage: NetworkImage(groupImg),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: EdgeInsets.all(2.r),
                                decoration: const BoxDecoration(
                                  color: AppColors.accentColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.black,
                                  size: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        SizedBox(
                          width: 70.w,
                          child: Text(
                            groupName,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  void _showGroupSelectionBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Groups to Share",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 18.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Flexible(
              child: Obx(() {
                if (controller.isGroupsLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accentColor,
                    ),
                  );
                }

                final groups = controller.myGroups;
                if (groups.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Text(
                        "No groups found.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: groups.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.white.withOpacity(0.1),
                    height: 20.h,
                  ),
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    final groupId = group['_id'] ?? '';
                    final groupName = group['groupName'] ?? 'Group';
                    final groupImg = ImageHelper.formatImageUrl(group['groupImage']?.toString());

                    return Obx(() {
                      final isSelected = controller.selectedGroupIds.contains(groupId);
                      return GestureDetector(
                        onTap: () => controller.toggleGroupSelection(groupId),
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24.r,
                                backgroundImage: NetworkImage(groupImg),
                              ),
                              SizedBox(width: 15.w),
                              Expanded(
                                child: Text(
                                  groupName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                width: 24.w,
                                height: 24.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? AppColors.accentColor : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected ? AppColors.accentColor : Colors.white.withOpacity(0.4),
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.black,
                                        size: 14.sp,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                child: Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({this.decimalRange = 2});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    // Split text by decimal point
    List<String> parts = text.split('.');

    // Allow at most one decimal point
    if (parts.length > 2) {
      return oldValue;
    }

    // Check if there are decimal places and they exceed the range
    if (parts.length == 2 && parts[1].length > decimalRange) {
      return oldValue;
    }

    return newValue;
  }
}
