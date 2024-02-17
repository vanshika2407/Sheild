import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:she_secure/features/navigation/options.dart';
import 'package:she_secure/features/navigation/routing.dart';

class CDraggable extends ConsumerStatefulWidget {
  const CDraggable({
    required this.startLoc,
    required this.destLoc,
    super.key,
    required this.title,
  });

  final String title;
  final startLoc;
  final destLoc;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CDraggableState();
}

class _CDraggableState extends ConsumerState<CDraggable> {
  final sheet_controller = DraggableScrollableController();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DraggableScrollableSheet(
          // key: ref.read(mapProvider).sheet,
          controller: sheet_controller,
          initialChildSize: 0.2,
          minChildSize: 0.2,
          maxChildSize: 0.4,
          expand: true,

          // snap: true,
          // snapSizes: [
          //   60 / constraints.maxHeight,
          //   0.5,
          // ],
          builder: (
            BuildContext context,
            ScrollController scrollController,
          ) {
            return SingleChildScrollView(
              controller: scrollController,
              // physics: const BouncingScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                    // color: Colors.white.withOpacity(0.5),
                    color: Colors.blueGrey.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        blurRadius: 30,
                        color: Colors.black12,
                        // color: Colors.white24,
                      )
                    ]),
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Options(
                                      startLoc: widget.startLoc,
                                      destLoc: widget.destLoc,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Directions'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text('Start'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
