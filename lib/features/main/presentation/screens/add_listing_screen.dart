import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:unilane/features/main/models/campus_mart_models.dart';
import 'package:unilane/features/main/presentation/providers/campus_mart_provider.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key, this.initialCategory = 'Books'});

  final String initialCategory;

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _imagePicker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _roomTypeController = TextEditingController();
  final _rentDurationController = TextEditingController();
  final _utilitiesController = TextEditingController();
  final _distanceToCampusController = TextEditingController();
  final _sellerNameController = TextEditingController();
  final _sellerRoleController = TextEditingController();

  late String _selectedCategory;
  String _selectedCondition = 'New';
  Uint8List? _pickedImageBytes;
  String? _pickedImageMimeType;
  bool _isPickingImage = false;
  bool _hasPrefilledSellerInfo = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = _availableCategories.contains(widget.initialCategory)
        ? widget.initialCategory
        : 'Books';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_hasPrefilledSellerInfo) {
      return;
    }

    final profile = context.read<CampusMartProvider>().currentUserProfile;
    if (profile != null && _sellerNameController.text.trim().isEmpty) {
      _sellerNameController.text = profile.displayName;
    }

    if (_sellerRoleController.text.trim().isEmpty) {
      _sellerRoleController.text = profile?.isVerifiedStudent == true
          ? 'Verified student seller'
          : 'Student seller';
    }

    _hasPrefilledSellerInfo = true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    _roomTypeController.dispose();
    _rentDurationController.dispose();
    _utilitiesController.dispose();
    _distanceToCampusController.dispose();
    _sellerNameController.dispose();
    _sellerRoleController.dispose();
    super.dispose();
  }

  static const List<String> _availableCategories = <String>[
    'Books',
    'Electronics',
    'Furniture',
    'Clothing',
    'Lodges',
  ];

  bool get _isLodgeListing => _selectedCategory == 'Lodges';

  String get _heroTitle =>
      _isLodgeListing ? 'Share a place to stay' : 'Share what you want to sell';

  String get _heroSubtitle => _isLodgeListing
      ? 'Add a clear lodge listing so students can compare stays faster on UniLane.'
      : 'Add a clean listing so students can find it faster on UniLane.';

  String get _sectionTitle =>
      _isLodgeListing ? 'Lodge details' : 'Listing details';

  String get _sellerSectionTitle =>
      _isLodgeListing ? 'Landlord details' : 'Seller details';

  String get _tipText => _isLodgeListing
      ? 'Tip: Add good photos and be clear about rent, location, and what is included.'
      : 'Tip: Keep your title short and your description clear. That usually gets better responses.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(_isLodgeListing ? 'Post Lodge' : 'Post Listing'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _heroTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _heroSubtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _sectionTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),
              _buildField(
                fieldKey: const Key('listingTitleField'),
                controller: _titleController,
                label: 'Item title',
                hint: 'e.g. HP Laptop',
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              _buildField(
                fieldKey: const Key('listingPriceField'),
                controller: _priceController,
                label: 'Price',
                hint: 'e.g. 250000',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              _buildField(
                fieldKey: const Key('listingLocationField'),
                controller: _locationController,
                label: 'Location',
                hint: 'e.g. Rumuolumeni',
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: _inputDecoration('Category'),
                items: const [
                  DropdownMenuItem(value: 'Books', child: Text('Books')),
                  DropdownMenuItem(
                    value: 'Electronics',
                    child: Text('Electronics'),
                  ),
                  DropdownMenuItem(
                    value: 'Furniture',
                    child: Text('Furniture'),
                  ),
                  DropdownMenuItem(value: 'Clothing', child: Text('Clothing')),
                  DropdownMenuItem(value: 'Lodges', child: Text('Lodges')),
                ],
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedCondition,
                decoration: _inputDecoration('Condition'),
                items: const [
                  DropdownMenuItem(value: 'New', child: Text('New')),
                  DropdownMenuItem(
                    value: 'Used - Excellent',
                    child: Text('Used - Excellent'),
                  ),
                  DropdownMenuItem(
                    value: 'Used - Good',
                    child: Text('Used - Good'),
                  ),
                  DropdownMenuItem(
                    value: 'Used - Fair',
                    child: Text('Used - Fair'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _selectedCondition = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildField(
                controller: _imageUrlController,
                label: 'Image URL (optional)',
                hint: 'Paste a photo link or leave blank',
              ),
              const SizedBox(height: 12),
              _buildImagePickerSection(),
              if (_isLodgeListing) ...[
                const SizedBox(height: 12),
                _buildLodgeSpecificFields(),
              ],
              const SizedBox(height: 12),
              _buildField(
                fieldKey: const Key('listingDescriptionField'),
                controller: _descriptionController,
                label: 'Description',
                hint: 'Tell students what makes it useful',
                maxLines: 5,
                validator: _requiredValidator,
              ),
              const SizedBox(height: 20),
              Text(
                _sellerSectionTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),
              _buildField(
                fieldKey: const Key('sellerNameField'),
                controller: _sellerNameController,
                label: 'Your name',
                hint: 'e.g. Kenneth Okoh',
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              _buildField(
                fieldKey: const Key('sellerRoleField'),
                controller: _sellerRoleController,
                label: 'Your role (optional)',
                hint: 'e.g. Student seller',
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Text(
                  _tipText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B5563),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _publishListing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Publish Listing'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF2563EB)),
      ),
    );
  }

  Widget _buildField({
    Key? fieldKey,
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      decoration: _inputDecoration(label).copyWith(hintText: hint),
    );
  }

  Widget _buildImagePickerSection() {
    final hasPickedImage = _pickedImageBytes != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload a photo',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You can add a gallery photo here. If you do, it will be saved with the listing.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          if (hasPickedImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.memory(
                _pickedImageBytes!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_outlined,
                    size: 34,
                    color: Color(0xFF9CA3AF),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No photo selected yet',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isPickingImage ? null : _pickImage,
                  icon: _isPickingImage
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.photo_library_outlined),
                  label: Text(hasPickedImage ? 'Change photo' : 'Choose photo'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2563EB),
                    side: const BorderSide(color: Color(0xFF2563EB)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              if (hasPickedImage) ...[
                const SizedBox(width: 12),
                TextButton(
                  onPressed: _clearPickedImage,
                  child: const Text('Remove'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLodgeSpecificFields() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lodge specifics',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'These details help students compare stays more quickly.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          _buildField(
            fieldKey: const Key('roomTypeField'),
            controller: _roomTypeController,
            label: 'Room type (optional)',
            hint: 'Self-contained, Single room, Mini flat',
          ),
          const SizedBox(height: 12),
          _buildField(
            fieldKey: const Key('rentDurationField'),
            controller: _rentDurationController,
            label: 'Rent duration (optional)',
            hint: 'Per year, Per semester, Monthly',
          ),
          const SizedBox(height: 12),
          _buildField(
            fieldKey: const Key('utilitiesField'),
            controller: _utilitiesController,
            label: 'Utilities included (optional)',
            hint: 'Water, Power, Wi-Fi',
          ),
          const SizedBox(height: 12),
          _buildField(
            fieldKey: const Key('distanceToCampusField'),
            controller: _distanceToCampusController,
            label: 'Distance to campus (optional)',
            hint: '10 mins walk, 5 mins drive',
          ),
        ],
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  Future<void> _pickImage() async {
    setState(() {
      _isPickingImage = true;
    });

    try {
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (pickedImage == null) {
        return;
      }

      final bytes = await pickedImage.readAsBytes();
      if (!mounted) {
        return;
      }

      setState(() {
        _pickedImageBytes = bytes;
        _pickedImageMimeType = _mimeTypeForFileName(pickedImage.name);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  void _clearPickedImage() {
    setState(() {
      _pickedImageBytes = null;
      _pickedImageMimeType = null;
    });
  }

  Future<void> _publishListing() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final imageUrl = _pickedImageBytes != null
        ? _buildDataUriForPickedImage()
        : _imageUrlController.text.trim().isEmpty
        ? _defaultImageForCategory(_selectedCategory)
        : _imageUrlController.text.trim();
    final price = _formatPrice(_priceController.text);

    final listing = ListingItem(
      imageUrl: imageUrl,
      title: _titleController.text.trim(),
      price: price,
      location: _locationController.text.trim(),
      category: _selectedCategory,
      description: _descriptionController.text.trim(),
      sellerName: _sellerNameController.text.trim(),
      sellerRole: _sellerRoleController.text.trim().isEmpty
          ? 'Student seller'
          : _sellerRoleController.text.trim(),
      condition: _selectedCondition,
      postedTime: 'Posted just now',
      badge: _selectedCondition,
      roomType: _selectedCategory == 'Lodges'
          ? _roomTypeController.text.trim().isEmpty
                ? null
                : _roomTypeController.text.trim()
          : null,
      rentDuration: _selectedCategory == 'Lodges'
          ? _rentDurationController.text.trim().isEmpty
                ? null
                : _rentDurationController.text.trim()
          : null,
      utilities: _selectedCategory == 'Lodges'
          ? _utilitiesController.text.trim().isEmpty
                ? null
                : _utilitiesController.text.trim()
          : null,
      distanceToCampus: _selectedCategory == 'Lodges'
          ? _distanceToCampusController.text.trim().isEmpty
                ? null
                : _distanceToCampusController.text.trim()
          : null,
    );

    await context.read<CampusMartProvider>().addMarketplaceListing(listing);
    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(listing);
  }

  String _buildDataUriForPickedImage() {
    final bytes = _pickedImageBytes;

    if (bytes == null) {
      return _defaultImageForCategory(_selectedCategory);
    }

    final mimeType = _pickedImageMimeType ?? 'image/jpeg';
    return 'data:$mimeType;base64,${base64Encode(bytes)}';
  }

  String _formatPrice(String rawValue) {
    final cleaned = rawValue.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleaned.isEmpty) {
      return 'N0';
    }

    final value = int.parse(cleaned);
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (match) => '${match[1]},',
    );

    return 'N$formatted';
  }

  String _defaultImageForCategory(String category) {
    switch (category) {
      case 'Electronics':
        return 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=900&q=80';
      case 'Furniture':
        return 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80';
      case 'Clothing':
        return 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=900&q=80';
      case 'Lodges':
        return 'https://images.unsplash.com/photo-1513258496099-48168024aec0?auto=format&fit=crop&w=900&q=80';
      case 'Books':
      default:
        return 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=900&q=80';
    }
  }

  String _mimeTypeForFileName(String fileName) {
    final lowerName = fileName.toLowerCase();

    if (lowerName.endsWith('.png')) {
      return 'image/png';
    }

    if (lowerName.endsWith('.webp')) {
      return 'image/webp';
    }

    return 'image/jpeg';
  }
}
