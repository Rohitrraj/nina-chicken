import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/constant/enum.dart';
import 'package:kedai_ayam_nina/core/widgets/custom_button_gradient.dart';
import 'package:kedai_ayam_nina/core/widgets/custom_dropdown.dart';
import 'package:kedai_ayam_nina/core/widgets/custom_textfield.dart';
import 'package:kedai_ayam_nina/core/widgets/switcher.dart';
import 'package:kedai_ayam_nina/features/transactions/domain/entities/transaction.dart';

class CardTransaction extends StatefulWidget {
  const CardTransaction({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
    this.resetToken = 0,
  });

  final ValueChanged<Transaction> onSubmit;
  final bool isLoading;
  final int resetToken;

  @override
  State<CardTransaction> createState() => _CardTransactionState();
}

class _CardTransactionState extends State<CardTransaction> {
  final List<String> options = ['Pemasukan', 'Pengeluaran'];

  final dateController = TextEditingController();
  final nominalController = TextEditingController();
  final keteranganController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  KategoriTransaksi? kategoriController;
  DateTime? _selectedDate;
  int selectedIndex = 0;

  @override
  void didUpdateWidget(covariant CardTransaction oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.resetToken != oldWidget.resetToken) {
      _resetForm();
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    nominalController.dispose();
    keteranganController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();

    dateController.clear();
    nominalController.clear();
    keteranganController.clear();

    kategoriController = null;
    _selectedDate = null;
    selectedIndex = 0;
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field ini wajib diisi.';
    }

    return null;
  }

  String? _validateNominal(String? value) {
    final nominal = int.tryParse(value?.trim() ?? '');

    if (nominal == null || nominal <= 0) {
      return 'Nominal harus lebih dari Rp 0.';
    }

    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Keterangan wajib diisi.';
    }

    return null;
  }

  Future<void> _pickDate() async {
    if (widget.isLoading) {
      return;
    }

    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: now,
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    _selectedDate = pickedDate;

    final day = pickedDate.day.toString().padLeft(2, '0');

    final month = pickedDate.month.toString().padLeft(2, '0');

    setState(() {
      dateController.text = '$day/$month/${pickedDate.year}';
    });
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    final valid = _formKey.currentState?.validate() ?? false;

    if (!valid ||
        _selectedDate == null ||
        kategoriController == null ||
        widget.isLoading) {
      return;
    }

    final jenis = selectedIndex == 0
        ? JenisTransaksi.pemasukan
        : JenisTransaksi.pengeluaran;

    widget.onSubmit(
      Transaction(
        id: '',
        tanggal: _selectedDate!,
        jenis: jenis,
        kategori: kategoriController!,
        nominal: int.parse(nominalController.text.trim()),
        keterangan: keteranganController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      color: Theme.of(context).colorScheme.onPrimary,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: AbsorbPointer(
          absorbing: widget.isLoading,
          child: Opacity(
            opacity: widget.isLoading ? 0.72 : 1,
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 10,
                children: [
                  Switcher(
                    key: ValueKey<String>(
                      'transaction-switcher-'
                      '${widget.resetToken}',
                    ),
                    options: options,
                    selectedIndex: selectedIndex,
                    onChanged: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                  CustomInputField(
                    key: const Key('transaction-date-field'),
                    validator: _validateRequired,
                    keyboardType: TextInputType.datetime,
                    label: 'Tanggal Transaksi',
                    controller: dateController,
                    hintText: 'dd/mm/yyyy',
                    prefixIcon: Icons.calendar_today,
                    readOnly: true,
                    onTap: _pickDate,
                  ),
                  CustomDropdownField(
                    key: ValueKey<String>(
                      'transaction-category-'
                      '${widget.resetToken}',
                    ),
                    label: 'Kategori',
                    hintText: 'Pilih kategori',
                    validator: _validateRequired,
                    items: KategoriTransaksi.values
                        .map((item) => item.label)
                        .toList(),
                    value: kategoriController?.label,
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      kategoriController = KategoriTransaksi.values.firstWhere(
                        (item) => item.label == value,
                        orElse: () => KategoriTransaksi.lainnya,
                      );
                    },
                  ),
                  CustomInputField.number(
                    key: const Key('transaction-nominal-field'),
                    validator: _validateNominal,
                    label: 'Nominal',
                    hintText: 'Masukkan nominal transaksi',
                    controller: nominalController,
                  ),
                  CustomInputField(
                    key: const Key('transaction-description-field'),
                    validator: _validateDescription,
                    label: 'Keterangan Tambahan',
                    hintText: 'Masukkan keterangan tambahan',
                    controller: keteranganController,
                  ),
                  if (widget.isLoading) const LinearProgressIndicator(),
                  KeyedSubtree(
                    key: const Key('transaction-create-submit'),
                    child: CustomGradientButton(
                      leadingIcon: Icons.save,
                      text: widget.isLoading
                          ? 'Menyimpan...'
                          : 'Simpan Transaksi',
                      onTap: _submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
