import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/pure_white_theme.dart';
import '../../../core/services/api_service.dart';
import '../../learning/screens/lesson_player_screen.dart';
import '../../assistant/screens/assistant_screen.dart';
import 'guardian_summary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _nextLesson;
  bool _isLoading = true;
  
  List<dynamic> _tracks = [];
  bool _isLoadingTracks = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNextLesson();
    _fetchTracks();
  }

  Future<void> _fetchNextLesson() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final learnerId = prefs.getString('learnerId');
      
      if (learnerId != null) {
        final result = await _apiService.getNextLesson(learnerId);
        if (mounted) {
          setState(() {
            _nextLesson = result;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Fetch Next Lesson Error: $e");
      if (mounted) {
        setState(() {
          _error = "Emergency Mode: Limited data available!";
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchTracks() async {
    try {
      final tracks = await _apiService.getTracks();
      if (mounted) {
        setState(() {
          _tracks = tracks;
          _isLoadingTracks = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingTracks = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PureWhiteTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sannu, Gimbiya!",
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: PureWhiteTheme.deepIndigo,
                        ),
                      ),
                      Text(
                        "Ready for magic today?",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: PureWhiteTheme.divider, width: 2),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: ClipOval(
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Image.asset(
                          'assets/images/jidda_avatar.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Enhanced Daily Progress Card
              _buildProgressCard(context),
              const SizedBox(height: 32),

              // Main CTA: Continue Learning
              _buildContinueLearningCard(context),
              const SizedBox(height: 32),

              // Quick Actions Grid
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      title: "My Growth",
                      icon: LucideIcons.trendingUp,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const GuardianSummaryScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      title: "Ask Jidda",
                      icon: LucideIcons.mic,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const AssistantScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Curriculum Browser Title
              Text(
                "Learning Path",
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: PureWhiteTheme.deepIndigo,
                ),
              ),
              const SizedBox(height: 20),
              
              if (_isLoadingTracks)
                const Center(child: CircularProgressIndicator())
              else if (_tracks.isEmpty)
                _buildEmptyTracks(context)
              else
                _buildTrackList(),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FE),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.star, color: Color(0xFFFFD700), size: 32),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Level Progress",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: PureWhiteTheme.deepIndigo,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "40%",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 0.4,
                    backgroundColor: Colors.white,
                    color: PureWhiteTheme.deepIndigo,
                    minHeight: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueLearningCard(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FE),
          borderRadius: BorderRadius.circular(32),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final lessonTitle = _nextLesson?['lesson']?['title'] ?? "Let's Get Started!";
    final rationale = _nextLesson?['rationale'] ?? "Discover something new today!";
    final lessonId = _nextLesson?['lesson']?['id'];

    return GestureDetector(
      onTap: () {
        if (lessonId != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LessonPlayerScreen(lessonId: lessonId),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A1F71), Color(0xFF3B44B3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A1F71).withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(LucideIcons.playCircle, color: Colors.white, size: 48),
            const SizedBox(height: 24),
            Text(
              "Continue Learning",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              lessonTitle,
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              rationale,
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFFF0F0F0)),
          boxShadow: [
            BoxShadow(
              color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: PureWhiteTheme.deepIndigo, size: 28),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: PureWhiteTheme.deepIndigo,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTracks(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FE),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          const Icon(LucideIcons.map, color: PureWhiteTheme.divider, size: 48),
          const SizedBox(height: 16),
          Text(
            "Demo Mode",
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: PureWhiteTheme.deepIndigo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Explore pre-loaded lessons above!",
            style: GoogleFonts.inter(
              color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _tracks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final track = _tracks[index];
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFF0F0F0)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F9FE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.bookOpen, color: PureWhiteTheme.deepIndigo, size: 20),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track['name'] ?? 'Learning Track',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: PureWhiteTheme.deepIndigo,
                        fontSize: 18,
                      ),
                    ),
                    if (track['description'] != null)
                      Text(
                        track['description'],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, size: 20, color: PureWhiteTheme.divider),
            ],
          ),
        );
      },
    );
  }
}
