import 'package:flutter/material.dart';

class SongControlsWidget extends StatelessWidget {
  const SongControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),             // 
            IconButton(icon: const Icon(Icons.remove), onPressed: () {}),             //  Transpose
            IconButton(icon: const Icon(Icons.add), onPressed: () {}),                //  Transpose
            IconButton(icon: const Icon(Icons.lock), onPressed: () {}),               //  Lokot
            ElevatedButton(onPressed: () {}, child: const Text('OUT')),               // / Status
            IconButton(icon: const Icon(Icons.zoom_out), onPressed: () {}),           //  Zoom -
            IconButton(icon: const Icon(Icons.zoom_in), onPressed: () {}),            //  Zoom +
            IconButton(icon: const Icon(Icons.edit), onPressed: () {}),               //  Edit
            IconButton(icon: const Icon(Icons.settings), onPressed: () {}),           //  Settings
          ],
        ),
      ),
    );
  }
}
