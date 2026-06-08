import 'package:get/get.dart';

class FriendsController extends GetxController {
  final friends = [
    {
      'name': 'Sarah Chen',
      'mutual': '12 mutual friends',
      'image': 'https://randomuser.me/api/portraits/women/1.jpg',
    },
    {
      'name': 'Marcus Miller',
      'mutual': '42 mutual friends',
      'image': 'https://randomuser.me/api/portraits/men/2.jpg',
    },
    {
      'name': 'Elena Rodriguez',
      'mutual': '8 mutual friends',
      'image': 'https://randomuser.me/api/portraits/women/3.jpg',
    },
    {
      'name': 'David Kim',
      'mutual': '15 mutual friends',
      'image': 'https://randomuser.me/api/portraits/men/4.jpg',
    },
  ].obs;

  final following = [
    {
      'name': 'Julian Casablancas',
      'mutual': '20 mutual friends',
      'image': 'https://randomuser.me/api/portraits/men/10.jpg',
    },
    {
      'name': 'Mia Wallace',
      'mutual': '5 mutual friends',
      'image': 'https://randomuser.me/api/portraits/women/10.jpg',
    },
  ].obs;

  final requests = [
    {
      'name': 'Elena Hayes',
      'mutual': '4 mutual friends',
      'image': 'https://randomuser.me/api/portraits/women/11.jpg',
    },
    {
      'name': 'David Brooks',
      'mutual': '12 mutual friends',
      'image': 'https://randomuser.me/api/portraits/men/11.jpg',
    },
  ].obs;

  final suggested = [
    {
      'name': 'Sophia Loren',
      'mutual': '10 mutual friends',
      'image': 'https://randomuser.me/api/portraits/women/12.jpg',
    },
    {
      'name': 'Robert De Niro',
      'mutual': '18 mutual friends',
      'image': 'https://randomuser.me/api/portraits/men/12.jpg',
    },
  ].obs;

  final recommended = [
    {
      'name': 'Jordan Wells',
      'mutual': 'Mutual: 5',
      'image': 'https://randomuser.me/api/portraits/men/5.jpg',
    },
    {
      'name': 'Amara Smith',
      'mutual': 'Mutual: 12',
      'image': 'https://randomuser.me/api/portraits/women/6.jpg',
    },
  ].obs;

  final selectedTab = 0.obs;
}
