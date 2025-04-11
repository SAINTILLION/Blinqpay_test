import 'package:flutter/material.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
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
                  borderRadius: BorderRadius.circular(9.0),
                  border: Border.all(
                    color: Colors.blue, 
                    width: 1.0,           
                  ),
                ),
                    
                child: TextField(
                  maxLines: 8,
                  maxLength: 200,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Write A Post...',
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                  ),
                  style: const TextStyle(fontSize: 16.0),
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

              const SizedBox(
                width: 320,
                child: Divider(color: Colors.black38),
              ),

              //video upload option
              InkWell(
                onTap: () {
                  // TODO: Implement video picker and check if file size is <= 10MB
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.videocam_outlined, color: Colors.blue, size: 30,),
                      Text(
                        "Upload a video (Max 10MB)",
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                ),
              ),
              

              // Post Button (static)
              Align(
                child: InkWell(
                  onTap: () {
                    //declares what is needed
                  },
                  child: Container(
                    height: 40,
                    width: 80,
                    //padding: EdgeInsets.all(4),
                    margin: const EdgeInsets.only(top: 36.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: Center(
                      child: Text(
                        "POST",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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
