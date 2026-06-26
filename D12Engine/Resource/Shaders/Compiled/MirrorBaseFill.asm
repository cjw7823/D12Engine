;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; SV_Position              0   xyzw        0      POS   float       
; POSITION                 0   xyz         1     NONE   float       
; NORMAL                   0   xyz         2     NONE   float       
; TEXCOORD                 0   xy          3     NONE   float       
;
;
; Output signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; SV_Target                0   xyzw        0   TARGET   float   xyzw
;
; shader debug name: 30a340cec4ff8e9a2469dc0f677b8272.pdb
; shader hash: 30a340cec4ff8e9a2469dc0f677b8272
;
; Pipeline Runtime Information: 
;
;PSVRuntimeInfo:
; Pixel Shader
; DepthOutput=0
; SampleFrequency=0
; MinimumExpectedWaveLaneCount: 0
; MaximumExpectedWaveLaneCount: 4294967295
; UsesViewID: false
; SigInputElements: 4
; SigOutputElements: 1
; SigPatchConstOrPrimElements: 0
; SigInputVectors: 4
; SigOutputVectors[0]: 1
; SigOutputVectors[1]: 0
; SigOutputVectors[2]: 0
; SigOutputVectors[3]: 0
; EntryFunctionName: PS_MirrorBaseFill
;
;
; Input signature:
;
; Name                 Index             InterpMode DynIdx
; -------------------- ----- ---------------------- ------
; SV_Position              0          noperspective       
; POSITION                 0                 linear       
; NORMAL                   0                 linear       
; TEXCOORD                 0                 linear       
;
; Output signature:
;
; Name                 Index             InterpMode DynIdx
; -------------------- ----- ---------------------- ------
; SV_Target                0                              
;
; Buffer Definitions:
;
; cbuffer cbMaterial
; {
;
;   struct hostlayout.cbMaterial
;   {
;
;       float4 gDiffuseAlbedo;                        ; Offset:    0
;       float3 gFresnelR0;                            ; Offset:   16
;       float gRoughness;                             ; Offset:   28
;       column_major float4x4 gMatTransform;          ; Offset:   32
;   
;   } cbMaterial;                                     ; Offset:    0 Size:    96
;
; }
;
;
; Resource Bindings:
;
; Name                                 Type  Format         Dim      ID      HLSL Bind  Count
; ------------------------------ ---------- ------- ----------- ------- -------------- ------
; cbMaterial                        cbuffer      NA          NA     CB0            cb1     1
;
;
; ViewId state:
;
; Number of inputs: 14, outputs: 4
; Outputs dependent on ViewId: {  }
; Inputs contributing to computation of Outputs:
;
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-f16:32-f32:32-f64:64-n8:16:32:64"
target triple = "dxil-ms-dx"

%dx.types.Handle = type { i8* }
%dx.types.CBufRet.f32 = type { float, float, float, float }
%hostlayout.cbMaterial = type { <4 x float>, <3 x float>, float, [4 x <4 x float>] }

@dx.nothing.a = internal constant [1 x i32] zeroinitializer

define void @PS_MirrorBaseFill() {
  %cbMaterial_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 0, i32 1, i1 false)  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 0), !dbg !154 ; line:165 col:12  ; CBufferLoadLegacy(handle,regIndex)
  %2 = extractvalue %dx.types.CBufRet.f32 %1, 0, !dbg !154 ; line:165 col:12
  %3 = extractvalue %dx.types.CBufRet.f32 %1, 1, !dbg !154 ; line:165 col:12
  %4 = extractvalue %dx.types.CBufRet.f32 %1, 2, !dbg !154 ; line:165 col:12
  %5 = extractvalue %dx.types.CBufRet.f32 %1, 3, !dbg !154 ; line:165 col:12
  %6 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !155 ; line:165 col:5
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %2), !dbg !155 ; line:165 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %3), !dbg !155 ; line:165 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %4), !dbg !155 ; line:165 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %5), !dbg !155 ; line:165 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  ret void, !dbg !155 ; line:165 col:5
}

; Function Attrs: nounwind
declare void @dx.op.storeOutput.f32(i32, i32, i32, i8, float) #0

; Function Attrs: nounwind readonly
declare %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32, %dx.types.Handle, i32) #1

; Function Attrs: nounwind readonly
declare %dx.types.Handle @dx.op.createHandle(i32, i8, i32, i32, i1) #1

