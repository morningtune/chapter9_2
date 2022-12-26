import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin   {
   late AnimationController _controller;

   @override
   void initState() {
     super.initState();

     _controller = AnimationController(
       duration: const Duration(milliseconds: 2000),
       vsync: this,
     );
   }

   _playAnimation() async {
     try {
       //先正向执行动画
       await _controller.forward().orCancel;
       //再反向执行动画
       await _controller.reverse().orCancel;
     } on TickerCanceled {
       // the animation got canceled, probably because we were disposed
     }
   }

   @override
   Widget build(BuildContext context) {
     return Center(
       child: Column(
         children: [
           ElevatedButton(
             onPressed: () => _playAnimation(),
             child: Text("start animation"),
           ),
           Container(
             width: 600.0,
             height: 600.0,
             decoration: BoxDecoration(
               color: Colors.black.withOpacity(0.1),
               border: Border.all(
                 color: Colors.black.withOpacity(0.5),
               ),
             ),
             //调用我们定义的交错动画Widget
             child: StaggerAnimation(controller: _controller),
           ),
         ],
       ),
     );
   }
 }
 class StaggerAnimation extends StatelessWidget {
   StaggerAnimation({
     Key? key,
     required this.controller,
   }) : super(key: key) {
     //高度动画
     height = Tween<double>(
       begin: .0,
       end: 600.0,
     ).animate(
       CurvedAnimation(
         parent: controller,
         curve: const Interval(
           0.0, 0.6, //间隔，前60%的动画时间
           curve: Curves.ease,
         ),
       ),
     );

     color = ColorTween(
       begin: Colors.deepPurpleAccent,
       end: Colors.greenAccent,
     ).animate(
       CurvedAnimation(
         parent: controller,
         curve: const Interval(
          0.0, 0.6, //间隔，前60%的动画时间
           curve: Curves.ease,
         ),
       ),
     );

     padding = Tween<EdgeInsets>(
       begin: const EdgeInsets.only(left: .0),
       end: const EdgeInsets.only(left: 100.0),
     ).animate(
       CurvedAnimation(
         parent: controller,
         curve: const Interval(
           0.6, 1.0, //间隔，后40%的动画时间
           curve: Curves.ease,
         ),
       ),
     );
   }

   late final Animation<double> controller;
   late final Animation<double> height;
   late final Animation<EdgeInsets> padding;
   late final Animation<Color?> color;

   Widget _buildAnimation(BuildContext context, child) {
     return Container(
       alignment: Alignment.bottomCenter,
       padding: padding.value,
       child: Container(
         color: color.value,
         width: 150.0,
         height: height.value,
       ),
     );
   }

   @override
   Widget build(BuildContext context) {
     return AnimatedBuilder(
       builder: _buildAnimation,
       animation: controller,
     );
   }

}