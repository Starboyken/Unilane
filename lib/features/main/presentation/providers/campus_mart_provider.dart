import 'package:flutter/foundation.dart';

enum SignupMethod { email, phone }

class CampusMartProvider extends ChangeNotifier {
  int _selectedTabIndex = 0;
  String _selectedMarketplaceCategory = 'All';
  String _selectedServiceCategory = 'All';
  SignupMethod _signupMethod = SignupMethod.email;
  String _homeSearchQuery = '';
  String _marketplaceSearchQuery = '';
  String _servicesSearchQuery = '';

  int get selectedTabIndex => _selectedTabIndex;
  String get selectedMarketplaceCategory => _selectedMarketplaceCategory;
  String get selectedServiceCategory => _selectedServiceCategory;
  SignupMethod get signupMethod => _signupMethod;
  String get homeSearchQuery => _homeSearchQuery;
  String get marketplaceSearchQuery => _marketplaceSearchQuery;
  String get servicesSearchQuery => _servicesSearchQuery;

  void setSelectedTab(int index) {
    if (_selectedTabIndex == index) return;

    _selectedTabIndex = index;
    notifyListeners();
  }

  void setMarketplaceCategory(String category) {
    if (_selectedMarketplaceCategory == category) return;

    _selectedMarketplaceCategory = category;
    notifyListeners();
  }

  void setServiceCategory(String category) {
    if (_selectedServiceCategory == category) return;

    _selectedServiceCategory = category;
    notifyListeners();
  }

  void setSignupMethod(SignupMethod method) {
    if (_signupMethod == method) return;

    _signupMethod = method;
    notifyListeners();
  }

  void setHomeSearchQuery(String query) {
    if (_homeSearchQuery == query) return;

    _homeSearchQuery = query;
    notifyListeners();
  }

  void setMarketplaceSearchQuery(String query) {
    if (_marketplaceSearchQuery == query) return;

    _marketplaceSearchQuery = query;
    notifyListeners();
  }

  void setServicesSearchQuery(String query) {
    if (_servicesSearchQuery == query) return;

    _servicesSearchQuery = query;
    notifyListeners();
  }

  void openMarketplace({String category = 'All'}) {
    var shouldNotify = false;

    if (_selectedTabIndex != 1) {
      _selectedTabIndex = 1;
      shouldNotify = true;
    }

    if (_selectedMarketplaceCategory != category) {
      _selectedMarketplaceCategory = category;
      shouldNotify = true;
    }

    if (_marketplaceSearchQuery.isNotEmpty) {
      _marketplaceSearchQuery = '';
      shouldNotify = true;
    }

    if (shouldNotify) {
      notifyListeners();
    }
  }

  void openServices({String category = 'All'}) {
    var shouldNotify = false;

    if (_selectedTabIndex != 2) {
      _selectedTabIndex = 2;
      shouldNotify = true;
    }

    if (_selectedServiceCategory != category) {
      _selectedServiceCategory = category;
      shouldNotify = true;
    }

    if (_servicesSearchQuery.isNotEmpty) {
      _servicesSearchQuery = '';
      shouldNotify = true;
    }

    if (shouldNotify) {
      notifyListeners();
    }
  }

  void openMessages() {
    if (_selectedTabIndex == 3) return;

    _selectedTabIndex = 3;
    notifyListeners();
  }
}
