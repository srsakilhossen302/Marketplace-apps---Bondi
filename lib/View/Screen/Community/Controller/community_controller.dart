import 'package:get/get.dart';

class CommunityController extends GetxController {
  final featuredCommunities = [
    {
      'title': 'Elite Tech Leaders',
      'description': 'The primary hub for Silicon Valley veterans and emerging',
      'members': '12.4k',
      'tag': 'Admin Choice',
      'code': 'TECH-1240',
      'image':
          'https://images.unsplash.com/photo-1519389950473-47ba0277781c?q=80&w=500&auto=format&fit=crop',
    },
    {
      'title': 'Global UX Collective',
      'description': 'Curating and UX s...',
      'members': '8.2k',
      'tag': 'Trending Now',
      'code': 'UX-4520',
      'image':
          'https://images.unsplash.com/photo-1558655146-d09347e92766?q=80&w=500&auto=format&fit=crop',
    },
  ].obs;

  final myGroups = [
    {
      'title': 'Marketing Mavericks',
      'status': 'Active now',
      'image':
          'https://images.unsplash.com/photo-1460925895917-afdab827c52f?q=80&w=500&auto=format&fit=crop',
    },
    {
      'title': 'Data Scientists Hub',
      'status': '32 new posts',
      'image':
          'https://images.unsplash.com/photo-1551288049-bebda4e38f71?q=80&w=500&auto=format&fit=crop',
    },
  ].obs;

  final exploreCommunities = [
    {
      'title': 'Startup Founders',
      'code': 'STRT-4829',
      'members': '4.8k members',
      'image':
          'https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=500&auto=format&fit=crop',
    },
    {
      'title': 'Web3 Innovators',
      'code': 'WEB3-2100',
      'members': '2.1k members',
      'image':
          'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?q=80&w=500&auto=format&fit=crop',
    },
    {
      'title': 'SaaS Growth',
      'code': 'SAAS-7200',
      'members': '7.2k members',
      'image':
          'https://images.unsplash.com/photo-1431540015161-0bf868a2d407?q=80&w=500&auto=format&fit=crop',
    },
    {
      'title': 'B2B Sales Pros',
      'code': 'B2B-3300',
      'members': '3.3k members',
      'image':
          'https://images.unsplash.com/photo-1552664730-d307ca884978?q=80&w=500&auto=format&fit=crop',
    },
    {
      'title': 'Agile Mentors',
      'code': 'AGL-1500',
      'members': '1.5k members',
      'image':
          'https://images.unsplash.com/photo-1531403009284-440f080d1e12?q=80&w=500&auto=format&fit=crop',
    },
  ].obs;
}
