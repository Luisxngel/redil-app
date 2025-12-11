import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/members/domain/entities/member.dart';
import 'features/members/presentation/bloc/members_bloc.dart';
import 'features/members/presentation/pages/member_form_page.dart';
import 'features/members/presentation/pages/members_page.dart';
import 'features/members/presentation/pages/trash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<MembersBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Redil',
        theme: AppTheme.theme,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MembersPage(),
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => const MemberFormPage(),
    ),
    GoRoute(
      path: '/edit',
      builder: (context, state) {
        final member = state.extra as Member;
        return MemberFormPage(member: member);
      },
    ),
    GoRoute(
      path: '/trash',
      builder: (context, state) => const TrashPage(),
    ),
  ],
);
