import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/product_card.dart';
import '../search/search_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key, required this.category});
  final Category category;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  String _sort = 'Featured';

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        var products = state.products
            .where((p) => widget.category.id == 'all' ||
                p.categoryId == widget.category.id)
            .toList();

        switch (_sort) {
          case 'Price: Low to High':
            products.sort((a, b) => a.price.compareTo(b.price));
            break;
          case 'Price: High to Low':
            products.sort((a, b) => b.price.compareTo(a.price));
            break;
          case 'Newest':
            products.sort(
                (a, b) => (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0));
            break;
          case 'Top Rated':
            products.sort((a, b) => b.rating.compareTo(a.rating));
            break;
          default:
            break;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.category.name),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                ),
                icon: const Icon(Icons.search_rounded),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    Text(
                      '${products.length} products',
                      style:
                          TextStyle(color: AppColors.muted, fontSize: 13),
                    ),
                    const Spacer(),
                    _SortButton(
                      current: _sort,
                      onChanged: (v) => setState(() => _sort = v),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: products.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'Nothing here yet',
                        message:
                            'Check back soon for new styles in this category.',
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.62,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, i) =>
                            ProductCard(product: products[i]),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({required this.current, required this.onChanged});
  final String current;
  final ValueChanged<String> onChanged;

  static const _options = [
    'Featured',
    'Newest',
    'Price: Low to High',
    'Price: High to Low',
    'Top Rated',
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Sort by',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
              ..._options.map((option) => ListTile(
                    title: Text(option),
                    trailing: option == current
                        ? const Icon(Icons.check_rounded, color: AppColors.accent)
                        : null,
                    onTap: () {
                      onChanged(option);
                      Navigator.of(context).pop();
                    },
                  )),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_vert_rounded,
                size: 18, color: AppColors.inkSoft),
            const SizedBox(width: 6),
            Text(
              current,
              style: TextStyle(
                color: AppColors.inkSoft,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}