import 'package:flutter/material.dart';
import 'package:godalone/components/Constants/colors.dart';
import 'package:unicons/unicons.dart';

class Give extends StatelessWidget {
  final bool isBottomSheet;

  const Give({super.key, this.isBottomSheet = false});

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.volunteer_activism, size: 70, color: myMainColor),
          const SizedBox(height: 12),
          const Text(
            'God Alone International Ministry',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your generosity makes a difference.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          _sectionCard(
            context,
            icon: UniconsLine.phone,
            title: 'Mobile Money (MoMo Pay)',
            rows: const [
              _DetailRow(label: 'Merchant Number', value: '786022'),
            ],
          ),
          const SizedBox(height: 16),
          _sectionCard(
            context,
            icon: Icons.account_balance,
            title: 'Bank Transfer (Access Bank)',
            rows: const [
              _DetailRow(label: 'Branch', value: 'Lashibi, Tema'),
              _DetailRow(label: 'Account', value: '0041659272041'),
              _DetailRow(label: 'Account', value: '0041659272042'),
              _DetailRow(label: 'Account', value: '0041659272043'),
            ],
          ),
        ],
      ),
    );

    if (isBottomSheet) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon:
              const Icon(UniconsLine.times_circle, color: Colors.red, size: 40),
        ),
        title: const Text('Give'),
        centerTitle: true,
      ),
      body: content,
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<_DetailRow> rows,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: myMainColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: myMainColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: myMainColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: myMainColor,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...rows,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
