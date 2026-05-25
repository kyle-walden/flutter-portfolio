import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../vendor_info/viewmodel/vendor_viewmodel.dart';
import '../../booking_management/viewmodel/booking_viewmodel.dart';
import '../viewmodel/booking_form_viewmodel.dart';

class BookingFormScreen extends StatefulWidget {
  final String? slug;
  const BookingFormScreen({super.key, this.slug});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _nameCtl = TextEditingController();

  @override
  void dispose() {
    _nameCtl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Load vendor info by slug via vendor provider in real app
    if (widget.slug != null) {
      // Load the vendor and availability for the public booking form.
      // We use the vendor provider to resolve the slug to a vendor and use
      // the booking provider to fetch availability rules.
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          final vp = context.read<VendorViewModel>();
          final bp = context.read<BookingViewModel>();
          await vp.loadVendorBySlug(widget.slug!);
          if (vp.vendor != null) {
            await bp.loadAvailability(vp.vendor!.id);
          }
        } catch (_) {
          // ignore: no-op for demo
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendorProv = context.watch<VendorViewModel>();
    final bookingProv = context.watch<BookingViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text('Booking — ${widget.slug ?? "public"}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Vendor: ${vendorProv.vendor?.name ?? "(public booking form)"}'),
            const SizedBox(height: 12),
            if (bookingProv.loading) const Text('Loading availability...'),
            if (!bookingProv.loading && bookingProv.rules.isNotEmpty) ...[
              const Text('Available slots:'),
              for (final r in bookingProv.rules) Text('- ${r.description}'),
              const SizedBox(height: 12),
            ],
            TextField(controller: _nameCtl, decoration: const InputDecoration(labelText: 'Your name')),
            const SizedBox(height: 8),
            Consumer<BookingFormViewModel>(builder: (context, formProv, _) {
              return ElevatedButton(
                onPressed: formProv.submitting
                    ? null
                    : () async {
                        final name = _nameCtl.text.trim();
                        if (name.isEmpty) return;
                        final payload = {
                          'owner_uid': vendorProv.vendor?.id,
                          'customer': name,
                          'date': DateTime.now().toIso8601String(),
                        };
                        final ok = await formProv.submit(payload);
                        final snack = ok ? 'Booking submitted' : 'Submission failed: ${formProv.error ?? ''}';
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snack)));
                      },
                child: formProv.submitting ? const Text('Submitting...') : const Text('Request Booking'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
