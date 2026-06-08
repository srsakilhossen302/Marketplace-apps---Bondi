import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/home_models.dart';

class DiscoverController extends GetxController {
  final searchController = TextEditingController();
  final categories = ['All Items', 'Watches', 'Sneakers', 'Accessories'].obs;
  final selectedCategory = 'All Items'.obs;

  final itemsYouMayLike = <ListingModel>[].obs;
  final recommendedForYou = <ListingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    final items = [
      ListingModel(
        title: 'iPad Air M2 - 13...',
        price: '\$950',
        seller: 'Sarah Miller',
        image: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?q=80&w=500&auto=format&fit=crop',
        isNew: true,
        isTrade: true,
      ),
      ListingModel(
        title: 'Premium Denim',
        price: '\$120',
        seller: 'John Doe',
        image: 'https://images.unsplash.com/photo-1542272604-787c3835535d?q=80&w=500&auto=format&fit=crop',
        isNew: true,
        isTrade: true,
      ),
      ListingModel(
        title: 'Office Desk',
        price: '\$450',
        seller: 'Office Hub',
        image: 'https://images.unsplash.com/photo-1518455027359-f3f816b1a22a?q=80&w=500&auto=format&fit=crop',
        isNew: true,
        isTrade: true,
      ),
      ListingModel(
        title: 'Vintage Camera',
        price: '\$320',
        seller: 'Classic Shots',
        image: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=500&auto=format&fit=crop',
        isNew: true,
        isTrade: true,
      ),
      ListingModel(
        title: 'Leather Wallet',
        price: '\$45',
        seller: 'Crafty Goods',
        image: 'https://images.unsplash.com/photo-1627123424574-724758594e93?q=80&w=500&auto=format&fit=crop',
        isNew: true,
        isTrade: true,
      ),
      ListingModel(
        title: 'Gaming Mouse',
        price: '\$85',
        seller: 'Pro Gamer',
        image: 'https://images.unsplash.com/photo-1527814050087-3793711524ee?q=80&w=500&auto=format&fit=crop',
        isNew: true,
        isTrade: true,
      ),
    ];

    itemsYouMayLike.assignAll(items.sublist(0, 3));
    recommendedForYou.assignAll(items.sublist(3, 6));
  }

  void onCategorySelected(String category) {
    selectedCategory.value = category;
  }
}
