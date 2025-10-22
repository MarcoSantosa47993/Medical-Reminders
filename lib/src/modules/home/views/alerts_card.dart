import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_repository/medicins_repository.dart';
import 'package:medicins_schedules/src/blocs/get_medicins/get_medicins_bloc.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/modules/home/blocs/get_alerts/get_alerts_bloc.dart';
import 'package:medicins_schedules/src/modules/home/blocs/handle_alert/handle_alert_bloc.dart';
import 'package:medicins_schedules/src/modules/home/components/alert_item.dart';
import 'package:planning_repository/planning_repository.dart';

class HomeAlertsCard extends StatefulWidget {
  final String dependentId;
  final String userId;
  final PlanningRepository plRepo;
  const HomeAlertsCard({
    super.key,
    required this.dependentId,
    required this.userId,
    required this.plRepo,
  });

  @override
  State<HomeAlertsCard> createState() => _HomeAlertsCardState();
}

class _HomeAlertsCardState extends State<HomeAlertsCard> {
  void refetchData() {
    context.read<GetAlertsBloc>().add(GetAlerts());
  }

  @override
  void initState() {
    super.initState();
    refetchData();
  }

  @override
  void didUpdateWidget(covariant HomeAlertsCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.dependentId != widget.dependentId) {
      //refetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAlertsBloc, GetAlertsState>(
      builder: (context, state) {
        return DashboardCard(
          flex: 4,
          children: [
            DashboardCardTitle(
              title: "Alerts",
              action: TextButton.icon(
                onPressed: refetchData,
                label: Icon(Icons.refresh),
              ),
            ),
            SizedBox(height: 20),
            switch (state) {
              GetAlertsInitial() => loadingContent(),

              GetAlertsLoading() => loadingContent(),

              GetAlertsSuccess() => successContent(state.plans),

              GetAlertsFailure() => failureContent(),
            },
          ],
        );
      },
    );
  }

  Widget loadingContent() {
    return Center(child: CircularProgressIndicator());
  }

  Widget failureContent() {
    return Column(
      children: [
        Text("Error on get dependent's alerts"),
        TextButton(onPressed: refetchData, child: Text("Refetch alerts")),
      ],
    );
  }

  Widget successContent(List<Planning> plans) {
    return BlocBuilder<GetMedicinsBloc, GetMedicinsState>(
      builder: (context, state) {
        String castToName(String medicineId) {
          if (state is GetMedicinsSuccess) {
            return state.medicins
                .singleWhere(
                  (e) => e.id == medicineId,
                  orElse: () => Medicin.empty(),
                )
                .name;
          }

          return "N/A";
        }

        return Column(
          children:
              plans.isEmpty
                  ? [emptyListContent()]
                  : plans
                      .map(
                        (element) => BlocProvider(
                          create: (context) => HandleAlertBloc(widget.plRepo),
                          child: AlertItem(
                            item: element,
                            castToName: castToName,
                          ),
                        ),
                      )
                      .toList(),
        );
      },
    );
  }

  Widget emptyListContent() {
    return Column(
      children: [
        Text("No alerts founded"),
        TextButton(onPressed: refetchData, child: Text("Refetch alerts")),
      ],
    );
  }
}
