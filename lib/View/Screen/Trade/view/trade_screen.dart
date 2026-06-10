import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../Controller/trade_controller.dart';
import 'select_project_screen.dart';

class TradeScreen extends GetView<TradeController> {
  const TradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TradeController());

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
                      SizedBox(height: 30.h),
                      Text(
                        "Offer A Trade",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Choose one of your products to exchange.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      _buildProductCard(
                        "Their Item",
                        controller.product.title,
                        controller.product.price,
                        controller.product.image,
                      ),
                      SizedBox(height: 20.h),
                      _buildTradeIcon(),
                      SizedBox(height: 20.h),
                      _buildSelectProductCard(),
                      SizedBox(height: 30.h),
                      _buildCashInput(),
                      SizedBox(height: 25.h),
                      _buildMessageInput(),
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
            "Trade",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String tag, String title, String price, String img, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF2558A8).withOpacity(0.4),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                child: Stack(
                  children: [
                    Image.network(
                      img,
                      height: 260.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    // Mock carousel dots
                    Positioned(
                      bottom: 15.h,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return Container(
                            width: 8.w,
                            height: 8.h,
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == 0
                                  ? const Color(0xFF00E5FF)
                                  : Colors.white.withOpacity(0.3),
                            ),
                          );
                        }),
                      ),
                    ),
                    // Navigation arrows (mock)
                    Positioned(
                      left: 10.w,
                      top: 110.h,
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10.w,
                      top: 110.h,
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 15.h,
                left: 15.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Ref. 126610LN • 2023",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  price,
                  style: TextStyle(
                    color: const Color(0xFF00E5FF),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      )
    );
  }

  Widget _buildTradeIcon() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: const BoxDecoration(
          color: Color(0xFF00E5FF),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          'assets/icons/Trade-In Available.svg',
          width: 24.w,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }

  Widget _buildSelectProductCard() {
    return Obx(() {
      final selectedProduct = controller.selectedProduct.value;
      if (selectedProduct != null) {
        return _buildProductCard(
          "Your Item",
          selectedProduct.title,
          selectedProduct.price,
          selectedProduct.image,
          onTap: () => Get.to(() => const SelectProjectScreen()),
        );
      }
      return GestureDetector(
        onTap: () => Get.to(() => const SelectProjectScreen()),
        child: CustomPaint(
          painter: DashedRectPainter(
            color: Colors.white.withOpacity(0.3),
            strokeWidth: 1,
            gap: 5,
            borderRadius: 30.r,
          ),
          child: Container(
            width: double.infinity,
            height: 250.h,
            decoration: BoxDecoration(
              color: const Color(0xFF2558A8).withOpacity(0.4),
              borderRadius: BorderRadius.circular(30.r),
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
                  child: Icon(Icons.add, color: Colors.white, size: 28.sp),
                ),
                SizedBox(height: 15.h),
                Text(
                  "Select Your Product",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Choose from your active listings",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCashInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.payments_outlined,
              color: const Color(0xFF00E5FF),
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              "Add Extra Cash (Optional)",
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        TextField(
          controller: controller.cashController,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
          decoration: InputDecoration(
            hintText: "0.00",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            prefixText: "\$  ",
            prefixStyle: TextStyle(
              color: const Color(0xFF00E5FF),
              fontSize: 16.sp,
            ),
            filled: true,
            fillColor: const Color(0xFF2558A8).withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.all(18.r),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "Increases your chances of trade acceptance.",
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.chat_bubble_outline,
              color: const Color(0xFF00E5FF),
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              "Message To Seller",
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        TextField(
          controller: controller.messageController,
          maxLines: 4,
          style: TextStyle(color: Colors.white, fontSize: 15.sp),
          decoration: InputDecoration(
            hintText: "Tell the seller why this is a great trade...",
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 15.sp,
            ),
            filled: true,
            fillColor: const Color(0xFF2558A8).withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.all(18.r),
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
            onPressed: () => controller.sendOffer(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0044CC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            child: Text(
              "Send Offer",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
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
              side: const BorderSide(color: Color(0xFF0044CC)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            child: Text(
              "Cancel Offer",
              style: TextStyle(color: const Color(0xFF0044CC), fontSize: 16.sp),
            ),
          ),
        ),
      ],
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double borderRadius;

  DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    final Path dashPath = Path();
    double distance = 0.0;
    for (final PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
      distance = 0.0;
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
