TEMPLATE = subdirs
QT_FOR_CONFIG += gui-private

!wasm:!android: SUBDIRS += minimal

qtConfig(xcb) {
    SUBDIRS += xcb
}

qtConfig(directfb) {
    SUBDIRS += directfb
}
