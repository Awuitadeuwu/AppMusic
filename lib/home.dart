import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/list_view.dart';
import 'views/card_view.dart';
import 'views/grid_view.dart';
import 'views/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(Color) changeTheme;
  const HomeScreen({super.key, required this.changeTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _userName = "App Menu";
  Color _primaryColor = const Color(0xFF4FC3F7);
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name') ?? "App Menu";
      final colorValue = prefs.getInt('primary_color') ?? 0xFF4FC3F7;
      _primaryColor = Color(colorValue);
      final imagePath = prefs.getString('profile_image');
      if (imagePath != null) {
        _profileImage = File(imagePath);
      }
    });
  }

  void _handleScreenChanged() {
    _scaffoldKey.currentState?.closeDrawer();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen(
        changeTheme: widget.changeTheme,
        updateProfileImage: (newImage) {
          setState(() {
            _profileImage = newImage != null ? File(newImage) : null;
          });
        },
      )),
    ).then((_) async {
      await _loadPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const ListViewScreen(),
      const CardViewScreen(),
      const GridViewScreen(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Test_Music',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () async {
                await _loadPreferences();
                _scaffoldKey.currentState?.openDrawer();
              },
            );
          },
        ),
      ),
      drawer: _buildDrawer(),
      body: pages[_currentPageIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: _primaryColor.withOpacity(0.8),
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: _primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_profileImage != null)
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: FileImage(_profileImage!),
                  )
                else
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 30, color: Colors.white),
                  ),
                const SizedBox(height: 15),
                Text(
                  _userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                FutureBuilder<SharedPreferences>(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final email = snapshot.data!.getString('email') ?? "";
                      return Text(
                        email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
          // Solo mostramos la opción de Configuración
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: Colors.white),
            title: const Text(
              'Configuración',
              style: TextStyle(color: Colors.white),
            ),
            onTap: _handleScreenChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: _currentPageIndex,
      backgroundColor: _primaryColor.withOpacity(0.8),
      indicatorColor: _primaryColor.withOpacity(0.5),
      onDestinationSelected: (int index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      destinations: <Widget>[
        NavigationDestination(
          icon: Icon(Icons.list_outlined, color: Colors.grey[300]),
          selectedIcon: Icon(Icons.list, color: Colors.white),
          label: 'List',
        ),
        NavigationDestination(
          icon: Icon(Icons.card_giftcard, color: Colors.grey[300]),
          selectedIcon: Icon(Icons.card_giftcard, color: Colors.white),
          label: 'Card',
        ),
        NavigationDestination(
          icon: Icon(Icons.grid_on_outlined, color: Colors.grey[300]),
          selectedIcon: Icon(Icons.grid_on, color: Colors.white),
          label: 'Grid',
        ),
      ],
    );
  }
}