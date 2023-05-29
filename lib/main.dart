import 'package:flutter/material.dart';

import 'models/user_model.dart';
import 'service/network.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const GridViewExample(),
      );
}

class GridViewExample extends StatefulWidget {
  const GridViewExample({super.key});

  @override
  State<GridViewExample> createState() => _GridViewExampleState();
}

class _GridViewExampleState extends State<GridViewExample> {
  int page = 0;
  int limit = 10;
  int total = 0;
  bool isLoading = false;

  List<User> items = [];
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    getData();
    pagination();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void getData() async {
    setState(() => isLoading = true);

    Network().get(
      Api.baseUrl,
      Api.user.path,
      query: {"limit": "$limit", "skip": "${page * limit}"},
    ).then((value) {
      final baseResponse = Network().parseUsers(value);
      total = baseResponse.total;
      items.addAll(baseResponse.users);

      setState(() => isLoading = false);
    });
  }

  void pagination() async {
    scrollController.addListener(() {
      if (page * limit <= total && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        print("""
-------------------------------------------
pixels - ${scrollController.position.pixels}
maxScrollExtent - ${scrollController.position.maxScrollExtent}
-------------------------------------------""");

        page++;
        getData();
      }
    });
  }

  Future<void> _refresh() async {
    await scrollController.animateTo(
      0,
      duration: const Duration(seconds: 2),
      curve: Curves.linear,
    );

    page = 0;
    items = [];

    getData();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green,
          title: const Text("GridView"),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: Stack(
            children: [
              GridView.builder(
                controller: scrollController,
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
              ),
              if (isLoading)
                const Align(
                  alignment: Alignment(0, .9),
                  child: CircularProgressIndicator(
                    color: Colors.red,
                    strokeWidth: 5,
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton:
            (total != 0 && items.length == total && scrollController.position.pixels == scrollController.position.maxScrollExtent)
                ? FloatingActionButton(
                    onPressed: _refresh,
                    child: const Icon(
                      Icons.refresh,
                    ),
                  )
                : null,
      );
}
