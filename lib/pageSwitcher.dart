import 'package:flutter/material.dart';

/*
Page2(
        title1: 'Profile',
        title2: 'New Project',
        appBarTitle: 'SIT',
        page1: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.green,
              ),
            ),
          ],
        ),
        page2: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),


HOW TO USE: 
title is for appbar title/title of page
title1 is for the string for the chip that navigates to first page
title2 is for the string for the chip that navigates to second page
page1 is the first page
page2 is the second page

Do not place an expanded as the outer most widget, it will throw incorrect use of parent data widget
use this instead -> to make it work
Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.red,
              ),
            ),
          ],
        ),

this works as well
Column(
          children: [
            Container(
              color: Colors.red,
            ),
          ],
        ),

but this does not

Expanded(
          child: Container(
            color: Colors.red,
          ),
        ),

*/

class Page2 extends StatefulWidget {
  final String title1;
  final String title2;
  final String appBarTitle;
  final Widget page1;
  final Widget page2;

  const Page2(
      {super.key,
      required this.title1,
      required this.title2,
      required this.appBarTitle,
      required this.page1,
      required this.page2});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  bool isCalView = true;
  PageController pageController = PageController(initialPage: 0);

  void changePage(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 400), curve: Curves.easeOutQuad);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.appBarTitle,
            style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(top: 0),
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InputChip(
                      // labelPadding: EdgeInsets.all(5.0),
                      onPressed: () {
                        setState(() {
                          isCalView = true;
                          changePage(0);
                        });
                      },
                      label: Text(widget.title1,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.white)),
                      backgroundColor: Colors.grey,
                      selectedColor: Colors.black,
                      checkmarkColor: Colors.white,
                      shape: const StadiumBorder(side: BorderSide.none),
                      selected: isCalView,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  InputChip(
                    // labelPadding: EdgeInsets.all(5.0),
                    onPressed: () {
                      setState(() {
                        isCalView = false;
                        changePage(1);
                      });
                    },
                    label: Text(widget.title2,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.white)),
                    backgroundColor: Colors.grey,
                    selectedColor: Colors.black,
                    checkmarkColor: Colors.white,
                    shape: const StadiumBorder(side: BorderSide.none),
                    selected: !isCalView,
                  ),
                ],
              ),
            ),
            Expanded(
                child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                  widget.page1,
                  widget.page2,
                ]))
          ],
        ),
      ),
    );
  }
}
