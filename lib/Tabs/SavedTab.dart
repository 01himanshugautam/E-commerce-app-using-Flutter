import 'package:e_commerce_app/Widgets/CustomActionBar.dart';
import 'package:flutter/material.dart';

class SavedTab extends StatelessWidget {
  const SavedTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        Center(
          child: Text("Saved Tab"),
        ),
        CustomActionBar(
          title: "Saved",
          hasBackArrow: false,
        ),
      ],
    ));
  }
}
