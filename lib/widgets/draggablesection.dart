import 'package:flutter/material.dart';

import 'explorerow.dart';
import 'rowevents.dart';
import 'rowimages.dart';
import 'rowlists.dart';
import 'rowwidgets.dart';
import 'searchbar.dart';

class DraggableSection extends StatelessWidget {
  final double? top;
  final double? searchBarHeight;

  DraggableSection({this.top, this.searchBarHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 1.1,
        margin: EdgeInsets.only(top: this.top!),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 30,
                color: Colors.grey.shade300,
              )
            ]),
        child: Stack(
          children: <Widget>[
            ListView(children: <Widget>[
              ExploreRow(),
              RowWidgets(),
              RowImages(),
              RowEvents(),
              RowLists()
            ]),
            SearchBarWidget(
              baseTop: top ?? 0.0,
              height: searchBarHeight ?? 0.0,
            ),
          ],
        ));
  }
}
