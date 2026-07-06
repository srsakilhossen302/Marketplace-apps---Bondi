import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Model/home_models.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/network_img/image_helper.dart';

class SearchController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  final isLoading = false.obs;
  
  // Lists
  final listings = <ListingModel>[].obs;
  final sellers = <SellerModel>[].obs;
  final groups = <GroupModel>[].obs;

  // Pagination states
  final listingsPage = 1.obs;
  final sellersPage = 1.obs;
  final groupsPage = 1.obs;

  final listingsTotalPage = 1.obs;
  final sellersTotalPage = 1.obs;
  final groupsTotalPage = 1.obs;

  final isLoadingMoreListings = false.obs;
  final isLoadingMoreSellers = false.obs;
  final isLoadingMoreGroups = false.obs;

  // Filters
  final selectedCategory = 'All'.obs;
  final minPrice = ''.obs;
  final maxPrice = ''.obs;
  final sortBy = 'Newest'.obs; // Default sorting option

  final categories = <String>['All'].obs;

  // Recent Searches
  final recentSearches = <String>[].obs;
  final popularSearches = <String>[
    'Vintage Shirts',
    'PlayStation 5',
    'Trading Cards',
    'Mechanical Keyboards',
    'Anime Figures'
  ];

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    loadRecentSearches();
    fetchCategories();
    
    // Perform search automatically when filters change
    ever(selectedCategory, (_) => performSearch(reset: true));
    ever(sortBy, (_) => performSearch(reset: true));
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchQuery.value = query;
      if (query.isNotEmpty) {
        saveSearchQuery(query);
      }
      performSearch(reset: true);
    });
  }

  Future<void> loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('recent_searches') ?? [];
      recentSearches.assignAll(list);
    } catch (e) {
      debugPrint('Error loading recent searches: $e');
    }
  }

  Future<void> saveSearchQuery(String query) async {
    final cleaned = query.trim();
    if (cleaned.isEmpty) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('recent_searches') ?? [];
      list.remove(cleaned);
      list.insert(0, cleaned);
      // Keep only top 10 recent searches
      if (list.length > 10) {
        list.removeRange(10, list.length);
      }
      await prefs.setStringList('recent_searches', list);
      recentSearches.assignAll(list);
    } catch (e) {
      debugPrint('Error saving search query: $e');
    }
  }

  Future<void> clearRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('recent_searches');
      recentSearches.clear();
    } catch (e) {
      debugPrint('Error clearing recent searches: $e');
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await ApiClient.get(ApiUrl.discoveryCategories, requireAuth: false);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final List<dynamic> catList = body['data'];
          final List<String> parsedCats = catList.map((e) => e.toString()).toList();
          categories.assignAll(['All', ...parsedCats]);
        }
      }
    } catch (e) {
      debugPrint('Error fetching categories for search: $e');
    }
  }

  Future<void> performSearch({bool reset = false}) async {
    final query = searchQuery.value.trim();
    if (query.isEmpty) {
      if (reset) {
        listings.clear();
        sellers.clear();
        groups.clear();
      }
      return;
    }

    if (reset) {
      isLoading.value = true;
      listingsPage.value = 1;
      sellersPage.value = 1;
      groupsPage.value = 1;
      listings.clear();
      sellers.clear();
      groups.clear();
    }

    try {
      final Map<String, String> queryParams = {
        'search': query,
        'page': '1',
        'limit': '10',
      };

      if (selectedCategory.value != 'All' && selectedCategory.value.isNotEmpty) {
        queryParams['category'] = selectedCategory.value;
      }
      if (minPrice.value.isNotEmpty) {
        queryParams['minPrice'] = minPrice.value;
      }
      if (maxPrice.value.isNotEmpty) {
        queryParams['maxPrice'] = maxPrice.value;
      }
      if (sortBy.value.isNotEmpty) {
        queryParams['sort'] = sortBy.value;
      }

      final uri = Uri.parse(ApiUrl.searchGlobal).replace(queryParameters: queryParams);
      final response = await ApiClient.get(uri.toString(), requireAuth: true);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'];

          // Parse Listings
          if (data['listings'] != null) {
            final listingsData = data['listings']['data'] as List? ?? [];
            final meta = data['listings']['meta'];
            listingsTotalPage.value = meta != null ? (meta['totalPage'] ?? 1) : 1;
            listings.assignAll(listingsData.map((e) => parseListing(e)).toList());
          }

          // Parse Sellers
          if (data['sellers'] != null) {
            final sellersData = data['sellers']['data'] as List? ?? [];
            final meta = data['sellers']['meta'];
            sellersTotalPage.value = meta != null ? (meta['totalPage'] ?? 1) : 1;
            sellers.assignAll(sellersData.map((e) => SellerModel.fromJson(e)).toList());
          }

          // Parse Groups
          if (data['groups'] != null) {
            final groupsData = data['groups']['data'] as List? ?? [];
            final meta = data['groups']['meta'];
            groupsTotalPage.value = meta != null ? (meta['totalPage'] ?? 1) : 1;
            groups.assignAll(groupsData.map((e) => GroupModel.fromJson(e)).toList());
          }
        }
      }
    } catch (e) {
      debugPrint('Error performing search: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreListings() async {
    if (isLoadingMoreListings.value || listingsPage.value >= listingsTotalPage.value) return;

    isLoadingMoreListings.value = true;
    try {
      final nextPage = listingsPage.value + 1;
      final Map<String, String> queryParams = {
        'search': searchQuery.value,
        'page': nextPage.toString(),
        'limit': '10',
      };

      if (selectedCategory.value != 'All' && selectedCategory.value.isNotEmpty) {
        queryParams['category'] = selectedCategory.value;
      }
      if (minPrice.value.isNotEmpty) {
        queryParams['minPrice'] = minPrice.value;
      }
      if (maxPrice.value.isNotEmpty) {
        queryParams['maxPrice'] = maxPrice.value;
      }
      if (sortBy.value.isNotEmpty) {
        queryParams['sort'] = sortBy.value;
      }

      final uri = Uri.parse(ApiUrl.searchGlobal).replace(queryParameters: queryParams);
      final response = await ApiClient.get(uri.toString(), requireAuth: true);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null && body['data']['listings'] != null) {
          final listingsData = body['data']['listings']['data'] as List? ?? [];
          if (listingsData.isNotEmpty) {
            listingsPage.value = nextPage;
            listings.addAll(listingsData.map((e) => parseListing(e)).toList());
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading more listings: $e');
    } finally {
      isLoadingMoreListings.value = false;
    }
  }

  Future<void> loadMoreSellers() async {
    if (isLoadingMoreSellers.value || sellersPage.value >= sellersTotalPage.value) return;

    isLoadingMoreSellers.value = true;
    try {
      final nextPage = sellersPage.value + 1;
      final Map<String, String> queryParams = {
        'search': searchQuery.value,
        'page': nextPage.toString(),
        'limit': '10',
      };

      if (selectedCategory.value != 'All' && selectedCategory.value.isNotEmpty) {
        queryParams['category'] = selectedCategory.value;
      }
      if (minPrice.value.isNotEmpty) {
        queryParams['minPrice'] = minPrice.value;
      }
      if (maxPrice.value.isNotEmpty) {
        queryParams['maxPrice'] = maxPrice.value;
      }
      if (sortBy.value.isNotEmpty) {
        queryParams['sort'] = sortBy.value;
      }

      final uri = Uri.parse(ApiUrl.searchGlobal).replace(queryParameters: queryParams);
      final response = await ApiClient.get(uri.toString(), requireAuth: true);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null && body['data']['sellers'] != null) {
          final sellersData = body['data']['sellers']['data'] as List? ?? [];
          if (sellersData.isNotEmpty) {
            sellersPage.value = nextPage;
            sellers.addAll(sellersData.map((e) => SellerModel.fromJson(e)).toList());
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading more sellers: $e');
    } finally {
      isLoadingMoreSellers.value = false;
    }
  }

  Future<void> loadMoreGroups() async {
    if (isLoadingMoreGroups.value || groupsPage.value >= groupsTotalPage.value) return;

    isLoadingMoreGroups.value = true;
    try {
      final nextPage = groupsPage.value + 1;
      final Map<String, String> queryParams = {
        'search': searchQuery.value,
        'page': nextPage.toString(),
        'limit': '10',
      };

      if (selectedCategory.value != 'All' && selectedCategory.value.isNotEmpty) {
        queryParams['category'] = selectedCategory.value;
      }
      if (minPrice.value.isNotEmpty) {
        queryParams['minPrice'] = minPrice.value;
      }
      if (maxPrice.value.isNotEmpty) {
        queryParams['maxPrice'] = maxPrice.value;
      }
      if (sortBy.value.isNotEmpty) {
        queryParams['sort'] = sortBy.value;
      }

      final uri = Uri.parse(ApiUrl.searchGlobal).replace(queryParameters: queryParams);
      final response = await ApiClient.get(uri.toString(), requireAuth: true);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null && body['data']['groups'] != null) {
          final groupsData = body['data']['groups']['data'] as List? ?? [];
          if (groupsData.isNotEmpty) {
            groupsPage.value = nextPage;
            groups.addAll(groupsData.map((e) => GroupModel.fromJson(e)).toList());
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading more groups: $e');
    } finally {
      isLoadingMoreGroups.value = false;
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

  void selectRecentOrPopularSearch(String search) {
    searchController.text = search;
    searchQuery.value = search;
    saveSearchQuery(search);
    performSearch(reset: true);
  }

  void resetFilters() {
    selectedCategory.value = 'All';
    minPrice.value = '';
    maxPrice.value = '';
    sortBy.value = 'Newest';
    performSearch(reset: true);
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
