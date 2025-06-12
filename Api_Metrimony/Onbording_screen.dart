import 'package:demo2/Api_Metrimony/Login_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to SoulMate',
      description: 'Your personal space for memories and connections',
      image: 'assets/img_3.png',
    ),
    OnboardingPage(
      title: 'Connect with Others',
      description: 'Build meaningful relationships and share experiences',
      image: 'assets/img_7.png',
    ),
    OnboardingPage(
      title: 'Start Your Journey',
      description: 'Join our community and begin your adventure',
      image: 'assets/img_6.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to login screen
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    }
  }

  void _onSkipPressed() {
    // Navigate to login screen
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return OnboardingPageWidget(page: _pages[index]);
            },
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                        (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 10,
                      width: _currentPage == index ? 30 : 10,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.deepPurple.shade200
                            : Colors.deepPurple.shade100,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _onSkipPressed,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.deepPurple.shade200,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _onNextPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade200,
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String image;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            page.image,
            height: 300,
            width: 300,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 50),
          Text(
            page.title,
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Saira',
              fontWeight: FontWeight.w600, // Changed from semiBold
              color: Color(0xFF0C0C0C),
            ),
          ),
          SizedBox(height: 20),
          Text(
            page.description,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Saira',
              fontWeight: FontWeight.w400, // Changed from regular
              color: Color(0xFF0C0C0C),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  OnboardingScreen(),
    );
  }
}
































// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'Api_Metrimony/Login_screen.dart';
// import 'Api_Metrimony/Api_bottemnavigationbar.dart';
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({Key? key}) : super(key: key);
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus(); // Check if user is already logged in
//   }
//
//   Future<void> _checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final bool? isLoggedIn = prefs.getBool('isLoggedIn');
//
//     if (isLoggedIn == true) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => ApiBottemnavigationbar()), // Go to Home
//       );
//     }
//   }
//
//   Future<void> _completeOnboarding() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isOnboardingCompleted', true);
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginScreen()), // Go to Login
//     );
//   }
//
//   void _onNextPressed() {
//     if (_currentPage < 2) {
//       _pageController.nextPage(
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       _completeOnboarding();
//     }
//   }
//
//   void _onSkipPressed() {
//     _completeOnboarding();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           PageView(
//             controller: _pageController,
//             onPageChanged: (index) {
//               setState(() {
//                 _currentPage = index;
//               });
//             },
//             children: [
//               OnboardingPage(
//                 title: "Welcome to Fvowrever",
//                 description: "Your personal space for memories and connections",
//                 image: "assets/img_3.png",
//               ),
//               OnboardingPage(
//                 title: "Connect with Others",
//                 description: "Build meaningful relationships and share experiences",
//                 image: "assets/img_7.png",
//               ),
//               OnboardingPage(
//                 title: "Start Your Journey",
//                 description: "Join our community and begin your adventure",
//                 image: "assets/img_6.png",
//               ),
//             ],
//           ),
//           Positioned(
//             bottom: 60,
//             left: 0,
//             right: 0,
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(
//                     3,
//                         (index) => AnimatedContainer(
//                       duration: Duration(milliseconds: 300),
//                       margin: EdgeInsets.symmetric(horizontal: 5),
//                       height: 10,
//                       width: _currentPage == index ? 30 : 10,
//                       decoration: BoxDecoration(
//                         color: _currentPage == index ? Colors.pink : Colors.pink.shade100,
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       TextButton(
//                         onPressed: _onSkipPressed,
//                         child: Text(
//                           "Skip",
//                           style: TextStyle(color: Colors.pink, fontSize: 16),
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: _onNextPressed,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.pink,
//                           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                         ),
//                         child: Text(
//                           _currentPage == 2 ? "Get Started" : "Next",
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class OnboardingPage extends StatelessWidget {
//   final String title;
//   final String description;
//   final String image;
//
//   const OnboardingPage({Key? key, required this.title, required this.description, required this.image})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset(image, height: 300, width: 300, fit: BoxFit.contain),
//         SizedBox(height: 50),
//         Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
//         SizedBox(height: 20),
//         Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
//       ],
//     );
//   }
// }
//
