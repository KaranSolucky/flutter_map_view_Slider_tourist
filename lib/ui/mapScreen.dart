import 'dart:typed_data';
import 'dart:async';

import 'package:animate_markers/ui/new_page.dart';
import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import '../tools/tools.dart';

const LatLng _center = const LatLng(19.067893294790665, 72.82638486094186);
LatLng newPosition;
CameraPosition newCameraPosition = CameraPosition(
    target: LatLng(19.067893294790665, 72.82638486094186), zoom: 20);

Set<Marker> markers = {};
int _index = 0;
int indexMarker;
ValueNotifier valueNotifier = ValueNotifier(indexMarker);

//*********StatefulWidget */
class MainMapScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainMapScreen> {
  //******** Map variables */
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  //******* getMarkers */
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void getMarkers() async {
    final Uint8List userMarkerIcon =
        await getBytesFromAsset('assets/normalMarker.png', 75);

    final Uint8List selectedMarkerIcon =
        await getBytesFromAsset('assets/selectedMarker.png', 100);

    markers = {};

    Tools.markersList.forEach((element) {
      if (element.latitude != null && element.longitude != null) {
        if (element.id == indexMarker) {
          markers.add(Marker(
              draggable: false,
              markerId: MarkerId(element.latitude + element.longitude),
              position: LatLng(
                double.tryParse(element.latitude),
                double.tryParse(element.longitude),
              ),
              icon: BitmapDescriptor.fromBytes(selectedMarkerIcon),
              infoWindow: InfoWindow(
                  title: element.name,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewPage(
                                name: element.name,
                                image: element.image,
                              )),
                    );
                  })));
        } else {
          markers.add(Marker(
              draggable: false,
              markerId: MarkerId(element.latitude + element.longitude),
              position: LatLng(
                double.tryParse(element.latitude),
                double.tryParse(element.longitude),
              ),
              icon: BitmapDescriptor.fromBytes(userMarkerIcon),
              infoWindow: InfoWindow(title: element.name)));
        }
      }
    });

    valueNotifier.value = indexMarker;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _controller.complete(controller);
  }

  @override
  void initState() {
    getMarkers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _counter = 0;
  bool isOpened = false;

  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();

  toggleMenu([bool end = false]) {
    if (end) {
      final _state = _endSideMenuKey.currentState;
      if (_state.isOpened) {
        _state.closeSideMenu();
      } else {
        _state.openSideMenu();
      }
    } else {
      final _state = _sideMenuKey.currentState;
      if (_state.isOpened) {
        _state.closeSideMenu();
      } else {
        _state.openSideMenu();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        initialData: 0,
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text("Karan's Map"),
                centerTitle: true,
              ),
              drawer: SideMenu(
                key: _endSideMenuKey,
                inverse: true, // end side menu
                background: Colors.green[700],
                type: SideMenuType.slideNRotate,
                menu: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: buildMenu(),
                ),
                onChange: (_isOpened) {
                  setState(() => isOpened = _isOpened);
                },
                child: SideMenu(
                  key: _sideMenuKey,
                  menu: buildMenu(),
                  type: SideMenuType.slideNRotate,
                  onChange: (_isOpened) {
                    setState(() => isOpened = _isOpened);
                  },
                  child: IgnorePointer(
                    ignoring: isOpened,
                    child: Scaffold(
                      appBar: AppBar(
                        centerTitle: true,
                        leading: IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => toggleMenu(),
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () => toggleMenu(true),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: ValueListenableBuilder(
                        valueListenable:
                            valueNotifier, // that's the value we are listening to
                        builder: (context, value, child) {
                          return GoogleMap(
                              zoomControlsEnabled: false,
                              markers: markers,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: _center,
                                zoom: 11.0,
                              ));
                        }),
                  ),
                  // Here is tha PageView Builder
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: SizedBox(
                          height: 116, // card height
                          child: PageView.builder(
                            itemCount: Tools.markersList.length,
                            controller: PageController(viewportFraction: 0.9),
                            onPageChanged: (int index) {
                              setState(() => _index = index);
                              indexMarker = Tools.markersList[index].id;
                              if (Tools.markersList[index].latitude != null &&
                                  Tools.markersList[index].longitude != null) {
                                newPosition = LatLng(
                                    double.tryParse(
                                        Tools.markersList[index].latitude),
                                    double.tryParse(
                                        Tools.markersList[index].longitude));
                                newCameraPosition = CameraPosition(
                                    target: newPosition, zoom: 15);
                              }
                              getMarkers();
                              mapController
                                  .animateCamera(CameraUpdate.newCameraPosition(
                                      newCameraPosition))
                                  .then((val) {
                                setState(() {});
                              });
                            },
                            itemBuilder: (_, i) {
                              return Transform.scale(
                                scale: i == _index ? 1 : 0.9,
                                child: new Container(
                                  height: 116.00,
                                  width: 325.00,
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0.5, 0.5),
                                        color:
                                            Color(0xff000000).withOpacity(0.12),
                                        blurRadius: 20,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10.00),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 9,
                                            top: 7,
                                            bottom: 7,
                                            right: 9),
                                        child: Container(
                                          height: 86.00,
                                          width: 86.00,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  Tools.markersList[i].image),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.00),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12, right: 0.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Wrap(
                                              alignment: WrapAlignment.start,
                                              spacing: 2,
                                              direction: Axis.vertical,
                                              children: <Widget>[
                                                Text(
                                                  Tools.markersList[i].name,
                                                  style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontSize: 15,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                                Container(
                                                  width: 230,
                                                  child: Text(
                                                    Tools.markersList[i]
                                                        .description,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 4,
                                                    style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      fontSize: 10,
                                                      color: Color(0xff000000),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ))
                ],
              ));
        });
  }

  Widget buildMenu() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 22.0,
                ),
                SizedBox(height: 16.0),
                Text(
                  "Hello, John Doe",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.home, size: 20.0, color: Colors.white),
            title: const Text("Home"),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.verified_user,
                size: 20.0, color: Colors.white),
            title: const Text("Profile"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.monetization_on,
                size: 20.0, color: Colors.white),
            title: const Text("Wallet"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.shopping_cart,
                size: 20.0, color: Colors.white),
            title: const Text("Cart"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {},
            leading:
                const Icon(Icons.star_border, size: 20.0, color: Colors.white),
            title: const Text("Favorites"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {},
            leading:
                const Icon(Icons.settings, size: 20.0, color: Colors.white),
            title: const Text("Settings"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
