import 'dart:async';
import 'dart:convert';
import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/arabic_products.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/press_scale.dart';
import 'cart_screen.dart';
import 'detail_screen.dart';
import 'product_list_screen.dart';

class _BannerSlide {
  final String title;
  final String subtitle;
  final String button;
  final List<Color> colors;
  final List<IconData> icons;
  final String? categoryName;
  final String? categoryApi;

  const _BannerSlide({
    required this.title,
    required this.subtitle,
    required this.button,
    required this.colors,
    required this.icons,
    this.categoryName,
    this.categoryApi,
  });
}

const List<_BannerSlide> _slides = [
  _BannerSlide(
    title: 'كل شي بمكان واحد',
    subtitle: 'من الأزياء للإلكترونيات',
    button: 'ابدأ التسوق',
    colors: [Color(0xFF6D3FC0), Color(0xFF9F7AEA)],
    icons: [
      Icons.checkroom,
      Icons.devices_other,
      Icons.watch_outlined,
      Icons.shopping_bag_outlined,
    ],
  ),
  _BannerSlide(
    title: 'تقنية بأسعار مناسبة',
    subtitle: 'أجهزة وملحقات مختارة',
    button: 'تصفّح الآن',
    colors: [Color(0xFF4C2A85), Color(0xFF7B5CD6)],
    icons: [
      Icons.laptop_mac,
      Icons.headphones_outlined,
      Icons.smartphone,
      Icons.camera_alt_outlined,
    ],
    categoryName: 'إلكترونيات',
    categoryApi: 'electronics',
  ),
  _BannerSlide(
    title: 'لمسة تكمّل إطلالتك',
    subtitle: 'إكسسوارات أنيقة بتفاصيل مميزة',
    button: 'شوف التشكيلة',
    colors: [Color(0xFF5E5A78), Color(0xFFA09CBD)],
    icons: [
      Icons.watch_outlined,
      Icons.auto_awesome,
      Icons.star_outline,
      Icons.favorite_border,
    ],
    categoryName: 'إكسسوارات',
    categoryApi: 'jewelery',
  ),
];

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
  final GlobalKey _productsKey = GlobalKey();

  final PageController _bannerController = PageController();
  Timer? _bannerTimer;
  int _bannerIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'رجالي',
      'api': "men's clothing",
      'image': 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=200',
      'color': const Color(0xFF6D3FC0),
    },
    {
      'name': 'نسائي',
      'api': "women's clothing",
      'image': 'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=200',
      'color': const Color(0xFFB45FD6),
    },
    {
      'name': 'إكسسوارات',
      'api': "jewelery",
      'image': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=200',
      'color': const Color(0xFF9F7AEA),
    },
    {
      'name': 'إلكترونيات',
      'api': "electronics",
      'image': 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=200',
      'color': const Color(0xFF5B6CE0),
    },
    {
      'name': 'أحذية',
      'api': "shoes",
      'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200',
      'color': const Color(0xFF7E6BA8),
    },
    {
      'name': 'حقائب',
      'api': "bags",
      'image': 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=200',
      'color': const Color(0xFF4C2A85),
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _bannerTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) => _nextBanner(),
    );
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _nextBanner() {
    if (!_bannerController.hasClients) return;
    final next = (_bannerIndex + 1) % _slides.length;
    _bannerController.animateToPage(
      next,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
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

      if (!mounted) return;
      setState(() {
        products = allProducts;
        filteredProducts = allProducts;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
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

  void _scrollToProducts() {
    final ctx = _productsKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToCategory(String name, String api) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => ProductListScreen(
          categoryName: name,
          categoryApi: api,
        ),
        transitionsBuilder: (_, animation, __, child) {
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
  }

  void _onSlideButton(_BannerSlide slide) {
    if (slide.categoryApi == null) {
      _scrollToProducts();
    } else {
      _goToCategory(slide.categoryName ?? '', slide.categoryApi!);
    }
  }

  Widget _bannerIcon(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }

  Widget _buildSlide(_BannerSlide slide) {
    return GestureDetector(
      onTap: _nextBanner,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: slide.colors,
          ),
        ),
        child: Stack(
          children: [
            PositionedDirectional(
              top: -40,
              start: -40,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.10),
                ),
              ),
            ),
            PositionedDirectional(
              bottom: -50,
              end: 90,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 2,
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              end: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: SizedBox(
                  width: 110,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: slide.icons.map(_bannerIcon).toList(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 20,
                top: 20,
                bottom: 20,
                end: 140,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    slide.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    slide.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  PressScale(
                    onTap: () => _onSlideButton(slide),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        slide.button,
                        style: const TextStyle(
                          color: Color(0xFF6D3FC0),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(bool isDark) {
    const primary = Color(0xFF6D3FC0);
    const accent = Color(0xFFB794F4);
    const silver = Color(0xFFC7CAD1);

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: PageView.builder(
              controller: _bannerController,
              itemCount: _slides.length,
              onPageChanged: (i) => setState(() => _bannerIndex = i),
              itemBuilder: (_, i) => _buildSlide(_slides[i]),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (i) {
            final active = i == _bannerIndex;
            return GestureDetector(
              onTap: () => _bannerController.animateToPage(
                i,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? (isDark ? accent : primary) : silver,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primary = Color(0xFF6D3FC0);
    const accent = Color(0xFFB794F4);
    const silver = Color(0xFFC7CAD1);
    const ink = Color(0xFF3B2475);
    final cardColor = Theme.of(context).cardColor;
    final headingColor = isDark ? Colors.white : ink;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: isDark ? accent : primary,
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
                                'يا هلا فيكم',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'سوقنا',
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
                              PressScale(
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
                                    borderRadius: BorderRadius.circular(14),
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
                            hintText: 'شو بتدوّر عليه؟',
                            hintStyle: const TextStyle(fontSize: 13),
                            prefixIcon: Icon(
                              Icons.search,
                              color: headingColor,
                            ),
                            filled: true,
                            fillColor: cardColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                color: silver.withOpacity(0.6),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                color: silver.withOpacity(0.6),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: accent,
                                width: 1.5,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                          ),
                        ),
                      ),
                      _buildBanner(isDark),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'تصفّح الأقسام',
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
                              onTap: () => _goToCategory(
                                cat['name'] as String,
                                cat['api'] as String,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        key: _productsKey,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'وصل حديثاً',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: headingColor,
                          ),
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
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
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