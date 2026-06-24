;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; SV_Position              0   xyzw        0      POS   float       
;
;
; Output signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; SV_Target                0   xyzw        0   TARGET   float   xyzw
;
; shader debug name: 523eedcb83cc6b9adc5f914d061464ec.pdb
; shader hash: 523eedcb83cc6b9adc5f914d061464ec
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
; SigInputElements: 1
; SigOutputElements: 1
; SigPatchConstOrPrimElements: 0
; SigInputVectors: 1
; SigOutputVectors[0]: 1
; SigOutputVectors[1]: 0
; SigOutputVectors[2]: 0
; SigOutputVectors[3]: 0
; EntryFunctionName: FullscreenPS
;
;
; Input signature:
;
; Name                 Index             InterpMode DynIdx
; -------------------- ----- ---------------------- ------
; SV_Position              0          noperspective       
;
; Output signature:
;
; Name                 Index             InterpMode DynIdx
; -------------------- ----- ---------------------- ------
; SV_Target                0                              
;
; Buffer Definitions:
;
; cbuffer DebugColorCB
; {
;
;   struct DebugColorCB
;   {
;
;       float4 gDebugColor;                           ; Offset:    0
;   
;   } DebugColorCB;                                   ; Offset:    0 Size:    16
;
; }
;
;
; Resource Bindings:
;
; Name                                 Type  Format         Dim      ID      HLSL Bind  Count
; ------------------------------ ---------- ------- ----------- ------- -------------- ------
; DebugColorCB                      cbuffer      NA          NA     CB0            cb0     1
;
;
; ViewId state:
;
; Number of inputs: 4, outputs: 4
; Outputs dependent on ViewId: {  }
; Inputs contributing to computation of Outputs:
;
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-f16:32-f32:32-f64:64-n8:16:32:64"
target triple = "dxil-ms-dx"

%dx.types.Handle = type { i8* }
%dx.types.CBufRet.f32 = type { float, float, float, float }
%DebugColorCB = type { <4 x float> }

@dx.nothing.a = internal constant [1 x i32] zeroinitializer

