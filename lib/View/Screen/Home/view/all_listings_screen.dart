import 'package:bondi/View/Widgegt/CustomCard/custom_listing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../Login/view/login_screen.dart';
import '../../ProductDetails/view/product_details_screen.dart';
import '../../../../Model/home_models.dart';
import '../Controller/home_controller.dart';

class AllListingsScreen extends GetView<HomeController> {
  const AllListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          StaticString.newListings,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundColor,
        child: SafeArea(
          child: Obx(
            () => GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 15.h,
                childAspectRatio: 0.55,
              ),
              itemCount: controller.newListings.length,
              itemBuilder: (context, index) {
                final item = controller.newListings[index];
                return CustomListingCard(
                  item: item,
                  width: double.infinity,
                  onTap: () => _handleListingTap(item),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleListingTap(ListingModel item) async {
    final token = await SharedPrefsHelper.getToken();
    if (token != null && token.isNotEmpty) {
      Get.to(() => const ProductDetailsScreen(), arguments: item);
    } else {
      Get.to(() => const LoginScreen());
    }
  }
}
