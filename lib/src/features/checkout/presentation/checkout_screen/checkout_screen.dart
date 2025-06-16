import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_form_type.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/checkout/presentation/payment/payment_page.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecommerce_app/src/utils/app_screen_enum.dart';
import 'package:ecommerce_app/src/utils/screen_analytics_manager.dart';

enum CheckoutSubRoute { register, payment }

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  late final PageController _controller;
  var _subRoute = CheckoutSubRoute.register;
  @override
  void initState() {
    super.initState();

    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      _subRoute = CheckoutSubRoute.payment;
    } 
    else {
          ScreenAnalyticsManager().trackScreen(AppScreen.checkoutRegister);
    }

    _controller = PageController(initialPage: _subRoute.index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSignedIn() {
    // Track transition to payment
    setState(() {
      _subRoute = CheckoutSubRoute.payment;
    });

    _controller.animateToPage(
      _subRoute.index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _subRoute == CheckoutSubRoute.register
        ? 'Register'.hardcoded
        : 'Payment'.hardcoded;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          EmailPasswordSignInContents(
            formType: EmailPasswordSignInFormType.register,
            onSignedIn: _onSignedIn,
          ),
          const PaymentPage()
        ],
      ),
    );
  }
}
