import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      content: Row(
        children: [
          SizedBox(width: 32, height: 32, child: CircularProgressIndicator()),
          SizedBox(width: 16),
          Expanded(child: Text('$message...', overflow: TextOverflow.ellipsis)),
        ],
      ),
      contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
