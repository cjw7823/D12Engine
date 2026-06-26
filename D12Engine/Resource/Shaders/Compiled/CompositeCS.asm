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
; shader debug name: 34aa2ac6ad02258cacb248257b80d284.pdb
; shader hash: 34aa2ac6ad02258cacb248257b80d284
;
; Pipeline Runtime Information: 
;
;PSVRuntimeInfo:
; Compute Shader
; NumThreads=(16,16,1)
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
; EntryFunctionName: CompositeCS
;
;
; Buffer Definitions:
;
;
; Resource Bindings:
;
; Name                                 Type  Format         Dim      ID      HLSL Bind  Count
; ------------------------------ ---------- ------- ----------- ------- -------------- ------
; gInput1                           texture     f32          2d      T0             t0     1
; gInput2                           texture     f32          2d      T1             t1     1
; gOutput                               UAV     f32          2d      U0             u0     1
;
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-f16:32-f32:32-f64:64-n8:16:32:64"
target triple = "dxil-ms-dx"

%dx.types.Handle = type { i8* }
%dx.types.ResRet.f32 = type { float, float, float, float, i32 }
%"class.Texture2D<vector<float, 4> >" = type { <4 x float>, %"class.Texture2D<vector<float, 4> >::mips_type" }
%"class.Texture2D<vector<float, 4> >::mips_type" = type { i32 }
%"class.RWTexture2D<vector<float, 4> >" = type { <4 x float> }

@dx.nothing.a = internal constant [1 x i32] zeroinitializer

define void @CompositeCS() {
  %gOutput_UAV_2d = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 1, i32 0, i32 0, i1 false), !dbg !58 ; line:49 col:16  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %gInput2_texture_2d = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 0, i32 1, i32 1, i1 false), !dbg !58 ; line:49 col:16  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %gInput1_texture_2d = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 0, i32 0, i32 0, i1 false), !dbg !58 ; line:49 col:16  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call i32 @dx.op.threadId.i32(i32 93, i32 0), !dbg !59 ; line:46 col:24  ; ThreadId(component)
  %2 = call i32 @dx.op.threadId.i32(i32 93, i32 1), !dbg !59 ; line:46 col:24  ; ThreadId(component)
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !60, metadata !61), !dbg !59 ; var:"tid" !DIExpression(DW_OP_bit_piece, 0, 32) func:"CompositeCS"
  call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !60, metadata !62), !dbg !59 ; var:"tid" !DIExpression(DW_OP_bit_piece, 32, 32) func:"CompositeCS"
  %TextureLoad = call %dx.types.ResRet.f32 @dx.op.textureLoad.f32(i32 66, %dx.types.Handle %gInput1_texture_2d, i32 0, i32 %1, i32 %2, i32 undef, i32 undef, i32 undef, i32 undef), !dbg !63 ; line:48 col:16  ; TextureLoad(srv,mipLevelOrSampleCount,coord0,coord1,coord2,offset0,offset1,offset2)
  call void @llvm.dbg.value(metadata %dx.types.ResRet.f32 %TextureLoad, i64 0, metadata !64, metadata !66), !dbg !67 ; var:"a" !DIExpression() func:"CompositeCS"
  %3 = extractvalue %dx.types.ResRet.f32 %TextureLoad, 0, !dbg !63 ; line:48 col:16
  %4 = extractvalue %dx.types.ResRet.f32 %TextureLoad, 1, !dbg !63 ; line:48 col:16
  %5 = extractvalue %dx.types.ResRet.f32 %TextureLoad, 2, !dbg !63 ; line:48 col:16
  %6 = extractvalue %dx.types.ResRet.f32 %TextureLoad, 3, !dbg !63 ; line:48 col:16
  %7 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !67 ; line:48 col:12
  %TextureLoad1 = call %dx.types.ResRet.f32 @dx.op.textureLoad.f32(i32 66, %dx.types.Handle %gInput2_texture_2d, i32 0, i32 %1, i32 %2, i32 undef, i32 undef, i32 undef, i32 undef), !dbg !58 ; line:49 col:16  ; TextureLoad(srv,mipLevelOrSampleCount,coord0,coord1,coord2,offset0,offset1,offset2)
  call void @llvm.dbg.value(metadata %dx.types.ResRet.f32 %TextureLoad1, i64 0, metadata !68, metadata !66), !dbg !69 ; var:"b" !DIExpression() func:"CompositeCS"
  %8 = extractvalue %dx.types.ResRet.f32 %TextureLoad1, 0, !dbg !58 ; line:49 col:16
  %9 = extractvalue %dx.types.ResRet.f32 %TextureLoad1, 1, !dbg !58 ; line:49 col:16
  %10 = extractvalue %dx.types.ResRet.f32 %TextureLoad1, 2, !dbg !58 ; line:49 col:16
  %11 = extractvalue %dx.types.ResRet.f32 %TextureLoad1, 3, !dbg !58 ; line:49 col:16
  %12 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !69 ; line:49 col:12
  %.i0 = fmul fast float %3, %8, !dbg !70 ; line:51 col:25
  %.i1 = fmul fast float %4, %9, !dbg !70 ; line:51 col:25
  %.i2 = fmul fast float %5, %10, !dbg !70 ; line:51 col:25
  %.i3 = fmul fast float %6, %11, !dbg !70 ; line:51 col:25
  call void @dx.op.textureStore.f32(i32 67, %dx.types.Handle %gOutput_UAV_2d, i32 %1, i32 %2, i32 undef, float %.i0, float %.i1, float %.i2, float %.i3, i8 15), !dbg !71 ; line:51 col:21  ; TextureStore(srv,coord0,coord1,coord2,value0,value1,value2,value3,mask)
  %13 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !72 ; line:52 col:1
  ret void, !dbg !72 ; line:52 col:1
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #0

