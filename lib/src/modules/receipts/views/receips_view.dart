import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';

import 'package:medicins_schedules/src/modules/receipts/blocs/get_receipts/get_receipts_bloc.dart';
import 'package:medicins_schedules/src/modules/receipts/blocs/get_receipts/get_receipts_event.dart';
import 'package:medicins_schedules/src/modules/receipts/blocs/get_receipts/get_receipts_state.dart';

import 'package:receipts_repository/src/firebase_receipts_repo.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';

import 'package:medicins_schedules/src/modules/receipts/views/receips_card.dart';
import 'package:medicins_schedules/src/modules/receipts/views/forms_card.dart';

class ReceipsView extends StatefulWidget {
  final String? dependentId;
  const ReceipsView({Key? key, required this.dependentId}) : super(key: key);

  @override
  State<ReceipsView> createState() => _ReceipsViewState();
}

class _ReceipsViewState extends State<ReceipsView> {
  String? selectedReceiptId;
  bool isCreating = false;

  void onSelectReceipt(String? val) {
    setState(() {
      if (selectedReceiptId == val) {
        selectedReceiptId = null;
      } else {
        selectedReceiptId = val;
      }
      isCreating = false;
    });
  }

  void onCreateReceipt() {
    setState(() {
      selectedReceiptId = null;
      isCreating = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthenticationBloc>().state;
    final userId = authState.user!.id;
    final userName = authState.user!.name;
    final depId = widget.dependentId!;

    return BlocProvider(
      create:
          (_) => GetReceiptsBloc(
            repository: FirebaseReceiptsRepo(
              userId: userId,
              dependentId: depId,
            ),
          )..add(const LoadReceipts()),
      child: BlocListener<GetReceiptsBloc, GetReceiptsState>(
        listener: (context, state) {
          if (state is GetReceiptsSuccess) {
            final receipts = state.receipts;
            if (selectedReceiptId != null &&
                !receipts.any((r) => r.id == selectedReceiptId)) {
              setState(() {
                selectedReceiptId = null;
                isCreating = false;
              });
            }
          }
        },
        child: DashboardViewBase(
          screenTitle: 'Recipes',
          screenSubtitle: userName,
          showBackbutton: true,
          children: [
            ReceipsCard(
              selectedReceipt: selectedReceiptId,
              onSelectReceipt: onSelectReceipt,
              onCreateReceipt: onCreateReceipt,
              dependentId: depId,
            ),
            const SizedBox(height: 20),
            ReceipFormsCard(
              key: ValueKey('${selectedReceiptId ?? "new"}-$isCreating'),
              receiptId: selectedReceiptId,
              dependentId: depId,
              isCreating: isCreating,
              onDeletedReceipt: () {
                setState(() {
                  selectedReceiptId = null;
                  isCreating = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
