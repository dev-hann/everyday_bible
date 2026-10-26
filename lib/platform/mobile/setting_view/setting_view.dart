import 'dart:async';

import 'package:everydaybible/model/setting.dart';
import 'package:everydaybible/platform/mobile/setting_view/bloc/setting_bloc.dart';
import 'package:everydaybible/platform/mobile/setting_view/bloc/update_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';

/// Settings screen: dark mode toggle, text size factor selection, and the
/// version / in-app update section.
class SettingView extends StatefulWidget {
  /// Creates the settings screen.
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView>
    with AutomaticKeepAliveClientMixin {
  SettingBloc get bloc => BlocProvider.of(context);

  UpdateBloc get updateBloc => BlocProvider.of(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        updateBloc.add(const UpdateEventInited());
      }
    });
  }

  Widget themeWidget({
    required ThemeMode themeMode,
    required void Function(ThemeMode themeMode) onChanged,
  }) {
    return FSwitch(
      label: const Text('Theme'),
      description: const Text('Dark / Light'),
      value: themeMode == ThemeMode.light,
      onChange: (value) {
        onChanged(value ? ThemeMode.light : ThemeMode.dark);
      },
    );
  }

  Widget textFactorWidget({
    required TextScaleFactor scaleFactor,
    required void Function(TextScaleFactor factor) onChanged,
  }) {
    return FSelect<TextScaleFactor>(
      control: FSelectControl.lifted(
        value: scaleFactor,
        onChange: (factor) {
          if (factor != null) {
            onChanged(factor);
          }
        },
      ),
      hint: 'TextFactor',
      items: {
        for (final factor in TextScaleFactor.values) factor.name: factor,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        final setting = state.setting;
        return FScaffold(
          header: const FHeader(title: Text('Setting')),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              themeWidget(
                themeMode: setting.themeMode,
                onChanged: (brightness) {
                  bloc.add(
                    SettingEventUpdatedSetting(
                      setting.copyWith(themeMode: brightness),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              textFactorWidget(
                scaleFactor: setting.textScaleFactor,
                onChanged: (factor) {
                  bloc.add(
                    SettingEventUpdatedSetting(
                      setting.copyWith(textScaleFactor: factor),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              versionWidget(),
            ],
          ),
        );
      },
    );
  }

  /// Version section: shows the installed version, the latest release
  /// status, and the download / install controls.
  Widget versionWidget() {
    return BlocBuilder<UpdateBloc, UpdateState>(
      builder: (context, state) {
        return FTile(
          title: const Text('버전'),
          subtitle: Text(versionSubtitle(state)),
          suffix: versionSuffix(state),
        );
      },
    );
  }

  /// Status line under the version number.
  String versionSubtitle(UpdateState state) {
    final base = 'v${state.currentVersion ?? '...'}';
    switch (state.status) {
      case UpdateViewStatus.idle:
        return base;
      case UpdateViewStatus.checking:
        return '$base · 확인 중…';
      case UpdateViewStatus.upToDate:
        return '$base · 최신 버전';
      case UpdateViewStatus.available:
        final newVersion = state.release?.version;
        if (newVersion == null || newVersion.isEmpty) {
          return base;
        }
        return '$base · v$newVersion 사용 가능';
      case UpdateViewStatus.downloading:
        final progress = state.progress;
        if (progress == null || progress.isUnknownSize) {
          return '$base · 다운로드 중…';
        }
        return '$base · 다운로드 ${progress.percent}%';
      case UpdateViewStatus.downloadFailure:
        return '$base · 다운로드 실패';
      case UpdateViewStatus.readyToInstall:
        return '$base · 다운로드 완료';
      case UpdateViewStatus.installPermissionRequired:
        return '$base · 설치 권한 필요';
      case UpdateViewStatus.failure:
        return '$base · 확인 실패';
    }
  }

  /// Trailing action for the current update phase; null when idle or
  /// up-to-date.
  Widget? versionSuffix(UpdateState state) {
    switch (state.status) {
      case UpdateViewStatus.checking:
        return const SizedBox(
          width: 18,
          height: 18,
          child: FCircularProgress(size: FCircularProgressSizeVariant.sm),
        );
      case UpdateViewStatus.available:
        return FButton(
          size: FButtonSizeVariant.sm,
          mainAxisSize: MainAxisSize.min,
          onPress: () => onUpdateTap(state),
          child: const Text('업데이트'),
        );
      case UpdateViewStatus.downloading:
        return FButton(
          variant: FButtonVariant.secondary,
          size: FButtonSizeVariant.sm,
          mainAxisSize: MainAxisSize.min,
          onPress: () => updateBloc.add(const UpdateEventDownloadCanceled()),
          child: const Text('취소'),
        );
      case UpdateViewStatus.downloadFailure:
        return FButton(
          variant: FButtonVariant.secondary,
          size: FButtonSizeVariant.sm,
          mainAxisSize: MainAxisSize.min,
          onPress: () => updateBloc.add(const UpdateEventDownloadRetried()),
          child: const Text('다시'),
        );
      case UpdateViewStatus.readyToInstall:
        return FButton(
          size: FButtonSizeVariant.sm,
          mainAxisSize: MainAxisSize.min,
          onPress: () => updateBloc.add(const UpdateEventInstallTapped()),
          child: const Text('설치'),
        );
      case UpdateViewStatus.installPermissionRequired:
        return FButton(
          size: FButtonSizeVariant.sm,
          mainAxisSize: MainAxisSize.min,
          onPress: () => updateBloc.add(
            const UpdateEventPermissionSettingsTapped(),
          ),
          child: const Text('설정 열기'),
        );
      case UpdateViewStatus.failure:
        return FButton(
          variant: FButtonVariant.secondary,
          size: FButtonSizeVariant.sm,
          mainAxisSize: MainAxisSize.min,
          onPress: () => updateBloc.add(const UpdateEventRetryTapped()),
          child: const Text('다시'),
        );
      case UpdateViewStatus.idle:
      case UpdateViewStatus.upToDate:
        return null;
    }
  }

  /// Starts the in-app download when the release ships an APK; otherwise
  /// opens the release page in the browser.
  void onUpdateTap(UpdateState state) {
    final release = state.release;
    if (release == null) {
      return;
    }
    final downloadUrl = release.downloadUrl;
    if (downloadUrl != null) {
      updateBloc.add(const UpdateEventDownloadTapped());
    } else {
      unawaited(openReleasePage(release.htmlUrl));
    }
  }

  Future<void> openReleasePage(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } on PlatformException {
      // The release page could not be opened; leave the banner unchanged.
    }
  }

  @override
  bool get wantKeepAlive => true;
}
