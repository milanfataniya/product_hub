import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool? centerTitle;
  final bool? automaticallyImplyLeading;
  final Widget? leading;

  const CustomAppbar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle,
    this.automaticallyImplyLeading,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: preferredSize.height, // 🔥 use preferred size
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFD0F7F4),
            Color(0xFFB8ECE7),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            leading ??
                (automaticallyImplyLeading == true
                    ? IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new),
                )
                    : const SizedBox()),

            Expanded(
              child: Text(
                title,
                textAlign: centerTitle == true
                    ? TextAlign.center
                    : TextAlign.start,
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF134E4A),
                  letterSpacing: 0.5,
                ),
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions ?? [],
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 REQUIRED
  @override
  Size get preferredSize => const Size.fromHeight(100);
}