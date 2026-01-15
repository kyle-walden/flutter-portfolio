import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/vendor_provider.dart';

class VendorDashboard extends StatefulWidget {
  const VendorDashboard({super.key});

  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  final _slugCtl = TextEditingController();

  @override
  void dispose() {
    _slugCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vendorProv = context.watch<VendorProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Vendor Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vendor: ${vendorProv.vendor?.name ?? "(not loaded)"}'),
            const SizedBox(height: 12),
            TextField(controller: _slugCtl, decoration: const InputDecoration(labelText: 'Desired public slug')),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                // UI triggers provider to reserve the slug. In production the
                // provider would include the authenticated vendor id so the
                // backend can make an authoritative reservation.
                final slug = _slugCtl.text.trim();
                if (slug.isEmpty) return;
                final ok = await vendorProv.reserveSlug(slug);
                final snack = ok ? 'Reserved' : 'Reservation failed';
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snack)));
              },
              child: const Text('Reserve Slug'),
            ),
          ],
        ),
      ),
    );
  }
}
