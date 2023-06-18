import 'package:flutter/material.dart';
import 'package:NUSLiving/utilities/myFunctions.dart';
import 'package:NUSLiving/screens/home.dart';
import 'package:NUSLiving/screens/user_screens/profile.dart';
import 'package:NUSLiving/models/task.dart';
import 'package:NUSLiving/screens/tasks_screens/tasks.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({required this.uid, super.key});
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      width: 200,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(height: 40),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () async {
              final navigator = Navigator.of(context);
              var user = await MyFunctions.getUser(uid);
              navigator.push(
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                    user: user,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () async {
              final navigator = Navigator.of(context);
              var tasks = await MyFunctions.getUserTasks(uid);
              navigator.pushReplacement(
                MaterialPageRoute(
                  builder: (_) => Home(
                    uid: uid,
                    myTasks: tasks,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text('Tasks'),
            onTap: () async {
              final navigator = Navigator.of(context);
              var tasks = await MyFunctions.getAllTasks();
              navigator.push(
                MaterialPageRoute(
                    builder: (_) => TasksScreen(currentTasks: tasks, uid: uid)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Bookings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
