import '/service/provider/app_provider.dart';
import 'package:provider/provider.dart';

import '/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'helper/colors.dart';
import 'helper/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'service/provider/chat_provider.dart';
import 'service/provider/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SaveData.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(
          create: (context) => AppProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (context) => ChatProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: backgroundColor,
              appBarTheme: const AppBarTheme(
                  elevation: 0,
                  backgroundColor: appBarColor,
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  )),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(tabColor),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(tabColor),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.only(left: 25, right: 25),
                  ),
                ),
              ),
            ),
            home: SaveData.getData(key: "goChat") == null ||
                    SaveData.getData(key: "goChat") == false
                ? WelcomeScreen()
                : const HomeScreen(),
          );
        },
      ),
    );
  }
}
