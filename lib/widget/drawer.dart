import 'package:first_flutter/main.dart';
import 'package:flutter/material.dart';

//Drawer
class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            padding: EdgeInsets.only(top: 120.0, left: 15.0),
            decoration: BoxDecoration(
              color: Palette.primary,
            ),
            child: Text(
              'Menu',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
          ListTile(
            title: const Text('首頁'),
            onTap: () {
              Navigator.popAndPushNamed(context, '/');
            },
          ),
          ListTile(
            title: const Text('QR code 掃描器'),
            onTap: () {
              Navigator.popAndPushNamed(context, '/qr_code_scanner');
            },
          ),
        ],
      ),
    );
  }
}
