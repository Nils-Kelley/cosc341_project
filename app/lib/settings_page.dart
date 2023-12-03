import 'package:flutter/material.dart';
import 'auth_provider.dart';
import 'logout.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  AuthProvider authProvider = AuthProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          SizedBox(height: 20),
          settingsCard(
            children: [
              settingsTile(
                icon: Icons.post_add,
                color: Colors.purple,
                title: 'Manage Your Reviews',
              ),
            ],
          ),
          SizedBox(height: 20),
          settingsCard(
            children: [
              settingsTile(
                icon: Icons.privacy_tip,
                color: Colors.red,
                title: 'Privacy & Security',
              ),
            ],
          ),
          SizedBox(height: 20),
          settingsCard(
            children: [
              settingsTile(
                icon: Icons.feedback,
                color: Colors.grey,
                title: 'Feedback/Report Issues',
              ),
              settingsTile(
                icon: Icons.info_outline,
                color: Colors.blueGrey,
                title: 'About',
              ),
            ],
          ),

          SizedBox(height: 20),
          settingsTile(
            icon: Icons.exit_to_app,
            color: Colors.red,
            title: 'Logout',
            onTap: () {
              logoutUser(context, authProvider);
            },
          ),
        ],
      ),
    );
  }

  Card settingsCard({required List<Widget> children}) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  ListTile settingsTile({
    required IconData icon,
    required Color color,
    required String title,
    Widget? trailing,
    void Function()? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      trailing: trailing ?? Icon(Icons.chevron_right, color: color),
      onTap: onTap,
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: color.withOpacity(0.2), width: 1.0),
      ),
      hoverColor: color.withOpacity(0.03),
      selectedTileColor: color.withOpacity(0.1),
    );
  }
}