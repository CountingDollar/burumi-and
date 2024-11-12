import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../service/ApiService.dart';
import '../service/JWTapi.dart';

class ImageApi {
  final Dio _dio = ApiService().dio;
  final ImagePicker _picker = ImagePicker();

  // 최대 파일 크기 제한 (5MB)
  static const int maxFileSize = 5 * 1024 * 1024;

  // 이미지 선택 및 파일 반환
  Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);

      // 파일 크기 확인
      if (await imageFile.length() > maxFileSize) {
        throw Exception("파일 크기가 5MB를 초과했습니다.");
      }
      return imageFile;
    }
    return null;
  }

  // 통합된 이미지 업로드 메서드
  Future<String> uploadImage(File imageFile, {required String uploadType, int? chatId}) async {
    try {
      String fileName = imageFile.path.split('/').last;

      // 업로드 URL 설정
      String? uploadUrl;
      if (uploadType == 'chat' && chatId != null) {
        uploadUrl = "https://api.dev.burumi.kr/v1/chats/$chatId/images";
      } else if (uploadType == 'profile' || uploadType == 'bankbook') {
        final userId = await JwtApi().getUser1Id(); // user1Id를 비동기로 가져옴
        if (userId == null) throw Exception("user1Id를 가져오는 데 실패했습니다.");

        uploadUrl = uploadType == 'profile'
            ? "https://api.dev.burumi.kr/v1/users/$userId/profiles"
            : "https://api.dev.burumi.kr/v1/users/$userId/bankbooks";
      }

      if (uploadUrl == null) {
        throw Exception('Invalid upload type or missing parameters');
      }

      // FormData 생성
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      // 이미지 업로드 요청
      final response = await _dio.post(
        uploadUrl,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['result']['image_url'] ?? '이미지 업로드 성공';
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print("Image upload error: $e");
      throw Exception('Failed to upload image');
    }
  }
}
