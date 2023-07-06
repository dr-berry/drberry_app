import 'package:flutter/material.dart';

class WeekMonthWidget extends StatelessWidget {
  const WeekMonthWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 17),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "일",
            style: TextStyle(fontSize: 16, fontFamily: "Pretendard", fontWeight: FontWeight.w600),
          ),
          Text(
            "월",
            style: TextStyle(fontSize: 16, fontFamily: "Pretendard", fontWeight: FontWeight.w600),
          ),
          Text(
            "화",
            style: TextStyle(fontSize: 16, fontFamily: "Pretendard", fontWeight: FontWeight.w600),
          ),
          Text(
            "수",
            style: TextStyle(fontSize: 16, fontFamily: "Pretendard", fontWeight: FontWeight.w600),
          ),
          Text(
            "목",
            style: TextStyle(fontSize: 16, fontFamily: "Pretendard", fontWeight: FontWeight.w600),
          ),
          Text(
            "금",
            style: TextStyle(fontSize: 16, fontFamily: "Pretendard", fontWeight: FontWeight.w600),
          ),
          Text(
            "토",
            style: TextStyle(fontSize: 16, fontFamily: "Pretendard", fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
