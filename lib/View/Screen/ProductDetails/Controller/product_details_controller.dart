import 'dart:convert';
import 'package:get/get.dart';
import '../../../../Model/home_models.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';

class ProductDetailsController extends GetxController {
  final ListingModel product = Get.arguments;
  
  final currentImageIndex = 0.obs;
  final productImages = [].obs;
  
  final isLoading = false.obs;
  final listingData = <String, dynamic>{}.obs;
  final sellerData = <String, dynamic>{}.obs;
  final similarListings = <ListingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Default fallback to initial product image
    productImages.assign(product.image);
    fetchListingDetails();
  }

  void updateImageIndex(int index) {
    currentImageIndex.value = index;
  }

  Future<void> fetchListingDetails() async {
    if (product.slug.isEmpty) return;
    
    isLoading.value = true;
    try {
      final token = await SharedPrefsHelper.getToken();
      final response = await ApiClient.get(
        '${ApiUrl.listing}/${product.slug}',
        requireAuth: token != null && token.isNotEmpty,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final resData = data['data'];
          listingData.assignAll(resData['listing'] ?? {});
          sellerData.assignAll(resData['seller'] ?? {});
          
          // Populate productImages with images from listing data
          final List<dynamic> images = resData['listing']?['images'] ?? [];
          if (images.isNotEmpty) {
            productImages.assignAll(images.map((img) => img.toString()).toList());
          } else {
            productImages.assign(product.image);
          }
          
          // Populate similarListings
          final List<dynamic> similar = resData['similarListings'] ?? [];
          List<ListingModel> similarModels = [];
          for (var item in similar) {
            String thumbnail = item['thumbnail']?.toString().replaceAll('`', '').trim() ?? '';
            if (thumbnail.isEmpty && item['images'] != null && (item['images'] as List).isNotEmpty) {
              thumbnail = item['images'][0].toString().replaceAll('`', '').trim();
            }
            if (thumbnail.isEmpty) {
              thumbnail = 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=800&auto=format&fit=crop';
            }
            final sellerName = item['sellerProfileId'] != null
                ? (item['sellerProfileId']['displayName'] ?? 'Jane Doe').toString()
                : 'Jane Doe';
                
            similarModels.add(ListingModel(
              title: item['title'] ?? '',
              price: '\$${item['price']?.toString() ?? '0'}',
              seller: sellerName,
              image: thumbnail,
              isNew: item['condition']?.toString().toLowerCase() == 'new',
              isTrade: item['listingType']?.toString().toLowerCase() == 'trade' || item['listingType']?.toString().toLowerCase() == 'sale_and_trade',
              slug: item['slug']?.toString() ?? '',
            ));
          }
          similarListings.assignAll(similarModels);
        }
      }
    } catch (e) {
      print('Error fetching listing details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
