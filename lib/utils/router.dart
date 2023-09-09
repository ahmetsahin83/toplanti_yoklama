import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../view/home/home_view.dart';
import '../view/attendance/attendance_view.dart';
import '../view/login/login_view.dart';
import '../view/meeting/meeting_view.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: "/home",
      name: "home",
      builder: (context, state) => const Home(),
      routes: [
        GoRoute(name: "meeting", path: "meeting", builder: (context, state) => const MeetingView(), routes: [
          GoRoute(
            path: "attendance",
            name: "attendance",
            builder: (context, state) {
              return AttendanceView(meetingId: state.extra as int);
            },
          )
        ]),
      ],
    ),
    GoRoute(path: "/login", name: "login", builder: (context, state) => const LoginView())
  ],
  initialLocation: "/home",
  redirect: (context, state) {
    if (Supabase.instance.client.auth.currentSession == null) {
      return "/login";
    } else {
      return state.fullPath;
    }
  },
);
