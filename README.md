# DirectX 12 Practice – Chapter 10 ~ 13

이 프로젝트는 DirectX 12 학습 과정 중 Chapter 10 ~ 13 내용을 실습하며 정리한 저장소입니다.

본 저장소는 **참고·보존 목적**으로 유지되며, 이후 구조 개선 및 추가 개발은 별도 브랜치에서 진행합니다.

---

## 📌 학습 범위
### ▢ Blending
- Alpha Blending을 이용한 반투명 오브젝트 렌더링
- Alpha Test를 통한 텍스처 기반의 픽셀 제거
- Material의 Alpha 값과 Texture Sampling 결과를 이용한 렌더링 제어

### ▢ Stencil Buffer
- Stencil Buffer를 이용한 특정 영역 마스킹
- Stencil Ref / Stencil Test 흐름 학습
- 거울 영역에만 반사 오브젝트를 렌더링하는 구조 구현

### ▢ Geometry Shader
- Geometry Shader 기본 개념 학습
- Geometry Shader 기반 Billboard(Tree Sprite) 구현
- Point Primitive를 Quad로 확장
- 카메라 방향 기준 Billboard 정렬

### ▢ Compute Shader
- Compute Shader 기본 개념 학습
- GPU 기반 Waves Simulation 구현
- UAV를 이용한 Texture2D 갱신
- SRV를 통해 Vertex Shader에서 Displacement Map 사용
- Prev / Curr / Next Solution을 이용한 Ping-Pong 구조 구현

---

## ✂️ 수정 사항
### ▢ MSAA 구조 변경
DirectX 12에서는 **스왑체인 백버퍼에 직접 MSAA를 적용할 수 없음**.
따라서 다음과 같은 구조로 수정.
* 별도의 **MSAA Render Target (4x)** 생성
* Scene을 MSAA Render Target에 렌더링
* `ResolveSubresource`를 통해 BackBuffer(1x)로 복사
* 이후 UI(ImGui)는 BackBuffer에 직접 렌더링

#### 렌더링 흐름
```
Scene → MSAA Render Target → Resolve → BackBuffer → ImGui → Present
```

### ▢ ImGui UI 적용
렌더링 상태 확인과 디버깅을 위해 **ImGui 기반 UI**를 추가.
- 렌더링 옵션 확인
- 실행 중 상태 확인용 UI 구성
- Scene 렌더링 이후 BackBuffer에 UI를 직접 렌더링하도록 구성

---

## 📎 참고 자료
* DX12에서는 swapchain back buffer에 multisampling을 직접 적용할 수 없음  
  -> https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ne-dxgi-dxgi_swap_effect

* ImGUI 링크
  -> https://github.com/ocornut/imgui
