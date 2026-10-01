import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../theme/app_theme.dart';
import '../cart/cart_screen.dart';
import '../categories/categories_screen.dart';
import '../profile/profile_screen.dart';
import '../wishlist/wishlist_screen.dart';
import 'home_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final screens = [
      const HomeScreen(),
      const CategoriesScreen(),
      const WishlistScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Color(0x0F111111),
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: ListenableBuilder(
            listenable: state,
            builder: (context, _) {
              return BottomNavigationBar(
                currentIndex: _index,
                onTap: (i) => setState(() => _index = i),
                type: BottomNavigationBarType.fixed,
                backgroundColor: AppColors.surface,
                selectedItemColor: AppColors.accent,
                unselectedItemColor: AppColors.muted,
                selectedFontSize: 11,
                unselectedFontSize: 11,
                iconSize: 24,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.grid_view_outlined),
                    activeIcon: Icon(Icons.grid_view_rounded),
                    label: 'Categories',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border_rounded),
                    activeIcon: Icon(Icons.favorite_rounded),
                    label: 'Wishlist',
                  ),
                  BottomNavigationBarItem(
                    icon: Badge(
                      isLabelVisible: state.cartCount > 0,
                      label: Text('${state.cartCount}'),
                      child: const Icon(Icons.shopping_bag_outlined),
                    ),
                    activeIcon: Badge(
                      isLabelVisible: state.cartCount > 0,
                      label: Text('${state.cartCount}'),
                      child: const Icon(Icons.shopping_bag_rounded),
                    ),
                    label: 'Cart',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline_rounded),
                    activeIcon: Icon(Icons.person_rounded),
                    label: 'Profile',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}