import 'package:flutter/material.dart';

class ClothingTileData {
  const ClothingTileData({required this.emoji, required this.color});

  final String emoji;
  final Color color;
}

class ClothingTile extends StatelessWidget {
  const ClothingTile({super.key, required this.data});

  final ClothingTileData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(data.emoji, style: const TextStyle(fontSize: 36)),
      ),
    );
  }
}
