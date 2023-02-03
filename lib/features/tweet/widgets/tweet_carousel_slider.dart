import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class TweetCarouselSlider extends StatefulWidget {
  const TweetCarouselSlider({
    super.key,
    required this.images,
  });

  final List<String> images;

  @override
  State<TweetCarouselSlider> createState() => _TweetCarouselSliderState();
}

class _TweetCarouselSliderState extends State<TweetCarouselSlider> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: widget.images.map((image) {
            return Container(
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(image),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            viewportFraction: 1,
            height: 200,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              current = index;
              setState(() {});
            },
          ),
        ),
        if (widget.images.length > 1)
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Container(
              margin: const EdgeInsetsDirectional.only(top: 20, end: 8),
              padding: const EdgeInsetsDirectional.all(8),
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.greyColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...widget.images.asMap().entries.map(
                    (e) {
                      return Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.whiteColor.withOpacity(e.key == current ? 1 : .5),
                        ),
                      );
                    },
                  ).toList(),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
