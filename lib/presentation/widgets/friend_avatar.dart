import 'package:flutter/material.dart';

class FriendAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const FriendAvatar({
    Key? key,
    this.imageUrl,
    this.radius = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the border width and outer container size
    double borderWidth = 4.0;
    double totalRadius = radius + borderWidth;

    return Container(
      width: totalRadius * 2,
      height: totalRadius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0x99D8ECFF), // #D8ECFF99
          width: borderWidth,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: imageUrl != null ? AssetImage(imageUrl!) : null,
        child: imageUrl == null
            ? Icon(Icons.person, size: radius, color: Colors.grey)
            : null,
      ),
    );
  }
}
