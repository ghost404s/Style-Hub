import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models.dart';

/// Thin client for the DummyJSON products API.
///
/// Every method degrades gracefully: when the network is unavailable the
/// callers fall back to the bundled mock catalogue.
class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  static const _base = 'https://dummyjson.com/products';
  static const _timeout = Duration(seconds: 10);

  Future<List<Product>> fetchProducts({int limit = 100}) async {
    final uri = Uri.parse(
      '$_base?limit=$limit&select=id,title,description,'
      'category,price,discountPercentage,rating,stock,tags,brand,images,thumbnail',
    );
    final data = await _get(uri);
    final list = (data['products'] as List).cast<Map<String, dynamic>>();
    return list.map(_fromJson).toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    final uri = Uri.parse(
      '$_base/search?q=${Uri.encodeComponent(query)}&'
      'select=id,title,description,category,price,discountPercentage,rating,'
      'stock,tags,brand,images,thumbnail',
    );
    final data = await _get(uri);
    final list = (data['products'] as List).cast<Map<String, dynamic>>();
    return list.map(_fromJson).toList();
  }

  Future<Product> fetchProduct(String id) async {
    final numericId = id.replaceFirst(RegExp(r'^d'), '');
    final data = await _get(Uri.parse('$_base/$numericId'));
    return _fromJson(data);
  }

  Future<Map<String, dynamic>> _get(Uri uri) async {
    final response = await http.get(uri).timeout(_timeout);
    if (response.statusCode != 200) {
      throw Exception('API error ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Product _fromJson(Map<String, dynamic> json) {
    final categoryId = (json['category'] as String?) ?? 'other';
    final price = ((json['price'] as num?) ?? 0).toDouble();
    final discount = ((json['discountPercentage'] as num?) ?? 0).toDouble();
    final oldPrice = discount > 0 ? (price / (1 - discount / 100)) : null;
    final images = ((json['images'] as List?) ?? const []).cast<String>();
    final tags = ((json['tags'] as List?) ?? const []).cast<String>();

    return Product(
      id: 'd${json['id']}',
      title: (json['title'] as String?) ?? 'Untitled product',
      brand: (json['brand'] as String?) ?? _fallbackBrand(categoryId),
      price: price,
      oldPrice: oldPrice,
      rating: ((json['rating'] as num?) ?? 4.0).toDouble(),
      reviewCount: ((json['reviews'] as List?) ?? const []).length,
      categoryId: categoryId,
      imageSeed: 900 + ((json['id'] as num?) ?? 0).toInt(),
      colors: _colorsFor(categoryId),
      sizes: _sizesFor(categoryId),
      tags: tags,
      description: (json['description'] as String?) ?? '',
      imageUrl: json['thumbnail'] as String?,
      gallery: images,
      stock: ((json['stock'] as num?) ?? 50).toInt(),
      isOnSale: discount > 0,
    );
  }

  String _fallbackBrand(String categoryId) {
    const brands = {
      'beauty': 'Éclat',
      'fragrances': 'Noir & Co',
      'furniture': 'Atlas Home',
      'groceries': 'Daily Market',
      'home-decoration': 'Casa Verde',
      'kitchen-accessories': 'Maison Kitchen',
      'laptops': 'Volt',
      'mens-shirts': 'Urban Threads',
      'mens-shoes': 'Grain & Sole',
      'mens-watches': 'Nord & Co',
      'mobile-accessories': 'Pocket',
      'motorcycle': 'Apex Rides',
      'mouse': 'Click Labs',
      'pets': 'Paw & Co',
      'phone': 'MobileCo',
      'sports-accessories': 'Activewear',
      'tablets': 'Slate',
      'tops': 'Woven',
      'vehicle': 'Driveworks',
      'women-bags': 'Atelier 8',
      'women-dresses': 'Maison Noire',
      'women-jewelry': 'Lumière',
      'women-shoes': 'Stride Co.',
      'women-watches': 'Élan',
    };
    return brands[categoryId] ?? 'StyleHub Edit';
  }

  List<Color> _colorsFor(String categoryId) {
    if (categoryId.contains('women') || categoryId == 'beauty') {
      return const [Color(0xFFE5484D), Color(0xFF111111), Color(0xFFECEAEA)];
    }
    if (categoryId.contains('men') || categoryId.contains('shoe')) {
      return const [Color(0xFF111111), Color(0xFF2B2B2B), Color(0xFF8A8781)];
    }
    if (categoryId.contains('bag') || categoryId.contains('watch')) {
      return const [Color(0xFF5B4232), Color(0xFF111111)];
    }
    return const [Color(0xFF6C4CF1), Color(0xFF111111), Color(0xFFECEAEA)];
  }

  List<String> _sizesFor(String categoryId) {
    if (categoryId.contains('shoe')) {
      return const ['EU38', 'EU39', 'EU40', 'EU41', 'EU42', 'EU43', 'EU44'];
    }
    if (categoryId.contains('shirt') ||
        categoryId.contains('dress') ||
        categoryId == 'tops') {
      return const ['XS', 'S', 'M', 'L', 'XL'];
    }
    if (categoryId.contains('watch') || categoryId.contains('jewel')) {
      return const ['One Size'];
    }
    return const ['One Size'];
  }
}

/// Maps a DummyJSON category slug to a friendly display name.
String categoryTitle(String slug) {
  return slug
      .split('-')
      .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
      .join(' ');
}

/// Stable icon + colour pair for any category slug.
(IconData, Color) categoryVisual(String slug) {
  if (slug.contains('men') || slug.contains('shirt') || slug == 'tops') {
    return (Icons.checkroom_rounded, const Color(0xFF6C4CF1));
  }
  if (slug.contains('women') || slug.contains('dress')) {
    return (Icons.checkroom_rounded, const Color(0xFFE5484D));
  }
  if (slug.contains('shoe')) {
    return (Icons.directions_walk_rounded, const Color(0xFF1F9D55));
  }
  if (slug.contains('bag')) {
    return (Icons.work_rounded, const Color(0xFFF5A623));
  }
  if (slug.contains('watch')) {
    return (Icons.watch_rounded, const Color(0xFF1F9D8B));
  }
  if (slug.contains('jewel')) {
    return (Icons.diamond_outlined, const Color(0xFF7B4DE4));
  }
  if (slug.contains('beauty')) {
    return (Icons.brush_rounded, const Color(0xFFE5484D));
  }
  if (slug.contains('fragrance')) {
    return (Icons.spa_outlined, const Color(0xFF7B4DE4));
  }
  if (slug.contains('furniture') ||
      slug.contains('home') ||
      slug.contains('decor') ||
      slug.contains('kitchen')) {
    return (Icons.chair_rounded, const Color(0xFF3B82C4));
  }
  if (slug.contains('laptop') ||
      slug.contains('phone') ||
      slug.contains('tablet') ||
      slug.contains('mobile') ||
      slug.contains('mouse')) {
    return (Icons.laptop_mac_rounded, const Color(0xFF3B82C4));
  }
  if (slug.contains('grocery')) {
    return (Icons.shopping_basket_rounded, const Color(0xFF1F9D55));
  }
  if (slug.contains('pets')) {
    return (Icons.pets_rounded, const Color(0xFFF5A623));
  }
  if (slug.contains('motorcycle') || slug.contains('vehicle')) {
    return (Icons.two_wheeler_rounded, const Color(0xFFE5484D));
  }
  if (slug.contains('sports')) {
    return (Icons.sports_basketball_rounded, const Color(0xFF1F9D55));
  }
  return (Icons.category_rounded, const Color(0xFF6C4CF1));
}
