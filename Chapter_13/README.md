## Chapter 13 - Xorg

This chapter builds the Xorg stack and related input/output libraries needed for a working graphical environment.  
Packages are grouped by category but installation order is preserved.  

---

### Core GNOME/GLib Utilities
- `glib2-pass1` – Core GLib library (bootstrap).  
- `gobject-introspection` – Runtime introspection of GObject libraries.  
- `glib2` – GLib final build.  
- `shared-mime-info` – MIME type database.  
- `desktop-file-utils` – Manage `.desktop` entries.  

---

### Core Xorg & Fonts
- `pixman` – Pixel manipulation library.  
- `polkit` – PolicyKit authorization framework.  
- `util-macros` – Autotools macros for Xorg.  
- `xorgproto` – X11 protocol headers.  
- `libXau` – X authorization.  
- `libXdmcp` – Display manager connection protocol.  
- `xcb-proto` – Protocol descriptions for XCB.  
- `libxcb` – Core XCB library.  
- `fontconfig` – Font discovery and configuration.  
- *(script: `xorg-lib.sh` – builds Xorg core libs batch)*  

---

### XCB Utilities & DRM
- `libxcvt` – VESA CVT modeline generator.  
- `xcb-util` – Helper utilities for XCB.  
- `xcb-util-image` – XCB image extension.  
- `xcb-util-keysyms` – Key symbol library.  
- `xcb-util-renderutil` – Render helper functions.  
- `xcb-util-wm` – Window manager utilities.  
- `xcb-util-cursor` – Cursor handling utilities.  
- `libdrm` – Direct Rendering Manager library.  

---

### Text, Fonts & Rendering
- `cairo-pass1` – Cairo bootstrap.  
- `graphene` – Vector math library.  
- `graphite2-pass1` – Graphite bootstrap.  
- `harfbuzz` – Text shaping engine.  
- `freetype2` – Font rasterizer.  
- `graphite2` – Smart font rendering.  

---

### Wayland & Vulkan
- `wayland` – Wayland display protocol.  
- `wayland-protocols` – Extra Wayland protocols.  
- `spirv-headers` – SPIR-V headers.  
- `spirv-tools` – SPIR-V tools.  
- `spirv-llvm-translator` – SPIR-V ↔ LLVM IR translator.  
- `libclc` – OpenCL library.  
- `vulkan-headers` – Vulkan API headers.  
- `vulkan-loader` – Vulkan runtime loader.  
- `glslang` – GLSL → SPIR-V compiler.  
- `libva-pass1` – Video Acceleration API bootstrap.  
- `libvdpau` – Video Decode and Presentation API.  
- `intel-vaapi-driver` – Intel VA-API driver.  
- `mesa` – OpenGL/Vulkan implementation.  
- `libva` – Final build of Video Acceleration API.  
- `xbitmaps` – Bitmap images for X.  
- `libvpx` – VP8/VP9 video codec.  

---

### Xorg Applications
- *(script: `xorg-app.sh` – builds Xorg applications batch)*  
- `luit` – Locale and UTF-8 terminal filter.  
- `xcursor-themes` – Cursor themes.  

---

### Xorg Fonts
- *(script: `xorg-font.sh` – builds font packages batch)*  
> `font-util, encodings, font-alias, font-adobe-utopia-type1, font-bh-ttf`  
> `font-bh-type1, font-ibm-type1, font-misc-ethiopic, font-xfree86-type1`  

---

### Input & Server
- `libxkbcommon` – Keyboard handling.  
- `xkeyboard-config` – X keyboard configuration.  
- `libepoxy` – GL dispatch library.  
- `xwayland` – Run X apps under Wayland.  
- `xorg-server` – X.Org display server.  
- `mtdev` – Multitouch event handling.  
- `libevdev` – Generic input event library.  
- `libinput` – Input device management.  
- `xf86-input-evdev` – Evdev input driver.  
- `xf86-input-libinput` – libinput driver.  
- `xf86-input-synaptics` – Synaptics touchpad driver.  
- `xf86-input-wacom` – Wacom tablet driver.  
- `twm` – Tab Window Manager.  
- `xterm` – Terminal emulator.  
- `xclock` – Simple clock.  
- `xinit` – Start X sessions.  

---

### Intel GPU Stack
- `gmmlib` – Intel Graphics Memory Management Library.  
- `intel-media-driver` – Intel GPU driver.  

---

### Fonts for Desktop
- `cantarell-fonts` – GNOME default fonts.  
- `dejavu-fonts-ttf` – DejaVu TrueType fonts.  

---

### XDG Desktop Integration
- `xdg-utils` – Desktop integration tools.  
- `xdg-user-dirs` – XDG user directories.  

---

### OpenGL Extras
- `glu` – OpenGL utility library.  
- `freeglut` – FreeGLUT implementation.  

---

### Legacy Fonts
- *(script: `xorg-legacy-font.sh` – builds legacy Xorg fonts)*  
> `bdftopcf, font-adobe-100dpi, font-adobe-75dpi, font-jis-misc`  
> `font-daewoo-misc, font-isas-misc, font-misc-misc`  

---

### Testing Xorg

Enable SysRq key support:  
```
echo 4 > /proc/sys/kernel/sysrq
startx
less /var/log/Xorg.0.log
```

---
✅ Finished a Working Xorg Session and New Limited User to Finish Installing in a Graphical Environment
