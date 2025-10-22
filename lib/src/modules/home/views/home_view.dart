import 'package:dependents_repository/dependents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_repository/medicins_repository.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:medicins_schedules/src/blocs/get_dependents/get_dependents_bloc.dart';
import 'package:medicins_schedules/src/blocs/get_medicins/get_medicins_bloc.dart';
import 'package:medicins_schedules/src/blocs/get_plans/get_plans_bloc.dart';
import 'package:medicins_schedules/src/components/dashboard/view_base.dart';
import 'package:medicins_schedules/src/modules/home/blocs/get_alerts/get_alerts_bloc.dart';
import 'package:medicins_schedules/src/modules/home/views/alerts_card.dart';
import 'package:medicins_schedules/src/modules/home/views/dependents_card.dart';
import 'package:medicins_schedules/src/modules/home/views/schedules_card.dart';
import 'package:planning_repository/planning_repository.dart';
import 'package:user_repository/user_repository.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? selectedDependent;
  DateTime currentDate = DateTime.now();

  void _onChangeDate(DateTime newDate) {
    setState(() {
      currentDate = newDate;
    });
  }

  onSelectDependent(String? val) {
    if (selectedDependent != val) {
      setState(() {
        selectedDependent = val;
      });
    }
  }

  @override
  void initState() {
    final user = context.read<AuthenticationBloc>().state.user!;
    bool isDependent = MyUserRole.dependent == user.role;

    if (isDependent) {
      selectedDependent = user.id;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.user!;

    getPlanningRepo() async {
      if (user.role == MyUserRole.dependent) {
        return await FirebasePlanningRepo.initWithoutDependent(user.id);
      } else {
        return FirebasePlanningRepo(
          dependentId: selectedDependent,
          userId: user.id,
        );
      }
    }

    getMedicinsRepo() async {
      if (user.role == MyUserRole.dependent) {
        return await FirebaseMedicinsRepo.initWithoutDependent(user.id);
      } else {
        return FirebaseMedicinsRepo(
          dependentId: selectedDependent,
          userId: user.id,
        );
      }
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  GetDependentsBloc(FirebaseDependentsRepo(userId: user.id)),
        ),
      ],
      child: DashboardViewBase(
        screenTitle: "Home",
        screenSubtitle: "Welcome ${user.name}",
        children: [
          if (user.role == MyUserRole.caregiver)
            HomeDependentsCard(
              selectedDependent: selectedDependent,
              onSelectDependent: onSelectDependent,
            ),

          if (selectedDependent != null || user.role == MyUserRole.dependent)
            FutureBuilder(
              key: ValueKey(
                "alerts-${user.id}-${selectedDependent.toString()}",
              ),
              future: getPlanningRepo(),
              builder:
                  (
                    BuildContext planningContext,
                    AsyncSnapshot<FirebasePlanningRepo> planningSnapshot,
                  ) => FutureBuilder(
                    future: getMedicinsRepo(),
                    builder: (
                      BuildContext medicinsContext,
                      AsyncSnapshot<FirebaseMedicinsRepo> medicinsSnapshot,
                    ) {
                      if (planningSnapshot.hasData &&
                          medicinsSnapshot.hasData) {
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              key: ValueKey(selectedDependent),
                              create:
                                  (context) =>
                                      GetAlertsBloc(planningSnapshot.data!),
                            ),
                            BlocProvider(
                              create:
                                  (context) =>
                                      GetMedicinsBloc(medicinsSnapshot.data!)
                                        ..add(GetMedicins()),
                            ),
                          ],
                          child: HomeAlertsCard(
                            dependentId: selectedDependent!,
                            userId: user.id,
                            plRepo: planningSnapshot.data!,
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
            ),

          if (selectedDependent != null || user.role == MyUserRole.dependent)
            FutureBuilder(
              key: ValueKey(
                "schedules-${user.id}-${selectedDependent.toString()}",
              ),
              future: getPlanningRepo(),
              builder:
                  (
                    BuildContext planningContext,
                    AsyncSnapshot<FirebasePlanningRepo> planningSnapshot,
                  ) => FutureBuilder(
                    future: getMedicinsRepo(),
                    builder: (
                      BuildContext medicinsContext,
                      AsyncSnapshot<FirebaseMedicinsRepo> medicinsSnapshot,
                    ) {
                      if (planningSnapshot.hasData &&
                          medicinsSnapshot.hasData) {
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              key: ValueKey(selectedDependent),
                              create:
                                  (context) =>
                                      GetPlansBloc(planningSnapshot.data!)
                                        ..add(GetPlans(currentDate)),
                            ),
                            BlocProvider(
                              create:
                                  (context) =>
                                      GetMedicinsBloc(medicinsSnapshot.data!)
                                        ..add(GetMedicins()),
                            ),
                          ],
                          child: HomeSchedulesCard(
                            currentDate: currentDate,
                            onSelectDate: _onChangeDate,
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
            ),
        ],
      ),
    );
  }
}
