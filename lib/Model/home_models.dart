class ListingModel {
  final String title;
  final String price;
  final String seller;
  final String image;
  final bool isNew;
  final bool isTrade;

  ListingModel({
    required this.title,
    required this.price,
    required this.seller,
    required this.image,
    this.isNew = false,
    this.isTrade = false,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      seller: json['seller'] ?? '',
      image: json['image'] ?? '',
      isNew: json['isNew'] ?? false,
      isTrade: json['isTrade'] ?? false,
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
  final String name;
  final String members;
  final String posts;
  final String icon;

  GroupModel({
    required this.name,
    required this.members,
    required this.posts,
    required this.icon,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      name: json['name'] ?? '',
      members: json['members'] ?? '',
      posts: json['posts'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}
