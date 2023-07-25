import 'package:drberry_app/color/color.dart';
import 'package:flutter/material.dart';

class ChangeNameDialog extends StatefulWidget {
  final String name;
  final String serverName;
  final void Function(String name) setServerName;

  const ChangeNameDialog({
    super.key,
    required this.name,
    required this.serverName,
    required this.setServerName,
  });

  @override
  State<ChangeNameDialog> createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends State<ChangeNameDialog> {
  final _controller = TextEditingController();

  String _name = "홍길동";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _name = widget.name;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 19, left: 16, right: 16, bottom: 20),
        height: deviceHeight * 0.4,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
          color: CustomColors.systemWhite,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 5,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(60, 60, 67, 0.3), borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "취소",
                        style: TextStyle(
                          color: Color.fromARGB(0, 0, 0, 0),
                          fontFamily: "Pretendard",
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        "이름",
                        style: TextStyle(
                          color: CustomColors.secondaryBlack,
                          fontFamily: "Pretendard",
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Material(
                        color: CustomColors.systemWhite,
                        child: InkWell(
                            onTap: () {},
                            child: const Text(
                              "취소",
                              style: TextStyle(
                                color: CustomColors.blue,
                                fontFamily: "Pretendard",
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Center(
                    child: Container(
                  width: deviceWidth - 32,
                  margin: const EdgeInsets.only(top: 4),
                  child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        setState(() {
                          _name = value;
                        });
                      },
                      cursorColor: Colors.black,
                      cursorHeight: 17,
                      style: const TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xFFF2F2F7)),
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xFFF2F2F7)),
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xFFF2F2F7)),
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          hintText: _name,
                          filled: true,
                          fillColor: const Color(0xFFF2F2F7),
                          contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 22),
                          hintStyle: const TextStyle(
                              fontFamily: "Pretendard",
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: CustomColors.systemGrey2))),
                )),
              ],
            ),
            Material(
                color: CustomColors.lightGreen2,
                borderRadius: BorderRadius.circular(13),
                child: InkWell(
                  borderRadius: BorderRadius.circular(13),
                  onTap: () {
                    widget.setServerName(_name);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: deviceWidth - 32,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Center(
                      child: Text(
                        "저장",
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: "Pretendard",
                          fontWeight: FontWeight.w500,
                          color: CustomColors.systemWhite,
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
