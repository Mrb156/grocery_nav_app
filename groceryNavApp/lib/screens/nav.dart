import 'package:flutter/material.dart';
import 'package:widget_arrows/widget_arrows.dart';

class Navigation extends StatefulWidget {
  Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  bool showArrows = true;
  @override
  Widget build(BuildContext context) => ArrowContainer(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Navigáció'),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: ArrowElement(
                    show: showArrows,
                    id: 'cont',
                    targetIds: const ['text2'],
                    sourceAnchor: Alignment.bottomCenter,
                    targetAnchor: Alignment.topCenter,
                    color: Colors.green,
                    child: FilledButton(child: Text("1"), onPressed: (){},),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: ArrowElement(
                    show: showArrows,
                    id: 'text2',
					targetId: 'cont',
					sourceAnchor: Alignment.topCenter,
                    targetAnchor: Alignment.bottomCenter,
                    child: FilledButton(child: const Text("2"), onPressed: (){},),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: ArrowElement(
            id: 'fab',
            child: FloatingActionButton(
              onPressed: () => setState(() {
                showArrows = !showArrows;
              }),
              tooltip: 'hide/show',
              child: const Icon(Icons.remove_red_eye),
            ),
          ),
        ),
      );
}
