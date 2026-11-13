import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';

enum Trade {
  tiling('تبليط', Icons.grid_view_rounded, AppColors.yellow),
  electric('كهرباء', Icons.electrical_services_rounded, AppColors.orange),
  plumbing('سباكة', Icons.plumbing_rounded, AppColors.lilac),
  carpentry('نجارة', Icons.carpenter_rounded, AppColors.light),
  painting('دهان', Icons.format_paint_rounded, AppColors.orange),
  ac('تكييف', Icons.ac_unit_rounded, AppColors.lilac);

  const Trade(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;
}

String priceRange(int from, int to) => 'من $from لـ $to دينار';

class Work {
  const Work(this.title, this.priceFrom, this.priceTo, this.seed, {this.image});

  final String title;
  final int priceFrom;
  final int priceTo;
  final int seed;

  /// Photo the technician picked. Null shows a drawn placeholder instead.
  final Uint8List? image;
}

class Review {
  const Review(this.author, this.rating, this.text, this.when);

  final String author;
  final int rating;
  final String text;
  final String when;
}

class Technician {
  const Technician({
    required this.id,
    required this.name,
    required this.trade,
    required this.city,
    required this.district,
    required this.distanceKm,
    required this.rating,
    required this.reviewsCount,
    required this.years,
    required this.bio,
    required this.works,
    required this.reviews,
    this.certLevel,
    this.certReviewed = false,
  });

  final int id;
  final String name;
  final Trade trade;
  final String city;
  final String district;
  final double distanceKm;
  final double rating;
  final int reviewsCount;
  final int years;
  final String bio;
  final List<Work> works;
  final List<Review> reviews;

  /// Practice-licence level: 2 limited-skill, 3 skilled, 4 craftsman.
  final int? certLevel;

  /// True once an admin has looked at the uploaded licence photo.
  final bool certReviewed;
}

class Post {
  const Post(this.tech, this.text, this.work, this.when);

  final Technician tech;
  final String text;
  final Work work;
  final String when;
}

enum RequestStatus {
  sent('بانتظار رد الفني'),
  quoted('وصلك سعر'),
  scheduled('تحدد الموعد'),
  done('خلص الشغل'),
  rated('تم التقييم');

  const RequestStatus(this.label);

  final String label;
}

class JobRequest {
  JobRequest({
    required this.tech,
    required this.title,
    required this.area,
    required this.when,
    this.details = '',
    this.status = RequestStatus.sent,
    this.quoteFrom,
    this.quoteTo,
    this.myRating,
  });

  final Technician tech;
  final String title;
  final String area;
  final String when;
  final String details;
  RequestStatus status;
  int? quoteFrom;
  int? quoteTo;
  int? myRating;
}

/// A customer's public post: "I need someone to fix this", with a photo.
///
/// Not an auction: technicians only say they are interested, with no price.
/// The customer picks one by profile and reviews, then gets a private quote.
class ProblemPost {
  ProblemPost({
    required this.title,
    required this.trade,
    required this.area,
    required this.when,
    this.details = '',
    this.image,
    this.mine = true,
    this.author = 'أنت',
    List<Technician>? interested,
  }) : interested = interested ?? [];

  final String title;
  final Trade trade;
  final String area;
  final String when;
  final String details;
  final Uint8List? image;

  /// True when the signed-in customer wrote this post.
  final bool mine;
  final String author;
  final List<Technician> interested;

  Technician? chosen;
  JobRequest? request;

  bool get open => chosen == null;
}
