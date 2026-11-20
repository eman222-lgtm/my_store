import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import 'detail_screen.dart';

final List<Product> bagsProducts = [
  Product(
    id: 201,
    title: 'شنطة يد نسائية فاخرة',
    price: 75.00,
    description: 'حقيبة يد أنيقة للسيدات مصنوعة من الجلد الطبيعي',
    image: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400',
    category: 'حقائب',
    rating: 4.4,
    ratingCount: 95,
  ),
  Product(
    id: 202,
    title: 'حقيبة ظهر كاجوال',
    price: 55.00,
    description: 'حقيبة ظهر عملية وأنيقة مناسبة للجامعة والعمل',
    image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
    category: 'حقائب',
    rating: 4.2,
    ratingCount: 110,
  ),
  Product(
    id: 203,
    title: 'حقيبة سفر كبيرة',
    price: 95.00,
    description: 'حقيبة سفر واسعة ومتينة مناسبة للرحلات الطويلة',
    image: 'https://images.unsplash.com/photo-1565026057447-bc90a3dceb87?w=400',
    category: 'حقائب',
    rating: 4.6,
    ratingCount: 75,
  ),
  Product(
    id: 204,
    title: 'حقيبة كروس بودي',
    price: 45.00,
    description: 'حقيبة صغيرة أنيقة مناسبة للاستخدام اليومي',
    image: 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=400',
    category: 'حقائب',
    rating: 4.3,
    ratingCount: 88,
  ),
  Product(
    id: 205,
    title: 'حقيبة توت باغ',
    price: 65.00,
    description: 'حقيبة توت واسعة مناسبة للتسوق والعمل',
    image: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400',
    category: 'حقائب',
    rating: 4.5,
    ratingCount: 120,
  ),
  Product(
    id: 206,
    title: 'حقيبة كلتش سهرة',
    price: 85.00,
    description: 'حقيبة سهرة أنيقة مناسبة للمناسبات الخاصة',
    image: 'https://images.unsplash.com/photo-1566150905458-1bf1fc113f0d?w=400',
    category: 'حقائب',
    rating: 4.7,
    ratingCount: 65,
  ),
];

final List<Product> shoesProducts = [
  Product(
    id: 301,
    title: 'حذاء رياضي نايك',
    price: 89.99,
    description: 'حذاء رياضي مريح وأنيق مناسب للجري والتمارين',
    image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
    category: 'أحذية',
    rating: 4.5,
    ratingCount: 120,
  ),
  Product(
    id: 302,
    title: 'حذاء كلاسيكي جلد',
    price: 120.00,
    description: 'حذاء جلد طبيعي أنيق مناسب للعمل والمناسبات',
    image: 'https://images.unsplash.com/photo-1533867617858-e7b97e060509?w=400',
    category: 'أحذية',
    rating: 4.3,
    ratingCount: 85,
  ),
  Product(
    id: 303,
    title: 'حذاء كونفرس',
    price: 65.00,
    description: 'حذاء كاجوال عصري مناسب للاستخدام اليومي',
    image: 'https://images.unsplash.com/photo-1607522370275-f6fd0288f6d6?w=400',
    category: 'أحذية',
    rating: 4.7,
    ratingCount: 200,
  ),
  Product(
    id: 304,
    title: 'حذاء رياضي أديداس',
    price: 95.00,
    description: 'حذاء رياضي خفيف ومريح للتمارين اليومية',
    image: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400',
    category: 'أحذية',
    rating: 4.6,
    ratingCount: 150,
  ),
  Product(
    id: 305,
    title: 'حذاء بوت شتوي',
    price: 110.00,
    description: 'حذاء بوت دافي مناسب للشتاء',
    image: 'https://images.unsplash.com/photo-1520639888713-7851133b1ed0?w=400',
    category: 'أحذية',
    rating: 4.4,
    ratingCount: 90,
  ),
  Product(
    id: 306,
    title: 'صندل صيفي',
    price: 45.00,
    description: 'صندل خفيف ومريح مناسب للصيف',
    image: 'https://images.unsplash.com/photo-1603487742131-4160ec999306?w=400',
    category: 'أحذية',
    rating: 4.2,
    ratingCount: 75,
  ),
];

class ProductListScreen extends StatefulWidget {
  final String categoryName;
  final String categoryApi;

