import 'package:flutter/material.dart';
import 'dart:math' show pi;

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _counterClockwiseController;
  late Animation<double> _counterClockwiseRotationAnimation;

  late AnimationController _flipController;
  late Animation _flipAnimation;

  @override
  void initState() {
    super.initState();
    //Rotation Animation
    _counterClockwiseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _counterClockwiseRotationAnimation = Tween<double>(
      begin: 0.0,
      //To rotate a widget CounterClockwise, we have passed '-' value to end.
      end: -(pi / 2),
    ).animate(CurvedAnimation(
        parent: _counterClockwiseController, curve: Curves.bounceOut));
    _counterClockwiseController.forward();

    //Flip Animation
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(
        CurvedAnimation(parent: _flipController, curve: Curves.bounceOut));

    _counterClockwiseController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _flipAnimation = Tween<double>(
                  begin: _flipAnimation.value, end: _flipAnimation.value + pi)
              .animate(
            CurvedAnimation(parent: _flipController, curve: Curves.bounceOut),
          );

          //Reset the flip controller and start the animation
          _flipController
            ..reset()
            ..forward();
        }
      },
    );

    _flipController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _counterClockwiseRotationAnimation = Tween<double>(
            begin: _counterClockwiseRotationAnimation.value,
            end: _counterClockwiseRotationAnimation.value + -(pi / 2),
          ).animate(CurvedAnimation(
              parent: _counterClockwiseController, curve: Curves.bounceOut));

          //Reset the CounterClockwise controller and start the animation
          _counterClockwiseController
            ..reset()
            ..forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _counterClockwiseController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
                animation: _counterClockwiseController,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateZ(_counterClockwiseRotationAnimation.value),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                            animation: _flipController,
                            builder: (context, child) {
                              return Transform(
                                alignment: Alignment.centerRight,
                                transform: Matrix4.identity()
                                  ..rotateY(_flipAnimation.value),
                                child: ClipPath(
                                  clipper: const HalfCircleClipper(
                                      side: CircleSide.left),
                                  child: Container(
                                    height: 180,
                                    width: 180,
                                    color: Colors.blue,
                                  ),
                                ),
                              );
                            }),
                        AnimatedBuilder(
                            animation: _flipController,
                            builder: (context, child) {
                              return Transform(
                                alignment: Alignment.centerLeft,
                                transform: Matrix4.identity()
                                  ..rotateY(_flipAnimation.value),
                                child: ClipPath(
                                  clipper: const HalfCircleClipper(
                                      side: CircleSide.right),
                                  child: Container(
                                    height: 180,
                                    width: 180,
                                    color: Colors.yellow,
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
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
