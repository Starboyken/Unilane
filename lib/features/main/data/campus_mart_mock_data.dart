import 'package:flutter/material.dart';

import 'package:unitrade/features/main/models/campus_mart_models.dart';

const marketplaceCategories = <String>[
  'All',
  'Books',
  'Electronics',
  'Furniture',
  'Clothing',
];

const servicesCategories = <String>[
  'All',
  'Haircut',
  'Photography',
  'Tutoring',
  'Laundry',
];

const homeCategories = <CategoryItem>[
  CategoryItem(
    label: 'Books',
    icon: Icons.menu_book_outlined,
    backgroundColor: Color(0xFFE8F0FF),
    iconColor: Color(0xFF356AE6),
    targetTabIndex: 1,
    targetFilter: 'Books',
  ),
  CategoryItem(
    label: 'Lodges',
    icon: Icons.home_work_outlined,
    backgroundColor: Color(0xFFE9F8EC),
    iconColor: Color(0xFF4C9B58),
    targetTabIndex: 1,
  ),
  CategoryItem(
    label: 'Roommates',
    icon: Icons.people_outline_rounded,
    backgroundColor: Color(0xFFF0EAFF),
    iconColor: Color(0xFF7C3AED),
    targetTabIndex: 3,
  ),
  CategoryItem(
    label: 'Services',
    icon: Icons.content_cut_rounded,
    backgroundColor: Color(0xFFFFF3E1),
    iconColor: Color(0xFFD97706),
    targetTabIndex: 2,
  ),
  CategoryItem(
    label: 'Food',
    icon: Icons.fastfood_outlined,
    backgroundColor: Color(0xFFFFE9E9),
    iconColor: Color(0xFFDC2626),
    targetTabIndex: 2,
  ),
  CategoryItem(
    label: 'Electronics',
    icon: Icons.devices_other_outlined,
    backgroundColor: Color(0xFFEEF2FF),
    iconColor: Color(0xFF4F46E5),
    targetTabIndex: 1,
    targetFilter: 'Electronics',
  ),
];

const featuredListings = <ListingItem>[
  ListingItem(
    imageUrl:
        'https://images.unsplash.com/photo-1513258496099-48168024aec0?auto=format&fit=crop&w=900&q=80',
    title: '2 Bedroom Self-Contained',
    price: 'N350,000/year',
    location: 'Bariga',
    category: 'Lodges',
    description:
        'A student-friendly apartment with tiled floors, prepaid meter access, steady water supply, and enough space for two to three students who want a calmer off-campus stay.',
    sellerName: 'Mr. Balogun (Landlord)',
    sellerRole: 'Property owner',
    condition: 'Available now',
    postedTime: 'Posted today',
  ),
  ListingItem(
    imageUrl:
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=900&q=80',
    title: 'iPhone 12 Pro Max 256GB',
    price: 'N320,000',
    location: 'Sabo',
    category: 'Electronics',
    description:
        'Neatly used iPhone 12 Pro Max with strong battery health, clean screen, Face ID working, and charger included. Great option for students who need a reliable phone for school and business.',
    sellerName: 'Femi Alade',
    sellerRole: 'Final-year student',
    condition: 'Used - Excellent',
    postedTime: 'Posted 1 hour ago',
    badge: 'Urgent Sale',
  ),
];

const marketplaceListings = <ListingItem>[
  ListingItem(
    imageUrl:
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=900&q=80',
    title: 'Leather Backpack - Student Edition',
    price: 'N12,000',
    location: 'Yaba Campus',
    category: 'Books',
    description:
        'A durable backpack with a padded laptop sleeve, side bottle pockets, and extra room for notebooks and chargers. Clean interior and still in good shape for daily campus use.',
    sellerName: 'Ada Chukwu',
    sellerRole: '200-level student',
    condition: 'Used - Good',
    postedTime: 'Posted yesterday',
    badge: 'Good',
  ),
  ListingItem(
    imageUrl:
        'https://images.unsplash.com/photo-1521587760476-6c12a4b040da?auto=format&fit=crop&w=900&q=80',
    title: 'Used Textbooks Bundle (5 books)',
    price: 'N15,000',
    location: 'Akoka',
    category: 'Books',
    description:
        'A five-book bundle for general science and introductory engineering courses. The pages are complete, the notes inside are light, and the set is useful if you want to save on new textbooks.',
    sellerName: 'Sarah Johnson',
    sellerRole: 'Biochemistry student',
    condition: 'Used - Fair',
    postedTime: 'Posted 2 days ago',
    badge: 'Fair',
  ),
  ListingItem(
    imageUrl:
        'https://images.unsplash.com/photo-1546868871-7041f2a55e12?auto=format&fit=crop&w=900&q=80',
    title: 'Smart Watch Series 6',
    price: 'N28,000',
    location: 'Hostel C',
    category: 'Electronics',
    description:
        'Smart watch with fitness tracking, notifications, and a charger included. It holds charge well and pairs quickly with most recent Android and iPhone devices.',
    sellerName: 'Adewale Ogunleye',
    sellerRole: 'Campus reseller',
    condition: 'Used - Good',
    postedTime: 'Posted 3 hours ago',
  ),
  ListingItem(
    imageUrl:
        'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=900&q=80',
    title: 'Casual Hoodie - Medium',
    price: 'N9,500',
    location: 'Faculty Road',
    category: 'Clothing',
    description:
        'Soft unisex hoodie in medium size with a relaxed fit for classes and cool evenings. The stitching is clean, the fabric still feels thick, and it has only been worn a few times.',
    sellerName: 'Mide Fashion House',
    sellerRole: 'Student vendor',
    condition: 'New',
    postedTime: 'Posted 4 hours ago',
  ),
  ListingItem(
    imageUrl:
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80',
    title: 'Study Desk and Chair Set',
    price: 'N45,000',
    location: 'Akoka Hostel',
    category: 'Furniture',
    description:
        'A compact desk and chair set that fits well in most hostel rooms. The table top is wide enough for a laptop and reading lamp, and the chair remains sturdy for long study sessions.',
    sellerName: 'Kemi Adebayo',
    sellerRole: 'Hostel mover',
    condition: 'Used - Good',
    postedTime: 'Posted 5 days ago',
  ),
];

