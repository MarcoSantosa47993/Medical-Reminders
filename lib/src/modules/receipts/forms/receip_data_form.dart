import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicins_repository/medicins_repository.dart';

import 'package:medicins_schedules/src/components/form/form.dart';
import 'package:medicins_schedules/src/components/buttons/delete_button.dart';
import 'package:medicins_schedules/src/modules/receipts/blocs/adjust_stock/adjust_stock_bloc.dart';
import 'package:medicins_schedules/src/modules/receipts/blocs/get_receipt/get_receipt_event.dart';
import 'package:medicins_schedules/src/modules/receipts/blocs/get_receipt/get_receipt_state.dart';
import 'package:medicins_schedules/src/modules/receipts/blocs/get_receipts/get_receipts_event.dart';

import 'package:medicins_schedules/src/modules/receipts/components/medicin_list_item.dart';
import 'package:medicins_schedules/src/modules/receipts/components/receip_date_field.dart';
import 'package:medicins_schedules/src/modules/receipts/components/responsive_form_row.dart';
import 'package:medicins_schedules/src/modules/receipts/models/medicin.dart';
import 'package:medicins_schedules/src/modules/receipts/views/add_medicine_dialog.dart';
import 'package:medicins_schedules/src/modules/receipts/views/administrate_dialog.dart';
import 'package:medicins_schedules/src/modules/receipts/views/delete_confirmation_dialog.dart';
import 'package:medicins_schedules/src/modules/receipts/views/view_medicine_dialog.dart';

import 'package:medicins_schedules/src/modules/receipts/blocs/get_receipt/get_receipt_bloc.dart';

import 'package:medicins_schedules/src/modules/receipts/blocs/get_receipts/get_receipts_bloc.dart';

import 'package:medicins_schedules/src/modules/receipts/blocs/add_receipt/add_receipt_bloc.dart';

import 'package:receipts_repository/receipts_repository.dart';
import 'package:uuid/uuid.dart';

class ReceipDataForm extends StatefulWidget {
  final bool isNew;
  final String? receiptId;
  final VoidCallback? onReceiptDeleted;

  const ReceipDataForm({
    Key? key,
    required this.isNew,
    this.receiptId,
    this.onReceiptDeleted,
  }) : super(key: key);

  @override
  ReceipDataFormState createState() => ReceipDataFormState();
}

class ReceipDataFormState extends State<ReceipDataForm> {
  final _formKey = GlobalKey<FormState>();
  final _receiptNumberController = TextEditingController();
  final _emittedDateController = TextEditingController();
  final _uuid = Uuid();
  final _expireDateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  List<Medicine> medicines = [];
  bool isLoadingForm = false;
  bool failOnGet = false;

