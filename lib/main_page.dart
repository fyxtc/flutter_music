
import 'package:cloud_music/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _barIndex = 0;
  final List<Widget> pages = [
    HomePage(key: PageStorageKey("home_page")),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.music_note), title: Text("发现音乐")),
          BottomNavigationBarItem(icon: Icon(Icons.music_video), title: Text("我的音乐")),
          BottomNavigationBarItem(icon: Icon(Icons.people), title: Text("朋友")),
          BottomNavigationBarItem(icon: Icon(Icons.face), title: Text("账号")),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _barIndex,
        onTap: (index){
          setState(() {
            _barIndex = index;
          });
        },
      ),
      body: getBody(),
      // body: PageStorage(
      //   child: pages[_barIndex],
      //   bucket: bucket,
      // ),
    );
  }

  Widget getBody(){
    switch (_barIndex) {
      case 0:
        return HomePage(); 
        break;
      default:
        return Container(width: 100, height: 100, color: Colors.blue,);
    }
  }
}