import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';

class BPM extends StatefulWidget {
  const BPM({super.key});

  @override
  State<BPM> createState() => _BPMState();
}

class _BPMState extends State<BPM> {
  bool _isConnected = false;
  int _bpm = 0;
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _characteristic;

  @override
  void initState() {
    super.initState();
    _checkConnectionStatus();
  }

  void _checkConnectionStatus() async {
    List<BluetoothDevice> connectedDevices = await FlutterBluePlus.connectedDevices;
    if (connectedDevices.isNotEmpty) {
      setState(() {
        _isConnected = true;
        _connectedDevice = connectedDevices.first;
      });
      _startListeningToBPM();
    }
  }

  void _startListeningToBPM() async {
    print('Starting to listen for BPM');
    List<BluetoothService> services = await _connectedDevice!.discoverServices();
    print('Discovered ${services.length} services');
    for (BluetoothService service in services) {
      print('Checking service ${service.uuid}');
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        print('Checking characteristic ${characteristic.uuid}');
        if (characteristic.uuid.toString() == '00000001-5ec4-4083-81cd-a10b8d5cf6ec') {
          _characteristic = characteristic;
          await _characteristic!.setNotifyValue(true);
          _characteristic!.value.listen((value) {
            if (value.isNotEmpty) {
              String rawString = String.fromCharCodes(value);
              print('Raw value: $rawString');
              
              setState(() {
                // Parse the string to a double, then round to an integer
                _bpm = double.parse(rawString).round();
              });
              
              print('Parsed BPM: $_bpm');
            } else {
              print('Received empty value');
            }
          });
          print('Listening to characteristic ${characteristic.uuid}');
          break;
        }
      }
      if (_characteristic != null) break;
    }
    if (_characteristic == null) {
      print('Failed to find the BPM characteristic');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fréquence cardiaque",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.grey.shade900)),
      ),
      body: _isConnected
          ? Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 80.0, right: 80.0, top: 0),
                        child: Image(
                          image: AssetImage("assets/pictures/hearth.png"),
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                      ),
                      Text("$_bpm battements/minutes ",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.grey.shade900)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Center(
                    child: Container(
                      child: SfCartesianChart(),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                "Aucun appareil connecté",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.grey),
              ),
            ),
    );
  }
}
