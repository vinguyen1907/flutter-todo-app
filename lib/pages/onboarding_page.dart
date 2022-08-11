import 'package:flutter/material.dart';
import 'package:todo_app/pages/home_page.dart';
import 'package:todo_app/ui/app_colors.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int _currentPageIndex = 0;
  PageController _pageController = PageController();

  List<Page> pages = [
    Page(
      detail: "Welcome to ToDo App",
      subDetail: "This is a simple ToDo App",
      imageAsset: "assets/images/onboarding_1.png",
    ),
    Page(
      detail: "Add your tasks",
      subDetail: "Add your tasks and mark them as done",
      imageAsset: "assets/images/onboarding_2.png",
    ),
    Page(
      detail: "See your tasks",
      subDetail: "See your tasks and mark them as done",
      imageAsset: "assets/images/onboarding_3.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: InkWell(
                child: Container(
                    color: Colors.white,
                    child: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.black))),
            actions: [
              InkWell(
                  onTap: () {
                    setState(() {
                      _currentPageIndex = pages.length - 1;
                      _pageController.jumpToPage(_currentPageIndex);
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Text("Skip",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ))))
            ]),
        body: Column(children: [
          Expanded(
            flex: 5,
            child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return pageViewItem(pages[index]);
                }),
          ),
          Expanded(
            flex: 1,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ...List.generate(pages.length, (index) => dotIndicator(index))
            ]),
          ),
          _currentPageIndex == pages.length - 1
              ? longButton(
                  title: "Done",
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return HomePage();
                    }));
                  })
              : longButton(
                  title: "Next",
                  onTap: () {
                    _pageController.nextPage(
                        curve: Curves.ease,
                        duration: const Duration(milliseconds: 500));
                  })
        ]));
  }

  Widget longButton({required String title, required Function onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0, right: 20, left: 20),
      child: InkWell(
          onTap: () => onTap(),
          child: Container(
              height: 50,
              // width: size.width * 0.9,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: Text(title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  )))),
    );
  }

  Widget dotIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: index == _currentPageIndex ? Colors.black : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget pageViewItem(Page page) {
    return Column(children: [
      Image.asset(
        page.imageAsset,
        width: 400,
        height: 400,
        fit: BoxFit.cover,
      ),
      Text(page.detail,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
      const SizedBox(height: 8),
      Text(page.subDetail,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
    ]);
  }
}

class Page {
  String imageAsset;
  String detail;
  String subDetail;

  Page(
      {required this.imageAsset,
      required this.detail,
      required this.subDetail});
}
