# DirectX 12 Practice – Chapter 10 ~

프로젝트 진행중...

---

## 📌 학습 범위

### ▢ Geometry 및 Scene 구성
- 기본 Geometry 생성
- RenderItem 구조를 이용한 Scene 관리

---

## ✂️ 수정 사항

### ▢ GameTimer 수정
기존 예제에서 사용하던 **QueryPerformanceCounter(QPC)** 기반 타이머를  
C++ 표준 라이브러리 기반 **`std::chrono` 타이머**로 교체했습니다.
- 플랫폼 의존성 감소
- 코드 단순화
