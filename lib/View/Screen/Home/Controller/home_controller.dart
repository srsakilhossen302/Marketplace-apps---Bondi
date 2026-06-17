import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/home_models.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/network_img/image_helper.dart';

class HomeController extends GetxController {
  final searchController = TextEditingController();

  final isLoading = false.obs;
  final isError = false.obs;
  final errorMessage = ''.obs;

  // Categories
  final categories = <String>['All'].obs;
  final selectedCategory = 'All'.obs;

  // New Listings
  final newListings = <ListingModel>[].obs;

  // Recommended Listings
  final recommendedListings = <ListingModel>[].obs;

  // Suggested Sellers
  final suggestedSellers = <SellerModel>[].obs;

  // Trending Groups
  final trendingGroups = <GroupModel>[].obs;

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
    await fetchHomeFeed();
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

  Future<void> fetchHomeFeed() async {
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';
    isFilterMode.value = false;
    
    try {
      final token = await SharedPrefsHelper.getToken();
      final response = await ApiClient.get(ApiUrl.discoveryHome, requireAuth: token != null && token.isNotEmpty);
      
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'];
          
          // 1. New Arrivals
          final List<dynamic> arrivalsJson = data['newArrivals'] ?? [];
          newListings.assignAll(arrivalsJson.map((j) => parseListing(j)).toList());
          
          // 2. Suggested Sellers
          final List<dynamic> sellersJson = data['popularSellers'] ?? [];
          suggestedSellers.assignAll(sellersJson.map((j) => parseSeller(j)).toList());
          
          // 3. Trending Groups
          final List<dynamic> groupsJson = data['trendingGroups'] ?? [];
          trendingGroups.assignAll(groupsJson.map((j) => parseGroup(j)).toList());
          
          // 4. Recommended Listings
          final List<dynamic> recommendedJson = data['recommendedListings'] ?? [];
          recommendedListings.assignAll(recommendedJson.map((j) => parseListing(j)).toList());
        } else {
          isError.value = true;
          errorMessage.value = body['message'] ?? 'Failed to load home feed.';
        }
      } else {
        isError.value = true;
        errorMessage.value = 'Failed to load home feed (Status: ${response.statusCode}).';
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
      fetchHomeFeed();
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

  SellerModel parseSeller(dynamic json) {
    String profileImg = json['profileImage']?.toString() ?? '';
    if (profileImg.isEmpty && json['userId'] != null && json['userId'] is Map) {
      profileImg = json['userId']['profileImage']?.toString() ?? '';
    }
    String name = json['displayName'] ?? json['username'] ?? '';
    if (name.isEmpty && json['userId'] != null && json['userId'] is Map) {
      name = json['userId']['displayName'] ?? json['userId']['username'] ?? 'Seller';
    }
    if (name.isEmpty) name = 'Seller';
    
    return SellerModel(
      name: name,
      role: json['role']?.toString() ?? 'Seller',
      image: ImageHelper.formatImageUrl(profileImg),
      isVerified: json['isVerifiedSeller'] ?? false,
    );
  }

  GroupModel parseGroup(dynamic json) {
    final memberCount = json['membersCount'] ?? json['totalMembers'] ?? '0';
    final postsCount = json['postsCount'] ?? json['newPosts'] ?? '0';
    
    return GroupModel(
      name: json['name']?.toString() ?? 'Group',
      members: '$memberCount members',
      posts: '$postsCount new posts',
      icon: json['icon']?.toString() ?? 'assets/icons/Vintage Lens Club.svg',
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
