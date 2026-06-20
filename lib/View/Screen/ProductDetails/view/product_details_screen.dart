import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../../../Widgegt/CustomCard/custom_listing_card.dart';
import '../../Profile/view/seller_profile_screen.dart';
import '../../Trade/view/trade_screen.dart';
import '../Controller/product_details_controller.dart';
import '../../../../Model/home_models.dart';
import '../../../../helper/network_img/image_helper.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final String _controllerTag;

  @override
  void initState() {
    super.initState();
    final ListingModel product = Get.arguments;
    _controllerTag = identityHashCode(product).toString();
    Get.put(ProductDetailsController(), tag: _controllerTag);
  }

  @override
  void dispose() {
    Get.delete<ProductDetailsController>(tag: _controllerTag);
    super.dispose();
  }

  ProductDetailsController get controller => Get.find<ProductDetailsController>(tag: _controllerTag);

  @override
  Widget build(BuildContext context) {
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildImageCarousel(),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20.h),
                                  _buildTitleSection(),
                                  SizedBox(height: 25.h),
                                  _buildTradeBadge(),
                                  SizedBox(height: 30.h),
                                  _buildDescriptionSection(),
                                  SizedBox(height: 20.h),
                                  _buildTags(),
                                  SizedBox(height: 30.h),
                                  _buildSellerCard(),
                                  SizedBox(height: 30.h),
                                  _buildSimilarListings(),
                                  SizedBox(height: 40.h),
                                  _buildBottomButtons(),
                                  SizedBox(height: 40.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (controller.isLoading.value)
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.accentColor,
                      ),
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
            StaticString.productDetails,
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

  Widget _buildImageCarousel() {
    return Obx(
      () => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 350.h,
            width: double.infinity,
            margin: EdgeInsets.all(20.r),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: PageView.builder(
                onPageChanged: controller.updateImageIndex,
                itemCount: controller.productImages.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    controller.productImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.white.withOpacity(0.1),
                      child: const Icon(Icons.image_not_supported, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 40.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.productImages.length,
                (index) => Container(
                  width: 8.w,
                  height: 8.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.currentImageIndex.value == index
                        ? AppColors.accentColor
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),
          // Arrows
          Positioned(
            left: 35.w,
            top: 175.h,
            child: _buildCarouselArrow(Icons.keyboard_arrow_left),
          ),
          Positioned(
            right: 35.w,
            top: 175.h,
            child: _buildCarouselArrow(Icons.keyboard_arrow_right),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselArrow(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20.sp),
    );
  }

  Widget _buildTitleSection() {
    return Obx(
      () {
        final title = controller.listingData['title']?.toString() ?? controller.product.title;
        final price = controller.listingData['price'] != null 
            ? '\$${controller.listingData['price']}' 
            : controller.product.price;
        final city = controller.listingData['city']?.toString() ?? '';
        final country = controller.listingData['country']?.toString() ?? '';
        final displayLocation = city.isNotEmpty && country.isNotEmpty 
            ? '$city, $country' 
            : 'New York, NY';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.white.withOpacity(0.6),
                  size: 14.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  "Posted 2h ago",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(width: 15.w),
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.white.withOpacity(0.6),
                  size: 14.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  displayLocation,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              price,
              style: TextStyle(
                color: AppColors.accentColor,
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _buildTradeBadge() {
    return Obx(
      () {
        final listType = controller.listingData['listingType']?.toString().toLowerCase();
        final isTrade = listType == 'trade' || listType == 'sale_and_trade' || 
            (controller.listingData.isEmpty && controller.product.isTrade);
            
        if (!isTrade) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.cardColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: const BoxDecoration(
                  color: AppColors.accentColor,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/icons/Trade-In Available.svg',
                  width: 20.w,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
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
                      StaticString.tradeInAvailable,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      StaticString.sellerAcceptsTradeOffers,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildDescriptionSection() {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: EdgeInsets.all(25.r),
        decoration: BoxDecoration(
          color: AppColors.cardColor.withOpacity(0.4),
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
            SizedBox(height: 15.h),
            Text(
              controller.listingData['description']?.toString() ?? 
                  (controller.isLoading.value ? "Loading details..." : "No description provided"),
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTags() {
    return Obx(
      () {
        final conditionVal = controller.listingData['condition']?.toString() ?? '';
        String displayCondition = '';
        if (conditionVal.toLowerCase() == 'new') {
          displayCondition = 'Condition: New';
        } else if (conditionVal.toLowerCase() == 'like_new') {
          displayCondition = 'Condition: Like New';
        } else if (conditionVal.toLowerCase() == 'good') {
          displayCondition = 'Condition: Good';
        } else {
          displayCondition = controller.product.isNew ? 'Condition: New' : 'Condition: Used';
        }

        return Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            _buildTag(displayCondition),
            _buildTag(StaticString.authentic),
            _buildTag(StaticString.warrantyIncluded),
          ],
        );
      }
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 12.sp),
      ),
    );
  }

  Widget _buildSellerCard() {
    return Obx(
      () {
        final sellerName = controller.sellerData['displayName']?.toString() ?? controller.product.seller;
        final profileImage = controller.sellerData['profileImage']?.toString() ?? '';
        final displayImage = profileImage.isNotEmpty 
            ? ImageHelper.formatImageUrl(profileImage) 
            : 'https://i.pravatar.cc/150?u=${sellerName.hashCode}';
            
        final mutualFriends = controller.sellerData['mutualFriendsCount']?.toString() ?? '0';
        final groupsCount = controller.sellerData['joinedGroupsCount']?.toString() ?? '0';

        final String sId = (controller.sellerData['userId'] ?? controller.listingData['sellerId'] ?? '').toString();

        return Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.cardColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (sId.isNotEmpty) {
                    Get.to(() => const SellerProfileScreen(), arguments: sId);
                  }
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25.r,
                      backgroundImage: NetworkImage(displayImage),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sellerName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              _buildSellerStat(
                'assets/icons/Friends.svg',
                "$mutualFriends Mutual Friends",
              ),
              SizedBox(height: 10.h),
              _buildSellerStat(
                'assets/icons/Member of 3 Groups.svg',
                "Member of $groupsCount Groups",
              ),
              SizedBox(height: 25.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: OutlinedButton(
                  onPressed: () {
                    if (sId.isNotEmpty) {
                      Get.to(() => const SellerProfileScreen(), arguments: sId);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.accentColor.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    StaticString.viewProfile,
                    style: TextStyle(color: AppColors.accentColor, fontSize: 14.sp),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildSellerStat(String iconPath, String label) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 18.w,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.6),
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 13.sp),
        ),
      ],
    );
  }

  Widget _buildSimilarListings() {
    return Obx(
      () {
        if (controller.similarListings.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StaticString.similarListings,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  StaticString.seeAllShort,
                  style: TextStyle(color: AppColors.accentColor, fontSize: 13.sp),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.similarListings
                    .map(
                      (item) => Padding(
                        padding: EdgeInsets.only(right: 15.w),
                        child: CustomListingCard(item: item),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 55.h,
            child: OutlinedButton(
              onPressed: () => Get.to(
                () => const TradeScreen(),
                arguments: {
                  'product': controller.product,
                  'receiverId': controller.listingData['sellerId']?.toString() ?? '',
                  'receiverListingId': controller.listingData['_id']?.toString() ?? '',
                },
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.buttonColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              child: Text(
                StaticString.tradeOffer,
                style: TextStyle(color: AppColors.accentColor, fontSize: 16.sp),
              ),
            ),
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: SizedBox(
            height: 55.h,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              child: Text(
                StaticString.buyNow,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
