import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pfe_1/utils/constants/colors.dart';
import 'package:pfe_1/utils/helper/helper_function.dart';

class AppCircularImage extends StatelessWidget {
  const AppCircularImage({
    super.key,
    this.size = 56,
    this.overlayColor,
    this.backgroundColor,
    required this.image,
    this.fit = BoxFit.cover,
    this.isNetworkImage = false,
  });

  final double size; // Property: Diameter of the circular image container
  final BoxFit? fit; // Property: How the image should be inscribed into the space allocated for it
  final String image; // Property: Path of the image
  final bool isNetworkImage; // Property: Whether the image is loaded from network or asset
  final Color? overlayColor; // Property: Color to overlay on top of the image
  final Color? backgroundColor; // Property: Background color of the container

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: backgroundColor ?? (AppHelperFunctions.isDarkMode(context) ? AppColors.black : AppColors.white),
        child: isNetworkImage ?
        CachedNetworkImage(
          fit: fit,
          imageUrl: image,
          errorWidget: (context, url, downloadProgress) => const Icon(Icons.error),
          color: overlayColor,
        ) :
        Image(
          fit: fit,
          image: AssetImage(image),
          color: overlayColor,
        ),
      ),
    );
  }
}
