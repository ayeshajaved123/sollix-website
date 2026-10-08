import 'package:flutter/material.dart';
import '../widgets/page_scaffold.dart';
import '../widgets/sub_page_header.dart';
import '../sections/contact_form_section.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      child: Column(
        children: [
          SubPageHeader(
            title: 'CONTACT US',
            subtitle:
                'Get a free consultation or request a quote — we usually reply within 24 hours.',
          ),
          ContactFormSection(),
        ],
      ),
    );
  }
}
