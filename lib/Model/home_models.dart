class ListingModel {
  final String title;
  final String price;
  final String seller;
  final String image;
  final bool isNew;
  final bool isTrade;
  final String slug;

  ListingModel({
    required this.title,
    required this.price,
    required this.seller,
    required this.image,
    this.isNew = false,
    this.isTrade = false,
    this.slug = '',
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      seller: json['seller'] ?? '',
      image: json['image'] ?? '',
      isNew: json['isNew'] ?? false,
      isTrade: json['isTrade'] ?? false,
      slug: json['slug'] ?? '',
    );
  }
}

class SellerModel {
  final String name;
  final String role;
  final String image;
  final bool isVerified;

  SellerModel({
    required this.name,
    required this.role,
    required this.image,
    this.isVerified = false,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      image: json['image'] ?? '',
      isVerified: json['isVerified'] ?? false,
    );
  }
}

class GroupModel {
  final String id;
  final String name;
  final String members;
  final String posts;
  final String icon;
  final bool isJoined;
  final String description;

  GroupModel({
    this.id = '',
    required this.name,
    required this.members,
    required this.posts,
    required this.icon,
    this.isJoined = false,
    this.description = '',
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['groupName'] ?? json['name'] ?? '',
      members: json['participants'] != null && json['participants'] is List 
          ? '${(json['participants'] as List).length} members'
          : '0 members',
      posts: '0 new posts',
      icon: json['groupImage'] ?? json['icon'] ?? '',
      isJoined: json['isJoined'] ?? false,
      description: json['description'] ?? '',
    );
  }
}
