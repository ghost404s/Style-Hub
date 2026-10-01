import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final List<String> _recent = [];
  String _query = '';
  List<Product> _results = const [];
  bool _searching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit(String query) async {
    FocusScope.of(context).unfocus();
    final q = query.trim();
    setState(() {
      _query = q;
      _searching = q.isNotEmpty;
      if (q.isNotEmpty && !_recent.contains(q)) {
        _recent.insert(0, q);
        if (_recent.length > 6) _recent.removeLast();
      }
    });
    if (q.isEmpty) return;
    final results = await AppState.instance.searchProducts(q);
    if (!mounted || _query != q) return;
    setState(() {
      _results = results;
      _searching = false;
    });
  }

  void _clear() {
    setState(() {
      _controller.clear();
      _query = '';
      _results = const [];
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          height: 44,
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: _submit,
            decoration: const InputDecoration(
              hintText: 'Search StyleHub…',
              border: InputBorder.none,
              isCollapsed: true,
              prefixIcon: Icon(Icons.search_rounded, size: 22),
            ),
          ),
        ),
      ),
      body: _searching
          ? const Center(child: CircularProgressIndicator())
          : _query.trim().isEmpty
              ? _buildIdle(context)
              : _buildResults(_results),
    );
  }

  Widget _buildIdle(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (_recent.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              TextButton(
                onPressed: () => setState(_recent.clear),
                child: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recent
                .map((r) => ActionChip(
                      avatar: const Icon(Icons.history_rounded, size: 18),
                      label: Text(r),
                      onPressed: () {
                        _controller.text = r;
                        _submit(r);
                      },
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
        ],
        const Text('Browse categories',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppState.instance.categories
              .take(10)
              .map((c) => ActionChip(
                    label: Text(c.name),
                    onPressed: () {
                      _controller.text = c.name;
                      _submit(c.name);
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildResults(List<Product> results) {
    if (results.isEmpty) {
      return EmptyState(
        icon: Icons.search_off_rounded,
        title: 'No results for “$_query”',
        message: 'Try a different spelling or browse our categories instead.',
        actionLabel: 'Clear search',
        onAction: _clear,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            '${results.length} results for “$_query”',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.62,
            ),
            itemCount: results.length,
            itemBuilder: (context, i) => ProductCard(product: results[i]),
          ),
        ),
      ],
    );
  }
}