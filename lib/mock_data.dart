import 'package:flutter/material.dart';

import 'models.dart';

/// Static demo data powering the StyleHub experience.
class MockData {
  MockData._();

  static const List<Category> categories = [
    Category(
      id: 'all',
      name: 'All',
      icon: Icons.grid_view_rounded,
      seed: 1,
      color: Color(0xFF2B2B2B),
    ),
    Category(
      id: 'men',
      name: 'Men',
      icon: Icons.checkroom_rounded,
      seed: 2,
      color: Color(0xFF6C4CF1),
    ),
    Category(
      id: 'women',
      name: 'Women',
      icon: Icons.favorite_border_rounded,
      seed: 3,
      color: Color(0xFFE5484D),
    ),
    Category(
      id: 'shoes',
      name: 'Shoes',
      icon: Icons.directions_walk_rounded,
      seed: 4,
      color: Color(0xFF1F9D55),
    ),
    Category(
      id: 'bags',
      name: 'Bags',
      icon: Icons.work_rounded,
      seed: 5,
      color: Color(0xFFF5A623),
    ),
    Category(
      id: 'accessories',
      name: 'Accessories',
      icon: Icons.watch_rounded,
      seed: 6,
      color: Color(0xFF1F9D8B),
    ),
    Category(
      id: 'beauty',
      name: 'Beauty',
      icon: Icons.brush_rounded,
      seed: 7,
      color: Color(0xFF7B4DE4),
    ),
    Category(
      id: 'home',
      name: 'Home & Living',
      icon: Icons.chair_rounded,
      seed: 8,
      color: Color(0xFF3B82C4),
    ),
  ];

  static const List<Color> garmentColors = [
    Color(0xFF111111),
    Color(0xFF6C4CF1),
    Color(0xFFE5484D),
    Color(0xFF1F9D55),
    Color(0xFFF5A623),
    Color(0xFF3B82C4),
    Color(0xFFECEAE3),
  ];

  static const List<String> sizes = ['XS', 'S', 'M', 'L', 'XL'];

