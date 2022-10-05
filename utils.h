
#ifndef UTILS_H
#define UTILS_H

#include <QtCore/qdebug.h>

#define DEBUG(var) do{ qDebug() << #var << " = " << var; }while(false)
#define TRACE() do{ qDebug() << __PRETTY_FUNCTION__; }while(false)

#endif // UTILS_H
