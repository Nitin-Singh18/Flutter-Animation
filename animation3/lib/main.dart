import 'package:flutter/material.dart';
import 'dart:math' show pi;

import 'package:vector_math/vector_math_64.dart' show Vector3;

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
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;
  late Tween<double> _animation;

  @override
  void initState() {
    super.initState();
    _xController =
        AnimationController(duration: const Duration(seconds: 10), vsync: this);
    _yController =
        AnimationController(duration: const Duration(seconds: 10), vsync: this);
    _zController =
        AnimationController(duration: const Duration(seconds: 10), vsync: this);

    _animation = Tween<double>(begin: 0, end: 2 * pi);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }

  double heightAndWidth = 100.0;
  @override
  Widget build(BuildContext context) {
    _xController
      ..forward()
      ..repeat();
    _yController
      ..reset()
      ..repeat();
    _zController
      ..reset()
      ..repeat();
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge(
            [
              _xController,
              _yController,
              _zController,
            ],
          ),
          builder: (BuildContext context, Widget? child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateX(_animation.evaluate(_xController))
                ..rotateY(_animation.evaluate(_yController))
                ..rotateZ(_animation.evaluate(_zController)),
              child: Stack(
                children: [
                  //back
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..translate(Vector3(0, 0, -heightAndWidth)),
                    child: Container(
                      height: heightAndWidth,
                      width: heightAndWidth,
                      color: Colors.purple,
                    ),
                  ),
                  //left
                  Transform(
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.identity()..rotateY(pi / 2),
                    child: Container(
                      height: heightAndWidth,
                      width: heightAndWidth,
                      color: Colors.red,
                    ),
                  ),
                  //right
                  Transform(
                    alignment: Alignment.centerRight,
                    transform: Matrix4.identity()..rotateY(-pi / 2),
                    child: Container(
                      height: heightAndWidth,
                      width: heightAndWidth,
                      color: Colors.blue,
                    ),
                  ),
                  // front
                  Container(
                    height: heightAndWidth,
                    width: heightAndWidth,
                    color: Colors.green,
                  ),
                  //top
                  Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()..rotateX(-pi / 2.0),
                    child: Container(
                      color: Colors.orange,
                      width: heightAndWidth,
                      height: heightAndWidth,
                    ),
                  ),

                  //bottom
                  Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()..rotateX(pi / 2.0),
                    child: Container(
                      color: Colors.brown,
                      width: heightAndWidth,
                      height: heightAndWidth,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
