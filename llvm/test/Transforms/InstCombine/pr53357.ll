; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test for (x & y) + ~(x | y) -> ~(x ^ y)
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; (x & y) + ~(x | y)
define i32 @src(i32 %0, i32 %1) {
; CHECK-LABEL: @src(
; CHECK-NEXT:    [[TMP3:%.*]] = xor i32 [[TMP1:%.*]], [[TMP0:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = xor i32 [[TMP3]], -1
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %3 = and i32 %1, %0
  %4 = or i32 %1, %0
  %5 = xor i32 %4, -1
  %6 = add i32 %3, %5
  ret i32 %6
}

; vector version of src
define <2 x i32> @src_vec(<2 x i32> %0, <2 x i32> %1) {
; CHECK-LABEL: @src_vec(
; CHECK-NEXT:    [[TMP3:%.*]] = xor <2 x i32> [[TMP1:%.*]], [[TMP0:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = xor <2 x i32> [[TMP3]], <i32 -1, i32 -1>
; CHECK-NEXT:    ret <2 x i32> [[TMP4]]
;
  %3 = and <2 x i32> %1, %0
  %4 = or  <2 x i32> %1, %0
  %5 = xor <2 x i32> %4, <i32 -1, i32 -1>
  %6 = add <2 x i32> %3, %5
  ret <2 x i32> %6
}

; vector version of src with undef values
define <2 x i32> @src_vec_undef(<2 x i32> %0, <2 x i32> %1) {
; CHECK-LABEL: @src_vec_undef(
; CHECK-NEXT:    [[TMP3:%.*]] = xor <2 x i32> [[TMP1:%.*]], [[TMP0:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = xor <2 x i32> [[TMP3]], <i32 -1, i32 -1>
; CHECK-NEXT:    ret <2 x i32> [[TMP4]]
;
  %3 = and <2 x i32> %1, %0
  %4 = or  <2 x i32> %1, %0
  %5 = xor <2 x i32> %4, <i32 -1, i32 undef>
  %6 = add <2 x i32> %3, %5
  ret <2 x i32> %6
}

; (x & y) + ~(y | x)
define i32 @src2(i32 %0, i32 %1) {
; CHECK-LABEL: @src2(
; CHECK-NEXT:    [[TMP3:%.*]] = xor i32 [[TMP1:%.*]], [[TMP0:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = xor i32 [[TMP3]], -1
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %3 = and i32 %1, %0
  %4 = or i32 %0, %1
  %5 = xor i32 %4, -1
  %6 = add i32 %3, %5
  ret i32 %6
}

; (x & y) + (~x & ~y)
define i32 @src3(i32 %0, i32 %1) {
; CHECK-LABEL: @src3(
; CHECK-NEXT:    [[TMP3:%.*]] = xor i32 [[TMP1:%.*]], [[TMP0:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = xor i32 [[TMP3]], -1
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %3 = and i32 %1, %0
  %4 = xor i32 %0, -1
  %5 = xor i32 %1, -1
  %6 = and i32 %4, %5
  %7 = add i32 %3, %6
  ret i32 %7
}

; ~(x | y) + (y & x)
define i32 @src4(i32 %0, i32 %1) {
; CHECK-LABEL: @src4(
; CHECK-NEXT:    [[TMP3:%.*]] = xor i32 [[TMP0:%.*]], [[TMP1:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = xor i32 [[TMP3]], -1
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %3 = and i32 %0, %1
  %4 = or i32 %1, %0
  %5 = xor i32 %4, -1
  %6 = add i32 %3, %5
  ret i32 %6
}

; ~(x | y) + (x & y)
define i32 @src5(i32 %0, i32 %1) {
; CHECK-LABEL: @src5(
; CHECK-NEXT:    [[TMP3:%.*]] = xor i32 [[TMP1:%.*]], [[TMP0:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = xor i32 [[TMP3]], -1
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %3 = or i32 %1, %0
  %4 = xor i32 %3, -1
  %5 = and i32 %1, %0
  %6 = add i32 %4, %5
  ret i32 %6
}

; (a & b) + ~(c | d)
define i32 @src6(i32 %0, i32 %1, i32 %2, i32 %3) {
; CHECK-LABEL: @src6(
; CHECK-NEXT:    [[TMP5:%.*]] = and i32 [[TMP0:%.*]], [[TMP1:%.*]]
; CHECK-NEXT:    [[TMP6:%.*]] = or i32 [[TMP2:%.*]], [[TMP3:%.*]]
; CHECK-NEXT:    [[TMP7:%.*]] = xor i32 [[TMP6]], -1
; CHECK-NEXT:    [[TMP8:%.*]] = add i32 [[TMP5]], [[TMP7]]
; CHECK-NEXT:    ret i32 [[TMP8]]
;
  %5 = and i32 %0, %1
  %6 = or i32 %2, %3
  %7 = xor i32 %6, -1
  %8 = add i32 %5, %7
  ret i32 %8
}