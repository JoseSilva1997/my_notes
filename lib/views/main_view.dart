
import 'package:flutter/material.dart';
import 'package:my_notes/widgets/page_title.dart';

class MainView extends StatefulWidget{
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();

}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  // Placeholder widgets for each page
  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Main Page')),
    Center(child: Text('My Notes')),
    Center(child: Text('To-Do List')),
  ];

  static const List<String> _titles = [
    'Hub',
    'My Notes',
    'To-Do',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    PageTitle pageTitle = PageTitle(_titles[_selectedIndex]);
    return Scaffold(
      appBar: AppBar(
        title: pageTitle,
        toolbarHeight: pageTitle.getHeight(),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'My Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'To-Do',
          ),
        ],
      ),
    );
  }
}

