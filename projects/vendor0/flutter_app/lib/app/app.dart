import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/firestore_service.dart';
import '../core/services/http_service.dart';
import '../core/utils/app_theme.dart';
import '../features/vendor_info/viewmodel/vendor_viewmodel.dart';
import '../features/booking_management/viewmodel/booking_viewmodel.dart';
import '../features/booking_form/view/booking_form_screen.dart';
import '../features/vendor_info/view/vendor_dashboard.dart';
import '../features/booking_form/viewmodel/booking_form_viewmodel.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => FirestoreService()),
        Provider(create: (_) => HttpService()),
        ChangeNotifierProvider(create: (ctx) => VendorViewModel(ctx.read<FirestoreService>(), ctx.read<HttpService>())),
        ChangeNotifierProvider(create: (ctx) => BookingViewModel(ctx.read<FirestoreService>())),
        ChangeNotifierProvider(create: (ctx) => BookingFormViewModel(ctx.read<HttpService>())),
      ],
      child: MaterialApp(
        title: 'vendor0 — admin',
        theme: AppTheme.light(),
        initialRoute: '/',
        routes: {
          '/': (c) => const VendorDashboard(),
          '/booking-form': (c) => const BookingFormScreen(),
        },
        onGenerateRoute: (settings) {
          // Public booking form via slug: /booking/form/:slug
          if (settings.name != null && settings.name!.startsWith('/public/')) {
            final parts = settings.name!.split('/');
            if (parts.length >= 3) {
              final slug = parts[2];
              return MaterialPageRoute(builder: (_) => BookingFormScreen(slug: slug));
            }
          }
          return null;
        },
      ),
    );
  }
}
