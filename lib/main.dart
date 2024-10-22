import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Widgets/MyApplication.dart';
import 'Widgets/Network.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Counter(),
        )
      ],
      child: MyApp(),
    ),
  );
}
