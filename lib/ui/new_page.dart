import 'package:flutter/material.dart';

class NewPage extends StatefulWidget {
  final String name;
  final String image;
  const NewPage({Key key, this.name, this.image});

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Center(child: Image.network(widget.image)),
    );
  }
}
