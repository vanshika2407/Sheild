import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../colors.dart';
import '../auth.dart/auth_screen.dart';
import 'widgets/onboarding_ui.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoardingPage> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  // Future controller() async {
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: PageView(
            onPageChanged: (index) {
              if (index == 3) {
                setState(() {
                  isLastPage = true;
                });
              } else {
                setState(() {
                  isLastPage = false;
                });
              }
            },
            controller: _controller,
            children: const [
              OnBoardingUi(
                title: "Welcome",
                description:
                    "ShiEld is all about women safety.This app is designed to ensure your safety, at all times. Stay positive with us",
                image: "assets/landingpage1.jpg",
              ),
              OnBoardingUi(
                title: "Emergency Alert",
                description:
                    "Emergency alert functionality can call and send SMS on saved contacts , if stuck in a panic situation",
                image: "assets/landingpage2.jpg",
              ),
              OnBoardingUi(
                title: "Spy Camera Feature",
                description:
                    "In cases of potential harassment, assault, or dangerous situations, discreetly capturing images or videos can serve as valuable evidence for law enforcement or legal proceedings.",
                image: "assets/landingpage3.jpg",
              ),
              OnBoardingUi(
                title: "Share Location",
                description:
                    "On emergency situation easily share your live location with our friends, family, and closed ones",
                image: "assets/landingpage4.jpg",
              ),
            ],
          ),
        ),
        bottomSheet: isLastPage
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: tabColor,
                  minimumSize: const Size(double.infinity, 60),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AuthScreen.routeName);
                },
                child: const Text(
                  "Get Started!",
                  style: TextStyle(fontSize: 20),
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                height: 160,
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () => _controller.animateToPage(
                        3,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                      ),
                      child: const Text(
                        "Skip Tour",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: tabColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _controller,
                        count: 4,
                        effect: const ExpandingDotsEffect(spacing: 10),
                        onDotClicked: (index) {
                          _controller.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
