import 'package:flutter/material.dart';

class ScrollControlWidget extends StatelessWidget {
  final VoidCallback onScrollUp;
  final VoidCallback onScrollDown;

  const ScrollControlWidget({
    super.key,
    required this.onScrollUp,
    required this.onScrollDown,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 4,
      bottom: 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            iconSize: 32,
            onPressed: onScrollUp,
          ),
          const SizedBox(height: 8),
          IconButton(
            icon: const Icon(Icons.arrow_downward),
            iconSize: 32,
            onPressed: onScrollDown,
          ),
        ],
      ),
    );
  }
}
