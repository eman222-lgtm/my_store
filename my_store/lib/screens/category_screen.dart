import 'package:flutter/material.dart';
import 'product_list_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'ملابس رجالية',
      'api': "men's clothing",
      'image':
          'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=400',
      'color': const Color(0xFF6D3FC0),
    },
    {
      'name': 'ملابس نسائية',
      'api': "women's clothing",
      'image':
          'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=400',
      'color': const Color(0xFFE8D5C4),
    },
    {
      'name': 'إكسسوارات',
      'api': "jewelery",
      'image':
          'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400',
      'color': const Color(0xFFB794F4),
    },
    {
      'name': 'إلكترونيات',
      'api': "electronics",
      'image':
          'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=400',
      'color': const Color(0xFF2C3E50),
    },
    {
      'name': 'حقائب',
      'api': "men's clothing",
      'image':
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400',
      'color': const Color(0xFF795548),
    },
    {
      'name': 'أحذية',
      'api': "women's clothing",
      'image':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
      'color': const Color(0xFF37474F),
    },
  ];

  // الفئة التي يوجد عليها السهم حاليًا
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'الفئات',
          style: TextStyle(
            color: Color(0xFF6D3FC0),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Color(0xFF6D3FC0),
            ),
            onPressed: () {},
          ),
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,

        itemBuilder: (context, index) {
          final cat = categories[index];

          final bool isHovered = hoveredIndex == index;

          return MouseRegion(
            cursor: SystemMouseCursors.click,

            // عندما يدخل السهم على الفئة
            onEnter: (_) {
              setState(() {
                hoveredIndex = index;
              });
            },

            // عندما يخرج السهم من الفئة
            onExit: (_) {
              setState(() {
                hoveredIndex = null;
              });
            },

            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductListScreen(
                      categoryName: cat['name'],
                      categoryApi: cat['api'],
                    ),
                  ),
                );
              },

              child: AnimatedScale(
                // تكبير الفئة عند وضع السهم عليها
                scale: isHovered ? 1.03 : 1.0,

                // سرعة التكبير والتصغير
                duration: const Duration(milliseconds: 180),

                curve: Curves.easeOut,

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),

                  curve: Curves.easeOut,

                  margin: const EdgeInsets.only(bottom: 16),

                  height: 120,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),

                    // ظل يظهر عند وضع السهم
                    boxShadow: isHovered
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 12,
                              spreadRadius: 1,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : [],

                    image: DecorationImage(
                      image: NetworkImage(cat['image']),
                      fit: BoxFit.cover,
                    ),
                  ),

                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
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
                        Text(
                          cat['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          'عرض الكل ←',
                          style: TextStyle(
                            color: Color(0xFFB794F4),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

