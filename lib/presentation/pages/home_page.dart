import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/injection_container.dart' as di;
import '../bloc/restaurant/restaurant_bloc.dart';
import '../../domain/entities/restaurant.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/promo_banner_widget.dart';
import '../widgets/category_section_widget.dart';
import '../widgets/popular_dishes_widget.dart';
import '../widgets/deals_section_widget.dart';
import '../widgets/recommended_section_widget.dart';
import '../widgets/restaurant_section_widget.dart';
import '../widgets/floating_cart_button.dart';
import 'restaurant_list_page.dart';
import 'order_history_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OrderHistoryPage()),
        );
        break;
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Favorites page coming soon!')),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => di.sl<RestaurantBloc>()..add(FetchRestaurants()),
        child: const HomeView(),
      ),
      floatingActionButton: const FloatingCartButton(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeHeaderWidget(),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<RestaurantBloc>().add(FetchRestaurants());
        },
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              PromoBannerWidget(),
              SizedBox(height: 8),
              CategorySectionWidget(),
              SizedBox(height: 24),
              PopularDishesWidget(),
              SizedBox(height: 24),
              DealsSectionWidget(),
              SizedBox(height: 24),
              RecommendedSectionWidget(),
              SizedBox(height: 24),
              RestaurantSectionWidget(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButton: const FloatingCartButton(),
    );
  }
}
