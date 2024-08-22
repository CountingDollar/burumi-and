import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:flutter_google_maps_webservices/geocoding.dart";
import 'package:geolocator/geolocator.dart';

import '../providers/Styles.dart';

class CustomGoogleMap extends StatefulWidget {
  final String address;

  CustomGoogleMap({required this.address});

  @override
  State<CustomGoogleMap> createState() => CustomGoogleMapState();
}

class CustomGoogleMapState extends State<CustomGoogleMap> {

  final TextEditingController _detailedAddressController =
  TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _addressController = TextEditingController();
  double _currentZoom = 14.0;
  LatLng? _currentPosition;
  CameraPosition? _lastCameraPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: buttonBackgroundColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _getCurrentLocation(); // 맵 생성 시 현재 위치 설정
              },
              initialCameraPosition: _initialPosition,
              markers: _markers,
              onTap: (LatLng position) {
                _updateCameraPosition(position);
                _onMarkerTapped(position);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _addressController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: '선택한 위치의 주소가 여기에 표시됩니다',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // 상세 주소 저장 후 원하는 동작 수행
                    String fullAddress = '${_addressController.text}';
                    String detailAddress = '${_detailedAddressController.text}';
                    Navigator.pop(context, {
                      'fullAddress': fullAddress,
                      'detailAddress': detailAddress
                    }); // 주소와 상세 주소를 반환하며 화면을 닫음
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(300, 45), // 최소 너비와 높이 설정
                      backgroundColor: buttonBackgroundColor),
                  child: Text('이 위치로 주소 설정',style:TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(34.9663, 127.0065),
    zoom: 14.0,
  );

  Set<Marker> _markers = {};
  // final _geocoding = GoogleMapsGeocoding(
  //     apiKey:dotenv.env['GOOGLE_MAPS_API_KEY']);

  late GoogleMapsGeocoding _geocoding;
  @override
  void initState() {
    super.initState();
    _initializeGeocoding();
    _addressController.text = widget.address; // 전달된 address 값을 TextField에 설정
  }

  void _initializeGeocoding() {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey != null) {
      _geocoding = GoogleMapsGeocoding(apiKey: apiKey);
      // API 초기화 성공 후 추가 작업
    } else {
      // 환경 변수가 없을 때의 처리
      print('API Key is not set');
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스 활성화 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 활성화되지 않은 경우 오류 메시지 표시
      _showErrorDialog('위치 서비스가 비활성화되었습니다. 위치 서비스를 활성화해주세요.');
      return;
    }

    // 위치 권한 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 위치 권한이 거부된 경우 오류 메시지 표시
        _showErrorDialog('위치 권한이 거부되었습니다.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 위치 권한이 영구적으로 거부된 경우 오류 메시지 표시
      _showErrorDialog('위치 권한이 영구적으로 거부되었습니다. 앱 설정에서 위치 권한을 허용해주세요.');
      return;
    }

    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _updateCameraPosition(LatLng(position.latitude, position.longitude));
    _onMarkerTapped(LatLng(position.latitude, position.longitude));
  }

  Future<void> _updateCameraPosition(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: position, zoom: _currentZoom), // 현재 줌 레벨 유지
    ));
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(title: '현재 위치'),
          onTap: () => _onMarkerTapped(position),
        ),
      );
    });
  }



  void _onMarkerTapped(LatLng position) async {
    final GoogleMapController controller = await _controller.future;

    // 현재 줌 레벨을 저장
    _currentZoom = (await controller.getZoomLevel());

    // 마커 업데이트 및 위치 저장
    setState(() {
      _currentPosition = position;
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId('tappedLocation'),
        position: position,
        draggable: true,
        onDragEnd: (newPosition) {
          _onMarkerDragged(newPosition); // 마커 드래그 후 위치 업데이트
        },
      ));
    });

    try {
      // 지오코딩 요청을 통해 한국어 주소를 가져옵니다.
      final response = await _geocoding.searchByLocation(
        Location(lat: position.latitude, lng: position.longitude),
        language: 'ko', // 언어 설정을 한국어로 지정
      );

      if (response.results.isNotEmpty) {
        final result = response.results.first;
        setState(() {
          _addressController.text = _getStreetAddress(result);
        });
      } else {
        _showErrorDialog('선택한 위치에 대한 주소를 찾을 수 없습니다.');
      }
    } catch (e) {
      _showErrorDialog('주소를 가져오는 중 오류 발생: $e');
    }

    // 현재 줌 레벨을 유지하면서 새 위치로 카메라 이동
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: position,
        zoom: _currentZoom,
      ),
    ));
  }

  void _onMarkerDragged(LatLng newPosition) async {
    final GoogleMapController controller = await _controller.future;

    // 현재 줌 레벨을 저장
    _currentZoom = (await controller.getZoomLevel());

    // 마커 업데이트 및 위치 저장
    setState(() {
      _currentPosition = newPosition;
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId('tappedLocation'),
        position: newPosition,
        draggable: true,
        onDragEnd: (newPosition) {
          _onMarkerDragged(newPosition); // 마커 드래그 후 위치 업데이트
        },
      ));
    });

    try {
      // 지오코딩 요청을 통해 한국어 주소를 가져옵니다.
      final response = await _geocoding.searchByLocation(
        Location(lat: newPosition.latitude, lng: newPosition.longitude),
        language: 'ko', // 언어 설정을 한국어로 지정
      );

      if (response.results.isNotEmpty) {
        final result = response.results.first;
        setState(() {
          _addressController.text = _getStreetAddress(result);
        });
      } else {
        _showErrorDialog('선택한 위치에 대한 주소를 찾을 수 없습니다.');
      }
    } catch (e) {
      _showErrorDialog('주소를 가져오는 중 오류 발생: $e');
    }

    // 현재 줌 레벨을 유지하면서 새 위치로 카메라 이동
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: newPosition,
        zoom: _currentZoom,
      ),
    ));
  }

  String _getStreetAddress(GeocodingResult result) {
    String streetAddress = '';

    for (var component in result.addressComponents) {
      if (component.types.contains('street_number') ||
          component.types.contains('route')) {
        streetAddress = component.longName;
        break;
      }
    }

    if (streetAddress.isEmpty) {
      streetAddress = result.formattedAddress ?? '주소를 찾을 수 없습니다.';
    }

    return streetAddress;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('오류'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

}
