import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreenAD extends StatefulWidget {
  const HomeScreenAD({Key? key}) : super(key: key);

  @override
  _HomeScreenADState createState() => _HomeScreenADState();
}

class _HomeScreenADState extends State<HomeScreenAD> {
  @override
  Widget build(BuildContext context) {
    // to get size
    var size = MediaQuery.of(context).size;
    //style
    var cardTextStyle = TextStyle(
      fontFamily: 'Montserat Regular',
      fontSize: 16,
      color: Color.fromRGBO(63, 63, 63, 1),
    );

    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: size.height * .3,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/images/mobile_1.png'),
                  fit: BoxFit.fill)),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  height: 64,
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_960_720.png'),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text(
                            'Anwar Kedir',
                            style: TextStyle(
                                fontFamily: 'Montserrat Medium',
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          const Text(
                            '14806798',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Montserrat Regular'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    primary: false,
                    crossAxisCount: 2,
                    children: <Widget>[
                      //Card 1
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            /*  SvgPicture.network(
                              'https://www.svgrepo.com/show/125846/graduate.svg',
                              height: 128,
                            ), */
                            SvgPicture.asset(
                              'assets/images/info.svg',
                              height: 80,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'New Employee',
                                style: cardTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
