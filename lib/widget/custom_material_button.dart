import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool condition;
  final IconData icon;
  final String name;

  const CustomMaterialButton(this.onTap, this.condition, this.icon, this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        onPressed: onTap,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: condition ? const Color(0xFF006aff) : Colors.grey,
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: condition ? const Color(0xFF006aff) : Colors.grey,
                    fontWeight: condition ? FontWeight.bold : null,
                  ),
                ),
              ],
            ),
            if (condition)
              Positioned(
                top: -11,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF006aff),
                  ),
                  width: 16,
                  height: 16,
                ),
              )
          ],
        ),
      ),
    );
  }
}