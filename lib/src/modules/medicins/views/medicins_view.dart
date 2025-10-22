import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_repository/medicins_repository.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:medicins_schedules/src/blocs/get_medicins/get_medicins_bloc.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/modules/medicins/views/forms_card.dart';
import 'package:medicins_schedules/src/modules/medicins/views/medicins_card.dart';

class MedicinsView extends StatefulWidget {
  final String? dependentId;
  const MedicinsView({super.key, required this.dependentId});

  @override
  State<MedicinsView> createState() => _MedicinsViewState();
}

class _MedicinsViewState extends State<MedicinsView> {
  String? selectedMedicin;

  onSelectMedicin(String? val) {
    if (selectedMedicin == val) {
      setState(() {
        selectedMedicin = null;
      });
    } else {
      setState(() {
        selectedMedicin = val;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthenticationBloc>().state.user!.id;
    final userName = context.read<AuthenticationBloc>().state.user!.name;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => GetMedicinsBloc(
                FirebaseMedicinsRepo(
                  userId: userId,
                  dependentId: widget.dependentId,
                ),
              )..add(GetMedicins()),
        ),
      ],
      child: DashboardViewBase(
        screenTitle: "Medicins",
        screenSubtitle: userName,
        showBackbutton: true,
        children: [
          MedicinsCard(
            selectedMedicin: selectedMedicin,
            onSelectMedicin: onSelectMedicin,
            dependentId: widget.dependentId,
          ),
          MedicinsFormsCard(
            key: ValueKey(selectedMedicin),
            medicinId: selectedMedicin,
            dependentId: widget.dependentId,
          ),
        ],
      ),
    );
  }
}
