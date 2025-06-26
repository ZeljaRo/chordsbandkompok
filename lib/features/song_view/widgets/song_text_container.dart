import 'package:flutter/material.dart';
import 'package:chordsbandkompok/features/song_view/widgets/attachment_button.dart';

class SongTextContainer extends StatelessWidget {
  final String songText;
  final String songFilename;

  const SongTextContainer({
    Key? key,
    required this.songText,
    required this.songFilename,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: SelectableText(songText),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: AttachmentButton(songName: songFilename),
        ),
      ],
    );
  }
}
