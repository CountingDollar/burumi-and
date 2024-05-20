
import 'package:flutter/material.dart';
import 'package:flat_list/flat_list.dart';
import 'package:team_burumi/cards/postcard.dart';

class ActivityBA extends StatelessWidget {
  const ActivityBA({super.key});

  @override
  Widget build(BuildContext context) {
    var loading;
    return FlatList(
      // loading: loading.value,
      //
      //   onEndReached: () async{
      //     loading.value = true;
      //     await Future.delayed(Duration(seconds: 2));
      //     loadMore();
      //     loading.value = false;
      //   },
      //
      //   onRefresh: () async{
      //     await Future.delayed(Duration(seconds: 2));
      //     refresh();
      //   },
      //   listEmptyWidget: Center(
      //     child: Text('No data'),
      //   ),
        data: List.generate(100, (index) => index),

        itemSeparatorWidget: Container(
          height: 1,
          color: Colors.grey,
        ),
      buildItem: (item, index){
        return PostCard(number: index);
    },



        );


  }
}