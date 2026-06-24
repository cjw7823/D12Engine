;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; no parameters
;
; Output signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; no parameters
; shader debug name: b6cfaa9d8a291b6710b6162848681f31.pdb
; shader hash: b6cfaa9d8a291b6710b6162848681f31
;
; Pipeline Runtime Information: 
;
;PSVRuntimeInfo:
; Compute Shader
; NumThreads=(1,1,1)
; MinimumExpectedWaveLaneCount: 0
; MaximumExpectedWaveLaneCount: 4294967295
; UsesViewID: false
; SigInputElements: 0
; SigOutputElements: 0
; SigPatchConstOrPrimElements: 0
; SigInputVectors: 0
; SigOutputVectors[0]: 0
; SigOutputVectors[1]: 0
; SigOutputVectors[2]: 0
; SigOutputVectors[3]: 0
; EntryFunctionName: DisturbWavesCS
;
;
; Buffer Definitions:
;
; cbuffer cbUpdateSettings
; {
;
;   struct cbUpdateSettings
;   {
;
;       float gWaveConstant0;                         ; Offset:    0
;       float gWaveConstant1;                         ; Offset:    4
;       float gWaveConstant2;                         ; Offset:    8
;       float gDisturbMag;                            ; Offset:   12
;       uint2 gDisturbIndex;                          ; Offset:   16
;   
;   } cbUpdateSettings;                               ; Offset:    0 Size:    24
;
; }
;
;
; Resource Bindings:
;
; Name                                 Type  Format         Dim      ID      HLSL Bind  Count
; ------------------------------ ---------- ------- ----------- ------- -------------- ------
; cbUpdateSettings                  cbuffer      NA          NA     CB0            cb0     1
; gOutput                               UAV     f32          2d      U0             u2     1
;
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-f16:32-f32:32-f64:64-n8:16:32:64"
target triple = "dxil-ms-dx"

%dx.types.Handle = type { i8* }
%dx.types.CBufRet.i32 = type { i32, i32, i32, i32 }
%dx.types.CBufRet.f32 = type { float, float, float, float }
%dx.types.ResRet.f32 = type { float, float, float, float, i32 }
%"class.RWTexture2D<float>" = type { float }
%cbUpdateSettings = type { float, float, float, float, <2 x i32> }

@dx.nothing.a = internal constant [1 x i32] zeroinitializer

