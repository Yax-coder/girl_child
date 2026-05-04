import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softRose,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(),
              
              // Celebration Header
              const Icon(Icons.auto_awesome, color: AppTheme.sunsetOrange, size: 100),
              const SizedBox(height: 24),
              Text(
                "Masha'Allah! You're Shining!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppTheme.deepViolet,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "You’ve completed your first magic lesson.",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.deepViolet.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 60),

              // Achievement Cards
              _buildAchievementCard(
                context,
                title: "First Word Hunter",
                description: "You successfully found your first word!",
                icon: Icons.search,
              ),
              const SizedBox(height: 16),
              _buildAchievementCard(
                context,
                title: "Star Pupil",
                description: "You answered all quiz questions correctly.",
                icon: Icons.star,
              ),
              
              const Spacer(),

              // Action
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                     Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text("Next Adventure"),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.softViolet.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.softRose,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.sunsetOrange, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.deepViolet,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: AppTheme.deepViolet.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
