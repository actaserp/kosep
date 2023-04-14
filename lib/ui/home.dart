// import 'package:actkosep/ui/account/tab_account.dart';
// import 'package:actkosep/ui/shopping_cart/tab_shopping_cart.dart';
// import 'package:actkosep/ui/wishlist/tab_wishlist.dart';
import 'package:flutter/material.dart';
import 'package:actkosep/config/constant.dart';
import 'package:actkosep/ui/home/tab_home.dart';
import 'package:actkosep/ui/account/tab_account.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  int _selectedIndex = 0;
  // Pages if you click bottom navigation
  final List<Widget> _contentPages = <Widget>[
    TabHomePage(),
  ];

  @override
  void initState() {
    // set initial pages for navigation to home page
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(_handleTabSelection );
    super.initState();
  }

  void _handleTabSelection() {
    setState(() {
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _contentPages.map((Widget content) {
          return content;
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (value) {
          _currentIndex = value;
          _pageController.jumpToPage(value);
          debugPrint('${_contentPages}');
          debugPrint('${_contentPages[_selectedIndex]}');
          // this unfocus is to prevent show keyboard in the wishlist page when focus on search text field
          FocusScope.of(context).unfocus();
        },
        selectedFontSize: 8,
        unselectedFontSize: 8,
        iconSize: 28,
        selectedLabelStyle: TextStyle(color: _currentIndex == 1 ? ASSENT_COLOR : PRIMARY_COLOR, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(color: CHARCOAL, fontWeight: FontWeight.bold),
        selectedItemColor: _currentIndex == 1 ? ASSENT_COLOR : PRIMARY_COLOR,
        unselectedItemColor: CHARCOAL,
        items: [
          BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0 ? PRIMARY_COLOR : CHARCOAL
              )
          ),
          BottomNavigationBarItem(
              label: '출고등록',
              icon: Icon(
                  Icons.favorite,
                  color: _currentIndex == 1 ? ASSENT_COLOR : CHARCOAL
              )
          ),
          BottomNavigationBarItem(
              label: '출고현황',
              icon: Icon(
                  Icons.perm_contact_cal,
                  color: _currentIndex == 2 ? PRIMARY_COLOR : CHARCOAL
              )
          ),
          BottomNavigationBarItem(
              label: 'Account',
              icon: Icon(
                  Icons.person_outline,
                  color: _currentIndex == 3 ? PRIMARY_COLOR : CHARCOAL
              )
          ),
        ],
      ),
    );
  }
}
