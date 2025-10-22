import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/modules/receipts/blocs/adjust_stock/adjust_stock_bloc.dart';
import 'package:medicins_schedules/src/modules/receipts/blocs/get_receipt/get_receipt_state.dart';
import 'package:medicins_schedules/src/modules/receipts/blocs/get_receipts/get_receipts_event.dart';

import 'package:medicins_schedules/src/modules/receipts/forms/receip_data_form.dart';

import 'package:medicins_schedules/src/modules/receipts/blocs/get_receipt/get_receipt_bloc.dart';
import 'package:medicins_schedules/src/modules/receipts/blocs/get_receipt/get_receipt_event.dart';

import 'package:medicins_schedules/src/modules/receipts/blocs/get_receipts/get_receipts_bloc.dart';

import 'package:medicins_schedules/src/modules/receipts/blocs/add_receipt/add_receipt_bloc.dart';

import 'package:receipts_repository/src/firebase_receipts_repo.dart';

import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';

class ReceipFormsCard extends StatefulWidget {
  final String? receiptId;
  final String? dependentId;
  final bool isCreating;
  final VoidCallback onDeletedReceipt;

  const ReceipFormsCard({
    Key? key,
    required this.receiptId,
    required this.dependentId,
    required this.isCreating,
    required this.onDeletedReceipt,
  }) : super(key: key);

  @override
  State<ReceipFormsCard> createState() => _ReceipFormsCardState();
}

class _ReceipFormsCardState extends State<ReceipFormsCard> {
  final _createFormKey = GlobalKey<ReceipDataFormState>();

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthenticationBloc>().state.user!.id;
    final depId = widget.dependentId!;
    final receiptRepo = FirebaseReceiptsRepo(
      userId: userId,
      dependentId: depId,
    );

    if (!widget.isCreating && widget.receiptId == null) {
      return DashboardCard(
        flex: 8,
        children: const [
          SizedBox(height: 60),
          Icon(Icons.receipt_long, size: 48, color: Colors.grey),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Select a recipes to view/edit",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      );
    }

    if (widget.isCreating) {
      return DashboardCard(
        flex: 8,
        children: [
          const SizedBox(height: 30),
          const DashboardCardTitle(title: 'New Recipe'),
          const SizedBox(height: 20),
          BlocProvider(
            create: (_) => AddReceiptBloc(repository: receiptRepo),
            child: BlocProvider(
              create: (_) => AdjustStockBloc(receiptRepo),
              child: BlocListener<AddReceiptBloc, AddReceiptState>(
                listener: (context, state) {
                  if (state is AddReceiptSuccess) {
                    context.read<GetReceiptsBloc>().add(const LoadReceipts());
                    _createFormKey.currentState?.resetForm();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Recipe created successfully!'),
                      ),
                    );
                  }
                },
                child: ReceipDataForm(
                  key: _createFormKey,
                  isNew: true,
                  receiptId: null,
                  onReceiptDeleted: widget.onDeletedReceipt,
                ),
              ),
            ),
          ),
        ],
      );
    }

    final rId = widget.receiptId!;
    return DashboardCard(
      flex: 8,
      children: [
        const SizedBox(height: 30),
        const DashboardCardTitle(title: 'Recipe Data'),
        const SizedBox(height: 20),
        MultiBlocProvider(
          providers: [
            BlocProvider<AddReceiptBloc>(
              create: (_) => AddReceiptBloc(repository: receiptRepo),
            ),
            BlocProvider<GetReceiptBloc>(
              key: ValueKey(rId),
              create:
                  (_) =>
                      GetReceiptBloc(repository: receiptRepo)
                        ..add(LoadReceipt(receiptId: rId)),
            ),
            BlocProvider<AdjustStockBloc>(
              create: (_) => AdjustStockBloc(receiptRepo),
            ),
          ],
          child: BlocListener<AddReceiptBloc, AddReceiptState>(
            listener: (context, state) {
              if (state is AddReceiptSuccess) {
                context.read<GetReceiptsBloc>().add(const LoadReceipts());
                context.read<GetReceiptBloc>().add(LoadReceipt(receiptId: rId));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recipe updated successfully!')),
                );
              }
            },
            child: ReceipDataForm(
              key: ValueKey(rId),
              isNew: false,
              receiptId: rId,
              onReceiptDeleted: widget.onDeletedReceipt,
            ),
          ),
        ),
      ],
    );
  }
}