  const ProductListScreen({
    super.key,
    required this.categoryName,
    required this.categoryApi,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  bool isLoading = true;
  String selectedFilter = 'الكل';
  String searchQuery = '';

  final List<String> filters = [
    'الكل',
    'الأقل سعراً',
    'الأعلى سعراً',
    'الأعلى تقييماً',
  ];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    if (widget.categoryApi == 'bags') {
      setState(() {
        products = bagsProducts;
        filteredProducts = bagsProducts;
        isLoading = false;
      });
      return;
    }

    if (widget.categoryApi == 'shoes') {
      setState(() {
        products = shoesProducts;
        filteredProducts = shoesProducts;
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          'https://fakestoreapi.com/products/category/${widget.categoryApi}',
        ),
      );
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        List<Product> fetchedProducts =
            data.map((e) => Product.fromJson(e)).toList();

        if (widget.categoryApi == 'jewelery') {
          fetchedProducts.addAll([
            Product(
              id: 401,
              title: 'قلادة ذهبية أنيقة',
              price: 85.00,
              description: 'قلادة ذهبية فاخرة مناسبة للمناسبات',
              image: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=400',
              category: 'إكسسوارات',
              rating: 4.6,
              ratingCount: 130,
            ),
            Product(
              id: 402,
              title: 'أسورة فضية',
              price: 45.00,
              description: 'أسورة فضية ناعمة للاستخدام اليومي',
              image: 'https://images.unsplash.com/photo-1611085583191-a3b181a88401?w=400',
              category: 'إكسسوارات',
              rating: 4.3,
              ratingCount: 95,
            ),
            Product(
              id: 403,
              title: 'خاتم ألماس',
              price: 250.00,
              description: 'خاتم فاخر مرصع بالألماس',
              image: 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=400',
              category: 'إكسسوارات',
              rating: 4.8,
              ratingCount: 200,
            ),
            Product(
              id: 404,
              title: 'حلق لؤلؤ',
              price: 65.00,
              description: 'حلق لؤلؤ طبيعي أنيق',
              image: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=400',
              category: 'إكسسوارات',
              rating: 4.5,
              ratingCount: 110,
            ),
            Product(
              id: 405,
              title: 'ساعة ذهبية فاخرة',
              price: 320.00,
              description: 'ساعة فاخرة بإطار ذهبي',
              image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
              category: 'إكسسوارات',
              rating: 4.9,
              ratingCount: 180,
            ),
          ]);
        }

        setState(() {
          products = fetchedProducts;
          filteredProducts = fetchedProducts;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      List<Product> temp = List.from(products);

      if (searchQuery.isNotEmpty) {
        temp = temp
            .where((p) =>
                p.title.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }

      if (filter == 'الأقل سعراً') {
        temp.sort((a, b) => a.price.compareTo(b.price));
      } else if (filter == 'الأعلى سعراً') {
        temp.sort((a, b) => b.price.compareTo(a.price));
      } else if (filter == 'الأعلى تقييماً') {
        temp.sort((a, b) => b.rating.compareTo(a.rating));
      }

      filteredProducts = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoriteProvider>();
    final cart = context.read<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6D3FC0)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Color(0xFF6D3FC0),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6D3FC0)),
            )
          : Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: TextField(
                    onChanged: (val) {
                      searchQuery = val;
                      applyFilter(selectedFilter);
                    },
                    decoration: InputDecoration(
                      hintText: 'ابحث في ${widget.categoryName}...',
                      hintStyle: const TextStyle(fontSize: 13),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF6D3FC0),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF7F9FC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      itemBuilder: (context, index) {
                        final filter = filters[index];
                        final isSelected = filter == selectedFilter;
                        return _FilterChip(
                          label: filter,
                          isSelected: isSelected,
                          onTap: () => applyFilter(filter),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        '${filteredProducts.length} منتج',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: filteredProducts.isEmpty
                      ? const Center(
                          child: Text(
                            'لا توجد نتائج 😕',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding:
                              const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            final isFav = favProvider.isFavorite(product);
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailScreen(product: product),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Hero(
                                            tag: 'product-${product.id}',
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade50,
                                                borderRadius:
                                                    const BorderRadius
                                                        .vertical(
                                                  top: Radius.circular(20),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Image.network(
                                                  product.image,
                                                  width: double.infinity,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: GestureDetector(
                                              onTap: () => favProvider
                                                  .toggleFavorite(product),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration:
                                                    const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  isFav
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: isFav
                                                      ? Colors.red
                                                      : Colors.grey,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Text(
                                                '\$ ${product.price.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  color: Color(0xFF6D3FC0),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 14,
                                                  ),
                                                  Text(
                                                    '${product.rating}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                cart.addToCart(product);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: const Text(
                                                        '✅ تمت الإضافة للسلة'),
                                                    backgroundColor:
                                                        const Color(0xFF6D3FC0),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    duration: const Duration(
                                                        seconds: 1),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFF6D3FC0),
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: const Text(
                                                'أضف للسلة',
                                                style:
                                                    TextStyle(fontSize: 11),
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
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

// ويدجت الفلتر مع انيميشن
class _FilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(
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
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color(0xFF6D3FC0)
                : const Color(0xFFF7F9FC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected
                  ? const Color(0xFF6D3FC0)
                  : Colors.grey.shade300,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF6D3FC0).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.isSelected
                  ? Colors.white
                  : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}