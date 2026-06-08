import 'package:get/get.dart';

class NotificationController extends GetxController {
  // Mock notification data can be added here
  final notifications = [
    {
      'type': 'new_item',
      'user': 'Alex',
      'action': 'posted a new item:',
      'item': 'Vintage Leather Jacket',
      'time': '2m ago',
      'user_image': 'https://randomuser.me/api/portraits/men/1.jpg',
      'item_image': 'https://images.unsplash.com/photo-1551028719-00167b16eac5?q=80&w=500&auto=format&fit=crop',
      'is_unread': true,
    },
    {
      'type': 'trade_accepted',
      'user': 'Sarah',
      'action': 'accepted your trade offer for the',
      'item': 'Rolex Submariner',
      'time': '1h ago',
      'user_image': 'https://randomuser.me/api/portraits/women/1.jpg',
      'status': 'Trade Finalized',
      'is_unread': true,
    },
    {
      'type': 'new_message',
      'user': 'Julian',
      'action': 'New message from',
      'message': '"Is the price negotiable?"',
      'time': '3h ago',
      'user_image': 'https://randomuser.me/api/portraits/men/2.jpg',
      'is_unread': false,
    },
    {
      'type': 'liked',
      'action': 'Your listing \'Air Jordan 1 Retro\' was liked by 5 people',
      'time': '5h ago',
      'icon': 'heart',
      'likers': [
        'https://randomuser.me/api/portraits/men/3.jpg',
        'https://randomuser.me/api/portraits/women/2.jpg',
        'https://randomuser.me/api/portraits/men/4.jpg',
      ],
      'extra_likers': 2,
      'is_unread': false,
    },
    {
      'type': 'group_invite',
      'user': 'Mike',
      'action': 'invited you to the',
      'group': '\'Sneakerheads LA\' group',
      'time': 'Yesterday',
      'user_image': 'https://randomuser.me/api/portraits/men/5.jpg',
      'is_unread': false,
    },
  ].obs;
}
