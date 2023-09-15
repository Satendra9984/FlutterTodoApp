import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/pick_file.dart';

class GetProfileImageWidget extends StatefulWidget {
  final Function(Uint8List? image) callBack;
  final String? id;
  const GetProfileImageWidget({required this.callBack, this.id, Key? key})
      : super(key: key);

  @override
  State<GetProfileImageWidget> createState() => _GetProfileImageWidgetState();
}

class _GetProfileImageWidgetState extends State<GetProfileImageWidget> {
  Uint8List? _profilePicture;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _setProfilePicture() async {
    /// setting profile picture from local storage if present
    debugPrint("Calling get photo");
    if (widget.id != null && _profilePicture == null) {
      FirebaseStorage storage = FirebaseStorage.instance;

      final Reference ref = storage.ref().child("contactPicture/${widget.id}");
      debugPrint(ref.fullPath);
      final Uint8List? metadata = await ref.getData();

      // debugPrint("image : ${metadata == null}");
      _profilePicture = metadata;
    }
  }

  Future<void> _uploadProfilePicture() async {
    await PickFile.pickAndGetFileAsBytes(fileExtensions: ['jpg', 'jpeg', 'png'])
        .then(
      (platformFile) async {
        if (platformFile != null) {
          /// upload bytes in firebase
          if (platformFile.path != null) {
            File fileImage = File(platformFile.path!);
            Uint8List imageData = await fileImage.readAsBytes();
            setState(() {
              _profilePicture = imageData;
            });
            widget.callBack(_profilePicture);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _setProfilePicture(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Container(
              height: 150,
              width: 150,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                color: Color(0xFF00755E),
              ),
            );
          } else {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                ClipOval(
                  child: _profilePicture != null
                      ? Image.memory(
                          _profilePicture!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.person,
                          size: 150,
                          color: Colors.grey,
                        ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF00755E),
                    child: IconButton(
                      onPressed: () async {
                        /// upload profile photo
                        await _uploadProfilePicture().then((value) {});
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        });
  }
}
