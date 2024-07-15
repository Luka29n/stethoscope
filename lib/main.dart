import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    child: Text("Wich service \ndo you need ?",style: GoogleFonts.poppins(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.red[400]),),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(onPressed:() => print("hte"), icon: const Icon(Icons.settings),iconSize: 40,),
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
        child: const Icon(Icons.bluetooth,),
        onPressed: () => print("reg"),
      ),
    );
  }
}
