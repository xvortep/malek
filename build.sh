#!/bin/bash

TO_RUN=$1

WITH_X=1

# Dependencies...
if [ $TO_RUN = 1 ]
then
	if [ $WITH_X = 1 ]
	then
		sudo apt install libx11-dev \
			libx11-xcb-dev \
			libxext-dev \
			libxfixes-dev \
			libxi-dev \
			libxrender-dev \
			libxcb1-dev \
			libxcb-glx0-dev libxcb-keysyms1-dev \
			libxcb-image0-dev \
			libxcb-shm0-dev \
			libxcb-icccm4-dev \
			libxcb-sync0-dev \
			libxcb-xfixes0-dev \
			libxcb-shape0-dev \
			libxcb-randr0-dev \
			libxcb-render-util0-dev \
			libxcb-xinerama0-dev \
			libxkbcommon-dev \
			libxkbcommon-x11-dev
	fi
	sudo apt install libdirectfb-dev
fi

# Qt5...
if [ $TO_RUN = 2 ]
then
	git clone https://code.qt.io/qt/qt5.git
	pushd qt5/
	git checkout 5.15
	perl init-repository --module-subset=qtbase
	popd
fi

# Our platform...
if [ $TO_RUN = 3 ]
then
	unzip mini2d.zip
	mv mini2d qt5/qtbase/src/plugins/platforms
	ls qt5/qtbase/src/plugins/platforms
fi

# Configure Qt...
if [ $TO_RUN = 4 ]
then
	mkdir build/
	pushd build/
	#../qt5/configure -help
	#../qt5/configure -list-features
	FLAGS="-qpa mini2d,directfb,minimal"
	if [ $WITH_X = 1 ]
	then
		FLAGS="$FLAGS,xcb" # Additional QPA
		FLAGS="$FLAGS -xcb" #TODO 
	fi
	../qt5/configure \
		-developer-build \
		-opensource \
		-confirm-license \
		-Dregister= \
		-directfb \
		-nomake tests \
		-no-opengl \
		-no-dbus \
		-no-feature-cups \
		-no-linuxfb \
		$FLAGS
	popd
fi
	
#gui
#network
#sql
#xml
#testlib
#dbus
#concurrent
#widgets
#harfbuzz
#system
#commandlineparser
#regularexpression
#angle
#jpeg
#png
#freetype
#vkgen
#opengl
#printer
#private_tests
#https://forum.qt.io/topic/70299/reduce-qt-libraries-size/4
#./configure -v -device arm-none-linux-gnueabi -device-option CROSS_COMPILE=$CROSS_COMPILE -release -confirm-license -opensource -nomake examples -qt-zlib -no-pch -no-largefile -no-c++11 -no-cups -lrt  -linuxfb -no-xcb -no-sse2 -no-sse3 -no-ssse3 -no-sse4.1 -no-sse4.2 -no-accessibility -no-openssl -no-gtkstyle -xplatform devices/arm-none-linux-gnueabi --prefix=/opt/HH/CodeSourceryArm2009q1203/arm-none-linux-gnueabi/libc/usr -no-qml-debug -no-avx -no-avx2 -no-mips_dsp -no-mips_dspr2 -no-mtdev -no-libproxy -no-xkbcommon-evdev -no-xinput2 -no-xcb-xlib -no-nis -no-iconv -no-evdev -no-tslib -no-icu -no-fontconfig -no-dbus -no-use-gold-linker -no-separate-debug-info -no-directfb -no-kms -no-gcc-sysroot -no-libinput -nomake tests -gstreamer 1.0 -force-pkg-config -no-audio-backend -no-freetype -no-harfbuzz -no-qpa

# Build Qt...
if [ $TO_RUN = 5 ]
then
	pushd build/
	time make -j8
	popd
fi

# Set up and test examples...
if [ $TO_RUN = 6 ]
then
	pushd build/
	EXAMPLE="qtbase/examples/widgets/widgets/calculator/calculator -platform"
	export QT_DEBUG_BACKINGSTORE=1
	export QT_QPA_PLATFORMTHEME=gtk3
	export QT_DMINI2D_BLITTER_DEBUGPAINT=1
	sudo $EXAMPLE directfb --dfb:system=FBDev
	popd
fi

exit 0

# Run...
# With DirectFB
sudo $EXAMPLE -platform mini2d &
# Ctrl+Alt+F2
sudo kill $!

#-platform linuxfb -plugin EvdevMouse -plugin EvdevKeyboard #-style motif

popd
