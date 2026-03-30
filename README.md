# DirectX 12 Practice – Chapter 10 ~

프로젝트 진행중...

---

## 📌 학습 범위
### ▢ Geometry Shader & Billboard
* Geometry Shader 기본 개념 학습
* Geometry Shader 기반 Billboard(Tree Sprite) 구현
* 카메라 방향 정렬

---

## ✂️ 수정 사항
### ▢ MSAA 구조 변경
DirectX 12에서는 **스왑체인 백버퍼에 직접 MSAA를 적용할 수 없음**.
따라서 다음과 같은 구조로 수정:
* 별도의 **MSAA Render Target (4x)** 생성
* Scene을 MSAA Render Target에 렌더링
* `ResolveSubresource`를 통해 BackBuffer(1x)로 복사
* 이후 UI(ImGui)는 BackBuffer에 직접 렌더링

#### 렌더링 흐름
```
Scene → MSAA Render Target → Resolve → BackBuffer → ImGui → Present
```

---

## 📎 참고 자료
* DX12에서는 swapchain back buffer에 multisampling을 직접 적용할 수 없음  
  → https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ne-dxgi-dxgi_swap_effect
