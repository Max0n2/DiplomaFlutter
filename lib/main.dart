import 'package:easy_party/provider/FirebaseAuth.dart';
import 'package:easy_party/provider/FirebaseStorage.dart';
import 'package:easy_party/provider/FirebaseStorageEvent.dart';
import 'package:easy_party/provider/FirebaseStorageUsers.dart';
import 'package:easy_party/provider/FirebaseTest.dart';
import 'package:easy_party/screens/authentication.dart';
import 'package:easy_party/screens/event.dart';
import 'package:easy_party/screens/events.dart';
import 'package:easy_party/screens/select.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FlutterBranchSdk.init();

  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthWrapper();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'events',
          builder: (BuildContext context, GoRouterState state) {
            return const Events();
          },
        ),
        GoRoute(
          path: 'event/:id/:index',
          builder: (BuildContext context, GoRouterState state) {
            final String eventId = state.pathParameters['id']!;
            final int indexValue = int.parse(state.pathParameters['index']!);

            return Event(inviteCode: eventId, indexValue: indexValue);
          },
        ),
        GoRoute(
          path: 'selectpage',
          builder: (BuildContext context, GoRouterState state) {
            return const SelectPage();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthntication()),
        ChangeNotifierProvider(create: (_) => FirebaseStorage()),
        ChangeNotifierProvider(create: (_) => FirebaseStorageUsers()),
        ChangeNotifierProvider(create: (_) => FirebaseEvent()),
        ChangeNotifierProvider(create: (_) => FirebaseTest()),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
