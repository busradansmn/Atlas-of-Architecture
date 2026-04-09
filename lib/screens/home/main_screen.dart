import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/login_dialog.dart';
import '../saved/saved_screen.dart';
import '../trends/trends_screen.dart';
import 'home_screen.dart';
import 'package:mimari_atlas/features/data/models/user_model.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  bool _hasShownLoginDialog = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final user = ref.read(userProvider);
    if (!_hasShownLoginDialog && !user.isAuthenticated && !user.isGuest) {
      _hasShownLoginDialog = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _showLoginDialog();
        }
      });
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoginDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavProvider);
    final user = ref.watch(userProvider);

    final screens = [
      const HomeScreen(),
      const TrendsScreen(),
      const SavedScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mimari Atlas'),
        actions: [
          _buildIconButtonProfile(user),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: _buildBottomNavigationBar(currentIndex),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        ref.read(bottomNavProvider.notifier).state = index;
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Ana Sayfa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up_outlined),
          activeIcon: Icon(Icons.trending_up),
          label: 'Trendler',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_border),
          activeIcon: Icon(Icons.bookmark),
          label: 'Kaydedilenler',
        ),
      ],
    );
  }

  IconButton _buildIconButtonProfile(UserModel user) {
    return IconButton(
      icon: const Icon(Icons.person),
      onPressed: () {
        if (user.isGuest || !user.isAuthenticated) {
          _showLoginDialog();
        } else {
          _showUserMenu();
        }
      },
    );
  }

  void _showUserMenu() {
    final user = ref.read(userProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.lightPurple,
              child: Text(
                user.name?.substring(0, 1).toUpperCase() ?? 'K',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name ?? 'Kullanıcı',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.email ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.primaryPurple),
              title: const Text('Çıkış Yap'),
              onTap: () async {
                Navigator.pop(context);
                await ref.read(userProvider.notifier).logout();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Çıkış yapıldı')),
                  );
                  _showLoginDialog();
                }
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
