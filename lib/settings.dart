import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'utils.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          ListTile(leading: const CircleAvatar(child: Icon(Icons.bluetooth),),
          title: Text("Bluetooth Permission"),
          subtitle: Text("Allow Bluetooth to connect to the device"),
          onTap: () => requestPermission(permission: Permission.bluetooth),
          ),
        ],
      ),
    );
  }
}
