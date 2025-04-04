import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  final Function() onThemeToggle;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(5, (index) => GlobalKey());
  bool _showAllProjects = false;
  int _visibleProjects = 2; // Track number of visible projects
  int _visibleWebProjects = 3; // Track number of visible projects in web view

  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  void _scrollToSection(int index) {
    Scrollable.ensureVisible(
      _sectionKeys[index].currentContext!,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _loadMoreProjects() {
    setState(() {
      if (isMobile(context)) {
        _visibleProjects += 2;
        if (_visibleProjects >= 7) { // Total number of projects
          _showAllProjects = true;
        }
      } else {
        _visibleWebProjects += 3;
        if (_visibleWebProjects >= 7) { // Total number of projects
          _showAllProjects = true;
        }
      }
    });
  }

  Widget _buildDrawer() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/my_portofolio_image.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  'Rohan Katwal',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.person, 'About Me', 0),
          _buildDrawerItem(Icons.code, 'Skills', 1),
          _buildDrawerItem(Icons.work, 'Projects', 2),
          _buildDrawerItem(Icons.contact_mail, 'Get in Touch', 3),
          const Divider(color: Colors.white24),
          ListTile(
            leading: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              '${isDark ? 'Light' : 'Dark'} Mode',
              style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            onTap: widget.onThemeToggle,
          ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
        ],
      ),
    ).animate().slideX(
      begin: -1,
      end: 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.onBackground),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
      onTap: () {
        Navigator.pop(context);
        _scrollToSection(index);
      },
    ).animate().fadeIn(delay: Duration(milliseconds: 100 * index));
  }

  Widget _buildWebNavBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'RK',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Row(
            children: [
              _buildNavBarItem('Home', 0),
              _buildNavBarItem('About Me', 1),
              _buildNavBarItem('Skillset', 2),
              _buildNavBarItem('Projects', 3),
              _buildNavBarItem('Get in Touch', 4),
              const SizedBox(width: 16),
              IconButton(
                onPressed: widget.onThemeToggle,
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                tooltip: '${isDark ? 'Light' : 'Dark'} Mode',
              ).animate().fadeIn(duration: 600.ms),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(String title, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () => _scrollToSection(index),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: isMobile(context)
          ? AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Text(
                'Rohan Katwal',
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
              ),
              iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onBackground),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: widget.onThemeToggle,
                  icon: Icon(
                    widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  tooltip: '${widget.isDarkMode ? 'Light' : 'Dark'} Mode',
                ),
              ],
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background.withOpacity(0.95),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _buildWebNavBar(),
              ),
            ),
      drawer: isMobile(context) ? _buildDrawer() : null,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Hero Section
                Container(
                  key: _sectionKeys[0],
                  constraints: const BoxConstraints(minHeight: 400),
                  height: isMobile(context) 
                      ? MediaQuery.of(context).size.height * 0.8
                      : MediaQuery.of(context).size.height * 0.8,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile(context) ? 20 : 48,
                    vertical: isMobile(context) ? 24 : 0,
                  ),
                  color: Theme.of(context).colorScheme.background,
                  child: isMobile(context)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildProfileImage(context),
                            const SizedBox(height: 24),
                            _buildHeroContent(context),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: _buildHeroContent(context)),
                            Expanded(child: _buildProfileImage(context)),
                          ],
                        ),
                ),

                // About Section
                Container(
                  key: _sectionKeys[1],
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        Theme.of(context).colorScheme.primary.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'About Me',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                          ).animate()
                            .fadeIn(duration: 600.ms)
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1, 1),
                              duration: 600.ms,
                              curve: Curves.easeOutBack,
                            ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                width: 1,
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).colorScheme.surface,
                                  Theme.of(context).colorScheme.surface.withOpacity(0.95),
                                ],
                              ),
                            ),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.basic,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                transform: Matrix4.identity(),
                                child: Column(
                                  children: [
                                    Text(
                                      'I am a Software Engineering student at Pokhara University (6th semester) from Damak, Jhapa with a passion for solving complex problems through technology. I enjoy designing and developing efficient, scalable, and user-friendly applications. My curiosity drives me to explore new technologies and refine my development skills.',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        height: 1.6,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      'I thrive in challenging environments, where I can analyze problems, break them down into smaller tasks, and develop optimized solutions. Whether it\'s debugging tricky issues, optimizing performance, or architecting scalable systems, I approach every challenge with a logical and solution-oriented mindset. Beyond coding, I enjoy collaborating with teams, sharing knowledge, and continuously learning to improve my craft. 🚀',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        height: 1.6,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ).animate()
                            .fadeIn(duration: 800.ms, delay: 200.ms)
                            .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 800.ms,
                              delay: 200.ms,
                              curve: Curves.easeOutBack,
                            )
                            .then()
                            .shimmer(duration: 1200.ms)
                            .then()
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .shimmer(
                              duration: 2000.ms,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Skills Section
                Container(
                  key: _sectionKeys[2],
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile(context) ? 20 : 48,
                    vertical: 48,
                  ),
                  color: Theme.of(context).colorScheme.background,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.code,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Skillset',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                          ).animate()
                            .fadeIn(duration: 600.ms)
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1, 1),
                              duration: 600.ms,
                              curve: Curves.easeOutBack,
                            ),
                          const SizedBox(height: 24),
                          MouseRegion(
                            cursor: SystemMouseCursors.basic,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              transform: Matrix4.identity(),
                              child: Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  _buildSkillChip(
                                    icon: FontAwesomeIcons.flutter,
                                    tooltip: 'Flutter',
                                  ),
                                  _buildSkillChip(
                                    icon: FontAwesomeIcons.code,
                                    tooltip: 'Dart',
                                  ),
                                  _buildSkillChip(
                                    icon: FontAwesomeIcons.layerGroup,
                                    tooltip: 'Bloc',
                                  ),
                                  _buildSkillChip(
                                    icon: FontAwesomeIcons.fire,
                                    tooltip: 'Firebase',
                                  ),
                                  _buildSkillChip(
                                    icon: FontAwesomeIcons.server,
                                    tooltip: 'RESTful APIs',
                                  ),
                                  _buildSkillChip(
                                    icon: FontAwesomeIcons.database,
                                    tooltip: 'Local Storage',
                                  ),
                                  _buildSkillChip(
                                    icon: FontAwesomeIcons.plug,
                                    tooltip: 'Socket.IO',
                                  ),
                                  _buildSkillChip(
                                    icon: FontAwesomeIcons.vial,
                                    tooltip: 'Testing',
                                  ),
                                  _buildSkillChip(
                                    icon: FontAwesomeIcons.cube,
                                    tooltip: 'Cubit',
                                  ),
                                  _buildSkillChip(
                                    icon: FontAwesomeIcons.database,
                                    tooltip: 'MongoDB',
                                  ),
                                  _buildSkillChip(
                                    icon: FontAwesomeIcons.database,
                                    tooltip: 'PostgreSQL',
                                  ),
                                  _buildSkillChip(
                                    icon: FontAwesomeIcons.java,
                                    tooltip: 'Java',
                                  ),
                                  _buildSkillChip(
                                    icon: FontAwesomeIcons.leaf,
                                    tooltip: 'Spring Boot',
                                  ),
                                ],
                              ),
                            ),
                          ).animate()
                            .fadeIn(duration: 800.ms, delay: 200.ms)
                            .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 800.ms,
                              delay: 200.ms,
                              curve: Curves.easeOutBack,
                            )
                            .then()
                            .shimmer(duration: 1200.ms)
                            .then()
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .shimmer(
                              duration: 2000.ms,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Projects Section
                Container(
                  key: _sectionKeys[3],
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile(context) ? 20 : 48,
                    vertical: 48,
                  ),
                  color: Theme.of(context).colorScheme.surface,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.work_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Projects',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                          ).animate()
                            .fadeIn(duration: 600.ms)
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1, 1),
                              duration: 600.ms,
                              curve: Curves.easeOutBack,
                            ),
                          const SizedBox(height: 8),
                          Text(
                            'Here are some of my featured projects',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 32),
                          MouseRegion(
                            cursor: SystemMouseCursors.basic,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              transform: Matrix4.identity(),
                              child: GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: isMobile(context) ? 1 : 3,
                                crossAxisSpacing: 24,
                                mainAxisSpacing: 24,
                                physics: const NeverScrollableScrollPhysics(),
                                childAspectRatio: isMobile(context) ? 0.45 : 0.55,
                                children: [
                                  _buildProjectCard(
                                    title: 'Gurukul Student App',
                                    description: 'A comprehensive student management system that revolutionizes educational institutions. The app provides real-time attendance tracking, assignment management, and progress monitoring. It features push notifications for important updates, detailed performance analytics, and seamless parent-teacher communication. The system includes exam schedule management and integrated fee payment solutions, making it a complete solution for modern educational institutions.',
                                    icon: Icons.school_outlined,
                                    githubLink: 'https://github.com/Katwal07/gurukul-student-app',
                                    playStoreLink: 'https://play.google.com/store/apps/details?id=com.rohankatwal.gurukulstudentapp',
                                    appStoreLink: 'https://apps.apple.com/us/app/gurukul-student-app/id1594444444',
                                    companyInfo: 'I worked on this project when I was working at DesVu Technologies Private Limited.',
                                    imageUrl: 'assets/images/gurukul_logo.png',
                                  ),
                                  _buildProjectCard(
                                    title: 'Kuruwa Sewa',
                                    description: 'A modern service marketplace platform that connects local service providers with customers. The app features a robust service provider verification system, real-time chat functionality, and secure payment integration. It includes service booking and scheduling capabilities, a comprehensive rating and review system, and location-based service discovery to help users find the right service providers in their area.',
                                    icon: Icons.handyman_outlined,
                                    githubLink: 'https://github.com/Katwal07/kuruwa-sewa',
                                    playStoreLink: 'https://kagazpatra.com/',
                                    appStoreLink: 'https://kagazpatra.com/',
                                    companyInfo: 'I worked on this project when I was working at DesVu Technologies Private Limited.',
                                    imageUrl: 'assets/images/kaagazpatralogo-DN6krflm.png',
                                  ),
                                  _buildProjectCard(
                                    title: 'Kagazpatra',
                                    description: 'An innovative digital document management system that transforms how organizations handle paperwork. The platform features advanced OCR capabilities for document scanning, secure cloud storage solutions, and automated workflow processing. It includes version control for document tracking, collaborative sharing features, digital signature integration, and intelligent document categorization and search functionality.',
                                    icon: Icons.description_outlined,
                                    githubLink: 'https://github.com/Katwal07/kagazpatra',
                                    playStoreLink: 'https://kagazpatra.com/',
                                    appStoreLink: 'https://kagazpatra.com/',
                                    companyInfo: 'I worked on this project when I was working at DesVu Technologies Private Limited.',
                                    imageUrl: 'assets/images/kaagazpatralogo-DN6krflm.png',
                                  ),
                                  if ((!isMobile(context) && _visibleWebProjects > 3) || (isMobile(context) && _visibleProjects > 2)) ...[
                                    if (isMobile(context) ? _visibleProjects > 2 : _visibleWebProjects > 3)
                                      _buildProjectCard(
                                        title: 'BidSewa',
                                        description: 'A sophisticated real-time bidding platform that brings auctions to the digital age. The system features live auction tracking, automated bidding capabilities, and secure payment processing. It includes comprehensive seller verification processes, buyer protection systems, real-time notifications, and detailed bid history and analytics to ensure a transparent and secure bidding experience.',
                                        icon: Icons.gavel,
                                        githubLink: 'https://github.com/Katwal07/bidSewa',
                                        playStoreLink: 'https://play.google.com/store/apps/details?id=com.rohankatwal.bidsawa',
                                        appStoreLink: 'https://apps.apple.com/us/app/bidsawa/id1594444444',
                                        imageUrl: 'assets/images/bidsewa_logo.png',
                                      ),
                                    if (isMobile(context) ? _visibleProjects > 3 : _visibleWebProjects > 4)
                                      _buildProjectCard(
                                        title: 'E-commerce App',
                                        description: 'A comprehensive e-commerce platform that provides a seamless shopping experience. The app features a robust product catalog with advanced search and filtering, secure payment gateway integration, and real-time inventory management. It includes user authentication, order tracking, wishlist functionality, and a sophisticated recommendation engine to enhance the shopping experience.',
                                        icon: Icons.shopping_cart_outlined,
                                        githubLink: 'https://github.com/Katwal07/Ecommerse_Application',
                                        playStoreLink: 'https://play.google.com/store/apps/details?id=com.rohankatwal.ecommerceapp',
                                        appStoreLink: 'https://apps.apple.com/us/app/ecommerce-app/id1594444444',
                                        imageUrl: 'assets/images/images.jpeg',
                                      ),
                                    if (isMobile(context) ? _visibleProjects > 4 : _visibleWebProjects > 5)
                                      _buildProjectCard(
                                        title: 'Weather App',
                                        description: 'A sleek and intuitive weather application that provides accurate and detailed weather forecasts. The app features real-time weather updates, hourly and daily forecasts, and severe weather alerts. It includes location-based weather information, interactive weather maps, and customizable weather widgets. The platform also provides weather history, air quality index, and UV index information.',
                                        icon: Icons.cloud_outlined,
                                        githubLink: 'https://github.com/Katwal07/weather_api',
                                        playStoreLink: 'https://play.google.com/store/apps/details?id=com.rohankatwal.weatherapp',
                                        appStoreLink: 'https://apps.apple.com/us/app/weather-app/id1594444444',
                                        imageUrl: 'assets/images/istockphoto-1257951336-612x612.jpg',
                                      ),
                                    if (isMobile(context) ? _visibleProjects > 5 : _visibleWebProjects > 6)
                                      _buildProjectCard(
                                        title: 'Movie App',
                                        description: 'A sleek and intuitive movie streaming application that delivers an exceptional viewing experience. The platform features personalized recommendations based on viewing history, offline viewing capabilities, and seamless multi-device synchronization. It includes social sharing features, comprehensive watchlist management, user reviews and ratings, and intelligent content categorization for easy discovery.',
                                        icon: Icons.movie_outlined,
                                        githubLink: 'https://github.com/Katwal07/MovieApp',
                                        playStoreLink: 'https://play.google.com/store/apps/details?id=com.rohankatwal.movieapp',
                                        appStoreLink: 'https://apps.apple.com/us/app/movie-app/id1594444444',
                                        imageUrl: 'assets/images/logo.png',
                                      ),
                                    if (isMobile(context) ? _visibleProjects > 6 : _visibleWebProjects > 7)
                                      _buildProjectCard(
                                        title: 'Journo',
                                        description: 'A feature-rich blogging platform designed for modern content creators. The app includes a powerful rich text editor with markdown support, image optimization with CDN integration, and seamless social sharing capabilities. It features a robust user authentication system, comprehensive comments and moderation tools, intelligent content categorization, and advanced search and filtering options.',
                                        icon: Icons.edit_document,
                                        githubLink: 'https://github.com/Katwal07/blog_app',
                                        playStoreLink: 'https://play.google.com/store/apps/details?id=com.rohankatwal.blogapp',
                                        appStoreLink: 'https://apps.apple.com/us/app/blog-app/id1594444444',
                                        imageUrl: 'assets/images/main_logo.svg',
                                      ),
                                  ],
                                ],
                              ),
                            ),
                          ).animate()
                            .fadeIn(duration: 800.ms, delay: 200.ms)
                            .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 800.ms,
                              delay: 200.ms,
                              curve: Curves.easeOutBack,
                            )
                            .then()
                            .shimmer(duration: 1200.ms)
                            .then()
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .shimmer(
                              duration: 2000.ms,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            ),
                          if ((!isMobile(context) && _visibleWebProjects < 8) || (isMobile(context) && _visibleProjects < 8)) ...[
                            const SizedBox(height: 24),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.secondary,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _loadMoreProjects,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'See More Projects',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 16,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ],
                                ),
                              ),
                            ).animate()
                              .fadeIn(duration: 600.ms)
                              .scale(
                                begin: const Offset(0.8, 0.8),
                                end: const Offset(1, 1),
                                duration: 600.ms,
                                curve: Curves.easeOutBack,
                              )
                              .then()
                              .shimmer(
                                duration: 1200.ms,
                                color: Colors.white.withOpacity(0.2),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // Contact Section
                Container(
                  key: _sectionKeys[4],
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile(context) ? 20 : 48,
                    vertical: 24,
                  ),
                  color: Theme.of(context).colorScheme.background,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.contact_mail_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Get in Touch',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                          ).animate()
                            .fadeIn(duration: 600.ms)
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1, 1),
                              duration: 600.ms,
                              curve: Curves.easeOutBack,
                            ),
                          const SizedBox(height: 12),
                          MouseRegion(
                            cursor: SystemMouseCursors.basic,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              transform: Matrix4.identity(),
                              child: Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  _buildSocialButton(
                                    icon: Icons.email_outlined,
                                    onTap: () async {
                                      final Uri emailLaunchUri = Uri(
                                        scheme: 'mailto',
                                        path: 'rohankatwal05@gmail.com',
                                      );
                                      if (await canLaunchUrl(emailLaunchUri)) {
                                        await launchUrl(emailLaunchUri);
                                      }
                                    },
                                  ),
                                  _buildSocialButton(
                                    icon: FontAwesomeIcons.linkedin,
                                    onTap: () async {
                                      final Uri url = Uri.parse('https://www.linkedin.com/feed/');
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url, mode: LaunchMode.externalApplication);
                                      }
                                    },
                                  ),
                                  _buildSocialButton(
                                    icon: FontAwesomeIcons.github,
                                    onTap: () async {
                                      final Uri url = Uri.parse('https://github.com/Katwal07');
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url, mode: LaunchMode.externalApplication);
                                      }
                                    },
                                  ),
                                  _buildSocialButton(
                                    icon: FontAwesomeIcons.facebook,
                                    onTap: () async {
                                      final Uri url = Uri.parse('https://www.facebook.com/rohan.katwal.106/');
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url, mode: LaunchMode.externalApplication);
                                      }
                                    },
                                  ),
                                  _buildSocialButton(
                                    icon: FontAwesomeIcons.instagram,
                                    onTap: () async {
                                      final Uri url = Uri.parse('https://www.instagram.com/rohan.katawal/');
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url, mode: LaunchMode.externalApplication);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ).animate()
                            .fadeIn(duration: 800.ms, delay: 200.ms)
                            .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 800.ms,
                              delay: 200.ms,
                              curve: Curves.easeOutBack,
                            )
                            .then()
                            .shimmer(duration: 1200.ms)
                            .then()
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .shimmer(
                              duration: 2000.ms,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroContent(BuildContext context) {
    final isSmallScreen = isMobile(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: isSmallScreen 
          ? CrossAxisAlignment.center 
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Hi, I\'m Rohan Katwal',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 32 : null,
                color: Theme.of(context).colorScheme.onBackground,
              ),
          textAlign: isSmallScreen ? TextAlign.center : TextAlign.start,
        ).animate().fadeIn(duration: 600.ms).slideX(),
        const SizedBox(height: 16),
        Text(
          'Full Stack Developer',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: isSmallScreen ? 24 : null,
              ),
          textAlign: isSmallScreen ? TextAlign.center : TextAlign.start,
        ).animate().fadeIn(duration: 600.ms).slideX(delay: 200.ms),
        const SizedBox(height: 24),
        Text(
          'I build beautiful, functional, and scalable apps.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          textAlign: isSmallScreen ? TextAlign.center : TextAlign.start,
        ).animate().fadeIn(duration: 600.ms).slideX(delay: 400.ms),
        const SizedBox(height: 32),
        Wrap(
          alignment: isSmallScreen ? WrapAlignment.center : WrapAlignment.start,
          spacing: 16,
          runSpacing: 16,
          children: [
            ElevatedButton(
              onPressed: () => _scrollToSection(3),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Contact Me'),
            ).animate().fadeIn(duration: 600.ms).slideX(delay: 600.ms),
            OutlinedButton(
              onPressed: () {
                // Add your resume download action here
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Download CV'),
            ).animate().fadeIn(duration: 600.ms).slideX(delay: 800.ms),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    final size = isMobile(context) ? 200.0 : 300.0;
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/my_portofolio_image.png',
            fit: BoxFit.cover,
          ),
        ),
      ).animate()
        .fadeIn(duration: 800.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 1000.ms,
          curve: Curves.easeOutBack,
        )
        .shimmer(duration: 2000.ms, delay: 500.ms),
    );
  }

  Widget _buildSkillChip({
    required IconData icon,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
      ).animate()
        .fadeIn(duration: 600.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 600.ms,
          curve: Curves.easeOutBack,
        ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon),
        iconSize: 16,
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          foregroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.all(8),
          minimumSize: const Size(32, 32),
        ),
      ).animate(
        onPlay: (controller) => controller.repeat(),
      )
        .fadeIn()
        .then(delay: 200.ms)
        .scaleXY(
          begin: 1,
          end: 1.1,
          duration: 300.ms,
          curve: Curves.easeInOut,
        )
        .then(delay: 200.ms)
        .scaleXY(
          begin: 1.1,
          end: 1,
          duration: 300.ms,
          curve: Curves.easeInOut,
        ),
    );
  }

  Widget _buildProjectCard({
    required String title,
    required String description,
    required IconData icon,
    String? githubLink,
    String? playStoreLink,
    String? appStoreLink,
    String? companyInfo,
    String? imageUrl,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: title == 'BidSewa' || title == 'Movie App'
                        ? Theme.of(context).colorScheme.primary 
                        : null,
                    child: imageUrl.endsWith('.svg')
                        ? SvgPicture.asset(
                            imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
              if (companyInfo != null) ...[
                const SizedBox(height: 16),
                Text(
                  companyInfo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              const Spacer(),
              if (githubLink != null || playStoreLink != null || appStoreLink != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (githubLink != null)
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final Uri url = Uri.parse(githubLink);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            }
                          },
                          icon: const Icon(FontAwesomeIcons.github, size: 16),
                          label: const Text('GitHub'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    if (playStoreLink != null || appStoreLink != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (playStoreLink != null)
                            ElevatedButton.icon(
                              onPressed: () async {
                                final Uri url = Uri.parse(playStoreLink);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.externalApplication);
                                }
                              },
                              icon: const Icon(FontAwesomeIcons.googlePlay, size: 16),
                              label: const Text('Play Store'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                foregroundColor: Theme.of(context).colorScheme.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          if (appStoreLink != null) ...[
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final Uri url = Uri.parse(appStoreLink);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.externalApplication);
                                }
                              },
                              icon: const Icon(FontAwesomeIcons.appStore, size: 16),
                              label: const Text('App Store'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                foregroundColor: Theme.of(context).colorScheme.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ).animate()
        .fadeIn(duration: 600.ms, delay: 200.ms)
        .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 200.ms)
        .then()
        .shimmer(duration: 1200.ms),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
} 