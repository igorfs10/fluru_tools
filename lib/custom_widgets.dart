import 'package:flutter/material.dart';

Widget buildFormatDropdown(
  BuildContext context,
  int value,
  List<DropdownMenuItem<int>> items,
  ValueChanged<int?> onChanged,
) {
  return Container(
    decoration: BoxDecoration(
      color: ColorScheme.of(context).onPrimaryContainer.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    child: DropdownButtonHideUnderline(
      child: DropdownButton(
        isExpanded: true,
        isDense: true,
        value: value,
        items: items,
        onChanged: onChanged,
      ),
    ),
  );
}

Widget buildTextField({
  required TextEditingController controller,
  bool readOnly = false,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      controller: controller,
      textAlignVertical: TextAlignVertical.top,
      readOnly: readOnly,
      expands: true,
      minLines: null,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    ),
  );
}
