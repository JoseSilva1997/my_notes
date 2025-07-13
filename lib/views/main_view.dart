
import 'package:flutter/material.dart';
import 'package:my_notes/widgets/page_title.dart';

class MainView extends StatefulWidget{
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();

}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    const pageTitle = PageTitle('Notes hub');
    return Scaffold(
      appBar: AppBar(
        title: pageTitle,
        toolbarHeight: pageTitle.getHeight(),
      ),
    );
  }
}

