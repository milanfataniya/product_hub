class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;

  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final String returnPolicy;
  final int minimumOrderQuantity;

  final List<Review> reviews;
  final List<String> images;
  final String thumbnail;

  final Dimensions dimensions;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.reviews,
    required this.images,
    required this.thumbnail,
    required this.dimensions,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      category: json['category'] ?? "",
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage:
      (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,

      tags: List<String>.from(json['tags'] ?? []),
      brand: json['brand'] ?? "",

      warrantyInformation: json['warrantyInformation'] ?? "",
      shippingInformation: json['shippingInformation'] ?? "",
      availabilityStatus: json['availabilityStatus'] ?? "",
      returnPolicy: json['returnPolicy'] ?? "",
      minimumOrderQuantity: json['minimumOrderQuantity'] ?? 0,

      /// ✅ FIX 1: reviews null-safe
      reviews: (json['reviews'] as List? ?? [])
          .map((e) => Review.fromJson(e))
          .toList(),

      images: List<String>.from(json['images'] ?? []),
      thumbnail: json['thumbnail'] ?? "",

      /// ✅ FIX 2: dimensions null-safe
      dimensions: json['dimensions'] != null
          ? Dimensions.fromJson(json['dimensions'])
          : Dimensions(width: 0, height: 0, depth: 0),
    );
  }
}
class Review {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? "",
      date: json['date'] ?? "",
      reviewerName: json['reviewerName'] ?? "",
      reviewerEmail: json['reviewerEmail'] ?? "",
    );
  }
}
class Dimensions {
  final double width;
  final double height;
  final double depth;

  Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      depth: (json['depth'] as num?)?.toDouble() ?? 0.0,
    );
  }
}