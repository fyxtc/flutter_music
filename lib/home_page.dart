import 'package:flutter/material.dart';
import 'package:cloud_music/scroll_image.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}): super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  TextEditingController editingController;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    editingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.mic),
        actions: <Widget>[
          Icon(Icons.list)
        ],
        title: Container(
          height: 60,
          // color: Colors.white,
          child: TextField(
            controller: editingController,
            decoration: InputDecoration(
              fillColor: Colors.white,
              hintText: "search here",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))
              ),
              focusedBorder: OutlineInputBorder(
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
            Text("tab2"),
            Text("tab3"),
          ],
        ),
      ),
    );
  }

  Widget buildTabMusic(){
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Container(child: ScrollImage(), height: 120,),
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

          SizedBox(height: 30,),
          buildItem("推荐歌单"),
          SizedBox(height: 30,),
          buildItem("独家放送"),
        ],
      ),
    );
  }

  Widget buildItem(String title){
    return Column(
      children: <Widget>[
        Row(
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
        ),

        SizedBox(height: 20,),

        GridView.count(
          physics: new NeverScrollableScrollPhysics(),
          primary: true, 
          shrinkWrap: true,
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 4.2,
          children: List.generate(6, (index){
              return Container(
                // color: Colors.red,
                child: Column(
                  children: <Widget>[
                    Image.network("https://p2.music.126.net/IkO4ZYPmvt5wGMer7fB-8g==/109951164271719654.jpg", ),
                    // FittedBox(fit: BoxFit.fill, child: Image.network("http://p1.music.126.net/QnAZc0aP8CzMWNZW6id6GQ==/109951164275528842.jpg", )),
                    Text("立秋 | 愿所有夏日遗憾，都被秋风温柔化解", maxLines: 2, style: TextStyle(fontSize: 12),),
                  ],
                ),
              );
            })
        )
      ],
    );
  }


}