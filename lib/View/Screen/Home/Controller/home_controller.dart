import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/home_models.dart';

class HomeController extends GetxController {
  final searchController = TextEditingController();

  // Categories
  final categories = ['All', 'Electronics', 'Fashion', 'Home', 'Toys'].obs;
  final selectedCategory = 'All'.obs;

  // New Listings
  final newListings = <ListingModel>[].obs;

  // Suggested Sellers
  final suggestedSellers = <SellerModel>[].obs;

  // Trending Groups
  final trendingGroups = <GroupModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    // New Listings
    newListings.assignAll([
      ListingModel(
        title: 'iPad Air M2 - 13...',
        price: '\$950',
        seller: 'Sarah Miller',
        image: 'assets/images/img.png',
        isNew: true,
        isTrade: true,
      ),
      ListingModel(
        title: 'iPad Air M2 - 13...',
        price: '\$950',
        seller: 'Sarah Miller',
        image: 'assets/images/img.png',
        isNew: true,
        isTrade: true,
      ),
      ListingModel(
        title: 'iPad Air M2 - 13...',
        price: '\$950',
        seller: 'Sarah Miller',
        image: 'assets/images/img.png',
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

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
