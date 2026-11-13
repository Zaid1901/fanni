import 'package:material_ui/material_ui.dart';

import '../data/models.dart';
import 'account_screen.dart';
import 'home_screen.dart';
import 'requests_screen.dart';
import 'search_screen.dart';

/// Bottom navigation with the four main tabs.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  final _tradeFilter = ValueNotifier<Trade?>(null);

  @override
  void dispose() {
    _tradeFilter.dispose();
    super.dispose();
  }

  void _openSearch(Trade? trade) {
    _tradeFilter.value = trade;
    setState(() => _index = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onOpenSearch: _openSearch),
          SearchScreen(tradeFilter: _tradeFilter),
          const RequestsScreen(),
          const AccountScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: 'البحث',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment_rounded),
            label: 'طلباتي',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
