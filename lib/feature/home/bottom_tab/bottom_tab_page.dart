import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_page.dart';
import '../wishlist/wishlist_page.dart';
import '../profile/view/profile_page.dart';
import 'bottom_tab_bloc.dart';
import 'bottom_tab_event.dart';
import 'bottom_tab_state.dart';

class BottomTabPage extends StatelessWidget {
  const BottomTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomTabBloc(),
      child: BlocBuilder<BottomTabBloc, BottomTabState>(
        builder: (context, state) {
          final List<Widget> pages = [
            const HomePage(),
            const WishlistPage(),
            const ProfilePage(),
          ];

          return Scaffold(
            body: pages[state.selectedIndex],
            bottomNavigationBar: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: state.selectedIndex,
                onTap: (index) {
                  context.read<BottomTabBloc>().add(TabChanged(index));
                },
                elevation: 0,
                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.deepPurple,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: false,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: "Wishlist",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Profile",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
