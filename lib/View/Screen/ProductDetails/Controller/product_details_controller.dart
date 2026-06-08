import 'package:get/get.dart';
import '../../../../Model/home_models.dart';

class ProductDetailsController extends GetxController {
  final ListingModel product = Get.arguments;
  
  final currentImageIndex = 0.obs;
  
  final productImages = [].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize images with the product image and some mock ones
    productImages.assignAll([
      product.image,
      'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?q=80&w=500&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1542496658-e33a6d0d50f6?q=80&w=500&auto=format&fit=crop',
    ]);
  }

  void updateImageIndex(int index) {
    currentImageIndex.value = index;
  }
}
