import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScrean extends StatefulWidget {
  const HomeScrean({Key? key}) : super(key: key);

  @override
  State<HomeScrean> createState() => _HomeScreanState();
}

class _HomeScreanState extends State<HomeScrean> {
  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
        ),
        title: const Text(
          'Todo App',
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add_outlined,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              currentIndex = index;
              print(currentIndex);
            });
          },
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'New Task'),
            BottomNavigationBarItem(
              icon: Icon(Icons.done_all_outlined),
              label: 'Done',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.archive),
                label: 'Archived',

            ),
          ]),

      // body: Column(
      //   children: [

      //   ],
      // ),
    );
  }
}
