///*******************************************************************************
///*Created By Aman Mishra
///******************************************************************************/

import 'package:datashare/utils/all_imports.dart';
import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final uploadDataController = Get.put(UploadDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("File upload and QR code"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: GetBuilder(
          init: uploadDataController,
          builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    uploadDataController.pickFile();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 50.0),
                    child: DottedBorder(
                        borderType: BorderType.RRect,
                        strokeWidth: 2,

                        ///On error I want to show red color
                        color: const Color(0xFFCED4DA),
                        radius: const Radius.circular(8),
                        dashPattern: const [8, 2],
                        child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              ///On hover I want to show light red color
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              children: [
                                DropzoneView(
                                  ///On drop a callback will run
                                  onDrop: (ev) async {
                                    debugPrint("file Name ${ev.name}");
                                    final bytes = await uploadDataController
                                        .controller1
                                        .getFileData(ev);
                                    debugPrint(bytes.sublist(0, 20).toString());
                                    uploadDataController.uploadImageOnWeb(
                                        bytes, ev.name);
                                  },

                                  ///On hover the box color will be change based on isHighlighted bool
                                  onHover: () => setState(() =>
                                      uploadDataController.isHighlighted =
                                          true),
                                  onLeave: () => setState(() =>
                                      uploadDataController.isHighlighted =
                                          false),
                                  onCreated: (ctrl) =>
                                      uploadDataController.controller1 = ctrl,
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.upload,
                                          color: Colors.black,
                                          size: 64.0,
                                        ),
                                        const SizedBox(height: 10),
                                        uploadDataController.progress != null
                                            ? LinearPercentIndicator(
                                                lineHeight: 20.0,
                                                percent: uploadDataController
                                                    .progress!,
                                                center: Text(
                                                  "${(uploadDataController.progress! * 100).toStringAsFixed(2)} %",
                                                  style: const TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black),
                                                ),
                                                progressColor:
                                                    Colors.green[400],
                                                backgroundColor:
                                                    Colors.grey[300],
                                                barRadius:
                                                    const Radius.circular(10),
                                              )
                                            : const SizedBox(),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 5.0),
                                          child: const Text(
                                            'Choose a file or drag it here.',
                                          ),
                                        ),
                                        Text(
                                          uploadDataController.progress != null
                                              ? 'Uploading....'
                                              : 'Maximum file size 60MB.',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ))),
                  ),
                ),
                uploadDataController.imageUrl.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(top: 20.0, left: 20.0),
                        child: QrImageView(
                          data: uploadDataController.imageUrl,
                          version: QrVersions.auto,
                          size: 200,
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 10.0),
                const SizedBox(
                  height: 20.0,
                ),
                uploadDataController.imageUrl.isNotEmpty
                    ? Center(
                        child: Text(
                        uploadDataController.imageUrl.toString(),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                        textAlign: TextAlign.center,
                      ))
                    : const SizedBox(),
                uploadDataController.imageUrl.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(
                                  text: uploadDataController.imageUrl));
                              // _launchURL(imageUrl);
                            },
                            child: const Text("Copy Url")),
                      )
                    : const SizedBox(),
              ],
            );
          },
        ),
      ),
    );
  }
}
