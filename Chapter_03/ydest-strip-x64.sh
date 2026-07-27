#!/bin/sh

if [[ -z $DESTDIR ]]; then
	echo "Warning: DESTDIR not set!"
	exit 1;
fi

if [[ -x ${YBLD}/ystrip-static ]]; then
	YSTRIP="${YBLD}/ystrip-static"
elif [[ -x "${YBLD}/ystrip" ]]; then
	YSTRIP="${YBLD}/ystrip"
else
	echo "ystrip binary missing"
	exit 1
fi

echo "* Preparing ${DESTDIR} Image *"
YLOG="${YBLD}/log/${PKGDIR}"

du -shBK ${DESTDIR} > ${YLOG}/before-strip.txt

echo "* Removing the execution bit on Libtool Archive files *"
find ${DESTDIR} -name "*.la" -exec chmod -v -x {} \;

if [[ -d "${DESTDIR}/etc" ]]; then
	echo "* Merging ${DESTDIR}/etc"
	cp -av ${DESTDIR}/etc/* /etc
else
	echo "* No /etc *"
fi

if [[ -d "${DESTDIR}/var" ]]; then
	echo "* Merging ${DESTDIR}/var"
	cp -av ${DESTDIR}/var/* /var
else
	echo "* No /var *"
fi

if [[ -d "${DESTDIR}/usr" ]]; then
	echo "* Making Sure Merged-usr *"
	for dir in bin lib sbin; do
		[[ -d "${DESTDIR}/${dir}" ]] && mv -v "${DESTDIR}/${dir}" "${DESTDIR}/usr/${dir}"
	done

	echo "* Stripping ${DESTDIR}/usr"
	${YSTRIP} "${DESTDIR}/usr"

    echo "* Merging ${DESTDIR}/usr"
	cp -av --remove-destination ${DESTDIR}/usr/* /usr
else
	echo "* No /usr *"
fi

if [[ -d "${DESTDIR}/opt/qt6" ]]; then
	echo "* Stripping ${DESTDIR}/opt/qt6"
	${YSTRIP} "${DESTDIR}/opt/qt6"

    echo "* Merging ${DESTDIR}/opt/qt6"
    if [[ -L /opt/qt6 ]]; then
       cp -a --remove-destination ${DESTDIR}/opt/qt6/* /opt/$(readlink /opt/qt6)
	else
	   cp -a --remove-destination ${DESTDIR}/opt/qt6/* /opt/qt6
	fi
elif [[ -d "${DESTDIR}/opt/kf6" ]]; then
	echo "* Stripping ${DESTDIR}/opt/kf6"
	${YSTRIP} "${DESTDIR}/opt/kf6"

    echo "* Merging ${DESTDIR}/opt/kf6"
    if [[ -L /opt/kf6 ]]; then
	   cp -a ${DESTDIR}/opt/kf6/* /opt/$(readlink /opt/kf6)
	else
	   cp -a ${DESTDIR}/opt/kf6/* /opt/kf6
	fi
	[ -d ${DESTDIR}/opt/kf6/share/dbus-1 ] && cp -av ${DESTDIR}/opt/kf6/share/dbus-1/* $(readlink /opt/kf6/share/dbus-1)
	[ -d ${DESTDIR}/opt/kf6/share/polkit-1 ] && cp -av ${DESTDIR}/opt/kf6/share/polkit-1/* $(readlink /opt/kf6/share/polkit-1)
	[ -d ${DESTDIR}/opt/kf6/lib/systemd ] && cp -av ${DESTDIR}/opt/kf6/lib/systemd/* $(readlink /opt/kf6/lib/systemd)

elif [[ -d "${DESTDIR}/opt" ]]; then
	echo "* Stripping ${DESTDIR}/opt"
	${YSTRIP} "${DESTDIR}/opt"

    echo "* Merging ${DESTDIR}/opt"
	cp -a --remove-destination ${DESTDIR}/opt/* /opt
else
	echo "* No /opt *"
fi

du -shBK ${DESTDIR} > ${YLOG}/after-strip.txt

echo "* Done *"
