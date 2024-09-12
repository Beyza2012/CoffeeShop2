import 'package:coffee_shop/buymenu.dart';
import 'package:coffee_shop/navigationbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:timezone/data/latest.dart' as tz;
import 'coffees.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  DateTime scheduledTime = DateTime.now().add(Duration(seconds: 30));

  // Nesnemizi oluşturduk
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future initialize() async {
    // Bildirim ikonu belirttik.
    const androidInitialize =
    AndroidInitializationSettings('mipmap/ic_launcher');
    const initializationsSettings =
    InitializationSettings(android: androidInitialize);

    // Paketimizi bildirim ikonu belirttikten sonra başlattık.
    await _notifications.initialize(initializationsSettings);
  }

  // Bildirimimizle ilgili tüm ayarları çağırmak üzere burada belirttik.
  static Future _notificationDetails() async => const NotificationDetails(
    android: AndroidNotificationDetails(
      "GunSayaci",
      "day_counterr_1",
      importance: Importance.max,
    ),
  );

  // Normal bildirim gösterme.
  static Future showNotification({
    int id = 0,
    required String title,
    required String body,
    required String payload, // bildirime extra veri eklemek istersek
  }) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payload);
//zamanlı bildirim
  static Future scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDateTime,
  }) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          // TimeZone paketiyle DateTime objesini TZDateTime'e dönüştürdük.
          tz.TZDateTime.from(scheduledDateTime, tz.local),
          await _notificationDetails(),
          // Bildirim tipini burada alarm olarak belirledik.
          androidScheduleMode: AndroidScheduleMode.alarmClock,
          // Bildirim zamanını absolute (gmt) zaman dilimi olarak belirledik.
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);

  // Tüm zamanlanmış fonksiyonları iptal etme.
  static Future unScheduleAllNotifications() async =>
      await _notifications.cancelAll();


  @override
  void initState() {
    super.initState();
    initialize();
    tz.initializeTimeZones();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
          scrollDirection: Axis.vertical,
              children:[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 535,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("resimler/bigcoffee.png"), fit:BoxFit.fill,
                      )
                  ),
                  child: Stack(
                      clipBehavior: Clip.none,
                      children:[
                        Positioned(
                          height: 1000,
                          top: 534,
                          left: 0,
                          right: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 800,
                            color: Colors.black,
                            child:Stack(
                              clipBehavior: Clip.none,
                              children:[
                                Positioned(
                                  top:-100,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 73),
                                    child: Column(
                                      children: [
                                        Text("Coffee so good,",style:TextStyle(fontSize:40,color: Colors.white),textAlign: TextAlign.center,
                                        ),
                                        Text("your taste buds",style:TextStyle(fontSize:40,color: Colors.white),textAlign: TextAlign.center,
                                        ),
                                        Text("will love it.",style:TextStyle(fontSize:40,color: Colors.white),textAlign: TextAlign.center,
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: Stack(
                        clipBehavior: Clip.none,
                      children:[
                        Positioned(
                        bottom: -10,
                        left: 140,
                        child: ElevatedButton(
                          onPressed: () {
                            //showNotification(title: 'Başlık', body: 'body', payload: 'meraba',);
                            scheduleNotification(title: 'Coffee Sale',body:'There is a 50% discount in the basket' ,scheduledDateTime: scheduledTime);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BarMenu()));
                          },
                          style: ElevatedButton.styleFrom(
                            //primary: const Color.fromRGBO(198, 124, 78, 1),
                            //onPrimary: Colors.white,
                          ),
                          child: Text("Get Started"),
                        ),
                      ),]
                    ),
                  ),
                ),

              ]

      ),
    );
  }
}
