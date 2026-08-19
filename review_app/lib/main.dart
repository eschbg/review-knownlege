import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/roadmap_bloc.dart';
import 'bloc/roadmap_event.dart';
import 'core/theme/app_theme.dart';
import 'screens/main_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TechMasteryApp());
}

class TechMasteryApp extends StatelessWidget {
  const TechMasteryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoadmapBloc()..add(LoadRoadmapData()),
      child: MaterialApp(
        title: 'Tech Mastery Review Hub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainLayout(),
      ),
    );
  }
}
