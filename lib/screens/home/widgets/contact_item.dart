import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/model/contact_data.dart';

class ContactItem extends StatelessWidget {
  final ContactData contact;
  final void Function() onCardClick;
  final void Function() onItemClick;

  const ContactItem(
      {super.key, required this.contact,
        required this.onCardClick,
        required this.onItemClick});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onItemClick();
      },
      leading: const CircleAvatar(
        backgroundImage: AssetImage('assets/images/azimjon.png'),
      ),
      title: Text(contact.name, style: const TextStyle(fontFamily: 'PaynetB')),
      subtitle:
      Text(contact.phone, style: const TextStyle(fontFamily: 'PaynetB')),
      trailing: GestureDetector(
          onTap: () {
            onCardClick();
          },
          child: const Icon(Iconsax.more)),
    );
  }
}