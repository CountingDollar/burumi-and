import 'package:flutter/material.dart';
import 'package:team_burumi/src/screens/activity-ba.dart';
import 'package:team_burumi/src/screens/activity-bu.dart';


class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
} // Activity 클래스 끝


class _ActivityState extends State<Activity> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left,size: 30,color: Colors.grey,),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),


              Expanded(child:
                Text('활동',textAlign: TextAlign.center,style: TextStyle(fontSize: 30,),)),

              Container(
                width: 30,
              ),
            ],
          ),
          TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabController,
            tabs: [
              Tab(text: '부르미'),
              Tab(text: '바라미'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ActivityBu(),
                ActivityBA(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