const recommendationItems = <RecommendationItem>[
  RecommendationItem(
    icon: Icons.home_work_outlined,
    title: 'Find a Student-Friendly Stay',
    subtitle: 'Verified lodge options closer to campus life',
    backgroundColor: Color(0xFFEAF7EB),
    iconColor: Color(0xFF4C9B58),
    targetTabIndex: 1,
  ),
  RecommendationItem(
    icon: Icons.people_outline_rounded,
    title: 'Need a Reliable Roommate?',
    subtitle: 'Chat with students and settle in faster',
    backgroundColor: Color(0xFFF2EAFE),
    iconColor: Color(0xFF7C3AED),
    targetTabIndex: 3,
  ),
];

const serviceItems = <ServiceItem>[
  ServiceItem(
    imageUrl:
        'https://images.unsplash.com/photo-1621605815971-fbc98d665033?auto=format&fit=crop&w=900&q=80',
    title: 'Professional Haircut & Styling',
    provider: 'Kola\'s Barbershop',
    price: 'N2,500',
    rating: '4.8 (156)',
    category: 'Haircut',
  ),
  ServiceItem(
    imageUrl:
        'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=900&q=80',
    title: 'Photography Services',
    provider: 'David Photos',
    price: 'N15,000',
    rating: '4.9 (89)',
    category: 'Photography',
  ),
  ServiceItem(
    imageUrl:
        'https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=900&q=80',
    title: 'Mathematics Tutoring',
    provider: 'Aisha Tutors',
    price: 'N5,000/session',
    rating: '4.7 (64)',
    category: 'Tutoring',
  ),
  ServiceItem(
    imageUrl:
        'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?auto=format&fit=crop&w=900&q=80',
    title: 'Express Laundry Pickup',
    provider: 'Sparkle Laundry',
    price: 'N3,500/bag',
    rating: '4.6 (42)',
    category: 'Laundry',
  ),
];

const conversations = <ConversationItem>[
  ConversationItem(
    initials: 'AO',
    name: 'Adewale Ogunleye',
    lastMessage: 'Is the laptop still available?',
    time: '2m ago',
    unreadCount: 2,
    messages: [
      ChatMessageItem(
        text: 'Hi, I saw your MacBook listing.',
        time: '9:02 AM',
        isMine: false,
      ),
      ChatMessageItem(
        text: 'Yes, it is still available.',
        time: '9:03 AM',
        isMine: true,
      ),
      ChatMessageItem(
        text: 'Is the laptop still available?',
        time: '9:05 AM',
        isMine: false,
      ),
    ],
  ),
  ConversationItem(
    initials: 'SJ',
    name: 'Sarah Johnson',
    lastMessage: 'Thanks for the quick response!',
    time: '1h ago',
    unreadCount: 0,
    messages: [
      ChatMessageItem(
        text: 'Can I pick up the textbooks this evening?',
        time: '7:10 AM',
        isMine: false,
      ),
      ChatMessageItem(
        text: 'Yes, that works for me.',
        time: '7:12 AM',
        isMine: true,
      ),
      ChatMessageItem(
        text: 'Thanks for the quick response!',
        time: '7:13 AM',
        isMine: false,
      ),
    ],
  ),
  ConversationItem(
    initials: 'MB',
    name: 'Mr. Balogun (Landlord)',
    lastMessage: 'You can come view the apartment tomorrow',
    time: '3h ago',
    unreadCount: 1,
    messages: [
      ChatMessageItem(
        text: 'Good afternoon sir, is the apartment still open?',
        time: '6:30 AM',
        isMine: true,
      ),
      ChatMessageItem(
        text: 'Yes, it is available.',
        time: '6:34 AM',
        isMine: false,
      ),
      ChatMessageItem(
        text: 'You can come view the apartment tomorrow',
        time: '6:35 AM',
        isMine: false,
      ),
    ],
  ),
];

const notificationItems = <NotificationItem>[
  NotificationItem(
    icon: Icons.chat_bubble_outline_rounded,
    title: 'Adewale sent a message about your MacBook listing',
    time: '5 min ago',
    isUnread: true,
  ),
  NotificationItem(
    icon: Icons.favorite_border_rounded,
    title: 'Someone saved your listing on UniLane',
    time: '1 hour ago',
    isUnread: true,
  ),
  NotificationItem(
    icon: Icons.sell_outlined,
    title: 'Price drop alert: iPhone 12 Pro is now N280,000',
    time: '3 hours ago',
    isUnread: false,
  ),
  NotificationItem(
    icon: Icons.notifications_none_rounded,
    title: 'New book listing: Engineering Mathematics',
    time: 'Yesterday',
    isUnread: false,
  ),
];
