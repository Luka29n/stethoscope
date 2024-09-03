import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'utils.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}



class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text("Wich service \ndo you need ???",style: GoogleFonts.poppins(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.red[400]),),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    },
                    icon: const Icon(Icons.settings),
                    iconSize: 40,
                  ),
                )
              ],
            )),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(87, 114, 105, 111),
                      ),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20,right: 20),
                            child: Image(image: AssetImage("assets/pictures/hearth.png")),
                          ),
                          Text("BPM",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.grey.shade900))
                        ],
                      )),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(87, 114, 105, 111),
                      ),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20,right: 20),
                            child: Image(image: AssetImage("assets/pictures/ecg.png")),
                          ),
                          Text("ECG",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.grey.shade900))
                        ],
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(15, 114, 105, 111),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20,right: 20),
                              child: Image(image: AssetImage("assets/pictures/travaux.png")),
                            ),
                            Text("IN WORK!",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.grey.shade900))
                        ],
                      )),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(15, 114, 105, 111),
                      ),
                                              child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20,right: 20),
                              child: Image(image: AssetImage("assets/pictures/travaux.png")),
                            ),
                            Text("IN WORK!",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.grey.shade900))
                        ],
                      )),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.bluetooth),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BluetoothPairPage()),
          );
        },
      ),
    );
  }
}



class BluetoothPairPage extends StatefulWidget {
  const BluetoothPairPage({Key? key}) : super(key: key);

  @override
  _BluetoothPairPageState createState() => _BluetoothPairPageState();
}

class _BluetoothPairPageState extends State<BluetoothPairPage> {
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() async {
    setState(() {
      _isScanning = true;
      _scanResults.clear();
    });

    try {
      await FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
      FlutterBluePlus.scanResults.listen((results) {
        setState(() {
          _scanResults = results;
        });
      });
    } catch (e) {
      print('Error starting scan: $e');
    }

    setState(() {
      _isScanning = false;
    });
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
        title: Text("Bluetooth Pairing"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Available Devices",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _isScanning
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _scanResults.length, 
                    itemBuilder: (context, index) {
                      final device = _scanResults[index].device;
                      return ListTile(
                        title: Text(device.name.isNotEmpty ? device.name : "Unknown Device"),
                        subtitle: Text(device.id.id),
                        trailing: ElevatedButton(
                          child: Text("Connect"),
                          onPressed: () => _connectToDevice(device),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: _startScan,
      ),
    );
  }
}

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


