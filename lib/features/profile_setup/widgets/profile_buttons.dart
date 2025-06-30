import 'package:flutter/material.dart';

class ProfileButtons extends StatelessWidget {
  final List<String> profiles;
  final void Function(String) onProfileSelected;

  const ProfileButtons({
    Key? key,
    required this.profiles,
    required this.onProfileSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final profile = profiles[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => onProfileSelected(profile),
                  child: Text(profile),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // TODO: Dodati potvrdu i funkciju brisanja
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
