import 'package:get/get.dart';

class MessagesController extends GetxController {
  final recentChats = [
    {'name': 'Marcus', 'image': 'https://i.pravatar.cc/150?u=marcus', 'online': true},
    {'name': 'Elena', 'image': 'https://i.pravatar.cc/150?u=elena', 'online': true},
    {'name': 'Julian', 'image': 'https://i.pravatar.cc/150?u=julian', 'online': false},
    {'name': 'Sarah', 'image': 'https://i.pravatar.cc/150?u=sarah', 'online': true},
    {'name': 'Clara', 'image': 'https://i.pravatar.cc/150?u=clara', 'online': false},
  ].obs;

  final chatList = [
    {
      'title': 'Trade: Rolex Datejust vs iPhone 15 Pro',
      'lastMsg': 'Alex: "The condition is mint, I have all',
      'time': '12:45 PM',
      'status': 'TRADE PENDING',
      'images': ['https://images.unsplash.com/photo-1523170335258-f5ed11844a49?q=80&w=200', 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?q=80&w=200'],
      'isGroup': false,
    },
    {
      'title': 'Vintage Chronograph',
      'lastMsg': 'You: "Is the leather strap original to',
      'time': 'Yesterday',
      'status': 'Read',
      'image': 'https://i.pravatar.cc/150?u=vintage_seller',
      'itemImage': 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=200',
      'isGroup': false,
    },
    {
      'title': 'Sneakerheads LA 👟',
      'lastMsg': 'Jordan: "Just copped the new...',
      'time': '2:14 PM',
      'status': '8 online',
      'isGroup': true,
      'groupImage': 'https://images.unsplash.com/photo-1552346154-21d32810aba3?q=80&w=200',
    },
    {
      'title': 'David Chen',
      'lastMsg': 'Voice note 0:12',
      'time': '3:50 PM',
      'status': 'online',
      'image': 'https://i.pravatar.cc/150?u=david',
      'isGroup': false,
      'isVoiceNote': true,
    },
    {
      'title': 'Sofia Vergara',
      'lastMsg': 'Shared an image',
      'time': 'Wed',
      'status': 'online',
      'image': 'https://i.pravatar.cc/150?u=sofia',
      'isGroup': false,
      'isImage': true,
    },
  ].obs;

  final groupMessages = [
    {
      'sender': 'MarcusKicks',
      'text': 'Anyone got the new Travis Scott\'s in a size 10?',
      'isMe': false,
      'image': 'https://i.pravatar.cc/150?u=marcus',
    },
    {
      'isSystem': true,
      'text': 'Sarah Miller joined the group.',
    },
    {
      'sender': 'Me',
      'text': 'Just listed a pair of Bred 4s if anyone is interested! Check my profile.',
      'isMe': true,
    },
    {
      'isCard': true,
      'title': 'Jordan 4 Retro \'Bred\'',
      'price': '\$450',
      'image': 'https://images.unsplash.com/photo-1552346154-21d32810aba3?q=80&w=500',
      'details': 'Size 10.5 • Deadstock',
      'isMe': false, // Card seems to be from someone else in the image context
      'senderImage': 'https://i.pravatar.cc/150?u=jordan',
    },
    {
      'sender': 'Me',
      'text': 'I might be interested in those Bred 4s. Are you open to trades or just cash?',
      'isMe': true,
      'time': '10:42 AM',
    },
  ].obs;
}
