import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:medicins_schedules/src/modules/auth/views/welcome_view.dart';
import 'package:medicins_schedules/src/modules/base/views/base_view.dart';
import 'package:medicins_schedules/src/modules/dependents/views/dependents_view.dart';
import 'package:medicins_schedules/src/modules/health/views/health_view.dart';
import 'package:medicins_schedules/src/modules/home/views/home_view.dart';
import 'package:medicins_schedules/src/modules/medicins/views/medicins_view.dart';
import 'package:medicins_schedules/src/modules/planning/views/planning_view.dart';
import 'package:medicins_schedules/src/modules/profile/views/profile_view.dart';
import 'package:medicins_schedules/src/modules/receipts/views/receips_view.dart';
import 'package:medicins_schedules/src/modules/splash/views/splash_screen.dart';
import 'package:medicins_schedules/src/routes/listeners.dart';

part 'paths.dart';

final _navKey = GlobalKey<NavigatorState>();

GoRouter router(AuthenticationBloc authBloc) {
  return GoRouter(
    navigatorKey: _navKey,
    initialLocation: Paths.splash.route,
    refreshListenable: StreamToListenable([authBloc.stream]),
    redirect: (context, state) {
      final isUnkown = authBloc.state.status == AuthenticationStatus.unknown;
      final isAuthenticated =
          authBloc.state.status == AuthenticationStatus.authenticated;
      final isUnauthenticated =
          authBloc.state.status == AuthenticationStatus.unauthenticated;

      if (isUnkown && state.matchedLocation != Paths.splash.fullRoute) {
        return Paths.splash.fullRoute;
      } else if (isAuthenticated &&
          (state.matchedLocation == Paths.splash.fullRoute ||
              state.matchedLocation == Paths.login.fullRoute)) {
        return Paths.home.fullRoute;
      } else if (isUnauthenticated &&
          !state.matchedLocation.contains(Paths.login.fullRoute)) {
        return Paths.login.fullRoute;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: Paths.splash.route,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Paths.login.route,
        builder: (context, state) => const WelcomeView(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => BaseView(navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Paths.home.route,
                builder: (context, state) => const HomeView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Paths.dependents.route,
                builder: (context, state) => const DependentsView(),
                routes: [
                  GoRoute(
                    path: Paths.receips.route,
                    builder: (context, state) {
                      final dependentId = state.extra as String?;
                      return ReceipsView(dependentId: dependentId);
                    },
                  ),
                  GoRoute(
                    path: Paths.medicins.route,
                    builder: (context, state) {
                      final dependentId = state.extra as String?;
                      return MedicinsView(dependentId: dependentId);
                    },
                  ),
                  GoRoute(
                    path: Paths.planning.route,
                    builder: (context, state) {
                      final dependentId = state.extra as String;
                      return PlanningView(dependentId: dependentId);
                    },
                  ),
                  GoRoute(
                    path: Paths.health.route,
                    builder: (context, state) {
                      final dependentId = state.extra as String;
                      return HealthView(dependentId: dependentId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Paths.profile.route,
                builder: (context, state) => const ProfileView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