  void resetForm() {
    _receiptNumberController.clear();
    _emittedDateController.clear();
    _expireDateController.clear();
    setState(() => medicines.clear());
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isNew && widget.receiptId != null) {
      context.read<GetReceiptBloc>().add(
        LoadReceipt(receiptId: widget.receiptId!),
      );
    }
  }

  @override
  void didUpdateWidget(covariant ReceipDataForm old) {
    super.didUpdateWidget(old);
    if (old.receiptId != widget.receiptId) {
      resetForm();
      if (!widget.isNew && widget.receiptId != null) {
        context.read<GetReceiptBloc>().add(
          LoadReceipt(receiptId: widget.receiptId!),
        );
      }
    }
  }

  @override
  void dispose() {
    _receiptNumberController.dispose();
    _emittedDateController.dispose();
    _expireDateController.dispose();
    super.dispose();
  }

  String? _validateField(String fieldName, String? value) {
    switch (fieldName) {
      case 'receiptNumber':
        return (value?.isEmpty ?? true) ? 'Recipe number is required' : null;
      case 'emittedAt':
      case 'expiresAt':
        final date = _dateFormat.tryParse(value ?? '');
        if (date == null) return 'Invalid date';
        if (fieldName == 'expiresAt') {
          final startDate = _dateFormat.tryParse(_emittedDateController.text);
          if (startDate != null && date.isBefore(startDate)) {
            return 'Date prior to emission';
          }
        }
        return null;
      default:
        return null;
    }
  }

  void _handleSave() {
    print(
      '[ReceipDataForm] _handleSave chamado — isNew=${widget.isNew}, meds=${medicines.length}',
    );
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final receiptNumber = _receiptNumberController.text.trim();
    final emittedDate = _dateFormat.parse(_emittedDateController.text.trim());
    final expireDate = _dateFormat.parse(_expireDateController.text.trim());
    final medications =
        medicines.map((m) {
          return MedicinPurchase(
            id: m.id!,
            quantityPurchased: m.quantity,
            name: m.name,
            observations: m.observations,
            isAdministered: m.isAdministered,
          );
        }).toList();
    context.read<AddReceiptBloc>().add(
      AddOrUpdateReceipt(
        receiptId: widget.isNew ? '' : widget.receiptId!,
        receiptNumber: receiptNumber,
        emittedDate: emittedDate,
        expireDate: expireDate,
        medications: medications,
      ),
    );
  }

  void _onSuccessGet(Receipt data) {
    _receiptNumberController.text = data.receiptNumber;
    _emittedDateController.text = _dateFormat.format(data.emittedDate);
    _expireDateController.text = _dateFormat.format(data.expireDate);
    setState(() {
      medicines =
          data.medications
              .map(
                (mp) => Medicine(
                  id: mp.id, // ← aqui!
                  name: mp.name,
                  observations: mp.observations,
                  quantity: mp.quantityPurchased,
                  isAdministered: mp.isAdministered,
                ),
              )
              .toList();
    });
  }

  void _listener(BuildContext context, GetReceiptState state) {
    if (state is GetReceiptLoading) {
      setState(() {
        isLoadingForm = true;
        failOnGet = false;
      });
    } else if (state is GetReceiptFailure) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: ${state.error}')));
      setState(() => failOnGet = true);
    } else if (state is GetReceiptSuccess &&
        state.type == GetReceiptType.getReceipt) {
      _onSuccessGet(state.receipt!);
      setState(() {
        isLoadingForm = false;
        failOnGet = false;
      });
    } else if (state is GetReceiptSuccess &&
        state.type == GetReceiptType.removeReceipt) {
      context.read<GetReceiptsBloc>().add(const LoadReceipts());
      widget.onReceiptDeleted?.call();
    }
  }

  void _deleteMedicineAt(int index) {
    setState(() {
      medicines.removeAt(index);
    });
    // Atualiza imediatamente na Firebase
    final addReceiptBloc = context.read<AddReceiptBloc>();
    addReceiptBloc.add(
      AddOrUpdateReceipt(
        receiptId: widget.receiptId!,
        receiptNumber: _receiptNumberController.text.trim(),
        emittedDate: _dateFormat.parse(_emittedDateController.text.trim()),
        expireDate: _dateFormat.parse(_expireDateController.text.trim()),
        medications:
            medicines
                .map(
                  (m) => MedicinPurchase(
                    id: m.id!,
                    quantityPurchased: m.quantity,
                    name: m.name,
                    observations: m.observations,
                    isAdministered: m.isAdministered,
                  ),
                )
                .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isNew
        ? _buildFormBody()
        : BlocListener<GetReceiptBloc, GetReceiptState>(
          listener: _listener,
          child:
              isLoadingForm
                  ? const LinearProgressIndicator()
                  : failOnGet
                  ? const Center(
                    child: Text(
                      'Something went wrong when uploading the receipt',
                    ),
                  )
                  : _buildFormBody(),
        );
  }

  Widget _buildFormBody() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveFormRow(
              children: [
                MyTextField(
                  label: 'Recipe Number',
                  controller: _receiptNumberController,
                  prefixIcon: const Icon(Icons.receipt),
                  validator: (v) => _validateField('receiptNumber', v),
                ),
                MyReceiptDateField(
                  label: 'Emitted At',
                  controller: _emittedDateController,
                  prefixIcon: const Icon(Icons.calendar_month),
                  validator: (v) => _validateField('emittedAt', v),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ResponsiveFormRow(
              children: [
                MyReceiptDateField(
                  label: 'Expires At',
                  controller: _expireDateController,
                  prefixIcon: const Icon(Icons.calendar_month),
                  validator: (v) => _validateField('expiresAt', v),
                ),
                const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 30),

            // ====== BOTÃO DE UPDATE/CREATE ANTES DOS MEDICINES ======
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 261,
                child: ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        widget.isNew ? Icons.add : Icons.edit_outlined,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(widget.isNew ? 'Create' : 'Update'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
            if (!widget.isNew) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Medicines',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Material(
                      shape: const CircleBorder(),
                      color: Theme.of(context).colorScheme.primary,
                      child: InkWell(
                        onTap: () => _showAddMedicineDialog(context),
                        customBorder: const CircleBorder(),
                        child: const Center(
                          child: Icon(Icons.add, size: 24, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: medicines.length,
                separatorBuilder:
                    (_, __) => Divider(color: Theme.of(context).dividerColor),
                itemBuilder: (ctx, i) {
                  final med = medicines[i];
                  return MedicineListItem(
                    medicine: med,
                    onView: () => _showEditMedicineDialog(context, med),
                    onDelete:
                        med.isAdministered
                            ? null
                            : () => _showDeleteMedicineDialog(context, i),
                    onAdministrate:
                        med.isAdministered
                            ? null
                            : () =>
                                _showAdministrateMedicineDialog(context, med),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
            // Delete Receipt
            if (!widget.isNew)
              DeleteButton(
                onPressed: () => _showDeleteReceiptDialog(context),
                text: 'Remove Receipt',
              ),
          ],
        ),
      ),
    );
  }

  void _showAddMedicineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AddMedicineDialog(
            onAdd: (medicine) {
              // Gere um ID se faltar
              final medWithId =
                  medicine.id == null
                      ? medicine.copyWith(id: _uuid.v4())
                      : medicine;

              setState(() => medicines.add(medWithId));
              // Atualiza imediatamente na Firebase
              final addReceiptBloc = context.read<AddReceiptBloc>();
              addReceiptBloc.add(
                AddOrUpdateReceipt(
                  receiptId: widget.receiptId!,
                  receiptNumber: _receiptNumberController.text.trim(),
                  emittedDate: _dateFormat.parse(
                    _emittedDateController.text.trim(),
                  ),
                  expireDate: _dateFormat.parse(
                    _expireDateController.text.trim(),
                  ),
                  medications:
                      medicines
                          .map(
                            (m) => MedicinPurchase(
                              id: m.id!,
                              quantityPurchased: m.quantity,
                              name: m.name,
                              observations: m.observations,
                              isAdministered: m.isAdministered,
                            ),
                          )
                          .toList(),
                ),
              );
            },
          ),
    );
  }

  void _showDeleteMedicineDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder:
          (_) => DeleteConfirmationDialog(
            title: 'Delete Medicine',
            content: 'Are you sure you want to remove this medicine?',
            icon: Icons.medical_services,
            color: Theme.of(context).colorScheme.error,
            onConfirm: () {
              _deleteMedicineAt(index);
            },
          ),
    );
  }

  void _showAdministrateMedicineDialog(BuildContext ctx, Medicine medicine) {
    final bloc = ctx.read<AdjustStockBloc>();
    final idx = medicines.indexOf(medicine);

    final input = MedicinPurchaseInput(
      name: medicine.name,
      type: '',
      quantityPurchased: medicine.quantity,
      dosePerPeriod: 1,
      period: Period.day,
      observations: medicine.observations,
    );

    showDialog(
      context: ctx,
      builder:
          (_) => BlocProvider.value(
            value: bloc,
            child: BlocConsumer<AdjustStockBloc, AdjustStockState>(
              listener: (c, state) {
                if (state is AdjustStockSuccess) {
                  setState(() {
                    medicines[idx] = medicines[idx].copyWith(
                      isAdministered: true,
                    );
                  });
                  _handleSave();
                  Navigator.pop(c);
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Medication administered!')),
                  );
                } else if (state is AdjustStockFailure) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('Erro: ${state.error}')),
                  );
                }
              },
              builder: (c, state) {
                final loading = state is AdjustStockLoading;
                return AdministrateDialog(
                  isLoading: loading,
                  onConfirm: () => bloc.add(AdjustStockRequested([input])),
                );
              },
            ),
          ),
    );
  }

  void _showEditMedicineDialog(BuildContext context, Medicine medicine) {
    showDialog(
      context: context,
      builder:
          (_) => EditMedicineDialog(
            medicine: medicine,
            isEditable: !medicine.isAdministered,
          ),
    ).then((editedMedicine) {
      if (editedMedicine != null && editedMedicine is Medicine) {
        final idx = medicines.indexOf(medicine);
        setState(() {
          medicines[idx] = editedMedicine;
        });
        // Atualiza imediatamente na Firebase
        final addReceiptBloc = context.read<AddReceiptBloc>();
        addReceiptBloc.add(
          AddOrUpdateReceipt(
            receiptId: widget.receiptId!,
            receiptNumber: _receiptNumberController.text.trim(),
            emittedDate: _dateFormat.parse(_emittedDateController.text.trim()),
            expireDate: _dateFormat.parse(_expireDateController.text.trim()),
            medications:
                medicines
                    .map(
                      (m) => MedicinPurchase(
                        id: m.id!,
                        quantityPurchased: m.quantity,
                        name: m.name,
                        observations: m.observations,
                        isAdministered: m.isAdministered,
                      ),
                    )
                    .toList(),
          ),
        );
      }
    });
  }

  void _showDeleteReceiptDialog(BuildContext context) {
    final state = context.read<GetReceiptBloc>().state;
    if (state is GetReceiptSuccess) {
      showDialog(
        context: context,
        builder:
            (_) => DeleteConfirmationDialog(
              title: 'Delete Receipt',
              content: 'Are you sure you want to delete this receipt?',
              icon: Icons.receipt,
              color: Theme.of(context).colorScheme.error,
              onConfirm: () {
                context.read<GetReceiptBloc>().add(
                  RemoveReceipt(receiptId: state.receipt!.id),
                );
              },
            ),
      );
    }
  }
}