  static List<Product> get products => <Product>[
        Product(
          id: 'p1',
          title: 'Oversized Cotton Hoodie',
          brand: 'Urban Threads',
          price: 78.00,
          oldPrice: 110.00,
          rating: 4.9,
          reviewCount: 342,
          categoryId: 'men',
          imageSeed: 101,
          colors: const [Color(0xFF2B2B2B), Color(0xFFECEAEA), Color(0xFF6C4CF1)],
          sizes: const ['S', 'M', 'L', 'XL'],
          tags: const ['Bestseller', 'Winter'],
          description:
              'A heavyweight, brushed-fleece hoodie cut for a relaxed silhouette. '
              'Stone-washed for a lived-in feel and finished with a ribbed hem.',
          isNew: true,
          isOnSale: true,
        ),
        Product(
          id: 'p2',
          title: 'Tailored Wrap Dress',
          brand: 'Maison Noire',
          price: 89.00,
          rating: 4.8,
          reviewCount: 218,
          categoryId: 'women',
          imageSeed: 102,
          colors: const [Color(0xFFFFF0F0), Color(0xFF111111), Color(0xFF3B82C4)],
          sizes: const ['XS', 'S', 'M', 'L'],
          tags: ['New', 'Trending'],
          description:
            'An elegant wrap dress cut in a fluid, drapey twill. Flattering nipped waist '
            'and a graceful full-length skirt for day-to-evening ease.',
          isNew: true,
        ),
        Product(
          id: 'p3',
          title: 'Retro Court Sneakers',
          brand: 'Stride Co.',
          price: 120.00,
          oldPrice: 160.00,
          rating: 4.7,
          reviewCount: 512,
          categoryId: 'shoes',
          imageSeed: 103,
          colors: const [Color(0xFFECEAEA), Color(0xFF111111)],
          sizes: const ['EU38', 'EU39', 'EU40', 'EU41', 'EU42', 'EU43', 'EU44'],
          tags: const ['Bestseller', 'Sale'],
          description:
            'Buttery leather uppers with a vulcanised rubber sole. Timeless court '
            'styling re-engineered for all-day comfort.',
          isOnSale: true,
        ),
        Product(
          id: 'p4',
          title: 'Structured Tote Bag',
          brand: 'Atelier 8',
          price: 95.00,
          rating: 4.6,
          reviewCount: 174,
          categoryId: 'bags',
          imageSeed: 104,
          colors: const [Color(0xFF8B5CF6), Color(0xFFF5A623), Color(0xFF111111)],
          sizes: const ['One Size'],
          tags: const ['Trending'],
          description:
            'A geometric tote in pebbled faux leather with a magnetic closure and '
            'interior zip pocket. Perfect for the everyday carry.',
        ),
        Product(
          id: 'p5',
          title: 'Minimal Chrono Watch',
          brand: 'Nord & Co',
          price: 149.00,
          oldPrice: 199.00,
          rating: 4.9,
          reviewCount: 96,
          categoryId: 'accessories',
          imageSeed: 105,
          colors: const [Color(0xFF111111), Color(0xFF8A8781)],
          sizes: const ['38mm', '40mm', '42mm'],
          tags: const ['Gift pick', 'Sale'],
          description:
            'A slim chronograph with a sapphire-coated glass, fine-lined dial and '
            'quick-release strap. Water resistant to 5ATM.',
          isOnSale: true,
        ),
        Product(
          id: 'p6',
          title: 'Linen Field Shirt',
          brand: 'Casa Verde',
          price: 64.00,
          rating: 4.5,
          reviewCount: 208,
          categoryId: 'men',
          imageSeed: 106,
          colors: const [Color(0xFFADD8C0), Color(0xFFECEAEA), Color(0xFF3B82C4)],
          sizes: sizes,
          tags: const [],
          description:
            'Breathable washed-linen shirt with a relaxed collar and single patch '
            'pocket. The warm-weather essential.',
        ),
        Product(
          id: 'p7',
          title: 'Merino Knit Sweater',
          brand: 'Noro',
          price: 75.00,
          oldPrice: 95.00,
          rating: 4.7,
          reviewCount: 145,
          categoryId: 'women',
          imageSeed: 107,
          colors: const [Color(0xFFF5A623), Color(0xFF111111), Color(0xFFECEAEA)],
          sizes: const ['S', 'M', 'L', 'XL'],
          tags: const ['Sale'],
          description:
            'Ultra-fine merino knit with a relaxed crew neck and dropped shoulders. '
            'Machine washable, pill-resistant, endlessly soft.',
          isOnSale: true,
        ),
        Product(
          id: 'p8',
          title: 'Leather Chelsea Boot',
          brand: 'Grain & Sole',
          price: 185.00,
          rating: 4.9,
          reviewCount: 88,
          categoryId: 'shoes',
          imageSeed: 108,
          colors: const [Color(0xFF5B4232), Color(0xFF111111)],
          sizes: const ['EU39', 'EU40', 'EU41', 'EU42', 'EU43', 'EU44'],
          tags: const ['New'],
          description:
            'Hand-stitched full-grain leather boots with a stacked heel and cushioned '
            'insole. A modern take on a timeless classic.',
          isNew: true,
        ),
        Product(
          id: 'p9',
          title: 'Satin Scarf Set',
          brand: 'Soirée',
          price: 29.00,
          rating: 4.4,
          reviewCount: 240,
          categoryId: 'accessories',
          imageSeed: 109,
          colors: const [Color(0xFFE5484D), Color(0xFF6C4CF1), Color(0xFF1F9D55)],
          sizes: const ['One Size'],
          tags: const ['Bestseller'],
          description:
              'A bundle of four silk-touch scarves in saturated jewel tones. Style them '
              'as a neckerchief, headwrap, or bag accent.',
        ),
        Product(
          id: 'p10',
          title: 'Velvet Slip Blouse',
          brand: 'Éclat',
          price: 58.00,
          rating: 4.6,
          reviewCount: 132,
          categoryId: 'beauty',
          imageSeed: 110,
          colors: const [Color(0xFF6C4CF1), Color(0xFF111111), Color(0xFFECEAEA)],
          sizes: const ['XS', 'S', 'M'],
          tags: const ['Trending'],
          description:
            'A bias-cut velvet blouse with a delicate square neckline. Effortless '
            'drama for evening looks.',
        ),
        Product(
          id: 'p11',
          title: 'Persian Wool Throw',
          brand: 'Atlas Home',
          price: 78.00,
          oldPrice: 98.00,
          rating: 4.8,
          reviewCount: 61,
          categoryId: 'home',
          imageSeed: 111,
          colors: const [Color(0xFFE5484D), Color(0xFFF5A623)],
          sizes: const ['120x160', '140x200'],
          tags: const ['Sale'],
          description:
            'Woven from 100% New Zealand wool with a hand-knotted pile. Layer it over '
            'a sofa or bench for instant warmth and texture.',
          isOnSale: true,
        ),
        Product(
          id: 'p12',
          title: 'Moisture Ritual Set',
          brand: 'Glow Lab',
          price: 46.00,
          rating: 4.5,
          reviewCount: 390,
          categoryId: 'beauty',
          imageSeed: 112,
          colors: const [Color(0xFFECEAEA)],
          sizes: const ['Travel', 'Full'],
          tags: const ['Bestseller'],
          description:
            'A three-step hydration system with squalane, ceramides and niacinamide '
            'for soft, dewy, glass-like skin.',
        ),
      ];

  static const List<String> banners = [
    'Summer Edit\nUp to 40% Off',
    'New Season\nFresh Arrivals',
    'Style Icons\nCurated Looks',
  ];

  static const List<String> searchSuggestions = [
    'oversized hoodie',
    'merino sweater',
    'chelsea boots',
    'satin scarf',
    'canvas tote',
    'linen shirt',
  ];
}