// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sheet_controller.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({Key? key}) : super(key: key);

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  final TextEditingController _moveController = TextEditingController();
  bool isWhite = true;
  FocusNode myFocusNode = FocusNode();

  void _addMove() {
    final controller = isWhite
        ? Get.find<ScoreSheetController>(tag: 'white')
        : Get.find<ScoreSheetController>(tag: 'black');
    if (_moveController.text.isNotEmpty) {
      controller.updateScore(_moveController.text);
      _moveController.clear();
      setState(() {
        isWhite = !isWhite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => myFocusNode.unfocus(),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: const [
                ScoreController(
                  name: 'white',
                  backColor: Colors.white,
                  accColor: Colors.black,
                ),
                VerticalDivider(
                  color: Colors.grey,
                  width: 2,
                ),
                ScoreController(
                  name: 'black',
                  backColor: Colors.black,
                  accColor: Colors.white,
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isWhite ? Colors.white : Colors.black,
            ),
            child: Card(
              color: isWhite ? Colors.black : Colors.white,
              margin: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  restartButton(),
                  inputController(),
                  addButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container restartButton() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Ink(
        decoration: ShapeDecoration(
          shape: const CircleBorder(),
          color: isWhite ? Colors.white : Colors.black,
        ),
        child: IconButton(
          icon: Icon(
            Icons.refresh,
            color: isWhite ? Colors.black : Colors.white,
          ),
          onPressed: () {
            Get.find<ScoreSheetController>(tag: 'white').refreshList();
            Get.find<ScoreSheetController>(tag: 'black').refreshList();
            isWhite = true;
          },
        ),
      ),
    );
  }

  Expanded inputController() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.left,
          controller: _moveController,
          style: TextStyle(
            color: isWhite ? Colors.black : Colors.white,
          ),
          decoration: InputDecoration(
            hintText: isWhite ? 'White move' : 'Black move',
            hintStyle: TextStyle(
                color: isWhite
                    ? Colors.grey
                    : const Color.fromARGB(255, 97, 97, 97)),
            filled: true,
            fillColor: isWhite ? Colors.white : Colors.black,
            focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                borderSide: BorderSide(
                  width: 1,
                  color: isWhite ? Colors.white : Colors.black,
                )),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          onSubmitted: (value) {
            _addMove();
            myFocusNode.requestFocus();
          },
          focusNode: myFocusNode,
        ),
      ),
    );
  }

  Container addButton() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Ink(
        decoration: ShapeDecoration(
          shape: const CircleBorder(),
          color: isWhite ? Colors.white : Colors.black,
        ),
        child: IconButton(
          icon: Icon(
            Icons.add,
            color: isWhite ? Colors.black : Colors.white,
          ),
          onPressed: () => _addMove(),
        ),
      ),
    );
  }
}

class ScoreController extends StatelessWidget {
  const ScoreController({
    super.key,
    required this.name,
    required this.backColor,
    required this.accColor,
  });

  final String name;
  final Color backColor;
  final Color accColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetX<ScoreSheetController>(
        tag: name,
        init: ScoreSheetController(name.toUpperCase()),
        builder: (controller) {
          return Column(
            children: [
              columnHeader(controller),
              Divider(
                color: accColor,
                height: 1,
                thickness: 2.5,
              ),
              listViewColumn(controller),
            ],
          );
        },
      ),
    );
  }

  Container columnHeader(ScoreSheetController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: backColor),
      width: double.infinity,
      child: Center(
        child: Container(
          padding: const EdgeInsetsDirectional.only(top: 2.0, bottom: 2.0),
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                  color: accColor,
                  width: 2.5,
                ),
                bottom: BorderSide(
                  color: accColor,
                  width: 2.5,
                )),
          ),
          child: Text(
            controller.category.value,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 20.0,
              color: accColor,
              shadows: const [
                Shadow(
                  blurRadius: 8.0,
                  color: Color.fromARGB(255, 128, 128, 128),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded listViewColumn(ScoreSheetController controller) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: backColor),
        child: Obx(
          () => ListView.separated(
            itemCount: controller.moves.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1.5,
              color: accColor,
              height: 1,
              indent: 10,
              endIndent: 10,
            ),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.zero,
                height: 50,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.zero,
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            text: '# ',
                            style: TextStyle(
                              color: accColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                text: '${index + 1}',
                                style: TextStyle(
                                  color: accColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              )
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            controller.moves[index].position,
                            style: TextStyle(
                              color: accColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
