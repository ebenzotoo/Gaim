import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

const List<String> _carouselImages = [
  'assets/a.jpg', 'assets/b.jpg', 'assets/c.jpg', 'assets/d.jpg',
  'assets/e.jpg', 'assets/f.jpg', 'assets/g.jpg', 'assets/h.jpg',
  'assets/i.jpg', 'assets/j.jpg', 'assets/l.jpg', 'assets/m.jpg',
  'assets/n.jpg', 'assets/o.jpg', 'assets/p.jpg', 'assets/q.jpg',
  'assets/r.jpg',
];

class CarouselSliderPage extends StatefulWidget {
  const CarouselSliderPage({super.key});

  @override
  State<CarouselSliderPage> createState() => _CarouselSliderPageState();
}

class _CarouselSliderPageState extends State<CarouselSliderPage> {
  late CarouselSliderController _carouselController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(body: _buildBannerSlider(size.height, size.width));
  }

  Widget _buildBannerSlider(double height, double width) {
    return Column(
      children: [
        SizedBox(
          height: height * .255,
          width: width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    viewportFraction: 0.8,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                  items: _carouselImages
                      .map((path) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: AssetImage(path),
                                  fit: BoxFit.cover),
                            ),
                          ))
                      .toList(),
                ),
              ),
              Positioned(
                bottom: 12,
                child: Row(
                  children: List.generate(
                    _carouselImages.length,
                    (index) {
                      final isSelected = _currentPage == index;
                      return GestureDetector(
                        onTap: () => _carouselController.animateToPage(index),
                        child: AnimatedContainer(
                          width: isSelected ? 55 : 17,
                          height: 10,
                          margin: EdgeInsets.symmetric(
                              horizontal: isSelected ? 6 : 3),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.black
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
