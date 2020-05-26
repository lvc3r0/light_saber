import 'package:flutter/material.dart';

class Plasma extends StatelessWidget {
  const Plasma({
    Key key,
    @required this.pageController,
    @required this.colorPage,
  }) : super(key: key);

  final PageController pageController;
  final List<Color> colorPage;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 60,
        color: Colors.transparent,
        child: PageView.builder(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: colorPage.length,
          scrollDirection: Axis.vertical,
          reverse: true,
          itemBuilder: (BuildContext ctx, int index) {
            if (index == 1) {
              return Container();
            } else {
              return Stack(
                children: <Widget>[
                  Positioned(
                    left: 15,
                    right: 15,
                    top: 10,
                    child: Container(
                      width: 90,
                      height: 800,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(13),
                          topRight: Radius.circular(13),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            colorPage[index],
                            Colors.white,
                            Colors.white,
                            colorPage[index],
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorPage[index].withOpacity(0.7),
                            spreadRadius: 10,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
