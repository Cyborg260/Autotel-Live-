import 'package:flutter/material.dart';

class Locations extends StatelessWidget {
  const Locations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Status Dashboard',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => Padding(
                padding:
                    //padding for main stack for print
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Stack(
                  //alignment: Alignment.topLeft,
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 36),
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            color: const Color(0x4d9e9e9e), width: 1),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 1,
                            color: Color.fromARGB(255, 155, 150, 150),
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.local_parking,
                              color: Color.fromARGB(255, 98, 120, 247),
                              size: 18,
                            ),
                            const Icon(
                              Icons.wifi,
                              color: Colors.orange,
                              size: 18,
                            ),
                            const Icon(
                              Icons.key_sharp,
                              color: Colors.red,
                              size: 18,
                            ),
                            const Icon(
                              Icons.battery_charging_full_outlined,
                              color: Colors.brown,
                              size: 18,
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.battery_3_bar_sharp,
                                  color: Colors.green,
                                  size: 18,
                                ),
                                Text('67%')
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      padding: EdgeInsets.zero,
                      width: MediaQuery.of(context).size.width,
                      height: 95,
                      decoration: BoxDecoration(
                        color: index == 2
                            ? const Color.fromARGB(255, 206, 248, 205)
                            : Color.fromARGB(255, 250, 208, 208),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                            color: const Color(0x4d9e9e9e), width: 1),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 5,
                            color: Color.fromARGB(255, 175, 172, 172),
                            offset: Offset.zero,
                            blurStyle: BlurStyle.normal,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                  child: Image(
                                    fit: BoxFit.contain,
                                    image: AssetImage(
                                        "assets/images/Circle-icons-car.svg.png"),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '$index h',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'BTY-997',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '20:00 pm , 15-nov-2022',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Manzooe Colony , karachi sas as as   as as a s a sa as as as adadcs ds ds sds sd sdsdsds sdsd sd sds',
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$index\nkm/h',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
