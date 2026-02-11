import 'package:flutter/material.dart';
import 'package:drawer_auth/views/second_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Accueil'),
            onTap: () {
              Navigator.pop(context); // Ferme le drawer
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          ListTile(
            leading: Icon(Icons.pages),
            title: Text('Deuxième Page'),
            onTap: () {
              Navigator.pop(context); // Ferme le drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
