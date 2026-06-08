import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  final plans = [
    {
      'name': 'Free',
      'tag': 'Basic',
      'price': 'Free',
      'subtitle': 'For casual enthusiasts',
      'isCurrent': true,
      'features': [
        '5 free listings valid to use on the first 30 days after the profile is created',
        'Each listing is valid for 10 days',
      ],
    },
    {
      'name': 'Silver Plan',
      'tag': 'Popular',
      'price': '\$5',
      'priceSuffix': 'Per listing',
      'isCurrent': false,
      'features': [
        'Pay \$5 for each listing you post',
        'Each listing valid for 15 days',
        'Trade offers unlocked',
      ],
    },
    {
      'name': 'Gold Plan',
      'tag': 'Popular',
      'price': '\$25',
      'priceSuffix': 'Per package',
      'isCurrent': false,
      'features': [
        '10 listings to use within 60 days',
        'Each listing valid for 20 days',
        'Trade offers unlocked',
      ],
    },
    {
      'name': 'Diamond Plan',
      'tag': 'Popular',
      'price': '\$100',
      'priceSuffix': 'Per month',
      'isCurrent': false,
      'features': [
        'Unlimited listings for the month',
        'Listings valid for the whole subscription',
        'Trade offers unlocked',
        'Auto-renews unless you cancel 1 day before expiry',
      ],
    },
  ].obs;
}
