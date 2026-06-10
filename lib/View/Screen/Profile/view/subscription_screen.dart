import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../Controller/subscription_controller.dart';

class SubscriptionScreen extends GetView<SubscriptionController> {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SubscriptionController());

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
                    children: [
                      SizedBox(height: 30.h),
                      Text(
                        "Upgrade Your\nExperience",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        "Choose the perfect plan to boost your\ntrading game.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14.sp,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      ...controller.plans.map((plan) => _buildPlanCard(plan)),
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
                "Subscriptions Plan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
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

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    bool isCurrent = plan['isCurrent'] ?? false;
    return Container(
      margin: EdgeInsets.only(bottom: 30.h),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(25.r),
            decoration: BoxDecoration(
              color: const Color(0xFF002FA7).withOpacity(0.4),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: isCurrent ? const Color(0xFF00E5FF).withOpacity(0.5) : Colors.white.withOpacity(0.1),
                width: isCurrent ? 2.w : 1.w,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF002FA7).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    plan['tag'],
                    style: TextStyle(color: const Color(0xFF00E5FF), fontSize: 11.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  plan['price'],
                  style: TextStyle(color: const Color(0xFF00E5FF), fontSize: 32.sp, fontWeight: FontWeight.bold),
                ),
                if (plan['priceSuffix'] != null)
                  Text(
                    plan['priceSuffix'],
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13.sp),
                  ),
                if (plan['subtitle'] != null)
                  Text(
                    plan['subtitle'],
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13.sp),
                  ),
                SizedBox(height: 25.h),
                ... (plan['features'] as List<String>).map((feature) => Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle_outline, color: const Color(0xFF00E5FF), size: 18.sp),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13.sp, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                )),
                if (!isCurrent) ...[
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: plan['name'] == 'Silver Plan' ? const Color(0xFF0052D4) : Colors.transparent,
                        side: plan['name'] == 'Silver Plan' ? null : const BorderSide(color: Color(0xFF0052D4)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Upgrade to Pro", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8.w),
                          Icon(Icons.arrow_forward, size: 16.sp),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            top: -15.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF00E5FF),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Text(
                isCurrent ? "Current Plan" : "Popular",
                style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
