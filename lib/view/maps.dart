import 'package:flutter/material.dart';

class Maps extends StatelessWidget {
  const Maps({super.key});

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
        elevation: 0,
        backgroundColor: const Color(0xffefecec),
        centerTitle: false,
      ),
      backgroundColor: const Color(0xffeeeaea),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 20,
              ),
              Stack(
                //alignment: Alignment.topLeft,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                    width: MediaQuery.of(context).size.width,
                    height: 145,
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                      border:
                          Border.all(color: const Color(0x4d9e9e9e), width: 1),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 2,
                          color: Colors.black,
                          offset: Offset.zero,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        Icon(
                          Icons.build,
                          color: Color(0xff212435),
                          size: 20,
                        ),
                        Icon(
                          Icons.wifi_lock,
                          color: Color(0xff212435),
                          size: 20,
                        ),
                        Icon(
                          Icons.wine_bar_outlined,
                          color: Color(0xff212435),
                          size: 20,
                        ),
                        Icon(
                          Icons.key_sharp,
                          color: Colors.green,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    padding: EdgeInsets.zero,
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xfff9bdbd),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                      border:
                          Border.all(color: const Color(0x4d9e9e9e), width: 1),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 2,
                          color: Colors.black,
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
                            children: const [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    'https://images.pexels.com/photos/337909/pexels-photo-337909.jpeg?auto=compress&cs=tinysrgb&w=800'),
                              ),
                              Text(
                                '7h',
                                style: TextStyle(
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                height: 10,
                              ),
                              Text(
                                'Manzooe Colony , karachi kask khaskah kasdsdsdsdsdsdsdsd s sds d sd ',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                '43\nkm/h',
                                textAlign: TextAlign.center,
                                style: TextStyle(
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
            ],
          ),
        ],
      ),
    );
  }
}
