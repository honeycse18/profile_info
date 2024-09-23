import 'package:flutter/material.dart';
import 'package:profile_info/profile_info_db.dart';
import 'package:sqflite/sqflite.dart';

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _displayNameController = TextEditingController();

  List<Map<String, dynamic>> _profiles = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  void _loadProfiles() async {
    final profiles = await DatabaseHelper.instance.queryAllRows();
    setState(() {
      _profiles = profiles;
    });
  }

  void _saveProfile() async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String displayName = _displayNameController.text;

    if (firstName.isNotEmpty && lastName.isNotEmpty && displayName.isNotEmpty) {
      Map<String, dynamic> row = {
        DatabaseHelper.columnFirstName: firstName,
        DatabaseHelper.columnLastName: lastName,
        DatabaseHelper.columnDisplayName: displayName
      };
      await DatabaseHelper.instance.insert(row);

      _firstNameController.clear();
      _lastNameController.clear();
      _displayNameController.clear();

      _loadProfiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _displayNameController,
              decoration: InputDecoration(
                labelText: 'Display Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Next Step'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            Expanded(
              child: _profiles.isNotEmpty
                  ? ListView.builder(
                      itemCount: _profiles.length,
                      itemBuilder: (context, index) {
                        final profile = _profiles[index];
                        return ListTile(
                          title: Text(profile['first_name'] +
                              " " +
                              profile['last_name']),
                          subtitle: Text(profile['display_name']),
                        );
                      },
                    )
                  : Center(
                      child: Text('No profiles added yet.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }
}
