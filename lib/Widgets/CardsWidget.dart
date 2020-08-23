import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class Cards extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  const Cards({
    Key key,
    this.image,
    this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: CachedNetworkImage(
              height: 80,
              width: 60,
              fit: BoxFit.cover,
              imageUrl: image,
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Row(
              children: [
                Icon(
                  LineAwesomeIcons.tags,
                  size: 15,
                  color: Colors.grey[500],
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  subtitle.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Color(0xFF011589),
          ),
        ),
      ),
    );
  }
}
