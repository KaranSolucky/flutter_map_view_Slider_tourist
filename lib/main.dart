import 'package:animate_markers/ui/dash.dart';
import 'package:animate_markers/ui/drawer.dart';
import 'package:flutter/material.dart';
import 'tools/tools.dart';
import 'ui/mapScreen.dart';

import 'models/markerModel.dart';

void main() {
  Tools.markersList.add(MarkersModel(
      1,
      "SAM TATTOO INDIA",
      "Sam studio of tattoo and arts, one of the best and hygine tattoo studio established in Mumbai since 2012. Artist of our team, are constantly evolving within in the industry by learning new methods, ideologies, and appreciating the artwork that others do. A team of award winning tattoo artist all over india.",
      "19.185266846968975",
      "72.8498159765488",
      "https://samtattooindia.com/img/studio/7.webp"));
  Tools.markersList.add(MarkersModel(
      2,
      "Orient Technology",
      "Orient is a leading System Integrator in India's IT space. We have been a trusted partner with a focus on digital transformation for 28+ years.",
      "19.118530089961908",
      "72.87146088465927",
      "https://lh5.googleusercontent.com/p/AF1QipMFR3URA07lFeTmClMs_V652OaV64qEk3nOG02O=w1080-k-no"));
  Tools.markersList.add(MarkersModel(
      3,
      "Lilavati Hospital And Research\n Centre",
      "Lilavati Hospital & Research Centre A-791,\n Bandra Reclamation, Bandra (W),\n Mumbai - 400050. India.",
      "19.051276222894348",
      "72.82900846794713",
      "https://www.google.com/maps/uv?pb=!1s0x3be7c938c9dfd491%3A0x88790013d219e1cc!3m1!7e115!4shttps%3A%2F%2Flh5.googleusercontent.com%2Fp%2FAF1QipPAIzBhH4dTxZ__P7p8Eil3QvY32o8GwMsTyx0v%3Dw143-h160-k-no!5slilavati%20hospital%20-%20Google%20Search!15sCgIgAQ&imagekey=!1e10!2sAF1QipPAIzBhH4dTxZ__P7p8Eil3QvY32o8GwMsTyx0v&hl=en&sa=X&ved=2ahUKEwibq_K6jcr2AhUjjOYKHW15C4YQoip6BAhPEAM#"));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AnimateMarkers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}