attributes #0 = { nounwind }
attributes #1 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!118, !119}
!llvm.ident = !{!120}
!dx.source.contents = !{!121, !122}
!dx.source.defines = !{!2}
!dx.source.mainFileName = !{!123}
!dx.source.args = !{!124}
!dx.version = !{!125}
!dx.valver = !{!126}
!dx.shaderModel = !{!127}
!dx.resources = !{!128}
!dx.typeAnnotations = !{!131, !138}
!dx.viewIdState = !{!141}
!dx.entryPoints = !{!142}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, subprograms: !3, globals: !40)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CDefault.hlsl", directory: "")
!2 = !{}
!3 = !{!4}
!4 = !DISubprogram(name: "PS_MirrorBaseFill", scope: !1, file: !1, line: 163, type: !5, isLocal: false, isDefinition: true, scopeLine: 164, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @PS_MirrorBaseFill)
!5 = !DISubroutineType(types: !6)
!6 = !{!7, !19}
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4", file: !1, line: 34, baseType: !8)
!8 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 4>", file: !1, line: 34, size: 128, align: 32, elements: !9, templateParams: !15)
!9 = !{!10, !12, !13, !14}
!10 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !8, file: !1, line: 34, baseType: !11, size: 32, align: 32, flags: DIFlagPublic)
!11 = !DIBasicType(name: "float", size: 32, align: 32, encoding: DW_ATE_float)
!12 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !8, file: !1, line: 34, baseType: !11, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!13 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !8, file: !1, line: 34, baseType: !11, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!14 = !DIDerivedType(tag: DW_TAG_member, name: "w", scope: !8, file: !1, line: 34, baseType: !11, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!15 = !{!16, !17}
!16 = !DITemplateTypeParameter(name: "element", type: !11)
!17 = !DITemplateValueParameter(name: "element_count", type: !18, value: i32 4)
!18 = !DIBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!19 = !DICompositeType(tag: DW_TAG_structure_type, name: "VertexOut", file: !1, line: 79, size: 384, align: 32, elements: !20)
!20 = !{!21, !22, !31, !32}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "PosH", scope: !19, file: !1, line: 81, baseType: !7, size: 128, align: 32)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "PosW", scope: !19, file: !1, line: 82, baseType: !23, size: 96, align: 32, offset: 128)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "float3", file: !1, line: 35, baseType: !24)
!24 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 3>", file: !1, line: 35, size: 96, align: 32, elements: !25, templateParams: !29)
!25 = !{!26, !27, !28}
!26 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !24, file: !1, line: 35, baseType: !11, size: 32, align: 32, flags: DIFlagPublic)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !24, file: !1, line: 35, baseType: !11, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !24, file: !1, line: 35, baseType: !11, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!29 = !{!16, !30}
!30 = !DITemplateValueParameter(name: "element_count", type: !18, value: i32 3)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "NormalW", scope: !19, file: !1, line: 83, baseType: !23, size: 96, align: 32, offset: 224)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !19, file: !1, line: 84, baseType: !33, size: 64, align: 32, offset: 320)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "float2", file: !1, line: 27, baseType: !34)
!34 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 2>", file: !1, line: 27, size: 64, align: 32, elements: !35, templateParams: !38)
!35 = !{!36, !37}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !34, file: !1, line: 27, baseType: !11, size: 32, align: 32, flags: DIFlagPublic)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !34, file: !1, line: 27, baseType: !11, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!38 = !{!16, !39}
!39 = !DITemplateValueParameter(name: "element_count", type: !18, value: i32 2)
!40 = !{!41, !65, !66, !68, !70, !71, !73, !75, !76, !77, !78, !79, !80, !81, !82, !83, !84, !85, !86, !87, !88, !89, !90, !91, !92, !106, !107, !108, !109, !110, !114, !115, !116}
!41 = !DIGlobalVariable(name: "gWorld", linkageName: "\01?gWorld@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 25, type: !42, isLocal: false, isDefinition: true)
!42 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !43)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4x4", file: !1, line: 25, baseType: !44)
!44 = !DICompositeType(tag: DW_TAG_class_type, name: "matrix<float, 4, 4>", file: !1, line: 25, size: 512, align: 32, elements: !45, templateParams: !62)
!45 = !{!46, !47, !48, !49, !50, !51, !52, !53, !54, !55, !56, !57, !58, !59, !60, !61}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "_11", scope: !44, file: !1, line: 25, baseType: !11, size: 32, align: 32, flags: DIFlagPublic)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "_12", scope: !44, file: !1, line: 25, baseType: !11, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "_13", scope: !44, file: !1, line: 25, baseType: !11, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "_14", scope: !44, file: !1, line: 25, baseType: !11, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "_21", scope: !44, file: !1, line: 25, baseType: !11, size: 32, align: 32, offset: 128, flags: DIFlagPublic)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "_22", scope: !44, file: !1, line: 25, baseType: !11, size: 32, align: 32, offset: 160, flags: DIFlagPublic)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "_23", scope: !44, file: !1, line: 25, baseType: !11, size: 32, align: 32, offset: 192, flags: DIFlagPublic)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "_24", scope: !44, file: !1, line: 25, baseType: !11, size: 32, align: 32, offset: 224, flags: DIFlagPublic)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "_31", scope: !44, file: !1, line: 25, baseType: !11, size: 32, align: 32, offset: 256, flags: DIFlagPublic)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "_32", scope: !44, file: !1, line: 25, baseType: !11, size: 32, align: 32, offset: 288, flags: DIFlagPublic)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "_33", scope: !44, file: !1, line: 25, baseType: !11, size: 32, align: 32, offset: 320, flags: DIFlagPublic)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "_34", scope: !44, file: !1, line: 25, baseType: !11, size: 32, align: 32, offset: 352, flags: DIFlagPublic)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "_41", scope: !44, file: !1, line: 25, baseType: !11, size: 32, align: 32, offset: 384, flags: DIFlagPublic)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "_42", scope: !44, file: !1, line: 25, baseType: !11, size: 32, align: 32, offset: 416, flags: DIFlagPublic)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "_43", scope: !44, file: !1, line: 25, baseType: !11, size: 32, align: 32, offset: 448, flags: DIFlagPublic)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "_44", scope: !44, file: !1, line: 25, baseType: !11, size: 32, align: 32, offset: 480, flags: DIFlagPublic)
!62 = !{!16, !63, !64}
!63 = !DITemplateValueParameter(name: "row_count", type: !18, value: i32 4)
!64 = !DITemplateValueParameter(name: "col_count", type: !18, value: i32 4)
!65 = !DIGlobalVariable(name: "gTexTransform", linkageName: "\01?gTexTransform@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 26, type: !42, isLocal: false, isDefinition: true)
!66 = !DIGlobalVariable(name: "gDisplacementMapTexelSize", linkageName: "\01?gDisplacementMapTexelSize@cbPerObject@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 27, type: !67, isLocal: false, isDefinition: true)
!67 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!68 = !DIGlobalVariable(name: "gGridSpatialStep", linkageName: "\01?gGridSpatialStep@cbPerObject@@3MB", scope: !0, file: !1, line: 28, type: !69, isLocal: false, isDefinition: true)
!69 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!70 = !DIGlobalVariable(name: "cbPerObjectPad1", linkageName: "\01?cbPerObjectPad1@cbPerObject@@3MB", scope: !0, file: !1, line: 29, type: !69, isLocal: false, isDefinition: true)
!71 = !DIGlobalVariable(name: "gDiffuseAlbedo", linkageName: "\01?gDiffuseAlbedo@cbMaterial@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 34, type: !72, isLocal: false, isDefinition: true)
!72 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !7)
!73 = !DIGlobalVariable(name: "gFresnelR0", linkageName: "\01?gFresnelR0@cbMaterial@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 35, type: !74, isLocal: false, isDefinition: true)
!74 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !23)
!75 = !DIGlobalVariable(name: "gRoughness", linkageName: "\01?gRoughness@cbMaterial@@3MB", scope: !0, file: !1, line: 36, type: !69, isLocal: false, isDefinition: true)
!76 = !DIGlobalVariable(name: "gMatTransform", linkageName: "\01?gMatTransform@cbMaterial@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 37, type: !42, isLocal: false, isDefinition: true)
!77 = !DIGlobalVariable(name: "gView", linkageName: "\01?gView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 42, type: !42, isLocal: false, isDefinition: true)
!78 = !DIGlobalVariable(name: "gInvView", linkageName: "\01?gInvView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 43, type: !42, isLocal: false, isDefinition: true)
!79 = !DIGlobalVariable(name: "gProj", linkageName: "\01?gProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 44, type: !42, isLocal: false, isDefinition: true)
!80 = !DIGlobalVariable(name: "gInvProj", linkageName: "\01?gInvProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 45, type: !42, isLocal: false, isDefinition: true)
!81 = !DIGlobalVariable(name: "gViewProj", linkageName: "\01?gViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 46, type: !42, isLocal: false, isDefinition: true)
!82 = !DIGlobalVariable(name: "gInvViewProj", linkageName: "\01?gInvViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 47, type: !42, isLocal: false, isDefinition: true)
!83 = !DIGlobalVariable(name: "gEyePosW", linkageName: "\01?gEyePosW@cbPass@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 48, type: !74, isLocal: false, isDefinition: true)
!84 = !DIGlobalVariable(name: "cbPerPassPad1", linkageName: "\01?cbPerPassPad1@cbPass@@3MB", scope: !0, file: !1, line: 49, type: !69, isLocal: false, isDefinition: true)
!85 = !DIGlobalVariable(name: "gRenderTargetSize", linkageName: "\01?gRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 50, type: !67, isLocal: false, isDefinition: true)
!86 = !DIGlobalVariable(name: "gInvRenderTargetSize", linkageName: "\01?gInvRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 51, type: !67, isLocal: false, isDefinition: true)
!87 = !DIGlobalVariable(name: "gNearZ", linkageName: "\01?gNearZ@cbPass@@3MB", scope: !0, file: !1, line: 52, type: !69, isLocal: false, isDefinition: true)
!88 = !DIGlobalVariable(name: "gFarZ", linkageName: "\01?gFarZ@cbPass@@3MB", scope: !0, file: !1, line: 53, type: !69, isLocal: false, isDefinition: true)
!89 = !DIGlobalVariable(name: "gTotalTime", linkageName: "\01?gTotalTime@cbPass@@3MB", scope: !0, file: !1, line: 54, type: !69, isLocal: false, isDefinition: true)
!90 = !DIGlobalVariable(name: "gDeltaTime", linkageName: "\01?gDeltaTime@cbPass@@3MB", scope: !0, file: !1, line: 55, type: !69, isLocal: false, isDefinition: true)
!91 = !DIGlobalVariable(name: "gAmbientLight", linkageName: "\01?gAmbientLight@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 56, type: !72, isLocal: false, isDefinition: true)
!92 = !DIGlobalVariable(name: "gLights", linkageName: "\01?gLights@cbPass@@3QBULight@@B", scope: !0, file: !1, line: 61, type: !93, isLocal: false, isDefinition: true)
!93 = !DICompositeType(tag: DW_TAG_array_type, baseType: !94, size: 6144, align: 32, elements: !104)
!94 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !95)
!95 = !DICompositeType(tag: DW_TAG_structure_type, name: "Light", file: !96, line: 3, size: 384, align: 32, elements: !97)
!96 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders/LightingUtil.hlsli", directory: "")
!97 = !{!98, !99, !100, !101, !102, !103}
!98 = !DIDerivedType(tag: DW_TAG_member, name: "Strength", scope: !95, file: !96, line: 5, baseType: !23, size: 96, align: 32)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffStart", scope: !95, file: !96, line: 6, baseType: !11, size: 32, align: 32, offset: 96)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "Direction", scope: !95, file: !96, line: 7, baseType: !23, size: 96, align: 32, offset: 128)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffEnd", scope: !95, file: !96, line: 8, baseType: !11, size: 32, align: 32, offset: 224)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "Position", scope: !95, file: !96, line: 9, baseType: !23, size: 96, align: 32, offset: 256)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "SpotPower", scope: !95, file: !96, line: 10, baseType: !11, size: 32, align: 32, offset: 352)
!104 = !{!105}
!105 = !DISubrange(count: 16)
!106 = !DIGlobalVariable(name: "gFogColor", linkageName: "\01?gFogColor@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 65, type: !72, isLocal: false, isDefinition: true)
!107 = !DIGlobalVariable(name: "gFogStart", linkageName: "\01?gFogStart@cbPass@@3MB", scope: !0, file: !1, line: 66, type: !69, isLocal: false, isDefinition: true)
!108 = !DIGlobalVariable(name: "gFogRange", linkageName: "\01?gFogRange@cbPass@@3MB", scope: !0, file: !1, line: 67, type: !69, isLocal: false, isDefinition: true)
!109 = !DIGlobalVariable(name: "cbPerObjectPad2", linkageName: "\01?cbPerObjectPad2@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 68, type: !67, isLocal: false, isDefinition: true)
!110 = !DIGlobalVariable(name: "gDiffuseMap", linkageName: "\01?gDiffuseMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 17, type: !111, isLocal: false, isDefinition: true)
!111 = !DICompositeType(tag: DW_TAG_class_type, name: "Texture2D<vector<float, 4> >", file: !1, line: 17, size: 160, align: 32, elements: !2, templateParams: !112)
!112 = !{!113}
!113 = !DITemplateTypeParameter(name: "element", type: !8)
!114 = !DIGlobalVariable(name: "gDiffuseMap2", linkageName: "\01?gDiffuseMap2@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 18, type: !111, isLocal: false, isDefinition: true)
!115 = !DIGlobalVariable(name: "gDisplacementMap", linkageName: "\01?gDisplacementMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 19, type: !111, isLocal: false, isDefinition: true)
!116 = !DIGlobalVariable(name: "gsamLinear", linkageName: "\01?gsamLinear@@3USamplerState@@A", scope: !0, file: !1, line: 21, type: !117, isLocal: false, isDefinition: true)
!117 = !DICompositeType(tag: DW_TAG_structure_type, name: "SamplerState", file: !1, line: 21, size: 32, align: 32, elements: !2)
!118 = !{i32 2, !"Dwarf Version", i32 4}
!119 = !{i32 2, !"Debug Info Version", i32 3}
!120 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!121 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CDefault.hlsl", !"#ifndef NUM_DIR_LIGHTS\0D\0A    #define NUM_DIR_LIGHTS 3\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_POINT_LIGHTS\0D\0A    #define NUM_POINT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_SPOT_LIGHTS\0D\0A    #define NUM_SPOT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A//#define CARTOON\0D\0A\0D\0A#include \22LightingUtil.hlsli\22\0D\0A\0D\0ATexture2D gDiffuseMap : register(t0);\0D\0ATexture2D gDiffuseMap2 : register(t1);\0D\0ATexture2D gDisplacementMap : register(t2);\0D\0A\0D\0ASamplerState gsamLinear : register(s0);\0D\0A\0D\0Acbuffer cbPerObject : register(b0)\0D\0A{\0D\0A    float4x4 gWorld; //16DWARD\0D\0A    float4x4 gTexTransform;\0D\0A    float2 gDisplacementMapTexelSize;\0D\0A    float gGridSpatialStep;\0D\0A    float cbPerObjectPad1;\0D\0A};\0D\0A\0D\0Acbuffer cbMaterial : register(b1)\0D\0A{\0D\0A    float4 gDiffuseAlbedo;\0D\0A    float3 gFresnelR0;\0D\0A    float gRoughness;\0D\0A    float4x4 gMatTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbPass : register(b2)\0D\0A{\0D\0A    float4x4 gView;\0D\0A    float4x4 gInvView;\0D\0A    float4x4 gProj;\0D\0A    float4x4 gInvProj;\0D\0A    float4x4 gViewProj;\0D\0A    float4x4 gInvViewProj;\0D\0A    float3 gEyePosW;\0D\0A    float cbPerPassPad1;\0D\0A    float2 gRenderTargetSize;\0D\0A    float2 gInvRenderTargetSize;\0D\0A    float gNearZ;\0D\0A    float gFarZ;\0D\0A    float gTotalTime;\0D\0A    float gDeltaTime;\0D\0A    float4 gAmbientLight;\0D\0A    \0D\0A    // \EC\9D\B8\EB\8D\B1\EC\8A\A4 [0, NUM_DIR_LIGHTS)\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B4\91\EC\9E\85\EB\8B\88\EB\8B\A4.\0D\0A\09// \EC\9D\B8\EB\8D\B1\EC\8A\A4[NUM_DIR_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHTS)\EB\8A\94 \EC\A0\90\EA\B4\91\EC\9B\90\EC\9E\85\EB\8B\88\EB\8B\A4.\0D\0A\09// \EC\9D\B8\EB\8D\B1\EC\8A\A4[NUM_DIR_LIGHTS + NUM_POINT_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHT + NUM_SPOT_LIGHTS)\EB\8A\94 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\B4\EB\A9\B0, \EA\B0\9D\EC\B2\B4\EB\8B\B9 \EC\B5\9C\EB\8C\80 MaxLights \EA\B0\9C\EC\88\98\EA\B9\8C\EC\A7\80 \EC\82\AC\EC\9A\A9\ED\95\A0 \EC\88\98 \EC\9E\88\EC\8A\B5\EB\8B\88\EB\8B\A4.\0D\0A    Light gLights[MaxLights];\0D\0A    \0D\0A    //\EC\95\B1\EC\9D\B4 \ED\94\84\EB\A0\88\EC\9E\84\EB\8B\B9 \ED\95\9C \EB\B2\88\EC\94\A9 \EC\95\88\EA\B0\9C \EB\A7\A4\EA\B0\9C\EB\B3\80\EC\88\98\EB\A5\BC \EB\B3\80\EA\B2\BD\ED\95\A0 \EC\88\98 \EC\9E\88\EB\8F\84\EB\A1\9D \ED\95\A9\EB\8B\88\EB\8B\A4.\0D\0A    //\ED\8A\B9\EC\A0\95 \EC\8B\9C\EA\B0\84\EB\8C\80\EC\97\90\EB\A7\8C \EC\95\88\EA\B0\9C\EB\A5\BC \EC\82\AC\EC\9A\A9\ED\95\A0 \EC\88\98 \EC\9E\88\EC\8A\B5\EB\8B\88\EB\8B\A4.\0D\0A    float4 gFogColor;\0D\0A    float gFogStart;\0D\0A    float gFogRange;\0D\0A    float2 cbPerObjectPad2;\0D\0A};\0D\0A\0D\0Astruct VertexIn\0D\0A{\0D\0A    float3 PosL : POSITION;\0D\0A    float3 NormalL : NORMAL;\0D\0A    float3 Tangent : TANGENT;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Astruct VertexOut\0D\0A{\0D\0A    float4 PosH : SV_Position;\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0AVertexOut VS(VertexIn vin)\0D\0A{\0D\0A    VertexOut vout = (VertexOut) 0.0f;\0D\0A    \0D\0A#ifdef DISPLACEMENT_MAP\0D\0A    //\EB\B3\80\ED\99\98\EB\90\98\EC\A7\80 \EC\95\8A\EC\9D\80 [0,1]^2 tex \EC\A2\8C\ED\91\9C\EB\A5\BC \EC\82\AC\EC\9A\A9\ED\95\98\EC\97\AC \EB\B3\80\EC\9C\84 \EB\A7\B5\EC\9D\84 \EC\83\98\ED\94\8C\EB\A7\81.\0D\0A    vin.PosL.y += gDisplacementMap.SampleLevel(gsamLinear, vin.TexC, 1.0f).r;\0D\0A\09\0D\0A\09//\EC\9C\A0\ED\95\9C\EC\B0\A8\EB\B6\84\EB\B2\95\EC\9D\84 \EC\9D\B4\EC\9A\A9\ED\95\98\EC\97\AC \EC\A0\95\EA\B7\9C\EB\B6\84\ED\8F\AC\EB\A5\BC \EC\B6\94\EC\A0\95.\0D\0A    float du = gDisplacementMapTexelSize.x;\0D\0A    float dv = gDisplacementMapTexelSize.y;\0D\0A    float l = gDisplacementMap.SampleLevel(gsamLinear, vin.TexC - float2(du, 0.0f), 0.0f).r;\0D\0A    float r = gDisplacementMap.SampleLevel(gsamLinear, vin.TexC + float2(du, 0.0f), 0.0f).r;\0D\0A    float t = gDisplacementMap.SampleLevel(gsamLinear, vin.TexC - float2(0.0f, dv), 0.0f).r;\0D\0A    float b = gDisplacementMap.SampleLevel(gsamLinear, vin.TexC + float2(0.0f, dv), 0.0f).r;\0D\0A    vin.NormalL = normalize(float3(-r + l, 2.0f * gGridSpatialStep, b - t));\0D\0A    \0D\0A#endif\0D\0A    \0D\0A    float4 posW = mul(float4(vin.PosL, 1.0f), gWorld);\0D\0A    vout.PosW = posW.xyz;\0D\0A    \0D\0A    // \EB\B9\84\EA\B7\A0\EC\9D\BC \EC\8A\A4\EC\BC\80\EC\9D\BC\EB\A7\81\EC\9D\84 \EA\B0\80\EC\A0\95. \EC\95\84\EB\8B\88\EB\9D\BC\EB\A9\B4 \EC\9B\94\EB\93\9C \ED\96\89\EB\A0\AC\EC\9D\98 \EC\97\AD\EC\A0\84\EC\B9\98 \ED\96\89\EB\A0\AC\EC\9D\84 \EC\82\AC\EC\9A\A9\ED\95\B4\EC\95\BC \ED\95\9C\EB\8B\A4.\0D\0A    vout.NormalW = mul(vin.NormalL, (float3x3) gWorld);\0D\0A    \0D\0A    // homogeneous clip \EA\B3\B5\EA\B0\84\EC\9C\BC\EB\A1\9C \EB\B3\80\ED\99\98.\0D\0A    vout.PosH = mul(posW, gViewProj);\0D\0A    \0D\0A    float4 texC = mul(float4(vin.TexC, 0.f, 1.f), gTexTransform);\0D\0A    vout.TexC = mul(texC, gMatTransform).xy;\0D\0A    \0D\0A    return vout;\0D\0A}\0D\0A \0D\0Afloat4 PS(VertexOut pin) : SV_Target\0D\0A{\0D\0A    float4 diffuseAlbedo = gDiffuseMap.Sample(gsamLinear, pin.TexC) * gDiffuseAlbedo;\0D\0A    \0D\0A#ifdef TEXTURE_BLEND\0D\0A    diffuseAlbedo *= (gDiffuseMap2.Sample(gsamLinear, pin.TexC) * gDiffuseAlbedo).r;\0D\0A#endif\0D\0A    \0D\0A#ifdef ALPHA_TEST\0D\0A\09//value < 0 \EC\9D\B4\EB\A9\B4 \ED\98\84\EC\9E\AC \ED\94\BD\EC\85\80\EC\9D\84 \EB\B2\84\EB\A6\AC\EA\B3\A0 \EB\8D\94 \EC\9D\B4\EC\83\81 \EB\A0\8C\EB\8D\94 \ED\83\80\EA\B9\83\EC\97\90 \EA\B8\B0\EB\A1\9D\ED\95\98\EC\A7\80 \EC\95\8A\EB\8A\94\EB\8B\A4.\0D\0A\09clip(diffuseAlbedo.a - 0.1f);\0D\0A#endif\0D\0A    \0D\0A    //\EB\B3\B4\EA\B0\84\EB\90\9C \EB\B2\95\EC\84\A0 \EB\B2\A1\ED\84\B0\EB\8A\94 \EA\B8\B8\EC\9D\B4\EA\B0\80 1\EC\9D\B4 \EC\95\84\EB\8B\90 \EC\88\98 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C.\0D\0A    pin.NormalW = normalize(pin.NormalW);\0D\0A\0D\0A    //\EA\B4\91\EC\9B\90\EC\97\90\EC\84\9C \EC\B9\B4\EB\A9\94\EB\9D\BC\EB\A1\9C \ED\96\A5\ED\95\98\EB\8A\94 \EB\B2\A1\ED\84\B0.\0D\0A    float3 toEyeW = gEyePosW - pin.PosW;\0D\0A    float distToEye = length(toEyeW);\0D\0A    toEyeW /= distToEye; //normalize\0D\0A    \0D\0A    float4 ambient = gAmbientLight * diffuseAlbedo;\0D\0A    const float shininess = 1.0f - gRoughness;\0D\0A    Material mat = { diffuseAlbedo, gFresnelR0, shininess };\0D\0A    float3 shadowFactor = 1.0f;\0D\0A    \0D\0A    float4 directLight = ComputeLighting(gLights, mat, pin.PosW,\0D\0A        pin.NormalW, toEyeW, shadowFactor);\0D\0A\0D\0A    float4 litColor = ambient + directLight;\0D\0A    \0D\0A#ifdef FOG\0D\0A    float fogAmount = saturate((distToEye - gFogStart) / gFogRange);\0D\0A    litColor = lerp(litColor, gFogColor, fogAmount);\0D\0A#endif\0D\0A\0D\0A    //\EC\9D\BC\EB\B0\98\EC\A0\81\EC\9C\BC\EB\A1\9C \EC\95\8C\ED\8C\8C \EA\B0\92\EC\9D\80 \EB\94\94\ED\93\A8\EC\A6\88 \EB\A8\B8\ED\8B\B0\EB\A6\AC\EC\96\BC\EC\9D\98 \EC\95\8C\ED\8C\8C \EA\B0\92\EC\9D\84 \EC\82\AC\EC\9A\A9\ED\95\9C\EB\8B\A4.\0D\0A    litColor.a = diffuseAlbedo.a;\0D\0A    \0D\0A    return litColor;\0D\0A}\0D\0A\0D\0Afloat4 PS_MirrorBaseFill(VertexOut pin) : SV_Target\0D\0A{\0D\0A    return gDiffuseAlbedo;\0D\0A}"}
!122 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CLightingUtil.hlsli", !"#define MaxLights 16\0D\0A\0D\0Astruct Light\0D\0A{\0D\0A    float3 Strength;\0D\0A    float FalloffStart;     //point, spot\0D\0A    float3 Direction;       //directional, spot\0D\0A    float FalloffEnd;       //point, spot\0D\0A    float3 Position;        //point\0D\0A    float SpotPower;        //spot\0D\0A};\0D\0A\0D\0Astruct Material\0D\0A{\0D\0A    float4 DiffuseAlbedo;\0D\0A    float3 FresnelR0;\0D\0A    float Shininess;\0D\0A};\0D\0A\0D\0A//\EC\B9\B4\ED\88\B0\ED\99\94\0D\0Afloat QuantizeKd(float kd)\0D\0A{\0D\0A    if (kd <= 0.0f)\0D\0A        return 0.2f;\0D\0A    else if (kd <= 0.3f)\0D\0A        return 0.4f;\0D\0A    else if (kd <= 0.6f)\0D\0A        return 0.6f;\0D\0A    else if (kd <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.0f;\0D\0A}\0D\0A\0D\0Afloat QuantizeKs(float ks)\0D\0A{\0D\0A    if (ks <= 0.1f)\0D\0A        return 0.0f;\0D\0A    else if (ks <= 0.3f)\0D\0A        return 0.2f;\0D\0A    else if (ks <= 0.5f)\0D\0A        return 0.4f;\0D\0A    else if (ks <= 0.7f)\0D\0A        return 0.6f;\0D\0A    else if (ks <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.f;\0D\0A}\0D\0A\0D\0Afloat CalcAttenuation(float d, float falloffStart, float falloffEnd)\0D\0A{\0D\0A    //\EC\84\A0\ED\98\95 \EA\B0\90\EC\87\A0\0D\0A    return saturate((falloffEnd - d) / (falloffEnd - falloffStart));\0D\0A}\0D\0A\0D\0A//Schlick\EC\9D\80 \ED\94\84\EB\A0\88\EB\84\AC \EB\B0\98\EC\82\AC\EC\9C\A8\EC\97\90 \EB\8C\80\ED\95\9C \EA\B7\BC\EC\82\AC\EC\B9\98(233\ED\8E\98\EC\9D\B4\EC\A7\80 \22\EC\8B\A4\EC\8B\9C\EA\B0\84 \EB\A0\8C\EB\8D\94\EB\A7\81 3\ED\8C\90\22 \EC\B0\B8\EC\A1\B0)\0D\0A//R0 = ((n-1)/(n+1))^2, \EC\97\AC\EA\B8\B0\EC\84\9C n\EC\9D\80 \EA\B5\B4\EC\A0\88\EB\A5\A0\0D\0Afloat3 SchlickFresnel(float3 R0, float3 normal, float3 lightVec)\0D\0A{\0D\0A    float cosIncidentAngle = saturate(dot(normal, lightVec));\0D\0A    float f0 = 1.0f - cosIncidentAngle;\0D\0A    float3 reflectPercent = R0 + (1.0f - R0) * pow(f0, 5.0f);\0D\0A    \0D\0A    return reflectPercent;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhong(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    \0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A    \0D\0A    float3 specAlbedo = fresnelFactor * roughnessFactor;\0D\0A\0D\0A    //Blinn-Phong \EB\AA\A8\EB\8D\B8\EC\97\90\EC\84\A0\EB\8A\94 speccAlbedo\EA\B0\80 1\EB\B3\B4\EB\8B\A4 \ED\81\B4 \EC\88\98 \EC\9E\88\EB\8B\A4.\0D\0A    //LDR\EB\A0\8C\EB\8D\94\EB\A7\81\EC\9D\84 \EC\88\98\ED\96\89\ED\95\98\EA\B3\A0 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C \EB\B2\94\EC\9C\84\EB\A5\BC \EC\95\BD\EA\B0\84 \EC\B6\95\EC\86\8C\ED\95\9C\EB\8B\A4.\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A    \0D\0A    return (mat.DiffuseAlbedo.rgb + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhongToon(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    // 1) kd\0D\0A    float kd = saturate(dot(lightVec, normal));\0D\0A    float kd_q = QuantizeKd(kd);\0D\0A\0D\0A    // 2) ks (Blinn-Phong)\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    float ndoth = saturate(dot(halfVec, normal));\0D\0A\0D\0A    float ks = pow(max(ndoth, 0), m); // \EC\8A\A4\ED\8E\99\ED\81\98\EB\9F\AC \EA\B0\95\EB\8F\84\EC\9D\98 \ED\95\B5\EC\8B\AC\0D\0A    float ks_q = QuantizeKs(ks); // \EC\9D\B4\EC\82\B0\ED\99\94\0D\0A\0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    // fresnel(\EC\83\89) + (\ED\95\84\EC\9A\94\ED\95\98\EB\A9\B4) \EC\A0\95\EA\B7\9C\ED\99\94 \EA\B3\84\EC\88\98\EB\8A\94 \EC\B7\A8\ED\96\A5\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A\0D\0A    // ks_q\EB\A5\BC spec\EC\97\90 \EB\B0\98\EC\98\81\0D\0A    float3 specAlbedo = roughnessFactor * fresnelFactor * ks_q;\0D\0A\0D\0A    // LDR clamp\EB\8A\94 \EC\9C\A0\EC\A7\80 \EA\B0\80\EB\8A\A5\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A\0D\0A    // diffuse\EB\8A\94 kd_q\EB\A5\BC \EB\B0\98\EC\98\81\0D\0A    float3 diffuse = mat.DiffuseAlbedo.rgb * kd_q;\0D\0A    \0D\0A    return (diffuse + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 ComputeDirectionalLight(Light L, Material mat, float3 normal, float3 toEye)\0D\0A{\0D\0A    //\EA\B4\91 \EB\B2\A1\ED\84\B0\EB\8A\94 \EB\B9\9B\EC\9D\B4 \EC\A7\84\ED\96\89\ED\95\9C\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B3\BC \EB\B0\98\EB\8C\80 \EB\B0\A9\ED\96\A5.\0D\0A    float3 lightVec = -L.Direction;\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat3 ComputePointLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A#endif\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat3 ComputeSpotLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A#endif\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    //\EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EA\B2\BD\EC\9A\B0, \EB\B9\9B\EC\9D\B4 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EC\A4\91\EC\8B\AC\EC\97\90\EC\84\9C \EB\A9\80\EC\96\B4\EC\A7\88\EC\88\98\EB\A1\9D \EB\B9\9B\EC\9D\B4 \EC\95\BD\ED\95\B4\EC\A7\84\EB\8B\A4.\0D\0A    float spotFactor = pow(max(dot(-lightVec, L.Direction), 0.0f), L.SpotPower);\0D\0A    lightStrength *= spotFactor;\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat4 ComputeLighting(Light gLights[MaxLights], Material mat, float3 pos, float3 normal, float3 toEye, float3 shadowFactor)\0D\0A{\0D\0A    float3 result = 0;\0D\0A    int i = 0;\0D\0A    \0D\0A#if (NUM_DIR_LIGHTS > 0)\0D\0A    for(i = 0; i < NUM_DIR_LIGHTS; ++i)\0D\0A    {\0D\0A        result += shadowFactor[i] * ComputeDirectionalLight(gLights[i], mat, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_POINT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS; i < NUM_DIR_LIGHTS+NUM_POINT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputePointLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_SPOT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS + NUM_POINT_LIGHTS; i < NUM_DIR_LIGHTS + NUM_POINT_LIGHTS + NUM_SPOT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputeSpotLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif \0D\0A    \0D\0A    return float4(result, 0.0f);\0D\0A}"}
!123 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CDefault.hlsl"}
!124 = !{!"-E", !"PS_MirrorBaseFill", !"-T", !"ps_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CCompiled\5CMirrorBaseFill.cso"}
!125 = !{i32 1, i32 0}
!126 = !{i32 1, i32 8}
!127 = !{!"ps", i32 6, i32 0}
!128 = !{null, null, !129, null}
!129 = !{!130}
!130 = !{i32 0, %hostlayout.cbMaterial* undef, !"cbMaterial", i32 0, i32 1, i32 1, i32 96, null}
!131 = !{i32 0, %hostlayout.cbMaterial undef, !132}
!132 = !{i32 96, !133, !134, !135, !136}
!133 = !{i32 6, !"gDiffuseAlbedo", i32 3, i32 0, i32 7, i32 9}
!134 = !{i32 6, !"gFresnelR0", i32 3, i32 16, i32 7, i32 9}
!135 = !{i32 6, !"gRoughness", i32 3, i32 28, i32 7, i32 9}
!136 = !{i32 6, !"gMatTransform", i32 2, !137, i32 3, i32 32, i32 7, i32 9}
!137 = !{i32 4, i32 4, i32 2}
!138 = !{i32 1, void ()* @PS_MirrorBaseFill, !139}
!139 = !{!140}
!140 = !{i32 0, !2, !2}
!141 = !{[16 x i32] [i32 14, i32 4, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0]}
!142 = !{void ()* @PS_MirrorBaseFill, !"PS_MirrorBaseFill", !143, !128, !153}
!143 = !{!144, !150, null}
!144 = !{!145, !147, !148, !149}
!145 = !{i32 0, !"SV_Position", i8 9, i8 3, !146, i8 4, i32 1, i8 4, i32 0, i8 0, null}
!146 = !{i32 0}
!147 = !{i32 1, !"POSITION", i8 9, i8 0, !146, i8 2, i32 1, i8 3, i32 1, i8 0, null}
!148 = !{i32 2, !"NORMAL", i8 9, i8 0, !146, i8 2, i32 1, i8 3, i32 2, i8 0, null}
!149 = !{i32 3, !"TEXCOORD", i8 9, i8 0, !146, i8 2, i32 1, i8 2, i32 3, i8 0, null}
!150 = !{!151}
!151 = !{i32 0, !"SV_Target", i8 9, i8 16, !146, i8 0, i32 1, i8 4, i32 0, i8 0, !152}
!152 = !{i32 3, i32 15}
!153 = !{i32 0, i64 1}
!154 = !DILocation(line: 165, column: 12, scope: !4)
!155 = !DILocation(line: 165, column: 5, scope: !4)