; Function Attrs: nounwind readnone
declare i32 @dx.op.threadId.i32(i32, i32) #0

; Function Attrs: nounwind
declare void @dx.op.textureStore.f32(i32, %dx.types.Handle, i32, i32, i32, float, float, float, float, i8) #1

; Function Attrs: nounwind readonly
declare %dx.types.ResRet.f32 @dx.op.textureLoad.f32(i32, %dx.types.Handle, i32, i32, i32, i32, i32, i32, i32) #2

; Function Attrs: nounwind readonly
declare %dx.types.Handle @dx.op.createHandle(i32, i8, i32, i32, i1) #2

attributes #0 = { nounwind readnone }
attributes #1 = { nounwind }
attributes #2 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!36, !37}
!llvm.ident = !{!38}
!dx.source.contents = !{!39}
!dx.source.defines = !{!2}
!dx.source.mainFileName = !{!40}
!dx.source.args = !{!41}
!dx.version = !{!42}
!dx.valver = !{!43}
!dx.shaderModel = !{!44}
!dx.resources = !{!45}
!dx.typeAnnotations = !{!52}
!dx.entryPoints = !{!55}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, subprograms: !3, globals: !18)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CSobel.hlsl", directory: "")
!2 = !{}
!3 = !{!4}
!4 = !DISubprogram(name: "CompositeCS", scope: !1, file: !1, line: 46, type: !5, isLocal: false, isDefinition: true, scopeLine: 47, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @CompositeCS)
!5 = !DISubroutineType(types: !6)
!6 = !{null, !7}
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint3", file: !1, baseType: !8)
!8 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<unsigned int, 3>", file: !1, size: 96, align: 32, elements: !9, templateParams: !14)
!9 = !{!10, !12, !13}
!10 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !8, file: !1, baseType: !11, size: 32, align: 32, flags: DIFlagPublic)
!11 = !DIBasicType(name: "unsigned int", size: 32, align: 32, encoding: DW_ATE_unsigned)
!12 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !8, file: !1, baseType: !11, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!13 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !8, file: !1, baseType: !11, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!14 = !{!15, !16}
!15 = !DITemplateTypeParameter(name: "element", type: !11)
!16 = !DITemplateValueParameter(name: "element_count", type: !17, value: i32 3)
!17 = !DIBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!18 = !{!19, !33, !34}
!19 = !DIGlobalVariable(name: "gInput1", linkageName: "\01?gInput1@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 5, type: !20, isLocal: false, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_class_type, name: "Texture2D<vector<float, 4> >", file: !1, line: 5, size: 160, align: 32, elements: !2, templateParams: !21)
!21 = !{!22}
!22 = !DITemplateTypeParameter(name: "element", type: !23)
!23 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 4>", file: !1, line: 48, size: 128, align: 32, elements: !24, templateParams: !30)
!24 = !{!25, !27, !28, !29}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !23, file: !1, line: 48, baseType: !26, size: 32, align: 32, flags: DIFlagPublic)
!26 = !DIBasicType(name: "float", size: 32, align: 32, encoding: DW_ATE_float)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !23, file: !1, line: 48, baseType: !26, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !23, file: !1, line: 48, baseType: !26, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "w", scope: !23, file: !1, line: 48, baseType: !26, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!30 = !{!31, !32}
!31 = !DITemplateTypeParameter(name: "element", type: !26)
!32 = !DITemplateValueParameter(name: "element_count", type: !17, value: i32 4)
!33 = !DIGlobalVariable(name: "gInput2", linkageName: "\01?gInput2@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 6, type: !20, isLocal: false, isDefinition: true)
!34 = !DIGlobalVariable(name: "gOutput", linkageName: "\01?gOutput@@3V?$RWTexture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 7, type: !35, isLocal: false, isDefinition: true)
!35 = !DICompositeType(tag: DW_TAG_class_type, name: "RWTexture2D<vector<float, 4> >", file: !1, line: 7, size: 128, align: 32, elements: !2, templateParams: !21)
!36 = !{i32 2, !"Dwarf Version", i32 4}
!37 = !{i32 2, !"Debug Info Version", i32 3}
!38 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!39 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CSobel.hlsl", !"/*\0D\0A    \EC\86\8C\EB\B2\A8 \EC\97\B0\EC\82\B0\EC\9E\90\EB\A5\BC \EC\82\AC\EC\9A\A9\ED\95\98\EC\97\AC \EC\97\90\EC\A7\80 \EA\B2\80\EC\B6\9C\0D\0A*/\0D\0A\0D\0ATexture2D gInput1 : register(t0);\0D\0ATexture2D gInput2 : register(t1);\0D\0ARWTexture2D<float4> gOutput : register(u0);\0D\0A\0D\0A//RGB\EA\B0\92\EC\9C\BC\EB\A1\9C\EB\B6\80\ED\84\B0 \ED\9C\98\EB\8F\84, \EC\A6\89 \EB\B0\9D\EA\B8\B0\EB\A5\BC \EA\B7\BC\EC\82\AC\ED\95\9C\EB\8B\A4.\0D\0A//\EC\9D\B4 \EA\B0\80\EC\A4\91\EC\B9\98\EB\8A\94 \EC\84\9C\EB\A1\9C \EB\8B\A4\EB\A5\B8 \EB\B9\9B\EC\9D\98 \ED\8C\8C\EC\9E\A5\EC\97\90 \EB\8C\80\ED\95\9C \EC\9D\B8\EA\B0\84 \EB\88\88\EC\9D\98 \EB\AF\BC\EA\B0\90\EB\8F\84\EB\A5\BC \EB\B0\94\ED\83\95\EC\9C\BC\EB\A1\9C \EC\8B\A4\ED\97\98\EC\A0\81\EC\9C\BC\EB\A1\9C \EB\8F\84\EC\B6\9C\EB\90\9C \EA\B0\92\EC\9D\B4\EB\8B\A4.\0D\0Afloat Calcuminance(float3 color)\0D\0A{\0D\0A    return dot(color, float3(0.299f, 0.587f, 0.114f));\0D\0A}\0D\0A\0D\0A[numthreads(16, 16, 1)]\0D\0Avoid SobelCS(int3 dispatchThreadID : SV_DispatchThreadID)\0D\0A{\0D\0A    //\ED\98\84\EC\9E\AC \ED\94\BD\EC\85\80 \EC\A3\BC\EB\B3\80\EC\9D\98 \EC\9D\B4\EC\9B\83 \ED\94\BD\EC\85\80\EB\93\A4\EC\9D\84 \EC\83\98\ED\94\8C\EB\A7\81\0D\0A    float4 c[3][3];\0D\0A    for (int i = 0; i < 3; i++)\0D\0A    {\0D\0A        for (int j = 0; j < 3; j++)\0D\0A        {\0D\0A            int2 xy = dispatchThreadID.xy + int2(-1 + j, -1 + i);\0D\0A            c[i][j] = gInput1[xy];\0D\0A        }\0D\0A    }\0D\0A    \0D\0A    //\EA\B0\81 \EC\83\89\EC\83\81 \EC\B1\84\EB\84\90\EC\97\90 \EB\8C\80\ED\95\B4 Sobel \EB\B0\A9\EC\8B\9D\EC\9D\84 \EC\82\AC\EC\9A\A9\ED\95\98\EC\97\AC x\EB\B0\A9\ED\96\A5 \ED\8E\B8\EB\AF\B8\EB\B6\84\EC\9D\84 \EC\B6\94\EC\A0\95\ED\95\9C\EB\8B\A4.\0D\0A    float4 Gx = -1.0f * c[0][0] - 2.0f * c[1][0] - 1.0f * c[2][0] + 1.0f * c[0][2] + 2.0f * c[1][2] + 1.0f * c[2][2];\0D\0A    \0D\0A    //\EA\B0\81 \EC\83\89\EC\83\81 \EC\B1\84\EB\84\90\EC\97\90 \EB\8C\80\ED\95\B4 Sobel \EB\B0\A9\EC\8B\9D\EC\9D\84 \EC\82\AC\EC\9A\A9\ED\95\98\EC\97\AC y\EB\B0\A9\ED\96\A5 \ED\8E\B8\EB\AF\B8\EB\B6\84\EC\9D\84 \EC\B6\94\EC\A0\95\ED\95\9C\EB\8B\A4.\0D\0A    float4 Gy = -1.0f * c[2][0] - 2.0f * c[2][1] - 1.0f * c[2][2] + 1.0f * c[0][0] + 2.0f * c[0][1] + 1.0f * c[0][2];\0D\0A    \0D\0A    //\EA\B7\B8\EB\9E\98\EB\94\94\EC\96\B8\ED\8A\B8\EB\8A\94 (Gx, Gy)\EB\8B\A4. \EA\B0\81 \EC\83\89\EC\83\81 \EC\B1\84\EB\84\90\EC\97\90 \EB\8C\80\ED\95\B4 \EA\B7\B8\EB\9E\98\EB\94\94\EC\96\B8\ED\8A\B8\EC\9D\98 \ED\81\AC\EA\B8\B0\EB\A5\BC \EA\B3\84\EC\82\B0\ED\95\98\EC\97\AC \EB\B3\80\ED\99\94\EC\9C\A8\EC\9D\98 \EC\B5\9C\EB\8C\80\EA\B0\92\EC\9D\84 \EA\B5\AC\ED\95\9C\EB\8B\A4.\0D\0A    float4 mag = sqrt(Gx * Gx + Gy + Gy);\0D\0A    \0D\0A    //\EC\97\A3\EC\A7\80\EB\8A\94 \EA\B2\80\EC\9D\80\EC\83\89, \EB\8B\A4\EB\A5\B8 \EB\B6\80\EB\B6\84\EC\9D\80 \ED\9D\B0\EC\83\89\0D\0A    mag = 1.0f - saturate(Calcuminance(mag.rgb));\0D\0A    \0D\0A    gOutput[dispatchThreadID.xy] = mag;\0D\0A}\0D\0A\0D\0A[numthreads(16, 16, 1)]\0D\0Avoid CompositeCS(uint3 tid : SV_DispatchThreadID)\0D\0A{\0D\0A    float4 a = gInput1[tid.xy];\0D\0A    float4 b = gInput2[tid.xy];\0D\0A\0D\0A    gOutput[tid.xy] = a * b;\0D\0A}"}
!40 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CSobel.hlsl"}
!41 = !{!"-E", !"CompositeCS", !"-T", !"cs_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CCompiled\5CCompositeCS.cso"}
!42 = !{i32 1, i32 0}
!43 = !{i32 1, i32 8}
!44 = !{!"cs", i32 6, i32 0}
!45 = !{!46, !50, null, null}
!46 = !{!47, !49}
!47 = !{i32 0, %"class.Texture2D<vector<float, 4> >"* undef, !"gInput1", i32 0, i32 0, i32 1, i32 2, i32 0, !48}
!48 = !{i32 0, i32 9}
!49 = !{i32 1, %"class.Texture2D<vector<float, 4> >"* undef, !"gInput2", i32 0, i32 1, i32 1, i32 2, i32 0, !48}
!50 = !{!51}
!51 = !{i32 0, %"class.RWTexture2D<vector<float, 4> >"* undef, !"gOutput", i32 0, i32 0, i32 1, i32 2, i1 false, i1 false, i1 false, !48}
!52 = !{i32 1, void ()* @CompositeCS, !53}
!53 = !{!54}
!54 = !{i32 0, !2, !2}
!55 = !{void ()* @CompositeCS, !"CompositeCS", null, !45, !56}
!56 = !{i32 0, i64 1, i32 4, !57}
!57 = !{i32 16, i32 16, i32 1}
!58 = !DILocation(line: 49, column: 16, scope: !4)
!59 = !DILocation(line: 46, column: 24, scope: !4)
!60 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "tid", arg: 1, scope: !4, file: !1, line: 46, type: !7)
!61 = !DIExpression(DW_OP_bit_piece, 0, 32)
!62 = !DIExpression(DW_OP_bit_piece, 32, 32)
!63 = !DILocation(line: 48, column: 16, scope: !4)
!64 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "a", scope: !4, file: !1, line: 48, type: !65)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4", file: !1, line: 48, baseType: !23)
!66 = !DIExpression()
!67 = !DILocation(line: 48, column: 12, scope: !4)
!68 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "b", scope: !4, file: !1, line: 49, type: !65)
!69 = !DILocation(line: 49, column: 12, scope: !4)
!70 = !DILocation(line: 51, column: 25, scope: !4)
!71 = !DILocation(line: 51, column: 21, scope: !4)
!72 = !DILocation(line: 52, column: 1, scope: !4)
