import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/study_group.dart';
import '../services/auth_service.dart';

/// Placeholder feed. It already listens to the `study_groups` collection
/// live, so any group added in the Firebase console shows up right away.
/// Filtering by class and sorting by distance come later.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final name = (user.displayName?.isNotEmpty ?? false)
        ? user.displayName!
        : (user.email ?? 'there');

    final groups = FirebaseFirestore.instance
        .collection('study_groups')
        .orderBy('startTime')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('StudySpot'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService().signOut(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Hi, $name 👋',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: groups,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _CenteredMessage(
                    icon: Icons.error_outline,
                    message: 'Could not load study groups.\n${snapshot.error}',
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items =
                    snapshot.data!.docs.map(StudyGroup.fromDoc).toList();
                if (items.isEmpty) {
                  return const _CenteredMessage(
                    icon: Icons.menu_book_outlined,
                    message: 'No study groups yet.\nBe the first to post one!',
                  );
                }

                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) => _GroupTile(group: items[i]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Creating posts is coming next!')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New group'),
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  const _GroupTile({required this.group});

  final StudyGroup group;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final when = '${localizations.formatShortMonthDay(group.startTime)}, '
        '${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(group.startTime))}';

    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.groups)),
      title: Text('${group.classCode} · ${group.title}'),
      subtitle: Text('${group.locationName} · $when'),
      trailing: group.isCheckedIn
          ? const Chip(label: Text('Meeting now'))
          : null,
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
