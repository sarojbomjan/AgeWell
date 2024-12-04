import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreens extends StatefulWidget {
  OnBoardingScreens({super.key});

  @override
  State<OnBoardingScreens> createState() => _OnBoardingScreensState();
}

class _OnBoardingScreensState extends State<OnBoardingScreens> {
  final controller = LiquidController();

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
              liquidController: controller,
              onPageChangeCallback: onPageChangeCallback,
              slideIconWidget: Icon(Icons.arrow_back_ios),
              enableSideReveal: true,
              pages: [
                Container(
                  padding: const EdgeInsets.all(30),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image(
                        image: AssetImage("lib/images/elder.jpg"),
                        height: size.height * 0.5,
                      ),
                      Column(
                        children: [
                          Text(
                            "Welcome to Eldery Care",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Text("Take care of elder with ease"),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(30),
                  color: Color(0xfffddcdf),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image(
                        image: AssetImage("lib/images/elder.jpg"),
                        height: size.height * 0.5,
                      ),
                      Column(
                        children: [
                          Text(
                            "Welcome to Eldery Care",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Text("Take care of elder with ease"),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(30),
                  color: Color(0xffffdcbd),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image(
                        image: AssetImage("lib/images/elder.jpg"),
                        height: size.height * 0.5,
                      ),
                      Column(
                        children: [
                          Text(
                            "Welcome to Eldery Care",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Text("Take care of elder with ease"),
                        ],
                      ),
                    ],
                  ),
                )
              ]),
          Positioned(
              bottom: 60,
              child: OutlinedButton(
                onPressed: () {
                  int nextPage = controller.currentPage + 1;
                  controller.animateToPage(page: nextPage);
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.black26),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_forward_ios),
                ),
              )),

          //Skip Button
          Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                  onPressed: () => controller.jumpToPage(page: 2),
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.grey),
                  ))),

          Positioned(
            bottom: 10,
            child: AnimatedSmoothIndicator(
              activeIndex: controller.currentPage,
              count: 3,
              effect: const WormEffect(
                activeDotColor: Color(0xff272727),
                dotWidth: 5,
              ),
            ),
          )
        ],
      ),
    );
  }

  void onPageChangeCallback(int activePageIndex) {
    setState(() {
      currentPage = activePageIndex;
    });
  }
}
