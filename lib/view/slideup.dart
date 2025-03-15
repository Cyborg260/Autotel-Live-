import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: _panelController,
        minHeight: 100,
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        panelBuilder: (scrollController) =>
            _buildSlidingPanel(scrollController),
        body: Container(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 80,
                child: Center(
                  child: Text(
                    'List element $index',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSlidingPanel(ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      children: [
        const SizedBox(
          height: 50,
          child: Center(
            child: Text(
              'Drag button',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        SizedBox(
          height: 400,
          child: ListView(
            children: [
              Container(
                height: 100,
                color: Colors.grey[300],
                child: const Center(
                  child: Text(
                    'First Widget',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        SizedBox(
                          height: 60,
                          child: Center(child: Text('Tab 1')),
                        ),
                        SizedBox(
                          height: 60,
                          child: Center(child: Text('Tab 2')),
                        ),
                      ],
                    ),
                    TabBarView(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: 100,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('Tab 1 Item $index'),
                            );
                          },
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: 100,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('Tab 2 Item $index'),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
