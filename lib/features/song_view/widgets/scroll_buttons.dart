import 'package:flutter/material.dart';

class ScrollButtons extends StatelessWidget {
  final VoidCallback onScrollUp;
  final VoidCallback onScrollDown;

  const ScrollButtons({
    super.key,
    required this.onScrollUp,
    required this.onScrollDown,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up),
          iconSize: 36,
          onPressed: onScrollUp,
        ),
        const SizedBox(height: 8),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          iconSize: 36,
          onPressed: onScrollDown,
        ),
      ],
    );
  }
}
