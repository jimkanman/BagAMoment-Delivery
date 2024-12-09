import 'package:flutter/material.dart';
import 'package:jimkanman_delivery/config/AppColors.dart';
import 'package:jimkanman_delivery/widgets/rectangle_elevated_button.dart';

class DeliveryCompleteScreen extends StatelessWidget {
  const DeliveryCompleteScreen({Key? key}) : super(key: key); // null safety 적용

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 설정
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/red_x.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            // 완료 메시지
            const Text(
              '배송 취소',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // 추가 설명
            const Text(
              '배송을 취소하였습니다.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            // 확인 버튼
            RectangularElevatedButton(
              onPressed: (){},
              borderRadius: 4,
              backgroundColor: AppColors.primaryDark,
              child: const Text("홈 화면으로", style: TextStyle(color: AppColors.textLight),),
            )
          ],
        ),
      ),
    );
  }
}
