import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/home_models.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/network_img/image_helper.dart';

class DiscoverController extends GetxController {
  final searchController = TextEditingController();

  final isLoading = false.obs;
  final isError = false.obs;
  final errorMessage = ''.obs;

  // Categories
  final categories = <String>['All'].obs;
  final selectedCategory = 'All'.obs;

  // Sections data
  final trendingProducts = <ListingModel>[].obs;
  final itemsYouMayLike = <ListingModel>[].obs;
  final recommendedForYou = <ListingModel>[].obs;

  // Category Filtered Listings
  final filteredListings = <ListingModel>[].obs;
  final isFilterMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    initLoad();
  }

  Future<void> initLoad() async {
    await fetchCategories();
    await fetchDiscoverFeed();
  }

  Future<void> refreshData() async {
    if (selectedCategory.value == 'All') {
      await initLoad();
    } else {
      await fetchCategories();
      await fetchCategoryListings(selectedCategory.value);
    }
  }

  Future<void> fetchCategories() async {
    try {
      final token = await SharedPrefsHelper.getToken();
      final response = await ApiClient.get(ApiUrl.discoveryCategories, requireAuth: token != null && token.isNotEmpty);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final List<dynamic> catList = body['data'];
          final List<String> parsedCats = catList.map((e) => e.toString()).toList();
          categories.assignAll(['All', ...parsedCats]);
        }
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> fetchDiscoverFeed() async {
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';
    isFilterMode.value = false;

    try {
      final token = await SharedPrefsHelper.getToken();
      final response = await ApiClient.get(ApiUrl.discoveryFeed, requireAuth: token != null && token.isNotEmpty);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'];

          // 1. Trending Products
          final List<dynamic> trendingJson = data['trendingProducts'] ?? [];
          trendingProducts.assignAll(trendingJson.map((j) => parseListing(j)).toList());

          // 2. Items You May Like
          final List<dynamic> likedJson = data['itemsYouMayLike'] ?? [];
          itemsYouMayLike.assignAll(likedJson.map((j) => parseListing(j)).toList());

          // 3. Recommended For You
          final List<dynamic> recommendedJson = data['recommendedForYou'] ?? [];
          recommendedForYou.assignAll(recommendedJson.map((j) => parseListing(j)).toList());
        } else {
          isError.value = true;
          errorMessage.value = body['message'] ?? 'Failed to load discover feed.';
        }
      } else {
        isError.value = true;
        errorMessage.value = 'Failed to load discover feed (Status: ${response.statusCode}).';
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = 'Something went wrong: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategoryListings(String categoryName) async {
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';
    isFilterMode.value = true;
    filteredListings.clear();

    try {
      final token = await SharedPrefsHelper.getToken();
      final response = await ApiClient.get(
        '${ApiUrl.discoveryCategory}/$categoryName',
        requireAuth: token != null && token.isNotEmpty,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final dynamic rawData = body['data'];
          List<dynamic> listingsList = [];
          if (rawData is List) {
            listingsList = rawData;
          } else if (rawData is Map && rawData['listings'] is List) {
            listingsList = rawData['listings'];
          }
          filteredListings.assignAll(listingsList.map((j) => parseListing(j)).toList());
        } else {
          isError.value = true;
          errorMessage.value = body['message'] ?? 'Failed to load category listings.';
        }
      } else {
        isError.value = true;
        errorMessage.value = 'Failed to load category listings (Status: ${response.statusCode}).';
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = 'Something went wrong: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void onCategorySelected(String category) {
    selectedCategory.value = category;
    if (category == 'All') {
      fetchDiscoverFeed();
    } else {
      fetchCategoryListings(category);
    }
  }

  ListingModel parseListing(dynamic json) {
    String thumbnail = json['thumbnail']?.toString().replaceAll('`', '').trim() ?? '';
    if (thumbnail.isEmpty && json['images'] != null && (json['images'] as List).isNotEmpty) {
      thumbnail = json['images'][0].toString().replaceAll('`', '').trim();
    }
    if (thumbnail.isEmpty) {
      thumbnail = 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=800&auto=format&fit=crop';
    }

    String sellerName = 'Jane Doe';
    if (json['sellerProfileId'] != null) {
      if (json['sellerProfileId'] is Map) {
        sellerName = (json['sellerProfileId']['displayName'] ?? json['sellerProfileId']['username'] ?? 'Jane Doe').toString();
      } else {
        sellerName = json['sellerProfileId'].toString();
      }
    } else if (json['sellerId'] != null) {
      if (json['sellerId'] is Map) {
        sellerName = (json['sellerId']['displayName'] ?? json['sellerId']['username'] ?? 'Jane Doe').toString();
      } else {
        sellerName = json['sellerId'].toString();
      }
    }

    return ListingModel(
      title: json['title']?.toString() ?? '',
      price: '\$${json['price']?.toString() ?? '0'}',
      seller: sellerName,
      image: ImageHelper.formatImageUrl(thumbnail),
      isNew: json['condition']?.toString().toLowerCase() == 'new',
      isTrade: json['listingType']?.toString().toLowerCase() == 'trade' || 
              json['listingType']?.toString().toLowerCase() == 'sale_and_trade',
      slug: json['slug']?.toString() ?? '',
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
