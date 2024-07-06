import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/model/contact_data.dart';
import '../../../theme/color/light_color.dart';
class CustomDeleteDialog extends StatelessWidget {

  final VoidCallback onDelete;

  const CustomDeleteDialog({required this.onDelete, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Iconsax.trash, color: Colors.red),
                const Text(
                  'Delete contact?',
                  style: TextStyle(fontFamily: 'PaynetB', fontSize: 18),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Iconsax.close_circle,
                      color: LightColor.mainColor),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Do you want to delete this contact?',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'PaynetB', fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LightColor.mainColor,
                  ),
                  onPressed: onDelete,
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