define void @FullscreenPS() {
  %DebugColorCB_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 0, i32 0, i1 false)  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %DebugColorCB_cbuffer, i32 0), !dbg !53 ; line:28 col:12  ; CBufferLoadLegacy(handle,regIndex)
  %2 = extractvalue %dx.types.CBufRet.f32 %1, 0, !dbg !53 ; line:28 col:12
  %3 = extractvalue %dx.types.CBufRet.f32 %1, 1, !dbg !53 ; line:28 col:12
  %4 = extractvalue %dx.types.CBufRet.f32 %1, 2, !dbg !53 ; line:28 col:12
  %5 = extractvalue %dx.types.CBufRet.f32 %1, 3, !dbg !53 ; line:28 col:12
  %6 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !54 ; line:28 col:5
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %2), !dbg !54 ; line:28 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %3), !dbg !54 ; line:28 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %4), !dbg !54 ; line:28 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %5), !dbg !54 ; line:28 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  ret void, !dbg !54 ; line:28 col:5
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
!llvm.module.flags = !{!25, !26}
!llvm.ident = !{!27}
!dx.source.contents = !{!28}
!dx.source.defines = !{!2}
!dx.source.mainFileName = !{!29}
!dx.source.args = !{!30}
!dx.version = !{!31}
!dx.valver = !{!32}
!dx.shaderModel = !{!33}
!dx.resources = !{!34}
!dx.typeAnnotations = !{!37, !40}
!dx.viewIdState = !{!43}
!dx.entryPoints = !{!44}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, subprograms: !3, globals: !22)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CDepthComplexity.hlsl", directory: "")
!2 = !{}
!3 = !{!4}
!4 = !DISubprogram(name: "FullscreenPS", scope: !1, file: !1, line: 26, type: !5, isLocal: false, isDefinition: true, scopeLine: 27, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @FullscreenPS)
!5 = !DISubroutineType(types: !6)
!6 = !{!7, !19}
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4", file: !1, line: 3, baseType: !8)
!8 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 4>", file: !1, line: 3, size: 128, align: 32, elements: !9, templateParams: !15)
!9 = !{!10, !12, !13, !14}
!10 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !8, file: !1, line: 3, baseType: !11, size: 32, align: 32, flags: DIFlagPublic)
!11 = !DIBasicType(name: "float", size: 32, align: 32, encoding: DW_ATE_float)
!12 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !8, file: !1, line: 3, baseType: !11, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!13 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !8, file: !1, line: 3, baseType: !11, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!14 = !DIDerivedType(tag: DW_TAG_member, name: "w", scope: !8, file: !1, line: 3, baseType: !11, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!15 = !{!16, !17}
!16 = !DITemplateTypeParameter(name: "element", type: !11)
!17 = !DITemplateValueParameter(name: "element_count", type: !18, value: i32 4)
!18 = !DIBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!19 = !DICompositeType(tag: DW_TAG_structure_type, name: "VOut", file: !1, line: 6, size: 128, align: 32, elements: !20)
!20 = !{!21}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "PosH", scope: !19, file: !1, line: 8, baseType: !7, size: 128, align: 32)
!22 = !{!23}
!23 = !DIGlobalVariable(name: "gDebugColor", linkageName: "\01?gDebugColor@DebugColorCB@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 3, type: !24, isLocal: false, isDefinition: true)
!24 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !7)
!25 = !{i32 2, !"Dwarf Version", i32 4}
!26 = !{i32 2, !"Debug Info Version", i32 3}
!27 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!28 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CDepthComplexity.hlsl", !"cbuffer DebugColorCB : register(b0)\0D\0A{\0D\0A    float4 gDebugColor;\0D\0A};\0D\0A\0D\0Astruct VOut\0D\0A{\0D\0A    float4 PosH : SV_Position;\0D\0A};\0D\0A\0D\0AVOut FullscreenVS(uint vid : SV_VertexID)\0D\0A{\0D\0A    VOut vout;\0D\0A    \0D\0A    float2 pos[3] =\0D\0A    {\0D\0A        float2(-1.0f, -1.0f),\0D\0A        float2(-1.0f, 3.0f),\0D\0A        float2(3.0f, -1.0f),\0D\0A    };\0D\0A\0D\0A    vout.PosH = float4(pos[vid], 0.0f, 1.0f);\0D\0A    return vout;\0D\0A}\0D\0A\0D\0Afloat4 FullscreenPS(VOut pin) : SV_Target\0D\0A{\0D\0A    return gDebugColor;\0D\0A}"}
!29 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CDepthComplexity.hlsl"}
!30 = !{!"-E", !"FullscreenPS", !"-T", !"ps_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CCompiled\5CDepthComplexity_ps.cso"}
!31 = !{i32 1, i32 0}
!32 = !{i32 1, i32 8}
!33 = !{!"ps", i32 6, i32 0}
!34 = !{null, null, !35, null}
!35 = !{!36}
!36 = !{i32 0, %DebugColorCB* undef, !"DebugColorCB", i32 0, i32 0, i32 1, i32 16, null}
!37 = !{i32 0, %DebugColorCB undef, !38}
!38 = !{i32 16, !39}
!39 = !{i32 6, !"gDebugColor", i32 3, i32 0, i32 7, i32 9}
!40 = !{i32 1, void ()* @FullscreenPS, !41}
!41 = !{!42}
!42 = !{i32 0, !2, !2}
!43 = !{[6 x i32] [i32 4, i32 4, i32 0, i32 0, i32 0, i32 0]}
!44 = !{void ()* @FullscreenPS, !"FullscreenPS", !45, !34, !52}
!45 = !{!46, !49, null}
!46 = !{!47}
!47 = !{i32 0, !"SV_Position", i8 9, i8 3, !48, i8 4, i32 1, i8 4, i32 0, i8 0, null}
!48 = !{i32 0}
!49 = !{!50}
!50 = !{i32 0, !"SV_Target", i8 9, i8 16, !48, i8 0, i32 1, i8 4, i32 0, i8 0, !51}
!51 = !{i32 3, i32 15}
!52 = !{i32 0, i64 1}
!53 = !DILocation(line: 28, column: 12, scope: !4)
!54 = !DILocation(line: 28, column: 5, scope: !4)