define void @DisturbWavesCS() {
  %gOutput_UAV_2d = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 1, i32 0, i32 2, i1 false), !dbg !76 ; line:44 col:5  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %cbUpdateSettings_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 0, i32 0, i1 false), !dbg !76 ; line:44 col:5  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call %dx.types.CBufRet.i32 @dx.op.cbufferLoadLegacy.i32(i32 59, %dx.types.Handle %cbUpdateSettings_cbuffer, i32 1), !dbg !77 ; line:39 col:13  ; CBufferLoadLegacy(handle,regIndex)
  %2 = extractvalue %dx.types.CBufRet.i32 %1, 0, !dbg !77 ; line:39 col:13
  %3 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !78 ; line:39 col:9
  call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !79, metadata !80), !dbg !78 ; var:"x" !DIExpression() func:"DisturbWavesCS"
  %4 = call %dx.types.CBufRet.i32 @dx.op.cbufferLoadLegacy.i32(i32 59, %dx.types.Handle %cbUpdateSettings_cbuffer, i32 1), !dbg !81 ; line:40 col:13  ; CBufferLoadLegacy(handle,regIndex)
  %5 = extractvalue %dx.types.CBufRet.i32 %4, 1, !dbg !81 ; line:40 col:13
  %6 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !82 ; line:40 col:9
  call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !83, metadata !80), !dbg !82 ; var:"y" !DIExpression() func:"DisturbWavesCS"
  %7 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbUpdateSettings_cbuffer, i32 0), !dbg !84 ; line:42 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %8 = extractvalue %dx.types.CBufRet.f32 %7, 3, !dbg !84 ; line:42 col:27
  %9 = fmul fast float 5.000000e-01, %8, !dbg !85 ; line:42 col:25
  %10 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !86 ; line:42 col:11
  call void @llvm.dbg.value(metadata float %9, i64 0, metadata !87, metadata !80), !dbg !86 ; var:"halfMag" !DIExpression() func:"DisturbWavesCS"
  %11 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbUpdateSettings_cbuffer, i32 0), !dbg !88 ; line:44 col:28  ; CBufferLoadLegacy(handle,regIndex)
  %12 = extractvalue %dx.types.CBufRet.f32 %11, 3, !dbg !88 ; line:44 col:28
  %TextureLoad = call %dx.types.ResRet.f32 @dx.op.textureLoad.f32(i32 66, %dx.types.Handle %gOutput_UAV_2d, i32 undef, i32 %2, i32 %5, i32 undef, i32 undef, i32 undef, i32 undef), !dbg !89 ; line:44 col:25  ; TextureLoad(srv,mipLevelOrSampleCount,coord0,coord1,coord2,offset0,offset1,offset2)
  %13 = extractvalue %dx.types.ResRet.f32 %TextureLoad, 0, !dbg !89 ; line:44 col:25
  %14 = fadd fast float %13, %12, !dbg !89 ; line:44 col:25
  call void @dx.op.textureStore.f32(i32 67, %dx.types.Handle %gOutput_UAV_2d, i32 %2, i32 %5, i32 undef, float %14, float %14, float %14, float %14, i8 15), !dbg !89 ; line:44 col:25  ; TextureStore(srv,coord0,coord1,coord2,value0,value1,value2,value3,mask)
  %15 = add nsw i32 %2, 1, !dbg !90 ; line:45 col:20
  %TextureLoad1 = call %dx.types.ResRet.f32 @dx.op.textureLoad.f32(i32 66, %dx.types.Handle %gOutput_UAV_2d, i32 undef, i32 %15, i32 %5, i32 undef, i32 undef, i32 undef, i32 undef), !dbg !91 ; line:45 col:29  ; TextureLoad(srv,mipLevelOrSampleCount,coord0,coord1,coord2,offset0,offset1,offset2)
  %16 = extractvalue %dx.types.ResRet.f32 %TextureLoad1, 0, !dbg !91 ; line:45 col:29
  %17 = fadd fast float %16, %9, !dbg !91 ; line:45 col:29
  call void @dx.op.textureStore.f32(i32 67, %dx.types.Handle %gOutput_UAV_2d, i32 %15, i32 %5, i32 undef, float %17, float %17, float %17, float %17, i8 15), !dbg !91 ; line:45 col:29  ; TextureStore(srv,coord0,coord1,coord2,value0,value1,value2,value3,mask)
  %18 = sub nsw i32 %2, 1, !dbg !92 ; line:46 col:20
  %TextureLoad2 = call %dx.types.ResRet.f32 @dx.op.textureLoad.f32(i32 66, %dx.types.Handle %gOutput_UAV_2d, i32 undef, i32 %18, i32 %5, i32 undef, i32 undef, i32 undef, i32 undef), !dbg !93 ; line:46 col:29  ; TextureLoad(srv,mipLevelOrSampleCount,coord0,coord1,coord2,offset0,offset1,offset2)
  %19 = extractvalue %dx.types.ResRet.f32 %TextureLoad2, 0, !dbg !93 ; line:46 col:29
  %20 = fadd fast float %19, %9, !dbg !93 ; line:46 col:29
  call void @dx.op.textureStore.f32(i32 67, %dx.types.Handle %gOutput_UAV_2d, i32 %18, i32 %5, i32 undef, float %20, float %20, float %20, float %20, i8 15), !dbg !93 ; line:46 col:29  ; TextureStore(srv,coord0,coord1,coord2,value0,value1,value2,value3,mask)
  %21 = add nsw i32 %5, 1, !dbg !94 ; line:47 col:23
  %TextureLoad3 = call %dx.types.ResRet.f32 @dx.op.textureLoad.f32(i32 66, %dx.types.Handle %gOutput_UAV_2d, i32 undef, i32 %2, i32 %21, i32 undef, i32 undef, i32 undef, i32 undef), !dbg !95 ; line:47 col:29  ; TextureLoad(srv,mipLevelOrSampleCount,coord0,coord1,coord2,offset0,offset1,offset2)
  %22 = extractvalue %dx.types.ResRet.f32 %TextureLoad3, 0, !dbg !95 ; line:47 col:29
  %23 = fadd fast float %22, %9, !dbg !95 ; line:47 col:29
  call void @dx.op.textureStore.f32(i32 67, %dx.types.Handle %gOutput_UAV_2d, i32 %2, i32 %21, i32 undef, float %23, float %23, float %23, float %23, i8 15), !dbg !95 ; line:47 col:29  ; TextureStore(srv,coord0,coord1,coord2,value0,value1,value2,value3,mask)
  %24 = sub nsw i32 %5, 1, !dbg !96 ; line:48 col:23
  %TextureLoad4 = call %dx.types.ResRet.f32 @dx.op.textureLoad.f32(i32 66, %dx.types.Handle %gOutput_UAV_2d, i32 undef, i32 %2, i32 %24, i32 undef, i32 undef, i32 undef, i32 undef), !dbg !97 ; line:48 col:29  ; TextureLoad(srv,mipLevelOrSampleCount,coord0,coord1,coord2,offset0,offset1,offset2)
  %25 = extractvalue %dx.types.ResRet.f32 %TextureLoad4, 0, !dbg !97 ; line:48 col:29
  %26 = fadd fast float %25, %9, !dbg !97 ; line:48 col:29
  call void @dx.op.textureStore.f32(i32 67, %dx.types.Handle %gOutput_UAV_2d, i32 %2, i32 %24, i32 undef, float %26, float %26, float %26, float %26, i8 15), !dbg !97 ; line:48 col:29  ; TextureStore(srv,coord0,coord1,coord2,value0,value1,value2,value3,mask)
  %27 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !98 ; line:49 col:1
  ret void, !dbg !98 ; line:49 col:1
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #0

