import 'package:equatable/equatable.dart';

class Deal extends Equatable {
  final int id;
  final String title;
  final String image;
  final double originalPrice;
  final double dealPrice;
  final int discountPercent;
  final int remainingHours;
  final int soldCount;

  const Deal({
    required this.id,
    required this.title,
    required this.image,
    required this.originalPrice,
    required this.dealPrice,
    required this.discountPercent,
    required this.remainingHours,
    required this.soldCount,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        image,
        originalPrice,
        dealPrice,
        discountPercent,
        remainingHours,
        soldCount
      ];
}

final List<Deal> sampleDeals = [
  Deal(
      id: 1,
      title: 'Velvet Lounge Chair',
      image: 'https://place-hold.it/400x300/coral/white?text=Flash+Deal',
      originalPrice: 799,
      dealPrice: 399,
      discountPercent: 50,
      remainingHours: 4,
      soldCount: 23),
  Deal(
      id: 2,
      title: 'Marble Coffee Table',
      image: 'https://place-hold.it/400x300/slate/white?text=Flash+Deal',
      originalPrice: 649,
      dealPrice: 449,
      discountPercent: 31,
      remainingHours: 8,
      soldCount: 17),
  Deal(
      id: 3,
      title: 'Scandi Floor Lamp',
      image: 'https://place-hold.it/400x300/gold/black?text=Flash+Deal',
      originalPrice: 199,
      dealPrice: 89,
      discountPercent: 55,
      remainingHours: 2,
      soldCount: 45),
];
