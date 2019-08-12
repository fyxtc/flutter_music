import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:cloud_music/scroll_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class HomePage extends StatefulWidget {
  HomePage({Key key}): super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  TextEditingController editingController;
  TabController tabController;
  List banners = [];
  List personalized = [];
  List privateContent = [];
  List personalizedMv = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    editingController = TextEditingController();

    initData();
  }

  void initData() async{
    List banners = await getBannerData();
    List personalized = await getPersonalizedData();
    List privateContent = await getPrivateContent();
    List mv = await getPersonalizedMv();
    setState(() {
      // print("banners data len ${this.banners.length}");
      this.banners = banners;
      this.personalized = personalized.sublist(0, 6);
      this.privateContent = privateContent;
      this.personalizedMv = mv;
      // print("banners data len ${this.banners.length}");
    });
  }

  Future getBannerData() async{
    var res = await http.get("http://localhost:3000/banner?type=2");
    if(res.statusCode == 200){
      // print(convert.jsonDecode(res.body));
      return convert.jsonDecode(res.body)['banners'];
    }else{
      print("Request failed with status: ${res.statusCode}.");
    }
  }

  Future getPersonalizedData() async{
    var res = await http.get("http://localhost:3000/personalized");
    if(res.statusCode == 200){
      return convert.jsonDecode(res.body)["result"];
    }
  }

  Future getPrivateContent() async{
    var res = await http.get("http://localhost:3000/personalized/privatecontent");
    if(res.statusCode == 200){
      return convert.jsonDecode(res.body)["result"];
    }
  }

  Future getPersonalizedMv() async{
    var res = await http.get("http://localhost:3000/personalized/mv");
    if(res.statusCode == 200){
      return convert.jsonDecode(res.body)["result"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.mic),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: (){
          },),
          SizedBox(width: 20,)
        ],
        title: Container(
          height: 30,
          // width: 50,
          // color: Colors.white,
          child: TextField(
            controller: editingController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              // hintText: "search here",
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white
                ),
                borderRadius: BorderRadius.all(Radius.circular(25))
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white
                ),
                borderRadius: BorderRadius.all(Radius.circular(25))
              )
            ),
          ),
        ),
      ),

      body: buildBody(),
    );
  }

  Widget buildBody(){
    // return TabBar(
    //       controller: tabController,
    //       labelColor: Colors.black,
    //       tabs: <Widget>[
    //         Tab(text: "音乐",), 
    //         Tab(text: "视频",), 
    //         Tab(text: "电台",), 
    //       ],
    // );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TabBar(
          labelColor: Colors.black,
          tabs: <Widget>[
            Tab(text: "音乐",), 
            Tab(text: "视频",), 
            Tab(text: "电台",), 
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            // Text("tab1"),
            buildTabMusic(),
            Center(child: Text("视频 Tab")),
            Center(child: Text("电台 Tab")),
          ],
        ),
      ),
    );
  }


  Widget buildTabMusic(){
    if(banners.length == 0){
      return CircularProgressIndicator();
    }
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Container(
            // child: ScrollImage(), 
            child: Carousel(
              images: /*banners.length == 0 ? [
                // Image.network("http://p1.music.126.net/QnAZc0aP8CzMWNZW6id6GQ==/109951164275528842.jpg"),
                Container(child: CircularProgressIndicator(), width: 50, height: 50,)
              ] :*/ banners.map((banner){
                // print("banner ${banner}");
                return Image.network(banner["pic"]);
                // return Image.network("http://p1.music.126.net/QnAZc0aP8CzMWNZW6id6GQ==/109951164275528842.jpg");
              }).toList(),
              overlayShadow: false,
              dotSpacing: 15,
              dotSize: 5,
              // dotBgColor: Colors.purple.withOpacity(0.5),
              indicatorBgPadding: 5.0,
              // showIndicator: false,
            ),
            height: 150,
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.music_video), onPressed: (){},),
                  Text("私人FM"),
                ],
              ),
              Column(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.list), onPressed: (){},),
                  Text("每日推荐"),
                ],
              ),
              Column(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.music_note), onPressed: (){},),
                  Text("歌单"),
                ],
              ),
              Column(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.nature), onPressed: (){},),
                  Text("排行榜"),
                ],
              ),
            ],
          ),

          SizedBox(height: 20,),
          buildItem("推荐歌单", this.personalized),
          SizedBox(height: 20,),
          buildPrivateContent("独家放送", this.privateContent),
          SizedBox(height: 20,),
          buildPersonalizedMv("推荐MV", this.personalizedMv),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget buildItemTitle(String title){
    return Row(
      children: <Widget>[
        Container(
          width: 4,
          color: Colors.green,
          child: Text(""),
        ),
        SizedBox(width: 10,),
        Text(title),
        Icon(Icons.arrow_right)
      ],
    );
  }

  Widget buildItem(String title, List data){
    return Column(
      children: <Widget>[
        buildItemTitle(title),
        SizedBox(height: 20,),

        GridView.count(
          physics: new NeverScrollableScrollPhysics(),
          // primary: true, 
          shrinkWrap: true,
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 4.2,
          children: data.map((ele){
            return Container(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.network(ele["picUrl"]),
                      Positioned(
                        right: 5,
                        top: -3,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.airline_seat_recline_extra, color: Colors.white,),
                            Text(ele["playCount"].toString(), style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      )

                    ],
                  ),
                  // Container(child: Image.network(ele["picUrl"])),
                  Text(ele["name"], maxLines: 2, style: TextStyle(fontSize: 12),),
                ],
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  buildPrivateContent(String title, List data){
    var data1 = data.sublist(0, 2);
    var data2 = data.sublist(2, 3);
    return Column(
      children: <Widget>[
        buildItemTitle(title),
        SizedBox(height: 20,),

        // GridView.count(
        //   physics: new NeverScrollableScrollPhysics(),
        //   // primary: true, 
        //   shrinkWrap: true,
        //   crossAxisCount: 2,
        //   children: data.map((ele){}),
        // )

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: data1.map((ele){
            return Container(
              width: MediaQuery.of(context).size.width / 2 - 2,
              // height: 50,
              child: Column(
                children: <Widget>[
                  Container(child: Image.network(ele["picUrl"],fit: BoxFit.fill,), height: 90,),
                  Text(ele["name"], maxLines: 2, style: TextStyle(fontSize: 12),),
                ],
              ),
            );
          }).toList(),
        ),

        SizedBox(height: 20,),

        Wrap(
          children: data2.map((ele){
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Container(child: Image.network(ele["picUrl"], fit: BoxFit.fill,),),
                  Text(ele["name"], maxLines: 2, style: TextStyle(fontSize: 12),),
                ],
              ),
            );
          }).toList(),
        ),

        SizedBox(height: 10,)
      ]
    );
  }

  Widget buildPersonalizedMv(String title, List data){
    return Column(
      children: <Widget>[
        buildItemTitle(title),
        SizedBox(height: 10,),
        GridView.count(
          physics: new NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 2 / 1.6,
          children: data.map((ele){
            return Container(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.network(ele["picUrl"]),
                      Positioned(
                        right: 5,
                        top: 0,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.video_label, color: Colors.white,),
                            SizedBox(width: 3,),
                            Text(ele["playCount"].toString(), style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      )

                    ],
                  ),
                  // Container(child: Image.network(ele["picUrl"])),
                  Text(ele["name"], maxLines: 1, style: TextStyle(fontSize: 12),),
                  Text(ele["artistName"], maxLines: 1, style: TextStyle(fontSize: 12, color: Colors.grey),),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    ); 
  }





}