; Function Attrs: nounwind readonly
declare %dx.types.ResRet.f32 @dx.op.textureLoad.f32(i32, %dx.types.Handle, i32, i32, i32, i32, i32, i32, i32) #1

; Function Attrs: nounwind
declare void @dx.op.textureStore.f32(i32, %dx.types.Handle, i32, i32, i32, float, float, float, float, i8) #2

; Function Attrs: nounwind readonly
declare %dx.types.CBufRet.i32 @dx.op.cbufferLoadLegacy.i32(i32, %dx.types.Handle, i32) #1

; Function Attrs: nounwind readonly
declare %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32, %dx.types.Handle, i32) #1

; Function Attrs: nounwind readonly
declare %dx.types.Handle @dx.op.createHandle(i32, i8, i32, i32, i1) #1

attributes #0 = { nounwind readnone }
attributes #1 = { nounwind readonly }
attributes #2 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!48, !49}
!llvm.ident = !{!50}
!dx.source.contents = !{!51}
!dx.source.defines = !{!2}
!dx.source.mainFileName = !{!52}
!dx.source.args = !{!53}
!dx.version = !{!54}
!dx.valver = !{!55}
!dx.shaderModel = !{!56}
!dx.resources = !{!57}
!dx.typeAnnotations = !{!63, !70}
!dx.entryPoints = !{!73}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !13, globals: !25)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CWaveSim.hlsl", directory: "")
!2 = !{}
!3 = !{!4}
!4 = !DIDerivedType(tag: DW_TAG_typedef, name: "int2", file: !1, line: 44, baseType: !5)
!5 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<int, 2>", file: !1, line: 44, size: 64, align: 32, elements: !6, templateParams: !10)
!6 = !{!7, !9}
!7 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !5, file: !1, line: 44, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!8 = !DIBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!9 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !5, file: !1, line: 44, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!10 = !{!11, !12}
!11 = !DITemplateTypeParameter(name: "element", type: !8)
!12 = !DITemplateValueParameter(name: "element_count", type: !8, value: i32 2)
!13 = !{!14}
!14 = !DISubprogram(name: "DisturbWavesCS", scope: !1, file: !1, line: 36, type: !15, isLocal: false, isDefinition: true, scopeLine: 37, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @DisturbWavesCS)
!15 = !DISubroutineType(types: !16)
!16 = !{null, !17}
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "int3", file: !1, line: 8, baseType: !18)
!18 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<int, 3>", file: !1, line: 8, size: 96, align: 32, elements: !19, templateParams: !23)
!19 = !{!20, !21, !22}
!20 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !18, file: !1, line: 8, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !18, file: !1, line: 8, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !18, file: !1, line: 8, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!23 = !{!11, !24}
!24 = !DITemplateValueParameter(name: "element_count", type: !8, value: i32 3)
!25 = !{!26, !29, !30, !31, !32, !42, !46, !47}
!26 = !DIGlobalVariable(name: "gWaveConstant0", linkageName: "\01?gWaveConstant0@cbUpdateSettings@@3MB", scope: !0, file: !1, line: 3, type: !27, isLocal: false, isDefinition: true)
!27 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !28)
!28 = !DIBasicType(name: "float", size: 32, align: 32, encoding: DW_ATE_float)
!29 = !DIGlobalVariable(name: "gWaveConstant1", linkageName: "\01?gWaveConstant1@cbUpdateSettings@@3MB", scope: !0, file: !1, line: 4, type: !27, isLocal: false, isDefinition: true)
!30 = !DIGlobalVariable(name: "gWaveConstant2", linkageName: "\01?gWaveConstant2@cbUpdateSettings@@3MB", scope: !0, file: !1, line: 5, type: !27, isLocal: false, isDefinition: true)
!31 = !DIGlobalVariable(name: "gDisturbMag", linkageName: "\01?gDisturbMag@cbUpdateSettings@@3MB", scope: !0, file: !1, line: 7, type: !27, isLocal: false, isDefinition: true)
!32 = !DIGlobalVariable(name: "gDisturbIndex", linkageName: "\01?gDisturbIndex@cbUpdateSettings@@3V?$vector@I$01@@B", scope: !0, file: !1, line: 8, type: !33, isLocal: false, isDefinition: true)
!33 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint2", file: !1, line: 8, baseType: !35)
!35 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<unsigned int, 2>", file: !1, line: 8, size: 64, align: 32, elements: !36, templateParams: !40)
!36 = !{!37, !39}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !35, file: !1, line: 8, baseType: !38, size: 32, align: 32, flags: DIFlagPublic)
!38 = !DIBasicType(name: "unsigned int", size: 32, align: 32, encoding: DW_ATE_unsigned)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !35, file: !1, line: 8, baseType: !38, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!40 = !{!41, !12}
!41 = !DITemplateTypeParameter(name: "element", type: !38)
!42 = !DIGlobalVariable(name: "gPrevSolInput", linkageName: "\01?gPrevSolInput@@3V?$RWTexture2D@M@@A", scope: !0, file: !1, line: 11, type: !43, isLocal: false, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_class_type, name: "RWTexture2D<float>", file: !1, line: 11, size: 32, align: 32, elements: !2, templateParams: !44)
!44 = !{!45}
!45 = !DITemplateTypeParameter(name: "element", type: !28)
!46 = !DIGlobalVariable(name: "gCurrSolInput", linkageName: "\01?gCurrSolInput@@3V?$RWTexture2D@M@@A", scope: !0, file: !1, line: 12, type: !43, isLocal: false, isDefinition: true)
!47 = !DIGlobalVariable(name: "gOutput", linkageName: "\01?gOutput@@3V?$RWTexture2D@M@@A", scope: !0, file: !1, line: 13, type: !43, isLocal: false, isDefinition: true)
!48 = !{i32 2, !"Dwarf Version", i32 4}
!49 = !{i32 2, !"Debug Info Version", i32 3}
!50 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!51 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CWaveSim.hlsl", !"cbuffer cbUpdateSettings : register(b0)\0D\0A{\0D\0A    float gWaveConstant0;\0D\0A    float gWaveConstant1;\0D\0A    float gWaveConstant2;\0D\0A    \0D\0A    float gDisturbMag;\0D\0A    uint2 gDisturbIndex;\0D\0A};\0D\0A\0D\0ARWTexture2D<float> gPrevSolInput : register(u0);\0D\0ARWTexture2D<float> gCurrSolInput : register(u1);\0D\0ARWTexture2D<float> gOutput : register(u2);\0D\0A\0D\0A[numthreads(16, 16, 1)]\0D\0Avoid UpdateWavesCS(int3 dispatchThreadID : SV_DispatchThreadID)\0D\0A{\0D\0A    //\EA\B2\BD\EA\B3\84 \EA\B2\80\EC\82\AC\EB\A5\BC \ED\95\A0 \ED\95\84\EC\9A\94\EA\B0\80 \EC\97\86\EC\9D\8C.\0D\0A    //\EA\B2\BD\EA\B3\84 \EB\B0\96 \EC\9D\BD\EA\B8\B0\EB\8A\94 0\EB\B0\98\ED\99\98(\ED\95\B4\EB\8B\B9 \EC\8B\9C\EB\AE\AC\EB\A0\88\EC\9D\B4\EC\85\98\EC\97\90\EC\84\9C\EB\8A\94 \EB\AC\B8\EC\A0\9C \EC\97\86\EC\9D\8C), \EA\B2\BD\EA\B3\84 \EB\B0\96 \EC\93\B0\EA\B8\B0\EB\8A\94 \EB\AC\B4\EC\8B\9C\EB\90\A8.\0D\0A    //0\EB\B0\98\ED\99\98\EC\9D\B4 \EB\AC\B8\EC\A0\9C\EA\B0\80 \EB\90\98\EB\8A\94 \EA\B2\BD\EC\9A\B0, \EA\B2\BD\EA\B3\84 \EA\B2\80\EC\82\AC\EB\A5\BC \ED\95\B4\EC\95\BC\ED\95\A0 \EC\88\98\EB\8F\84 \EC\9E\88\EC\9D\8C.\0D\0A    \0D\0A    int x = dispatchThreadID.x;\0D\0A    int y = dispatchThreadID.y;\0D\0A    \0D\0A    gOutput[int2(x, y)] =\0D\0A        gWaveConstant0 * gPrevSolInput[int2(x, y)].r +\0D\0A        gWaveConstant1 * gCurrSolInput[int2(x, y)].r +\0D\0A        gWaveConstant2 * (\0D\0A            gCurrSolInput[int2(x + 1, y)].r +\0D\0A            gCurrSolInput[int2(x - 1, y)].r +\0D\0A            gCurrSolInput[int2(x, y + 1)].r +\0D\0A            gCurrSolInput[int2(x, y - 1)].r);\0D\0A}\0D\0A\0D\0A[numthreads(1, 1, 1)]\0D\0Avoid DisturbWavesCS(int3 dispatchThreadID : SV_DispatchThreadID)\0D\0A{\0D\0A    //\EA\B2\BD\EA\B3\84\EA\B2\80\EC\82\AC \ED\95\84\EC\9A\94x.\0D\0A    int x = gDisturbIndex.x;\0D\0A    int y = gDisturbIndex.y;\0D\0A    \0D\0A    float halfMag = 0.5 * gDisturbMag;\0D\0A    \0D\0A    gOutput[int2(x, y)] += gDisturbMag;\0D\0A    gOutput[int2(x + 1, y)] += halfMag;\0D\0A    gOutput[int2(x - 1, y)] += halfMag;\0D\0A    gOutput[int2(x, y + 1)] += halfMag;\0D\0A    gOutput[int2(x, y - 1)] += halfMag;\0D\0A}\0D\0A"}
!52 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CWaveSim.hlsl"}
!53 = !{!"-E", !"DisturbWavesCS", !"-T", !"cs_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CCompiled\5CWaveSim_cs_Disturb.cso"}
!54 = !{i32 1, i32 0}
!55 = !{i32 1, i32 8}
!56 = !{!"cs", i32 6, i32 0}
!57 = !{null, !58, !61, null}
!58 = !{!59}
!59 = !{i32 0, %"class.RWTexture2D<float>"* undef, !"gOutput", i32 0, i32 2, i32 1, i32 2, i1 false, i1 false, i1 false, !60}
!60 = !{i32 0, i32 9}
!61 = !{!62}
!62 = !{i32 0, %cbUpdateSettings* undef, !"cbUpdateSettings", i32 0, i32 0, i32 1, i32 24, null}
!63 = !{i32 0, %cbUpdateSettings undef, !64}
!64 = !{i32 24, !65, !66, !67, !68, !69}
!65 = !{i32 6, !"gWaveConstant0", i32 3, i32 0, i32 7, i32 9}
!66 = !{i32 6, !"gWaveConstant1", i32 3, i32 4, i32 7, i32 9}
!67 = !{i32 6, !"gWaveConstant2", i32 3, i32 8, i32 7, i32 9}
!68 = !{i32 6, !"gDisturbMag", i32 3, i32 12, i32 7, i32 9}
!69 = !{i32 6, !"gDisturbIndex", i32 3, i32 16, i32 7, i32 5}
!70 = !{i32 1, void ()* @DisturbWavesCS, !71}
!71 = !{!72}
!72 = !{i32 0, !2, !2}
!73 = !{void ()* @DisturbWavesCS, !"DisturbWavesCS", null, !57, !74}
!74 = !{i32 0, i64 1, i32 4, !75}
!75 = !{i32 1, i32 1, i32 1}
!76 = !DILocation(line: 44, column: 5, scope: !14)
!77 = !DILocation(line: 39, column: 13, scope: !14)
!78 = !DILocation(line: 39, column: 9, scope: !14)
!79 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "x", scope: !14, file: !1, line: 39, type: !8)
!80 = !DIExpression()
!81 = !DILocation(line: 40, column: 13, scope: !14)
!82 = !DILocation(line: 40, column: 9, scope: !14)
!83 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "y", scope: !14, file: !1, line: 40, type: !8)
!84 = !DILocation(line: 42, column: 27, scope: !14)
!85 = !DILocation(line: 42, column: 25, scope: !14)
!86 = !DILocation(line: 42, column: 11, scope: !14)
!87 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "halfMag", scope: !14, file: !1, line: 42, type: !28)
!88 = !DILocation(line: 44, column: 28, scope: !14)
!89 = !DILocation(line: 44, column: 25, scope: !14)
!90 = !DILocation(line: 45, column: 20, scope: !14)
!91 = !DILocation(line: 45, column: 29, scope: !14)
!92 = !DILocation(line: 46, column: 20, scope: !14)
!93 = !DILocation(line: 46, column: 29, scope: !14)
!94 = !DILocation(line: 47, column: 23, scope: !14)
!95 = !DILocation(line: 47, column: 29, scope: !14)
!96 = !DILocation(line: 48, column: 23, scope: !14)
!97 = !DILocation(line: 48, column: 29, scope: !14)
!98 = !DILocation(line: 49, column: 1, scope: !14)
