import 'package:flutter/material.dart';

import 'mock_data.dart';
import 'models.dart';
import 'services/api_service.dart';
import 'services/persistence_service.dart';
import 'theme/app_theme.dart';

/// Global, in-memory store for StyleHub. Exposes a plain `ChangeNotifier`
/// so every screen rebuilds when the shopping bag, wishlist or orders change.
class AppState extends ChangeNotifier {
  AppState._();

  static final AppState instance = AppState._();

  /// Used to surface toast feedback (e.g. "Added to cart") from any screen.
  GlobalKey<ScaffoldMessengerState>? messengerKey;

  void _showSnack(String message) {
    messengerKey?.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  /// Loads the persisted session before the UI boots, so a returning user
  /// lands straight on the home screen with their cart and wishlist intact.
  Future<void> restoreSession() async {
    final auth = await PersistenceService.instance.loadAuth();
    isLoggedIn = auth.isLoggedIn;
    if (auth.user.email.isNotEmpty || auth.user.name.isNotEmpty) {
      user = auth.user;
    }
    onboardingSeen = await PersistenceService.instance.loadOnboardingSeen();
    darkMode = await PersistenceService.instance.loadDarkMode();
    AppColors.setBrightness(darkMode);
    _wishlist
      ..clear()
      ..addAll(await PersistenceService.instance.loadWishlist());
    _cart
      ..clear()
      ..addAll(await PersistenceService.instance.loadCart());
    notifyListeners();
  }

  bool onboardingSeen = false;
  bool isLoggedIn = false;

  // ---------------------------------------------------------------------
  // Theme
  // ---------------------------------------------------------------------

  bool darkMode = false;

  void setDarkMode(bool value) {
    if (darkMode == value) return;
    darkMode = value;
    AppColors.setBrightness(value);
    PersistenceService.instance.saveDarkMode(value);
    notifyListeners();
  }

  AppUser user = const AppUser(
    name: 'Alex Morgan',
    email: 'alex.morgan@example.com',
    phone: '+1 555 012 3456',
    bio: 'Fashion enthusiast. Coffee first, retail therapy second.',
  );

  // ---------------------------------------------------------------------
  // Catalogue (loads from DummyJSON with mock fallback)
  // ---------------------------------------------------------------------

  bool catalogueLoading = false;
  List<Product> _products = List.of(MockData.products);
  List<Category> _categories = List.of(MockData.categories);

  List<Product> get products => _products;
  List<Category> get categories => _categories;

  /// Attempts to refresh the catalogue from the API. Keeps the bundled
  /// mock data untouched when the network is unreachable.
  Future<void> loadCatalogue() async {
    if (catalogueLoading) return;
    catalogueLoading = true;
    notifyListeners();
    try {
      final remote = await ApiService.instance.fetchProducts();
      if (remote.isNotEmpty) {
        _products = remote;
        _categories = _buildCategories(remote);
      }
    } catch (_) {
      // Offline: keep the mock catalogue.
    } finally {
      catalogueLoading = false;
      notifyListeners();
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    try {
      final remote = await ApiService.instance.searchProducts(query);
      if (remote.isNotEmpty) return remote;
    } catch (_) {
      // Fall through to local search.
    }
    return localSearch(q);
  }

  List<Product> localSearch(String q) {
    final catNames = _categories
        .where((c) => c.name.toLowerCase().contains(q))
        .map((c) => c.id)
        .toList();
    return _products.where((p) {
      final fields = [
        p.title.toLowerCase(),
        p.brand.toLowerCase(),
        ...p.tags.map((t) => t.toLowerCase()),
        p.categoryId,
      ];
      return fields.any((f) => f.contains(q)) ||
          catNames.contains(p.categoryId);
    }).toList();
  }

  List<Category> _buildCategories(List<Product> products) {
    final seen = <String>{};
    final result = <Category>[
      const Category(
        id: 'all',
        name: 'All',
        icon: Icons.grid_view_rounded,
        seed: 1,
        color: Color(0xFF2B2B2B),
      ),
    ];
    for (final product in products) {
      final id = product.categoryId;
      if (!seen.add(id)) continue;
      final (icon, color) = categoryVisual(id);
      result.add(Category(
        id: id,
        name: categoryTitle(id),
        icon: icon,
        seed: id.hashCode.abs() % 999 + 1,
        color: color,
      ));
    }
    return result;
  }

  final List<CartItem> _cart = [];
  final Set<String> _wishlist = {};
  final List<Order> _orders = [];
  final List<Address> _addresses = [
    const Address(
      id: 'a1',
      fullName: 'Alex Morgan',
      phone: '+1 555 012 3456',
      street: '218 Sunset Boulevard, Apt 4B',
      city: 'Los Angeles',
      state: 'CA',
      zip: '90028',
      country: 'United States',
      isDefault: true,
    ),
    const Address(
      id: 'a2',
      fullName: 'Alex Morgan',
      phone: '+1 555 012 3456',
      street: '88 Harbor Lane',
      city: 'San Francisco',
      state: 'CA',
      zip: '94105',
      country: 'United States',
      isDefault: false,
    ),
  ];

  List<AppNotification> _notifications = [
    AppNotification(
      id: 'n1',
      title: 'Order Shipped 🎉',
      body:
          'Your order #SH-2026-0711 is on the way. Track it from Order Details.',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      icon: Icons.local_shipping_rounded,
      type: NotificationType.order,
      action: 'View',
    ),
    AppNotification(
      id: 'n2',
      title: 'Weekend Flash Sale',
      body: 'Extra 25% off select styles this weekend only. Code: STYLE25.',
      time: DateTime.now().subtract(const Duration(hours: 9)),
      icon: Icons.percent_rounded,
      type: NotificationType.offer,
    ),
    AppNotification(
      id: 'n3',
      title: 'Welcome to StyleHub',
      body: 'Your account is ready. Complete your profile to unlock perks.',
      time: DateTime.now().subtract(const Duration(days: 2)),
      icon: Icons.celebration_rounded,
      type: NotificationType.system,
    ),
    AppNotification(
      id: 'n4',
      title: 'Back in Stock',
      body:
          'The Retro Court Sneakers you saved are available again in your size.',
      time: DateTime.now().subtract(const Duration(days: 4)),
      icon: Icons.notifications_active_rounded,
      type: NotificationType.offer,
      action: 'View',
    ),
  ];

  List<CartItem> get cart => List.unmodifiable(_cart);
  List<Order> get orders => List.unmodifiable(_orders);
  List<Address> get addresses => List.unmodifiable(_addresses);
  List<AppNotification> get notifications =>
      List.unmodifiable(_notifications);

  int get cartCount => _cart.fold(0, (sum, i) => sum + i.quantity);

  double get cartSubtotal =>
      _cart.fold(0.0, (sum, i) => sum + i.total);

  double get shippingCost => cartSubtotal >= 100 ? 0 : 8.0;

  double get tax => cartSubtotal * 0.08;

  int get unreadCount =>
      _notifications.where((n) => !n.read).length;

  // ---------------------------------------------------------------------
  // Auth / profile
  // ---------------------------------------------------------------------

  void completeOnboarding() {
    onboardingSeen = true;
    PersistenceService.instance.saveOnboardingSeen(true);
    notifyListeners();
  }

  /// Signs the user in. When the email matches the last stored account the
  /// existing name/phone are kept, otherwise a profile is derived from the
  /// entered details.
  void login({String? name, String? email}) {
    isLoggedIn = true;
    final enteredEmail = email?.trim() ?? user.email;
    final enteredName = name?.trim();
    if (enteredName == null || enteredName.isEmpty) {
      user = user.copyWith(email: enteredEmail);
    } else {
      user = AppUser(
        name: enteredName,
        email: enteredEmail,
        phone: user.phone,
        bio: user.bio,
      );
    }
    PersistenceService.instance.saveAuth(isLoggedIn: true, user: user);
    notifyListeners();
  }

  void register({
    required String name,
    required String email,
    required String phone,
  }) {
    isLoggedIn = true;
    user = AppUser(
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
    );
    PersistenceService.instance.saveAuth(isLoggedIn: true, user: user);
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    PersistenceService.instance.saveAuth(isLoggedIn: false, user: user);
    notifyListeners();
  }

  void updateProfile({String? name, String? email, String? phone, String? bio}) {
    user = user.copyWith(name: name, email: email, phone: phone, bio: bio);
    PersistenceService.instance.saveAuth(isLoggedIn: isLoggedIn, user: user);
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // Cart
  // ---------------------------------------------------------------------

  void addToCart(Product product, {int quantity = 1, String? size, Color? color}) {
    final existingIndex = _cart.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.size == size &&
          item.color == color,
    );
    if (existingIndex >= 0) {
      _cart[existingIndex] = _cart[existingIndex].copyWith(
        quantity: _cart[existingIndex].quantity + quantity,
      );
    } else {
      _cart.add(
        CartItem(
          product: product,
          quantity: quantity,
          size: size ?? (product.sizes.isNotEmpty ? product.sizes.first : ''),
          color: color ?? (product.colors.isNotEmpty ? product.colors.first : Colors.black),
        ),
      );
    }
    PersistenceService.instance.saveCart(_cart);
    notifyListeners();
    _showSnack('Added to cart');
  }

  void updateQuantity(CartItem item, int quantity) {
    if (quantity <= 0) {
      _cart.removeWhere((i) => identical(i, item));
    } else {
      final index = _cart.indexOf(item);
      if (index >= 0) _cart[index] = item.copyWith(quantity: quantity);
    }
    PersistenceService.instance.saveCart(_cart);
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cart.removeWhere((i) => identical(i, item));
    PersistenceService.instance.saveCart(_cart);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    PersistenceService.instance.saveCart(_cart);
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // Wishlist
  // ---------------------------------------------------------------------

  bool isWishlisted(Product product) => _wishlist.contains(product.id);

  void toggleWishlist(Product product) {
    final added = _wishlist.add(product.id);
    if (!added) {
      _wishlist.remove(product.id);
    }
    PersistenceService.instance.saveWishlist(_wishlist);
    notifyListeners();
    _showSnack(added ? 'Added to wishlist' : 'Removed from wishlist');
  }

  List<Product> get wishlistProducts =>
      _products.where((p) => _wishlist.contains(p.id)).toList();

  // ---------------------------------------------------------------------
  // Orders
  // ---------------------------------------------------------------------

  Order placeOrder({required String paymentMethod, required Address address}) {
    final subtotal = cartSubtotal;
    final shipping = shippingCost;
    final order = Order(
      id: 'SH-${DateTime.now().year}-${_orders.length + 11}',
      items: List.of(_cart),
      subtotal: subtotal,
      shipping: shipping,
      tax: tax,
      total: subtotal + shipping + tax,
      status: OrderStatus.processing,
      paymentMethod: paymentMethod,
      address: address,
      placedAt: DateTime.now(),
    );
    _orders.insert(0, order);
    _cart.clear();
    PersistenceService.instance.saveCart(_cart);
    _notifications.insert(
      0,
      AppNotification(
        id: 'n-${_notifications.length + 1}',
        title: 'Order Confirmed',
        body:
            'Thank you! We received your order ${order.id} and are processing it.',
        time: DateTime.now(),
        icon: Icons.check_circle_rounded,
        type: NotificationType.order,
        action: 'View',
      ),
    );
    notifyListeners();
    return order;
  }

  // ---------------------------------------------------------------------
  // Addresses
  // ---------------------------------------------------------------------

  void addAddress(Address address) {
    _addresses.insert(0, address);
    if (address.isDefault) setDefaultAddress(address);
    notifyListeners();
  }

  void setDefaultAddress(Address address) {
    for (var i = 0; i < _addresses.length; i++) {
      _addresses[i] = _addresses[i].copyWith(
        isDefault: identical(_addresses[i], address),
      );
    }
    notifyListeners();
  }

  void removeAddress(Address address) {
    _addresses.removeWhere((a) => identical(a, address));
    if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
      _addresses[0] = _addresses[0].copyWith(isDefault: true);
    }
    notifyListeners();
  }

  Address? get defaultAddress =>
      _addresses.isEmpty ? null : _addresses.firstWhere(
            (a) => a.isDefault,
            orElse: () => _addresses.first,
          );

  // ---------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------

  void markAllRead() {
    _notifications = _notifications.map((n) => n.copyWith(read: true)).toList();
    notifyListeners();
  }

  void markRead(AppNotification notification) {
    final index = _notifications.indexOf(notification);
    if (index >= 0 && !_notifications[index].read) {
      _notifications[index] = _notifications[index].copyWith(read: true);
      notifyListeners();
    }
  }
}

/// Time formatting helper for notifications and orders.
String friendlyTime(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${time.day}/${time.month}/${time.year}';
}
