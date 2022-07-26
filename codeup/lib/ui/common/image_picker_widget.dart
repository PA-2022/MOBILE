import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import 'package:codeup/services/auth_service.dart';
import 'package:codeup/ui/common/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

import '../../entities/user.dart';
import 'custom_dialog.dart';
import 'gallery_item.dart';

enum PhotoSource { FILE, NETWORK }

class ImagePickerWidget extends StatefulWidget {
  List<GalleryItem> galleryItems = [];
  List<File> photos = [];
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Color kErrorRed = Colors.redAccent;
  Color kDarkGray = Color(0xFFA3A3A3);
  Color kLightGray = Color(0xFFF1F0F5);

  bool imageChoosen = false;

  
  List<String> _photosUrls = [];
  List<PhotoSource> _photosSources = [];
  //List<GalleryItem> _galleryItems = [];

  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.photos.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddPhoto();
              }
              
              File image = widget.photos[index - 1];
              PhotoSource source = _photosSources[index - 1];
              return Stack(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 100,
                      width: 100,
                      color: kLightGray,
                      child: source == PhotoSource.FILE
                          ? Image.file(image)
                          : Image.network(_photosUrls[index - 1]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      /*   Container(
          margin: EdgeInsets.all(16),
          child: RaisedButton(
            child: Text('Save'),
            onPressed: () {},
          ),
        ) */
      ],
    );
  }

  _buildAddPhoto() {
    return FutureBuilder(
      future: AuthService().getUserById(AuthService.currentUser!.user.id),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        return InkWell(
          onTap: () => _onAddPhotoClicked(context),
          child: Container(
            margin: !imageChoosen ? EdgeInsets.only(left:115) :EdgeInsets.all(5) ,
            height: 100,
            width: 100,
            color: imageChoosen ? CustomColors.excellentGreen : kDarkGray,
            child: Center(
              child:imageChoosen ? Icon(
                 Icons.edit,
                color: kLightGray,
              ) : snapshot.data != null ? Image(image: NetworkImage(snapshot.data!.profilePictureUrl)) : Image(image: NetworkImage(dotenv.env["DEFAULT_PP"].toString())) ,
            ),
          ),
        );
      }
    );
  }

  _onAddPhotoClicked(context) async {
    Permission permission;

    permission = Permission.storage;

    PermissionStatus permissionStatus = await permission.status;

    if (permissionStatus == PermissionStatus.restricted) {
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.limited) {
      permissionStatus = await permission.request();

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.denied) {
      if (Platform.isIOS) {
        _showOpenAppSettingsDialog(context);
      } else {
        permissionStatus = await permission.request();
      }

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }
//Image.file(File(selectedImage!.path))
    if (permissionStatus == PermissionStatus.granted) {
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        imageChoosen = true;
        String fileExtension = path.extension(image.path);
        widget.galleryItems.add(
          GalleryItem(
              id: Uuid().v1(),
              resource: image.path,
              isSvg: fileExtension.toLowerCase() == ".svg",
              name: image.name),
        );

        setState(() {
          if (widget.photos.length == 1) {
            widget.photos[0] = (File(image.path));
            _photosSources[0] = (PhotoSource.FILE);
          } else {
            widget.photos.add(File(image.path));
            _photosSources.add(PhotoSource.FILE);
          }
        });
      }
    }
  }

  _showOpenAppSettingsDialog(context) {
    return CustomDialog.show(
        context,
        'Permission needed',
        'Photos permission is needed to select photos',
        'Open settings',
        openAppSettings,
        null,
        null);
  }
}
