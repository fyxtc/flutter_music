import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';


class ScrollImage extends StatefulWidget {
  @override
  _ScrollImageState createState() => _ScrollImageState();
}

class _ScrollImageState extends State<ScrollImage> {
  double screenWidth = 0.0;
  final ScrollController controller = ScrollController();
  int startTime;
  int endTime;
  double startOffset;
  double endOffset;

  void _scrollTo(bool isPre){
    final double offset = controller.offset;
    final double maxOffset = controller.position.maxScrollExtent;
    if(offset >= maxOffset){
      return;
    }

    int index;
    if(isPre){
      index = (offset / screenWidth).floor() - 1;
    }else{
      index = (offset / screenWidth).ceil();
    }

    double width = max(0, index * screenWidth).toDouble();
    width = min(maxOffset, width);
    controller.animateTo(width, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  void _onScrollEnd(){
    // var v = controller.position.activity.velocity;
    // print("velocity ${v}");
    final double offset = controller.offset;
    final double maxOffset = controller.position.maxScrollExtent;
    if(offset >= maxOffset){
      return;
    }
    final diff = offset % screenWidth;
    int index = (offset / screenWidth).floor();
    if(diff >= screenWidth / 2){
      index++;
    }
    double width = index * screenWidth;
    if(width > maxOffset){
      width = maxOffset;
    }
    print(">>>>>>>>>> $width, offset $offset, max ${controller.position.maxScrollExtent}");
    controller.animateTo(width, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 2), (timer) {
      // controller.animateTo(0, duration: Duration(microseconds: 10), curve: Curves.ease);
      // controller.addListener(_scrollListener);

      // print(DateTime.now().millisecondsSinceEpoch);
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context){
      //     return AlertDialog(
      //       title: Text("alert"),
      //       content: Text("content"),
      //     );
      //   }
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    print("screen width $screenWidth");
    return NotificationListener(
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index){
          return Container(
            width: screenWidth,
            child: FittedBox(fit: BoxFit.fill, child: Image.network("http://p1.music.126.net/QnAZc0aP8CzMWNZW6id6GQ==/109951164275528842.jpg"))
          );
        },
      ),
      onNotification: (t){
        if(t is ScrollEndNotification && (controller.offset.toInt() % screenWidth != 0)){
          // final double vel = t.dragDetails.primaryVelocity;
          // print("vel: $vel");
          endTime = DateTime.now().millisecondsSinceEpoch;
          int diffTime = endTime - startTime;
          endOffset = controller.offset;
          double diffOffset = endOffset - startOffset;
          double vel = (diffOffset / diffTime).abs();
          if(vel > 0.04){
            if(diffOffset > startOffset){
              // next
              // _scrollTo(false);
            }else{
              // back
              // _scrollTo(true);
            }
          }
          print("vel $vel");
          Timer(Duration(milliseconds: 10), (){
            _onScrollEnd();
          });
          // _onScrollEnd();
          // controller.animateTo(0, duration: Duration(microseconds: 10), curve: Curves.ease);
          // print("fuck " + ((controller.offset.toInt() % screenWidth).toString()));
          // controller.jumpTo(0);
        }else if(t is ScrollStartNotification){
          startTime = DateTime.now().millisecondsSinceEpoch;
          startOffset = controller.offset;
        }
      },
    );
  }
}