install -Dv out/Release/chrome "${DESTDIR}/usr/lib/chromium/chromium"
install -Dv out/Release/chromedriver.unstripped "${DESTDIR}/usr/bin/chromedriver"

install -Dvm4755 out/Release/chrome_sandbox "${DESTDIR}/usr/lib/chromium/chrome-sandbox"

install -Dvm644 chrome/installer/linux/common/desktop.template "${DESTDIR}/usr/share/applications/chromium.desktop"

install -Dvm644 chrome/app/resources/manpage.1.in "${DESTDIR}/usr/share/man/man1/chromium.1"

sed -i \
    -e 's/@@MENUNAME/Chromium/g' \
    -e 's/@@PACKAGE/chromium/g' \
    -e 's/@@usr_bin_symlink_name/chromium/g' \
    -e 's|@@uri_scheme|x-scheme-handler/chromium;|g' \
    -e 's/@@extra_desktop_entries//g' \
    "${DESTDIR}/usr/share/applications/chromium.desktop" \
    "${DESTDIR}/usr/share/man/man1/chromium.1"

export toplevel_files=(
    chrome_100_percent.pak
    chrome_200_percent.pak
    chrome_crashpad_handler
    libqt6_shim.so
    resources.pak
    v8_context_snapshot.bin
    libEGL.so
    libGLESv2.so
    libvk_swiftshader.so
    libvulkan.so.1
    vk_swiftshader_icd.json
  )

  if [[ -z ${_system_libs[icu]+set} ]]; then
    toplevel_files+=(icudtl.dat)
  fi

  cp -v "${toplevel_files[@]/#/out/Release/}" "${DESTDIR}/usr/lib/chromium/"
  install -Dvm644 -t "${DESTDIR}/usr/lib/chromium/locales" out/Release/locales/*.pak

  for size in 24 48 64 128 256; do
    install -Dvm644 "chrome/app/theme/chromium/product_logo_$size.png" \
      "${DESTDIR}/usr/share/icons/hicolor/${size}x${size}/apps/chromium.png"
  done

  for size in 16 32; do
    install -Dvm644 "chrome/app/theme/default_100_percent/chromium/product_logo_$size.png" \
      "${DESTDIR}/usr/share/icons/hicolor/${size}x${size}/apps/chromium.png"
  done
