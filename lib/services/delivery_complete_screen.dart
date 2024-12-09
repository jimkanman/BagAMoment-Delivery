import 'package:flutter/material.dart';
import 'package:jimkanman_delivery/config/AppColors.dart';
import 'package:jimkanman_delivery/widgets/rectangle_elevated_button.dart';

class DeliveryCompleteScreen extends StatelessWidget {
  const DeliveryCompleteScreen({Key? key}) : super(key: key); // null safety 적용

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight, // 배경색 설정
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 체크 마크 이미지
            Image.asset(
              'assets/images/check-circle-broken.png', // 이미지 경로 수정 필요
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            // 완료 메시지
            const Text(
              '배송 완료!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // 추가 설명
            const Text(
              '성공적으로 배송을 완료했습니다.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
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
