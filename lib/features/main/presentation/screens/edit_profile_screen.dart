import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unilane/features/main/models/campus_mart_models.dart';
import 'package:unilane/features/main/presentation/providers/campus_mart_provider.dart';
import 'package:unilane/features/main/presentation/widgets/shared_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final UserProfileItem profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _displayNameController;
  late final TextEditingController _contactController;
  late final TextEditingController _campusController;
  late final TextEditingController _bioController;
  late final TextEditingController _interestsController;

  final List<String> _levels = const [
    '100 Level',
    '200 Level',
    '300 Level',
    '400 Level',
    '500 Level',
    'Postgraduate',
  ];

  late String _selectedLevel;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text: widget.profile.displayName,
    );
    _contactController = TextEditingController(text: widget.profile.contact);
    _campusController = TextEditingController(text: widget.profile.campus);
    _bioController = TextEditingController(text: widget.profile.bio);
    _interestsController = TextEditingController(
      text: widget.profile.interests.join(', '),
    );
    _selectedLevel = widget.profile.level.isNotEmpty
        ? widget.profile.level
        : _levels.first;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _contactController.dispose();
    _campusController.dispose();
    _bioController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_isSaving || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final provider = context.read<CampusMartProvider>();
    final updatedProfile = widget.profile.copyWith(
      displayName: _displayNameController.text.trim(),
      contact: _contactController.text.trim(),
      campus: _campusController.text.trim(),
      level: _selectedLevel,
      bio: _bioController.text.trim(),
      initials: _buildInitials(_displayNameController.text.trim()),
      interests: _parseInterests(_interestsController.text),
    );

    await provider.saveCurrentUserProfile(updatedProfile);

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });
    Navigator.of(context).pop(true);
  }

  List<String> _parseInterests(String rawInterests) {
    final interests = rawInterests
        .split(',')
        .map((interest) => interest.trim())
        .where((interest) => interest.isNotEmpty)
        .toList();

    if (interests.isEmpty) {
      return widget.profile.interests;
    }

    return interests;
  }

  String _buildInitials(String name) {
    final cleaned = name.trim();
    if (cleaned.isEmpty) {
      return 'UL';
    }

    final parts = cleaned
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return 'UL';
    }

    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length >= 2 ? 2 : 1)
          .toUpperCase();
    }

    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: const Color(0xFFF8FAFC),
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF111827),
            size: 20,
          ),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF8FBFF), Color(0xFFEAF2FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFDDE8FF)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1D4ED8),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _buildInitials(_displayNameController.text),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.profile.displayName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              const SizedBox(height: 6),
                              TrustBadge(
                                label: widget.profile.isVerifiedStudent
                                    ? 'Verified student'
                                    : 'Verification pending',
                                backgroundColor:
                                    widget.profile.isVerifiedStudent
                                    ? const Color(0xFFE8F8EF)
                                    : const Color(0xFFFFF4E5),
                                foregroundColor:
                                    widget.profile.isVerifiedStudent
                                    ? const Color(0xFF15803D)
                                    : const Color(0xFFB45309),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Keep your profile clean and specific so students can trust who they are dealing with.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const _FieldLabel('Display Name'),
              const SizedBox(height: 8),
              TextFormField(
                key: const Key('editProfileDisplayNameField'),
                controller: _displayNameController,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => setState(() {}),
                decoration: _buildDecoration(
                  hintText: 'Enter your full name',
                  prefixIcon: Icons.person_outline_rounded,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your display name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const _FieldLabel('Contact'),
              const SizedBox(height: 8),
              TextFormField(
                key: const Key('editProfileContactField'),
                controller: _contactController,
                decoration: _buildDecoration(
                  hintText: 'Email address or phone number',
                  prefixIcon: Icons.alternate_email_rounded,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your contact details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const _FieldLabel('Campus'),
              const SizedBox(height: 8),
              TextFormField(
                key: const Key('editProfileCampusField'),
                controller: _campusController,
                textCapitalization: TextCapitalization.words,
                decoration: _buildDecoration(
                  hintText: 'Your campus or university',
                  prefixIcon: Icons.school_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your campus';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const _FieldLabel('Level'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                key: const Key('editProfileLevelField'),
                initialValue: _levels.contains(_selectedLevel)
                    ? _selectedLevel
                    : _levels.first,
                items: _levels
                    .map(
                      (level) => DropdownMenuItem<String>(
                        value: level,
                        child: Text(level),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedLevel = value;
                  });
                },
                decoration: _buildDecoration(
                  hintText: 'Select your level',
                  prefixIcon: Icons.badge_outlined,
                ),
              ),
              const SizedBox(height: 16),
              const _FieldLabel('Bio'),
              const SizedBox(height: 8),
              TextFormField(
                key: const Key('editProfileBioField'),
                controller: _bioController,
                maxLines: 4,
                decoration: _buildDecoration(
                  hintText:
                      'Tell other students what you usually buy, sell, or look for on campus.',
                  prefixIcon: Icons.notes_rounded,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please add a short bio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const _FieldLabel('Interests'),
              const SizedBox(height: 8),
              TextFormField(
                key: const Key('editProfileInterestsField'),
                controller: _interestsController,
                decoration: _buildDecoration(
                  hintText: 'Marketplace, Lodges, Chat',
                  prefixIcon: Icons.interests_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please add at least one interest';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  key: const Key('saveProfileButton'),
                  onPressed: _isSaving ? null : _saveProfile,
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: const Color(0xFF6B7280)),
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF1D4ED8), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.2),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }
}
