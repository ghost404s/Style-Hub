import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models.dart';

/// Persists lightweight app state (auth, theme, cart and wishlist) across
/// launches using `shared_preferences`.
class PersistenceService {
  PersistenceService._();
  static final PersistenceService instance = PersistenceService._();

  static const _kLoggedIn = 'auth.loggedIn';
  static const _kName = 'auth.name';
  static const _kEmail = 'auth.email';
  static const _kPhone = 'auth.phone';
  static const _kBio = 'auth.bio';
  static const _kOnboardingSeen = 'auth.onboardingSeen';
  static const _kDarkMode = 'theme.darkMode';
  static const _kCart = 'cart.items';
  static const _kWishlist = 'wishlist.ids';

  Future<void> saveAuth({
    required bool isLoggedIn,
    required AppUser user,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, isLoggedIn);
    await prefs.setString(_kName, user.name);
    await prefs.setString(_kEmail, user.email);
    await prefs.setString(_kPhone, user.phone);
    await prefs.setString(_kBio, user.bio);
  }

  Future<({bool isLoggedIn, AppUser user})> loadAuth() async {
    final prefs = await SharedPreferences.getInstance();
    return (
      isLoggedIn: prefs.getBool(_kLoggedIn) ?? false,
      user: AppUser(
        name: prefs.getString(_kName) ?? '',
        email: prefs.getString(_kEmail) ?? '',
        phone: prefs.getString(_kPhone) ?? '',
        bio: prefs.getString(_kBio) ?? '',
      ),
    );
  }

  Future<void> saveOnboardingSeen(bool seen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingSeen, seen);
  }

  Future<bool> loadOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kOnboardingSeen) ?? false;
  }

  Future<void> saveDarkMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDarkMode, enabled);
  }

  Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kDarkMode) ?? false;
  }

  Future<void> saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kCart,
      jsonEncode(items.map((i) => i.toJson()).toList()),
    );
  }

  Future<List<CartItem>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kCart);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> saveWishlist(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kWishlist, jsonEncode(ids.toList()));
  }

  Future<Set<String>> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kWishlist);
    if (raw == null || raw.isEmpty) return <String>{};
    try {
      return (jsonDecode(raw) as List).cast<String>().toSet();
    } catch (_) {
      return <String>{};
    }
  }
}
