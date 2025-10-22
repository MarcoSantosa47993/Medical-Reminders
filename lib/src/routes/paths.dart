part of 'routes.dart';

class Paths {
  final String route;
  final String fullRoute;

  const Paths(this.route, this.fullRoute);

  static const Paths login = Paths("/login", "/login");

  static const Paths splash = Paths("/", "/");

  static const Paths home = Paths("/home", "/home");

  static const Paths profile = Paths("/profile", "/profile");

  static const Paths dependents = Paths("/dependents", "/dependents");

  static const Paths receips = Paths("/receips", "/dependents/receips");
  static const Paths medicins = Paths("/medicins", "/dependents/medicins");
  static const Paths planning = Paths("/planning", "/dependents/planning");
  static const Paths health = Paths("/health", "/dependents/health");
}
