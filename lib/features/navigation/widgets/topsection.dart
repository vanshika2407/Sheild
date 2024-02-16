import 'package:flutter/material.dart';

import 'fancybar.dart';

class TopSection extends StatelessWidget {
  const TopSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              FancyBar(
                height: 46,
                margin: const EdgeInsets.only(left: 20, top: 40),
                child: const Icon(Icons.menu, color: Colors.black, size: 20),
              )
            ],
          ),
          Column(
            children: <Widget>[
              FancyBar(
                height: 46 * 3.0,
                margin: const EdgeInsets.only(right: 20, top: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Icon(Icons.layers, color: Colors.black, size: 20),
                    Transform.rotate(
                      angle: 3.14 / 4,
                      child: const Icon(
                        Icons.navigation,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    Icon(
                      Icons.directions,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
