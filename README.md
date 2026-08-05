# D12Engine

DirectX 12 기반의 실시간 3D 렌더러와 ImGui 에디터를 구현하는 개인 프로젝트입니다.

*Introduction to 3D Game Programming with DirectX 12*에서 학습한 렌더링 기법을 바탕으로, 단일 예제 애플리케이션 구조를 `Editor`, `Renderer`, `EngineCore` 계층으로 분리하고 재사용 가능한 렌더링 엔진 구조로 확장하고 있습니다.

```text
단일 RenderApp
        ↓
EditorApplication
├─ Editor
├─ EngineCore
└─ Renderer
```
---

```mermaid
 classDiagram
    class EditorApplication["EditorApplication<br/>전체 객체 소유 및 실행 흐름 조율"]

    class D3D12Context["D3D12Context<br/>Device, Command, SwapChain, Descriptor 관리"]

    class D3D12RenderTarget["D3D12RenderTarget<br/>Scene View용 Color/Depth Render Target 관리"]

    class SceneRenderer["SceneRenderer<br/>Scene 데이터와 카메라를 기반으로 3D 렌더링"]

    class ImGuiLayer["ImGuiLayer<br/>ImGui 생명주기와 Win32/DX12 백엔드 연결"]

    class EditorLayer["EditorLayer<br/>DockSpace와 에디터 패널 UI 구성"]

    class SceneViewPanel["SceneViewPanel<br/>Scene Texture 출력과 Hover/Focus 상태 관리"]

    class Scene["Scene<br/>렌더링할 월드 데이터 관리"]

    class InputSystem["InputSystem<br/>키보드와 마우스의 프레임 단위 상태 저장"]

    class EditorInputRouter["EditorInputRouter<br/>패널 상태에 따라 입력 대상 결정"]

    class IEditorInputHandler["IEditorInputHandler<br/>에디터 입력 처리기 공통 인터페이스"]

    class GlobalInputHandler["GlobalInputHandler<br/>애플리케이션 전역 단축키 처리"]

    class SceneViewInputHandler["SceneViewInputHandler<br/>Scene View 카메라와 씬 조작 입력 처리"]

    EditorApplication *-- D3D12Context
    EditorApplication *-- D3D12RenderTarget
    EditorApplication *-- SceneRenderer
    EditorApplication *-- ImGuiLayer
    EditorApplication *-- EditorLayer
    EditorApplication *-- Scene
    EditorApplication *-- InputSystem
    EditorApplication *-- EditorInputRouter
    EditorApplication *-- GlobalInputHandler
    EditorApplication *-- SceneViewInputHandler

    EditorLayer *-- SceneViewPanel

    EditorInputRouter --> InputSystem : 상태 조회
    EditorInputRouter --> IEditorInputHandler : 입력 전달

    GlobalInputHandler ..|> IEditorInputHandler
    SceneViewInputHandler ..|> IEditorInputHandler

    SceneViewInputHandler --> SceneRenderer : 카메라/렌더 설정 조작
    SceneViewInputHandler --> Scene : 씬 선택/조작

    SceneRenderer ..> Scene : 데이터 조회
    SceneRenderer ..> D3D12Context : GPU 명령 기록
    SceneRenderer ..> D3D12RenderTarget : Scene 출력

    ImGuiLayer ..> D3D12Context : Editor UI 렌더링
    SceneViewPanel --> D3D12RenderTarget : SRV 출력
```
---

## 주요 목표

- DirectX 12 렌더링 파이프라인의 직접 구현과 이해
- 렌더러, 에디터 계층의 책임 분리
- ImGui Docking 기반 Scene Editor 구현
- Descriptor, Frame Resource, GPU 동기화 구조 일반화
- 렌더링 기능별 성능 측정 및 시각적 비교
- 향후 외부 모델과 애니메이션을 불러올 수 있는 런타임 렌더러 구축

---

## 사용 라이브러리

- [Dear ImGui](https://github.com/ocornut/imgui)  
  Docking 기반 에디터 UI 구현

- [ufbx](https://github.com/ufbx/ufbx)  
  FBX 메시, 스켈레톤, 애니메이션, 머티리얼 및 텍스처 데이터 임포트

- [DirectXTex](https://github.com/microsoft/DirectXTex)  
  DDS, WIC 등의 텍스처 파일 로드와 이미지 데이터 처리를 위해 사용하며, 이를 기반으로 텍스처 리소스의 생성·조회·수명을 관리하는 `TextureManager`를 구현

- [DirectX-Headers](https://github.com/microsoft/DirectX-Headers)  
  DirectX 12 헤더와 `d3dx12.h` 헬퍼 사용

- [Protocol Buffers](https://github.com/protocolbuffers/protobuf)  
  씬 및 엔진 데이터 직렬화를 위한 데이터 스키마와 바이너리 포맷 구현

---

## 의존성 설치

이 프로젝트는 [vcpkg](https://github.com/microsoft/vcpkg)의 Manifest 모드를 사용하여 Protocol Buffers 등의 외부 라이브러리와 전이 종속성을 관리합니다.  
저장소의 `vcpkg.json`에 선언된 라이브러리는 첫 빌드 시 프로젝트의 `vcpkg_installed` 폴더에 자동으로 설치됩니다.

다른 컴퓨터에서 처음 빌드하는 경우, 명령 프롬프트에서 vcpkg를 설치하고 Visual Studio의 MSBuild와 연결합니다.

```bat
git clone https://github.com/microsoft/vcpkg.git C:\vcpkg
C:\vcpkg\bootstrap-vcpkg.bat
C:\vcpkg\vcpkg.exe integrate install
```

> `C:\vcpkg`가 아닌 다른 위치에 설치한 경우 이후 명령의 경로도 해당 위치에 맞게 변경해야 합니다.

설치 후 Visual Studio를 다시 실행하고 솔루션을 빌드합니다.
