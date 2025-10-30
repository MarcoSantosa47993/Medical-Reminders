import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_repository/health_repository.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/modules/health/blocs/get_healthdata/get_health_bloc.dart';
import 'package:medicins_schedules/src/modules/health/blocs/get_healthdatas/get_health_data_bloc.dart';
import 'package:medicins_schedules/src/modules/health/views/health_data_card.dart';
import 'package:medicins_schedules/src/modules/health/views/healthdata_forms_card.dart';

class HealthView extends StatefulWidget {
  final String dependentId;
  const HealthView({super.key, required this.dependentId});

  @override
  State<HealthView> createState() => _HealthViewState();
}

class _HealthViewState extends State<HealthView> {
  String? selectedHealth;
  DateTime currentDate = DateTime.now();

  void _onChangeDate(DateTime newDate) {
    setState(() {
      currentDate = newDate;
    });
  }

  void _onSelectHealth(String? val) {
    if (selectedHealth != val) {
      setState(() {
        selectedHealth = val;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthenticationBloc>().state.user!.id;
    final userName = context.read<AuthenticationBloc>().state.user!.name;

    return BlocProvider(
      create:
          (context) => GetHealthDataBloc(
            FirebaseHealthRepo(userId: userId, dependentId: widget.dependentId),
          )..add(GetHealthData(currentDate)),
      child: DashboardViewBase(
        screenTitle: "Health Data",
        screenSubtitle: userName,
        showBackbutton: true,
        children: [
          HealthDataCard(
            onSelectHealth: _onSelectHealth,
            selectedHealth: selectedHealth,
            onSelectDate: _onChangeDate,
            selectedDate: currentDate,
            getImage:
                FirebaseHealthRepo(
                  userId: userId,
                  dependentId: widget.dependentId,
                ).getImage,
          ),
          BlocProvider(
            key: ValueKey(selectedHealth),
            create:
                (context) => GetHealthBloc(
                  FirebaseHealthRepo(
                    userId: userId,
                    dependentId: widget.dependentId,
                  ),
                )..add(GetHealth(selectedHealth ?? "")),
            child: HealthdataFormsCard(
              selectedDate: currentDate,
              getImage:
                  FirebaseHealthRepo(
                    userId: userId,
                    dependentId: widget.dependentId,
                  ).getImage,
            ),
          ),
        ],
      ),
    );
  }
}