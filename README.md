# DirectX 12 Practice – Chapter 13 ~

프로젝트 진행중...

---

## 📌 학습 범위

### ▢ Compute Shader
- Blur 적용. Blur Count 2, 4, 8
- Sobel Filter 적용

### ▢ Tessellation Stages
- 지형 LOD 표현 구현
- 거울 벽 요철 표현 추가

### ▢ Camera and Dynamic Indexing
- Camera 클래스를 추가하여 View / Projection 제어 분리
- 텍스처 디스크립터 테이블 기반 Dynamic Indexing 적용

### ▢ Instancing and Frustum Culling
- Hardware Instancing 적용
- Bounding Box 기반 Frustum Culling 적용
- 전체 Instance 수와 실제 렌더링 Instance 수 디버깅 UI 추가

### ▢ Picking
- 화면 좌표 기반 World Ray 생성
- Bounding Box 1차 필터링 후 Triangle 교차 테스트 수행
- Gizmo 축 선택 및 Drag Plane 기반 이동 처리 구현

### ▢ Character Animation
- .m3d 모델 로딩 구조 추가
- Bone Transform 보간 및 최종 Skinning Matrix 계산

---

## ✂️ 수정 사항

### ▢ PSOBuilder 생성
PSO 생성 책임을 분리하기 위해 `PSOBuilder`를 추가.
- 공통 PSO 설정 재사용
- RenderLayer별 PSO 생성 흐름 정리
- 렌더링 코드와 파이프라인 상태 생성 코드 분리

### ▢ DDSLoader 묶음 텍스처 로딩
텍스처 경로를 리스트로 입력받아 여러 텍스처를 한 번에 로딩하는 구조로 변경.
- 텍스처별 개별 Flush / GPU 동기화 감소
- 여러 DDS 텍스처를 묶어서 로딩
- 텍스처 로딩 코드 중복 감소
- SRV Descriptor Heap 구성 흐름 정리

측정 결과, 15개 텍스처 기준 로딩 시간이 약 **20ms → 16ms**로 감소.

### ▢ 셰이더 사전 컴파일
런타임 셰이더 컴파일 비용을 줄이기 위해 사전 컴파일 구조를 적용.

기존에는 실행 중 `.hlsl` 파일을 컴파일했기 때문에 초기화 시간이 크게 증가.
이를 `.cso` 파일을 미리 생성하는 방식으로 변경.
- `.hlsl` 파일을 사전에 `.cso` 파일로 컴파일
- `.vcxproj` 파일을 수정하여 셰이더 증분 빌드 구성
- 변경된 셰이더만 다시 컴파일되도록 설정
- 런타임 초기화 시에는 컴파일된 `.cso` 파일만 로드

측정 결과, 셰이더 로딩 및 준비 시간이 약 **280ms → 4ms**로 감소.

### ▢ Waves.h / Waves.cpp 폐기
- 기존 `Waves.h` / `Waves.cpp` 제거
- Compute Shader 기반 Waves 구조로 대체
- Wave Simulation과 렌더링 흐름 분리
- CPU에서 매 프레임 정점 데이터를 갱신하던 구조 제거

### ▢ RenderApp.cpp 파일 분리
`RenderApp.cpp`에 집중되어 있던 코드를 기능별 파일로 분리.
- `RenderApp_ImGui.cpp`
- `RenderApp_Input.cpp`
- `RenderApp_Geometry.cpp`
- `RenderApp_Pipeline.cpp`
- `RenderApp_Resources.cpp`

---

## 한계점

### ▢ Stencil 기반 거울 반사의 한계
Stencil 기반 직접 반사 렌더링은 메인 Depth Buffer를 공유하기 때문에,  
반사 대상에서 제외한 지형이나 오브젝트의 Depth 값이 여전히 반사 패스에 영향을 줄 수 있습니다.

이로 인해 반사상이 실제 장면의 깊이 정보에 의해 잘리거나 가려지는 문제가 발생합니다.

또한 반사 대상 오브젝트들을 하나의 Reflected PSO로 일괄 처리할 경우,  
서로 다른 렌더링 상태가 필요한 물체들의 특성이 제대로 반영되지 않습니다.

예를 들어 다음과 같은 오브젝트는 각각 다른 렌더링 상태나 셰이더 처리가 필요합니다.

- 물
- 알파 테스트 오브젝트
- 투명 오브젝트
- 특수 셰이더를 사용하는 오브젝트

따라서 현재 방식은 단순한 거울 반사 표현에는 사용할 수 있지만,  
완전한 반사 렌더링 구조로 보기에는 한계가 있습니다.

### ▢ Picking / Gizmo 개선 여지
현재 Picking은 CPU 측 Ray 교차 테스트를 기준으로 선택 대상을 계산합니다.
Skinned Mesh의 최종 Skinning 결과 기준 Picking, 다중 선택 편집, 회전 / 스케일 Gizmo는 별도 개선 대상으로 남아 있습니다.

---

## 📎 참고 자료

작성 예정
