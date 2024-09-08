import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothPairPage extends StatefulWidget {
  const BluetoothPairPage({Key? key}) : super(key: key);

  @override
  _BluetoothPairPageState createState() => _BluetoothPairPageState();
}

class _BluetoothPairPageState extends State<BluetoothPairPage> {
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  @override
  void initState() {
    super.initState();
    _startScan(); // Start scanning when the page is initialized
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }

  void _startScan() async {
    if (_isScanning) return; // Prevent multiple simultaneous scans

    setState(() {
      _isScanning = true;
      _scanResults.clear();
    });

    try {
      // Cancel any existing subscription
      await _scanSubscription?.cancel();
      
      // Start the scan
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 1));
      
      // Listen for scan results
      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        setState(() {
          _scanResults = results;
        });
      });

      // Wait for the scan to complete
      await FlutterBluePlus.isScanning.where((val) => val == false).first;
    } catch (e) {
      print('Error during scan: $e');
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connected to ${device.name}")),
      );
    } catch (e) {
      print('Error connecting to device: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to connect to ${device.name}")),
      );
    }
  }

  Future<bool> _requestPermissions() async {
    print("Requesting Bluetooth permissions...");
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    print("Permission statuses: $statuses");

    return statuses.values.every((status) => status.isGranted);
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Pairing"),
      ),
      body: Column(
        children: [const 
          Padding(
            padding:  EdgeInsets.all(16.0),
            child:  Text(
              "named devices",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: _isScanning
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _scanResults.where((result) => result.device.name.isNotEmpty).length,
                    itemBuilder: (context, index) {
                      final namedDevices = _scanResults.where((result) => result.device.name.isNotEmpty).toList();
                      final device = namedDevices[index].device;
                      return ListTile(
                        title: Text(device.name),
                        subtitle: Text(device.id.id),
                        trailing: ElevatedButton(
                          child: Text("Connect"),
                          onPressed: () => _connectToDevice(device),
                        ),
                      );
                    },
                  ),
          ),
          const Padding(
            padding:  EdgeInsets.all(16.0),
            child:  Text(
              "other devices",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _isScanning
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _scanResults.where((result) => result.device.name.isEmpty).length,
                    itemBuilder: (context, index) {
                      final noNameDevices = _scanResults.where((result) => result.device.name.isEmpty).toList();
                      final device = noNameDevices[index].device;
                      return ListTile(
                        title: const Text("Unnamed Device"),
                        subtitle: Text(device.id.id),
                        trailing: ElevatedButton(
                          child: const Text("Connect"),
                          onPressed: () => _connectToDevice(device),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(_isScanning ? Icons.stop : Icons.refresh),
        onPressed: _isScanning ? null : _startScan,
      ),
    );
  }
}