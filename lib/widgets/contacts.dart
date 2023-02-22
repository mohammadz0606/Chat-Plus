import 'package:flutter_contacts/contact.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class ContactsWidget extends StatelessWidget {
  const ContactsWidget({
    Key? key,
    required this.contact,
  }) : super(key: key);
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        contact.displayName,
        style:  TextStyle(
          color: Colors.white,
          fontSize: 17.sp,
        ),
      ),
      subtitle: Text(
        "phone: ${
          contact.phones.isEmpty
              ? "there's no phone number"
              : contact.phones[0].number
        }",
        style:  TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
