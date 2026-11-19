import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/arabic_products.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'detail_screen.dart';
import 'product_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'رجالي',
      'api': "men's clothing",
      'image': 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=200',
      'color': const Color(0xFF1B4332),
    },
    {
      'name': 'نسائي',
      'api': "women's clothing",
      'image': 'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=200',
      'color': const Color(0xFFE91E8C),
    },
    {
      'name': 'إكسسوارات',
      'api': "jewelery",
      'image': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=200',
      'color': const Color(0xFFC9A96E),
    },
    {
      'name': 'إلكترونيات',
      'api': "electronics",
      'image': 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=200',
      'color': const Color(0xFF2196F3),
    },
    {
      'name': 'أحذية',
      'api': "shoes",
      'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200',
      'color': const Color(0xFF795548),
    },
    {
      'name': 'حقائب',
      'api': "bags",
      'image': 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=200',
      'color': const Color(0xFF5D4037),
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    try {
      final List<String> apis = [
        "men's clothing",
        "women's clothing",
        "jewelery",
        "electronics",
      ];

      List<Product> allProducts = [];

      for (String api in apis) {
        final response = await http.get(
          Uri.parse(
            'https://fakestoreapi.com/products/category/$api',
          ),
        );
        if (response.statusCode == 200) {
          final List data = json.decode(response.body);
          allProducts.addAll(
            data.map((e) => toArabic(Product.fromJson(e))).toList(),
          );
        }
      }

      allProducts.addAll([
        Product(
          id: 201,
          title: 'شنطة يد نسائية فاخرة',
          price: 75.00,
          description: 'حقيبة يد أنيقة للسيدات',
          image: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400',
          category: 'حقائب',
          rating: 4.4,
          ratingCount: 95,
        ),
        Product(
          id: 202,
          title: 'حقيبة ظهر كاجوال',
          price: 55.00,
          description: 'حقيبة ظهر عملية وأنيقة',
          image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
          category: 'حقائب',
          rating: 4.2,
          ratingCount: 110,
        ),
        Product(
          id: 301,
          title: 'حذاء رياضي نايك',
          price: 89.99,
          description: 'حذاء رياضي مريح وأنيق',
          image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
          category: 'أحذية',
          rating: 4.5,
          ratingCount: 120,
        ),
        Product(
          id: 302,
          title: 'حذاء كلاسيكي جلد',
          price: 120.00,
          description: 'حذاء جلد طبيعي أنيق',
          image: 'https://images.unsplash.com/photo-1533867617858-e7b97e060509?w=400',
          category: 'أحذية',
          rating: 4.3,
          ratingCount: 85,
        ),
      ]);

      setState(() {
        products = allProducts;
        filteredProducts = allProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products.where((p) {
        return p.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primary = Color(0xFF1B4332);
    const gold = Color(0xFFC9A96E);
    final cardColor = Theme.of(context).cardColor;
    final headingColor = isDark ? Colors.white : primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: isDark ? gold : primary,
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  floating: true,
                  backgroundColor: cardColor,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: cardColor,
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'مرحباً 👋',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'My Store 🛍️',
                                style: TextStyle(
                                  color: headingColor,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CartScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                              if (cart.itemCount > 0)
                                PositionedDirectional(
                                  end: 0,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${cart.itemCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: _searchController,
                          onChanged: filterProducts,
                          decoration: InputDecoration(
                            hintText: 'ابحث عن منتج...',
                            hintStyle: const TextStyle(fontSize: 13),
                            prefixIcon: Icon(
                              Icons.search,
                              color: headingColor,
                            ),
                            filled: true,
                            fillColor: cardColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=800',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                begin: AlignmentDirectional.centerStart,
                                end: AlignmentDirectional.centerEnd,
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'مجموعة الرجال',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'أناقة تناسب كل لحظة',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ProductListScreen(
                                          categoryName: 'ملابس رجالية',
                                          categoryApi: "men's clothing",
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: gold,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'تسوق الآن',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'الفئات',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: headingColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 110,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            return _CategoryItem(
                              cat: cat,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, animation, __) =>
                                        ProductListScreen(
                                      categoryName: cat['name'],
                                      categoryApi: cat['api'],
                                    ),
                                    transitionsBuilder:
                                        (_, animation, __, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero,
                                        ).animate(CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeInOut,
                                        )),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'أحدث المنتجات',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: headingColor,
                              ),
                            ),
                            const Text(
                              'عرض الكل',
                              style: TextStyle(
                                fontSize: 14,
                                color: gold,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ProductCard(
                          product: filteredProducts[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(
                                  product: filteredProducts[index],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: filteredProducts.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),
              ],
            ),
    );
  }
}

class _CategoryItem extends StatefulWidget {
  final Map<String, dynamic> cat;
  final VoidCallback onTap;

  const _CategoryItem({required this.cat, required this.onTap});

  @override
  State<_CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<_CategoryItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: () {
          _controller.forward(from: 0).then((_) {
            _controller.reverse();
            widget.onTap();
          });
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsetsDirectional.only(end: 16),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: (widget.cat['color'] as Color).withOpacity(
                        _isHovered ? 0.8 : 0.3,
                      ),
                      width: _isHovered ? 2.5 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.cat['color'] as Color).withOpacity(
                          _isHovered ? 0.5 : 0.2,
                        ),
                        blurRadius: _isHovered ? 15 : 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(widget.cat['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          (widget.cat['color'] as Color).withOpacity(
                            _isHovered ? 0.6 : 0.3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.cat['name'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white70
                        : widget.cat['color'] as Color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}