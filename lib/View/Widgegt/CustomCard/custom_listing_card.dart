import 'package:bondi/View/Screen/ProductDetails/view/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../Model/home_models.dart';

class CustomListingCard extends StatelessWidget {
  final ListingModel item;
  final VoidCallback? onTap;
  final double? width;

  const CustomListingCard({
    super.key,
    required this.item,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Get.to(() => const ProductDetailsScreen(), arguments: item),
      child: Container(
        width: width ?? 115.81876373291016.w, // Exact width from user
        decoration: BoxDecoration(
          color: const Color(0xFF002FA7).withOpacity(0.3),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Section (Image and Badges)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  child: Image.network(
                    item.image,
                    height: 105.90914154052734.h, // Exact height from user
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 105.90914154052734.h,
                      color: Colors.grey.withOpacity(0.2),
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
                // NEW Badge
                if (item.isNew)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "NEW",
                        style: TextStyle(
                          color: const Color(0xFF00E5FF),
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Trade Badge
                if (item.isTrade)
                  Positioned(
                    bottom: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E5FF),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sync, color: Colors.white, size: 10.sp),
                          SizedBox(width: 3.w),
                          Text(
                            "Trade",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Bottom Section (Info)
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    item.price,
                    style: TextStyle(
                      color: const Color(0xFF00E5FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Divider
                  Container(
                    height: 1.h,
                    width: double.infinity,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  SizedBox(height: 10.h),
                  // Seller and Like
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 10.r,
                              backgroundColor: Colors.grey.withOpacity(0.3),
                              child: Text(
                                item.seller.substring(0, 1),
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                item.seller,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 10.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 4.w),
                      SvgPicture.asset(
                        'assets/icons/Love-icons.svg',
                        width: 14.w,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
