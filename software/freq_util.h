// vi: ts=2:sw=2:sts=2:noet

#ifndef FREQ_UTIL_H
#define FREQ_UTIL_H

#include <stdbool.h>

bool parse_frequency(const char* frequency_str, bool* div5, int* divisor);

#endif
