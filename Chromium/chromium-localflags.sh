export _flags=(
    'custom_toolchain="//build/toolchain/linux/unbundle:default"'
    'host_toolchain="//build/toolchain/linux/unbundle:default"'
    'is_official_build=false'
    'symbol_level=0'
    'treat_warnings_as_errors=false'
    'fatal_linker_warnings=false'
    'disable_fieldtrial_testing_config=true'
    'blink_enable_generated_code_formatting=false'
    'ffmpeg_branding="Chrome"'
    'proprietary_codecs=true'
    'rtc_use_pipewire=true'
    'link_pulseaudio=true'
    'use_custom_libcxx=true'
    'use_sysroot=false'
    'use_system_libffi=true'
    'enable_hangout_services_extension=true'
    'enable_widevine=true'
    'use_qt5=false'
    'use_qt6=true'
    'moc_qt6_path="/opt/qt-6.11.1/libexec"'
    "google_api_key=\"$_google_api_key\""
    'use_clang_modules=false'
    'icu_use_data_file=false'
    'chrome_pgo_phase=0'
    'use_thin_lto=false'
  )

echo ${_flags[@]}
#
## needs profiler support in rustc
if (( _local_rust )); then
   # 'rust_use_custom_libcxx = false'
   _clang_version=$(clang --version | grep -m1 version | sed 's/.* \([0-9]\+\).*/\1/')
   _rust_path=$(rustc --print sysroot)
   flags+=(
   "rust_sysroot_absolute=\"${_rust_path}\""
   "rustc_version=\"$(rustc --version | awk '{ print $2 ;}')\""
   'clang_base_path="/usr"'
   'clang_use_chrome_plugins=false'
   "clang_version=\"$_clang_version\""
   )
fi

## Facilitate deterministic builds (taken from build/config/compiler/BUILD.gn)
# CFLAGS+='   -Wno-builtin-macro-redefined'
# CXXFLAGS+=' -Wno-builtin-macro-redefined'
# CPPFLAGS+=' -D__DATE__=  -D__TIME__=  -D__TIMESTAMP__='

## Do not warn about unknown warning options
# CFLAGS+='   -Wno-unknown-warning-option'
# CXXFLAGS+=' -Wno-unknown-warning-option'

## Let Chromium set its own symbol level
# CFLAGS=${CFLAGS/-g }
# CXXFLAGS=${CXXFLAGS/-g }

## https://github.com/ungoogled-software/ungoogled-chromium-archlinux/issues/123
# CFLAGS=${CFLAGS/-fexceptions}
# CFLAGS=${CFLAGS/-fcf-protection}
# CXXFLAGS=${CXXFLAGS/-fexceptions}
# CXXFLAGS=${CXXFLAGS/-fcf-protection}

# This appears to cause random segfaults when combined with ThinLTO
## https://bugs.archlinux.org/task/73518
# CFLAGS=${CFLAGS/-fstack-clash-protection}
# CXXFLAGS=${CXXFLAGS/-fstack-clash-protection}

## https://crbug.com/957519#c122
# CXXFLAGS=${CXXFLAGS/-Wp,-D_GLIBCXX_ASSERTIONS}

echo $CFLAGS $CPPFLAGS $CXXFLAGS

