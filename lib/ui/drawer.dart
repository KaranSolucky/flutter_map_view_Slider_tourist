import 'package:flutter/material.dart';

import 'mapScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 500);
  AnimationController _animationController;

  AppBar appBar = AppBar();
  double borderRadius = 0.0;

  int _navBarIndex = 0;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: duration);
  }

  @override
  void dispose() {
    _animationController.dispose();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {
        _navBarIndex = tabController.index;
      });
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return WillPopScope(
      onWillPop: () async {
        if (!isCollapsed) {
          setState(() {
            _animationController.reverse();
            borderRadius = 0.0;
            isCollapsed = !isCollapsed;
          });
          return false;
        } else
          return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //  Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: <Widget>[
            menu(context),
            AnimatedPositioned(
                left: isCollapsed ? 0 : 0.6 * screenWidth,
                right: isCollapsed ? 0 : -0.2 * screenWidth,
                top: isCollapsed ? 0 : screenHeight * 0.1,
                bottom: isCollapsed ? 0 : screenHeight * 0.1,
                duration: duration,
                curve: Curves.fastOutSlowIn,
                child: dashboard(context)),
          ],
        ),
      ),
    );
  }

  Widget menu(context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: FractionallySizedBox(
            widthFactor: 0.6,
            heightFactor: 0.6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainMapScreen()),
                    );
                  },
                  splashColor: Colors.amber,
                  child: ListTile(
                    tileColor: Colors.black,
                    textColor: Colors.white,
                    title: Text("Tousrist Location Guide"),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  splashColor: Colors.amber,
                  child: ListTile(
                    tileColor: Colors.black,
                    textColor: Colors.white,
                    title: Text("Tousrist Location Guide"),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  splashColor: Colors.amber,
                  child: ListTile(
                    tileColor: Colors.black,
                    textColor: Colors.white,
                    title: Text("Tousrist Location Guide"),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  splashColor: Colors.amber,
                  child: ListTile(
                    tileColor: Colors.black,
                    textColor: Colors.white,
                    title: Text("Tousrist Location Guide"),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  splashColor: Colors.amber,
                  child: ListTile(
                    tileColor: Colors.black,
                    textColor: Colors.white,
                    title: Text("Tousrist Location Guide"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // ),
    // )
  }

  Widget dashboard(context) {
    return SafeArea(
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        type: MaterialType.card,
        animationDuration: duration,
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 8,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text('Karans Map'),
              centerTitle: true,
              leading: IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _animationController,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isCollapsed) {
                        _animationController.forward();

                        borderRadius = 16.0;
                      } else {
                        _animationController.reverse();

                        borderRadius = 0.0;
                      }

                      isCollapsed = !isCollapsed;
                    });
                  }),
            ),
            bottomNavigationBar: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                  bottomLeft: Radius.circular(borderRadius),
                  bottomRight: Radius.circular(borderRadius)),
              child: BottomNavigationBar(
                  currentIndex: _navBarIndex,
                  type: BottomNavigationBarType.shifting,
                  onTap: (index) {
                    setState(() {
                      _navBarIndex = index;
                    });
                  },
                  backgroundColor: Theme.of(context).primaryColorDark,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard),
                      label: "",
                    ),
                  ]),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 50),
                    // Container(
                    //   height: 200,
                    //   child: PageView(
                    //     controller: PageController(viewportFraction: 0.8),
                    //     scrollDirection: Axis.horizontal,
                    //     pageSnapping: true,
                    //     children: <Widget>[
                    //       Container(
                    //         margin: const EdgeInsets.symmetric(horizontal: 8),
                    //         color: Colors.redAccent,
                    //         width: 100,
                    //       ),
                    //       Container(
                    //         margin: const EdgeInsets.symmetric(horizontal: 8),
                    //         color: Colors.blueAccent,
                    //         width: 100,
                    //       ),
                    //       Container(
                    //         margin: const EdgeInsets.symmetric(horizontal: 8),
                    //         color: Colors.greenAccent,
                    //         width: 100,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
