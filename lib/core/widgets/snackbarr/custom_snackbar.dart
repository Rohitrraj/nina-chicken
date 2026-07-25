import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/constant/enum.dart';
import 'package:kedai_ayam_nina/core/widgets/feedback/app_snackbar.dart';

/// Compatibility wrapper.
///
/// Call site lama yang menggunakan CustomSnackbar tetap berjalan,
/// tetapi tampilan snackbar sekarang mengikuti komponen feedback baru.
class CustomSnackbar extends SnackBar {
  CustomSnackbar({
    super.key,
    required String message,
    required SnackBarState state,
  }) : super(
         backgroundColor: Colors.transparent,
         elevation: 0,
         behavior: SnackBarBehavior.floating,
         padding: EdgeInsets.zero,
         margin: const EdgeInsets.all(16),
         dismissDirection: DismissDirection.horizontal,
         content: AppSnackbarContent(
           message: message,
           type: _mapSnackbarType(state),
         ),
       );
}

AppSnackbarType _mapSnackbarType(SnackBarState state) {
  switch (state) {
    case SnackBarState.success:
      return AppSnackbarType.success;

    case SnackBarState.error:
      return AppSnackbarType.error;

    case SnackBarState.info:
      return AppSnackbarType.info;
  }
}
