import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsiveness/responsiveness.dart';

import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/components/form/form.dart';

import 'package:medicins_schedules/src/modules/receipts/blocs/get_receipts/get_receipts_bloc.dart';
import 'package:medicins_schedules/src/modules/receipts/blocs/get_receipts/get_receipts_event.dart';
import 'package:medicins_schedules/src/modules/receipts/blocs/get_receipts/get_receipts_state.dart';

import 'package:medicins_schedules/src/modules/receipts/blocs/add_receipt/add_receipt_bloc.dart';
import 'package:receipts_repository/src/firebase_receipts_repo.dart';

import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';

import 'package:receipts_repository/receipts_repository.dart';

class ReceipsCard extends StatefulWidget {
  final String? selectedReceipt;
  final Function(String?) onSelectReceipt;
  final VoidCallback onCreateReceipt;
  final String dependentId;

  const ReceipsCard({
    Key? key,
    required this.selectedReceipt,
    required this.onSelectReceipt,
    required this.onCreateReceipt,
    required this.dependentId,
  }) : super(key: key);

  @override
  State<ReceipsCard> createState() => _ReceipsCardState();
}

class _ReceipsCardState extends State<ReceipsCard> {
  final TextEditingController searchController = TextEditingController(
    text: "",
  );

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetReceiptsBloc, GetReceiptsState>(
      listener: (context, state) {
        if (state is GetReceiptsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error when obtaining recipes:: ${state.error}"),
            ),
          );
        }
      },
      child: BlocBuilder<GetReceiptsBloc, GetReceiptsState>(
        builder: (context, state) {
          bool isLoading = false;
          List<Receipt> allReceipts = [];

          if (state is GetReceiptsLoading) {
            isLoading = true;
          } else if (state is GetReceiptsSuccess) {
            allReceipts = state.receipts;
          }

          final query = searchController.text.toLowerCase();
          final filteredReceipts =
              allReceipts.where((r) {
                return r.receiptNumber.toLowerCase().contains(query) ||
                    r.id == widget.selectedReceipt;
              }).toList();

          return DashboardCard(
            flex: 3,
            floatingActionButton: ResponsiveChild(
              xs: const SizedBox.shrink(),
              lg: FloatingActionButton(
                onPressed: widget.onCreateReceipt,
                tooltip: 'Add Recipe',
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 3,
                child: const Icon(Icons.add),
              ),
            ),
            children: [
              const DashboardCardTitle(title: "Recipes"),
              const SizedBox(height: 20),

              MySearchInput(controller: searchController),

              const SizedBox(height: 20),
              ResponsiveChild(
                xs:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MySelectField(
                              label: "",
                              items:
                                  filteredReceipts
                                      .map(
                                        (rec) => DropdownMenuItem(
                                          value: rec.id,
                                          child: Text(rec.receiptNumber),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (val) {
                                widget.onSelectReceipt(val as String?);
                              },
                              value: widget.selectedReceipt,
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FloatingActionButton(
                                onPressed: widget.onCreateReceipt,
                                tooltip: 'Add Recipe',
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                elevation: 3,
                                mini: true,
                                child: const Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                lg:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                          children: [
                            if (filteredReceipts.isEmpty)
                              const Text("No recipes to show"),
                            ...filteredReceipts.map((rec) {
                              return DashboardListItem(
                                label: rec.receiptNumber,
                                value: rec.id,
                                isSelected: widget.selectedReceipt == rec.id,
                                onSelect: (val) {
                                  widget.onSelectReceipt(val as String);
                                },
                              );
                            }).toList(),
                          ],
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
