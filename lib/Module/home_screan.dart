import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/Module/archieve/archieve.dart';
import 'package:todo/Module/done/done_screan.dart';
import 'package:todo/Module/new_task/new_task.dart';

class HomeScrean extends StatefulWidget {
  const HomeScrean({Key? key}) : super(key: key);

  @override
  State<HomeScrean> createState() => _HomeScreanState();
}

class _HomeScreanState extends State<HomeScrean> {
  int currentIndex = 0;
  List<String> titles = [
    'New Task',
    'Done Task',
    'Archieve'
  ];

  List<Widget> screans = [
    NewTaskScrean(),
    DoneScrean(),
    ArchieveScrean(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
        ),
        title: Text(
          titles[currentIndex],
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

      body: Column(
        children: [

        ],
      ),
    );
  }
}
