import 'package:flutter/material.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> occupations = [
      "Electrician",
      "Mechanic",
      "Makeup Artist",
      "Plumber",
      "Other",
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.cancel),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              // Static Write-Up Field
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(9.0)),
                child: TextField(
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Write A Post...',
                    border: const OutlineInputBorder(
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                  ),
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),

              // Notify Freelancer Option UI (static)
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 8.0, top: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Checkbox(value: false, onChanged: null),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notify a freelancer',
                          style: TextStyle(
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: const Text(
                            'This allows your post to directly notify a freelancer who you might need to come work for you.',
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Static Occupation Options
              Container(
                margin: const EdgeInsets.only(top: 30.0),
                child: Column(
                  children: [
                    const Text('Select an Occupation:'),
                    const SizedBox(height: 6.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: occupations.map((category) {
                        return ChoiceChip(
                          label: Text(category),
                          selected: false,
                          onSelected: null,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Camera Option
              InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.camera_alt_outlined, color: Colors.blue),
                      Text("Take a photo", style: TextStyle(fontSize: 16)),
                      Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 320,
                child: Divider(color: Colors.black38),
              ),

              // Gallery Option
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.image_outlined, color: Colors.blue),
                      Text("Choose from gallery", style: TextStyle(fontSize: 16)),
                      Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                ),
              ),

              // Post Button (static)
              Container(
                margin: const EdgeInsets.only(top: 36.0, bottom: 10.0),
                alignment: Alignment.bottomRight,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  child: const Text(
                    "POST",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
