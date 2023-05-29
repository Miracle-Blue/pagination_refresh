import 'package:flutter/material.dart';

import 'models/user_model.dart';
import 'service/network.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.green,
            title: const Text("GridView"),
          ),
          body: const GridViewExample(),
        ),
      );
}

class GridViewExample extends StatefulWidget {
  const GridViewExample({super.key});

  @override
  State<GridViewExample> createState() => _GridViewExampleState();
}

class _GridViewExampleState extends State<GridViewExample> {
  List<User> items = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    Network().get(Api.baseUrl, Api.user.path).then((value) {
      items = Network().parseAllUsers(value);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 300,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) => ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ColoredBox(
            color: Colors.primaries[i % 18],
            child: GridTile(
              header: Image.network(items[i].image ?? ''),
              child: Align(
                alignment: const Alignment(0, .5),
                child: Text(
                  "${items[i].firstName} ${items[i].lastName}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
