import 'package:flutter/material.dart';
import 'package:she_secure/colors.dart';

class OptionsWidget extends StatelessWidget {
  const OptionsWidget({
    Key? key,
    required this.opt,
    required this.onOptionSelected,
  }) : super(key: key);

  final List opt;
  final Function(String, double, double) onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: opt.length * 80,
      // width: 200,
      child: ListView.builder(
        itemCount: opt.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () => onOptionSelected(
            opt[index].name,
            opt[index].geometry!.location.lat,
            opt[index].geometry!.location.lng,
          ),
          child: Container(
            color: greyColor,
            child: ListTile(
              title: Text(opt[index].name),
            ),
          ),
        ),
      ),
    );
  }
}
