import 'package:chats/service/provider/app_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../helper/colors.dart';
import '../widgets/welcome_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'auth_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key? key}) : super(key: key);
  static const String route = "/welcome_chats_screen";
  final List<WelcomeWidget> _pageViewItem = const [
    WelcomeWidget(
      image:
          "https://cdn-icons-png.flaticon.com/512/326/326033.png?w=740&t=st=1673011670~exp=1673012270~hmac=c4415e380a24f6c0ce83cae0689292d613d82f739da3f6fdde5ae65fd699104e",
      title: "Welcome to Chat Plus",
      body:
          "There are many variations of passages of Lorem Ipsum available\nbut the majority",
    ),
    WelcomeWidget(
      image:
          "https://img.freepik.com/free-vector/contact-us-flat-girl-background_23-2148182335.jpg?w=740&t=st=1673012752~exp=1673013352~hmac=bf3eb82c8793455b2cf74acf13105a9952b8f1f854561b81b18ca253b3654e35",
      title: "Free Chats",
      body:
          "The cites of the word in classical literature, discovered the undoubted source",
    ),
    WelcomeWidget(
      image:
          "https://img.freepik.com/free-vector/video-conferencing-concept-landing-page_52683-20933.jpg?w=740&t=st=1673012673~exp=1673013273~hmac=10d29254dbb6c713fb0128ea4f14572dae4ce6e06bf8f94cbe6b54eee69a6ecc",
      title: "Be happy for Chat Plus",
      body:
          "The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested",
    ),
  ];
  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 35),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) {
                  return _pageViewItem[index];
                },
                itemCount: _pageViewItem.length,
                controller: _pageController,
                pageSnapping: true,
                physics: const BouncingScrollPhysics(),
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: _pageViewItem.length,
              effect: const ExpandingDotsEffect(
                dotColor: Colors.grey,
                activeDotColor: tabColor,
                dotHeight: 10,
                dotWidth: 10,
                expansionFactor: 4,
                spacing: 5,
              ),
            ),
            SizedBox(height: 12.h),
            Consumer<AppProvider>(
              builder: (context, provider, child) {
                return ElevatedButton(
                  onPressed: () {
                    //provider.endPageView(context);
                    /*Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return const HomeScreen();
                        },
                      ),
                    );*/
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return const AuthScreen();
                        },
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor:
                        MaterialStateProperty.all(tabColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    side: MaterialStateProperty.all(
                      const BorderSide(
                        color: tabColor,
                      ),
                    ),
                  ),
                  child: const Text("Start Chats"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
