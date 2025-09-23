## Chapter 13 - Xorg
```
glib2-pass1 gobject-introspection glib2 shared-mime-info desktop-file-utils
pixman polkit util-macros xorgproto libXau libXdmcp xcb-proto libxcb fontconfig
(xorg-lib.sh) 
libxcvt xcb-util xcb-util-image xcb-util-keysyms xcb-util-renderutil
xcb-util-wm xcb-util-cursor libdrm
cairo-pass1 graphene graphite2-pass1 harfbuzz freetype2 graphite2
wayland wayland-protocols spirv-headers spirv-tools spirv-llvm-translator
libclc Vulkan-Headers Vulkan-Loader glslang libva-pass1 libvdpau intel-vaapi-driver
mesa libva xbitmaps libvpx
(xorg-app.sh) luit xcursor-themes 
(xorg-font.sh)
libxkbcommon xkeyboard-config libepoxy xwayland xorg-server
mtdev libevdev libinput xf86-input-evdev xf86-input-libinput xf86-input-synaptics xf86-input-wacom
twm xterm xclock xinit
gmmlib intel-media-driver
cantarell-fonts dejavu-fonts-ttf
xdg-utils xdg-user-dirs glu freeglut
(xorg-legacy-font.sh)
bdftopcf font-adobe-100dpi font-adobe-75dpi font-jis-misc font-daewoo-misc font-isas-misc font-misc-misc
```
> Testing Xorg <br>
* `echo 4 > /proc/sys/kernel/sysrq`
> Alt+SysRq+R to reset the keyboard mode.
* Test Run: `startx`
* Log File to Check: `less /var/log/Xorg.0.log`
