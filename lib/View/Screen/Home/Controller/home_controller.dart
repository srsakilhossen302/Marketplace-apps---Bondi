import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/home_models.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';

class HomeController extends GetxController {
  final searchController = TextEditingController();

  // Categories
  final categories = ['All', 'Electronics', 'Fashion', 'Home', 'Toys'].obs;
  final selectedCategory = 'All'.obs;

  // New Listings
  final newListings = <ListingModel>[].obs;

  // Recommended Listings
  final recommendedListings = <ListingModel>[].obs;

  // Suggested Sellers
  final suggestedSellers = <SellerModel>[].obs;

  // Trending Groups
  final trendingGroups = <GroupModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
    fetchPublicListings();
  }

  void loadMockData() {
    // New Listings
    newListings.assignAll([
      ListingModel(
        title: 'iPad Air M2 - 13...',
        price: '\$950',
        seller: 'Sarah Miller',
        image:
            'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?q=80&w=500&auto=format&fit=crop',
        isNew: true,
        isTrade: true,
      ),
      ListingModel(
        title: 'Premium Denim Jeans',
        price: '\$120',
        seller: 'John Doe',
        image:
            'https://images.unsplash.com/photo-1542272604-787c3835535d?q=80&w=500&auto=format&fit=crop',
        isNew: true,
        isTrade: true,
      ),
      ListingModel(
        title: 'Modern Office Desk',
        price: '\$450',
        seller: 'Office Hub',
        image:
            'https://images.unsplash.com/photo-1518455027359-f3f816b1a22a?q=80&w=500&auto=format&fit=crop',
        isNew: true,
        isTrade: true,
      ),
    ]);

    // Recommended Listings
    recommendedListings.assignAll([
      ListingModel(
        title: 'Vintage Camera',
        price: '\$320',
        seller: 'Classic Shots',
        image:
            'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=500&auto=format&fit=crop',
        isNew: false,
        isTrade: true,
      ),
      ListingModel(
        title: 'Leather Wallet',
        price: '\$45',
        seller: 'Crafty Goods',
        image:
            'https://images.unsplash.com/photo-1627123424574-724758594e93?q=80&w=500&auto=format&fit=crop',
        isNew: true,
        isTrade: false,
      ),
      ListingModel(
        title: 'Wireless Headphones',
        price: '\$180',
        seller: 'Audio Tech',
        image:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=500&auto=format&fit=crop',
        isNew: false,
        isTrade: true,
      ),
      ListingModel(
        title: 'Smart Watch S2',
        price: '\$250',
        seller: 'Gadget Store',
        image:
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=500&auto=format&fit=crop',
        isNew: true,
        isTrade: true,
      ),
      ListingModel(
        title: 'Canvas Backpack',
        price: '\$65',
        seller: 'Travel Gear',
        image:
            'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?q=80&w=500&auto=format&fit=crop',
        isNew: false,
        isTrade: false,
      ),
      ListingModel(
        title: 'Gaming Mouse',
        price: '\$85',
        seller: 'Pro Gamer',
        image:
            'https://images.unsplash.com/photo-1527814050087-3793711524ee?q=80&w=500&auto=format&fit=crop',
        isNew: true,
        isTrade: true,
      ),
    ]);

    // Suggested Sellers
    suggestedSellers.assignAll([
      SellerModel(
        name: 'David K.',
        role: 'TECH EXPERT',
        image: 'https://i.pravatar.cc/150?u=david',
        isVerified: true,
      ),
      SellerModel(
        name: 'Diana R.',
        role: 'DESIGNER',
        image: 'https://i.pravatar.cc/150?u=diana',
        isVerified: false,
      ),
      SellerModel(
        name: 'Marcus L.',
        role: 'COLLECTOR',
        image: 'https://i.pravatar.cc/150?u=marcus',
        isVerified: false,
      ),
    ]);

    // Trending Groups
    trendingGroups.assignAll([
      GroupModel(
        name: 'Vintage Lens Club',
        members: '2.4k members',
        posts: '15 new posts',
        icon: 'assets/icons/Vintage Lens Club.svg',
      ),
      GroupModel(
        name: 'NYC Road Cyclists',
        members: '892 members',
        posts: '5 new posts',
        icon: 'assets/icons/NYC Road Cyclists.svg',
      ),
    ]);
  }

  void onCategorySelected(String category) {
    selectedCategory.value = category;
  }

  Future<void> fetchPublicListings() async {
    try {
      print('Fetching public listings...');
      final response = await ApiClient.get(ApiUrl.listing, requireAuth: false);
      print('Public listings response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final listingsJson = data['data'] as List<dynamic>;
        print('Loaded ${listingsJson.length} public listings');
        
        List<ListingModel> loadedListings = [];
        for (var json in listingsJson) {
          String thumbnail = json['thumbnail']?.toString().replaceAll('`', '').trim() ?? '';
          if (thumbnail.isEmpty && json['images'] != null && (json['images'] as List).isNotEmpty) {
            thumbnail = json['images'][0].toString().replaceAll('`', '').trim();
          }
          if (thumbnail.isEmpty) {
            thumbnail = 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=800&auto=format&fit=crop';
          }
          
          final sellerName = json['sellerProfileId'] != null 
              ? (json['sellerProfileId']['displayName'] ?? 'Jane Doe').toString()
              : 'Jane Doe';
              
          loadedListings.add(ListingModel(
            title: json['title'] ?? '',
            price: '\$${json['price']?.toString() ?? '0'}',
            seller: sellerName,
            image: thumbnail,
            isNew: json['condition']?.toString().toLowerCase() == 'new',
            isTrade: json['listingType']?.toString().toLowerCase() == 'trade' || json['listingType']?.toString().toLowerCase() == 'sale_and_trade',
            slug: json['slug']?.toString() ?? '',
          ));
        }
        
        if (loadedListings.isNotEmpty) {
          newListings.assignAll(loadedListings);
          recommendedListings.assignAll(loadedListings);
        }
      }
    } catch (e) {
      print('Error fetching public listings: $e');
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
