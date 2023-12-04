import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Section Name
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[500]),
              ),

              //Edit Button
              IconButton(
                onPressed: onPressed, 
                icon: const Icon(
                  Icons.settings, 
                  color: Colors.grey,
                  ),
              ),
            ],
          ),

          // text
          Text(text),
        ],
      )
    );
  }
}

class ViewTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  
  const ViewTextBox({
    Key? key,
    required this.text,
    required this.sectionName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.only(left: 15, bottom: 15),
        margin: const EdgeInsets.only(left: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Name
            Text(
              sectionName,
              style: TextStyle(color: Colors.grey[500]),
            ),
            const SizedBox(height: 2), // Add space between section name and divider
            // Divider
            Divider(color: Colors.grey[500], thickness: 1),
            const SizedBox(height: 8), // Add space between divider and text
            // Text
            Text(
              text,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
