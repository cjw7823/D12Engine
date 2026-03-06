# DirectX 12 Practice – Chapter 7 ~ 9

이 프로젝트는 **DirectX 12 학습 과정 중 Chapter 7 ~ 9 내용을 실습하며 정리한 저장소**입니다.  
Frank Luna의 *Introduction to 3D Game Programming with DirectX 12* 교재 예제를 기반으로  
렌더링 흐름을 분석하고 일부 기능을 직접 수정하며 학습했습니다.

---

## 📌 학습 범위

### ▢ Geometry 및 Scene 구성
- 기본 Geometry 생성
- RenderItem 구조를 이용한 Scene 관리

### ▢ Frame Resource
- FrameResource 구조 이해
- CPU / GPU 동기화를 위한 다중 프레임 리소스 관리

### ▢ Texture 및 Material
- 텍스처 로딩
- Material 데이터 구조 구성

### ▢ Descriptor Heap / Root Signature
- Constant Buffer는 Root CBV로 바인딩
- Texture Resource는 SRV Descriptor Heap과 Descriptor Table로 관리

---

## ✂️ 수정 사항

### ▢ GameTimer 수정
기존 예제에서 사용하던 **QueryPerformanceCounter(QPC)** 기반 타이머를  
C++ 표준 라이브러리 기반 **`std::chrono` 타이머**로 교체했습니다.
- 플랫폼 의존성 감소
- 코드 단순화

### ▢ DirectX-Headers 수정
교재 예제는 구버전 Windows SDK 구조를 사용하므로
최신 DirectX-Headers 구조에 맞게 수정했습니다.
https://github.com/microsoft/DirectX-Headers

### ▢ DDS TextureLoader
교재 예제 파일로 존재하던 DDS TextureLoader 삭제.  
https://github.com/microsoft/DirectXTex 를 사용하여 새로 만들었습니다.
- 교재 예제코드의 의존성 감소
- MS사 공식 헬퍼 클래스만 사용

### ▢ 이동 로직 추가
테스트용 이동 로직을 추가했습니다.  
카메라 회전과 완전히 연동되지 않는 단순 구현입니다.
