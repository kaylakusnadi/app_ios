import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/services/api_service.dart';
import 'presentation/bloc/user_bloc.dart';
import 'presentation/pages/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ApiService(),
      child: BlocProvider(
        create: (context) => UserBloc(context.read<ApiService>()),
        child: MaterialApp(
          title: 'GitHub Mini App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
          home: const DashboardPage(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}