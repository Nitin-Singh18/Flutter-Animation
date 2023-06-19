import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipPath(
                clipper: const HalfCircleClipper(side: CircleSide.left),
                child: Container(
                  height: 180,
                  width: 180,
                  color: Colors.blue,
                ),
              ),
              ClipPath(
                clipper: const HalfCircleClipper(side: CircleSide.right),
                child: Container(
                  height: 180,
                  width: 180,
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

enum CircleSide {
  left,
  right,
}

//Adding functionality to CircleSide
extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();

    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        //offset is the endpoint of the arc
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.right:
        //In this case, the pencil is by default at (0,0) coordinate.
        // path.moveTo(0, 0);
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }

    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockwise,
    );
    path.close();
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  const HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
