import 'package:flutter/material.dart';

class ProfileButtons extends StatelessWidget {
  final List<String> profiles;
  final void Function(String) onProfileSelected;
  final void Function(String) onProfileDelete;

  const ProfileButtons({
    super.key,
    required this.profiles,
    required this.onProfileSelected,
    required this.onProfileDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final name = profiles[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(name),
            onTap: () => onProfileSelected(name),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onProfileDelete(name),
            ),
          ),
        );
      },
    );
  }
}
