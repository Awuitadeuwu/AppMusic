import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/list_view.dart';
import 'views/card_view.dart';
import 'views/grid_view.dart';
import 'views/settings_screen.dart';

class ExampleDestination {
  const ExampleDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<ExampleDestination> destinations = <ExampleDestination>[
  ExampleDestination(
      'List',
      Icon(Icons.list_outlined),
      Icon(Icons.list)
  ),
  ExampleDestination(
      'Card',
      Icon(Icons.card_giftcard),
      Icon(Icons.card_giftcard)
  ),
  ExampleDestination(
      'Grid',
      Icon(Icons.grid_on_outlined),
      Icon(Icons.grid_on)
  ),
  ExampleDestination(
      'Configuración',
      Icon(Icons.settings_outlined),
      Icon(Icons.settings)
  ),
];

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
    });
  }

  void _handleScreenChanged(int selectedIndex) {
    _scaffoldKey.currentState?.closeDrawer();

    if (selectedIndex < 3) {
      setState(() {
        _currentPageIndex = selectedIndex;
      });
    } else if (selectedIndex == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen(changeTheme: widget.changeTheme)),
      ).then((_) async {
        await _loadPreferences();
      });
    }
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
          ...destinations.map<Widget>((ExampleDestination destination) {
            return ListTile(
              leading: destination.icon,
              title: Text(
                destination.label,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () => _handleScreenChanged(destinations.indexOf(destination)),
              tileColor: _currentPageIndex == destinations.indexOf(destination)
                  ? _primaryColor.withOpacity(0.5)
                  : null,
            );
          }).toList(),
          const Divider(color: Colors.white24, height: 20),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white),
            title: const Text(
              'About',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              _scaffoldKey.currentState?.closeDrawer();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('About this app'),
                  backgroundColor: _primaryColor,
                ),
              );
            },
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