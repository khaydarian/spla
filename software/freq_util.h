// vi: ts=2:sw=2:sts=2:et

#ifndef FREQ_UTIL_H
#define FREQ_UTIL_H

#include "status.h"

status parse_frequency(const char* frequency_str, bool* div5, int* divisor)
    __attribute__((warn_unused_result));

#endif
