/// Domain models for StyleHub.
library;

import 'package:flutter/material.dart';

/// Builds a reproducible picsum.photos URL for demo imagery.
String productImage(int seed, [int w = 600, int h = 720]) =>
    'https://picsum.photos/seed/$seed/$w/$h';

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.seed,
    required this.color,
  });

  final String id;
  final String name;
  final IconData icon;
  final int seed;
  final Color color;
}

class Product {
  const Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviewCount,
    required this.categoryId,
    required this.imageSeed,
    required this.colors,
    required this.sizes,
    required this.tags,
    required this.description,
    this.imageUrl,
    this.gallery = const [],
    this.stock = 100,
    this.isNew = false,
    this.isOnSale = false,
  });

  final String id;
  final String title;
  final String brand;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviewCount;
  final String categoryId;
  final int imageSeed;
  final List<Color> colors;
  final List<String> sizes;
  final List<String> tags;
  final String description;
  final String? imageUrl;
  final List<String> gallery;
  final int stock;
  final bool isNew;
  final bool isOnSale;

  String get image =>
      (imageUrl != null && imageUrl!.isNotEmpty) ? imageUrl! : productImage(imageSeed);
  int get discountPercent => (oldPrice == null || oldPrice! <= price)
      ? 0
      : (((oldPrice! - price) / oldPrice!) * 100).round();

  /// User-friendly hex labels for each colour swatch.
  List<String> get colorHexes => colors.map(_colorName).toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'brand': brand,
        'price': price,
        'oldPrice': oldPrice,
        'rating': rating,
        'reviewCount': reviewCount,
        'categoryId': categoryId,
        'imageSeed': imageSeed,
        'colors': colors.map((c) => c.toARGB32()).toList(),
        'sizes': sizes,
        'tags': tags,
        'description': description,
        'imageUrl': imageUrl,
        'gallery': gallery,
        'stock': stock,
        'isNew': isNew,
        'isOnSale': isOnSale,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        title: json['title'] as String,
        brand: json['brand'] as String,
        price: (json['price'] as num).toDouble(),
        oldPrice: (json['oldPrice'] as num?)?.toDouble(),
        rating: (json['rating'] as num).toDouble(),
        reviewCount: json['reviewCount'] as int,
        categoryId: json['categoryId'] as String,
        imageSeed: json['imageSeed'] as int,
        colors: (json['colors'] as List).map((v) => Color(v as int)).toList(),
        sizes: (json['sizes'] as List).cast<String>(),
        tags: (json['tags'] as List).cast<String>(),
        description: json['description'] as String,
        imageUrl: json['imageUrl'] as String?,
        gallery: (json['gallery'] as List).cast<String>(),
        stock: json['stock'] as int,
        isNew: json['isNew'] as bool,
        isOnSale: json['isOnSale'] as bool,
      );
}

String _colorName(Color color) {
  final lower32 = color.toARGB32() & 0xFFFFFF;
  final hex = lower32.toRadixString(16).padLeft(6, '0').toUpperCase();
  final names = {
    '111111': 'Jet Black',
    'FFFFFF': 'Pure White',
    'ECEAEA': 'Off White',
    '2B2B2B': 'Graphite',
    '6C4CF1': 'Iris',
    '8B5CF6': 'Lilac',
    'E5484D': 'Scarlet',
    '1F9D55': 'Emerald',
    'F5A623': 'Amber',
    '3B82C4': 'Cobalt',
    '1F9D8B': 'Teal',
    'ADD8C0': 'Seafoam',
    '5B4232': 'Chestnut',
    '8A8781': 'Stone',
    'FFF0F0': 'Blush',
  };
  return names[hex] ?? '#$hex';
}

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
    required this.size,
    required this.color,
  });

  final Product product;
  final int quantity;
  final String size;
  final Color color;

  double get total => product.price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
      size: size,
      color: color,
    );
  }

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
        'size': size,
        'color': color.toARGB32(),
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product: Product.fromJson(json['product'] as Map<String, dynamic>),
        quantity: json['quantity'] as int,
        size: json['size'] as String,
        color: Color(json['color'] as int),
      );
}

@immutable
class Address {
  const Address({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
    required this.isDefault,
  });

  final String id;
  final String fullName;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String zip;
  final String country;
  final bool isDefault;

  String get summary => '$street, $city, $state $zip';

  Address copyWith({bool? isDefault}) {
    return Address(
      id: id,
      fullName: fullName,
      phone: phone,
      street: street,
      city: city,
      state: state,
      zip: zip,
      country: country,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

enum OrderStatus {
  processing,
  confirmed,
  shipped,
  delivered,
  cancelled;

  String get label {
    switch (this) {
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class OrderItem {
  const OrderItem({required this.cartItem});
  final CartItem cartItem;

  double get lineTotal => cartItem.total;
}

class Order {
  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.address,
    required this.placedAt,
  });

  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final OrderStatus status;
  final String paymentMethod;
  final Address address;
  final DateTime placedAt;

  int get itemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  String get timeline => '...';
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.type,
    this.read = false,
    this.action,
  });

  final String id;
  final String title;
  final String body;
  final DateTime time;
  final IconData icon;
  final NotificationType type;
  final bool read;
  final String? action;

  AppNotification copyWith({bool? read}) {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      time: time,
      icon: icon,
      type: type,
      read: read ?? this.read,
      action: action,
    );
  }
}

enum NotificationType { order, offer, system }

class AppUser {
  const AppUser({
    required this.name,
    required this.email,
    required this.phone,
    this.bio = '',
    this.avatarSeed = 27,
  });

  final String name;
  final String email;
  final String phone;
  final String bio;
  final int avatarSeed;

  String get avatarUrl => productImage(avatarSeed, 200, 200);

  AppUser copyWith({String? name, String? email, String? phone, String? bio}) {
    return AppUser(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      avatarSeed: avatarSeed,
    );
  }
}

/// Simple value object used for displaying prices.
String formatPrice(double value, {bool includeSymbol = true}) {
  final digits = value.toStringAsFixed(2);
  final whole = digits.split('.')[0];
  final cents = digits.split('.')[1];
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final rest = whole.length - i;
    buffer.write(whole[i]);
    if (rest > 1 && rest % 3 == 1) buffer.write(',');
  }
  return includeSymbol
      ? '\$${buffer.toString()}.$cents'
      : '${buffer.toString()}.$cents';
}