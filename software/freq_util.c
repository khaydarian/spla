// vi: ts=2:sw=2:sts=2:noet

#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>

#include "freq_util.h"

static int divisor_to_frequency(bool div5, int divisor) {
	int initial_freq = div5 ? 6000000 : 30000000;
	return initial_freq / (1 + divisor);
}

// freq = base / (1 + divisor)
// 1 +  divisor = base / freq
// divisor = (base / freq) - 1

static double frequency_to_divisor(bool div5, int frequency_hz) {
	double base = div5 ? 6.0e6 : 30.0e6;
	return (base / (double)frequency_hz) - 1.0;
}

__attribute__((constructor))
static void selftest_divisors() {
	struct {
		bool div5;
		int divisor;
		int frequency_hz;
	} testcase[] = {
		{.div5 = false, .divisor = 0, .frequency_hz = 30000000},
		{.div5 = false, .divisor = 1, .frequency_hz = 15000000},
		{.div5 = false, .divisor = 2, .frequency_hz = 10000000},
		{.div5 = false, .divisor = 3, .frequency_hz =  7500000},
		{.div5 = false, .divisor = 4, .frequency_hz =  6000000},
		{.div5 = true, .divisor = 0, .frequency_hz = 6000000},
		{.div5 = true, .divisor = 1, .frequency_hz = 3000000},
		{.div5 = true, .divisor = 2, .frequency_hz = 2000000},
		{.div5 = true, .divisor = 3, .frequency_hz = 1500000},
		{.div5 = true, .divisor = 4, .frequency_hz = 1200000},
	};
	for (unsigned i = 0; i < sizeof(testcase) / sizeof(testcase[0]); i++) {
		bool div5 = testcase[i].div5;
		int divisor = testcase[i].divisor;
		int frequency_hz = testcase[i].frequency_hz;
		int actual_frequency_hz = divisor_to_frequency(div5, divisor);
		if (actual_frequency_hz != frequency_hz) {
			fprintf(stderr, "selftest_divisors.divisor_to_frequency[%d] "
					"(div%d, divisor %d): expected %d, actual %d\n",
					i, div5 ? 5 : 1, divisor, frequency_hz, actual_frequency_hz);
			abort();
		}
		int actual_divisor = frequency_to_divisor(div5, frequency_hz);
		if (actual_divisor != divisor) {
			fprintf(stderr, "selftest_divisors.frequency_to_divisor[%d] "
					"(div%d, frequency %d): expected %d, actual %d\n",
					i, div5 ? 5 : 1, frequency_hz, divisor, actual_divisor);
			abort();
		}
	}
}


int parse_frequency_string(const char* fstr) {
	int n = strlen(fstr);
	int mult = 1;
	if (fstr[n-2] == 'H' && fstr[n-1] == 'z') {
		n -= 2;
	}
	if (fstr[n-1] == 'M') {
		mult = 1000000;
		n--;
	} else if (fstr[n-1] == 'k') {
		mult = 1000;
		n--;
	}
	char* end;
	double freq = strtod(fstr, &end);
	if (end != fstr + n) {
		return 0;
	}
	return (int)floor(mult * freq);
}

__attribute__((constructor))
static void selftest_parse_frequency_string() {
	struct {
		const char* str;
		int expected;
	} testcase[] = {
		{"30000000", 30000000},
		{"30000k", 30000000},
		{"30M", 30000000},
		{"30MHz", 30000000},
		{"30.0", 30},
		{"30.0M", 30000000},
		{"30.0MHz", 30000000},
		{"30e6", 30000000},
		{"30.0e6", 30000000},
		{"2.5k", 2500},
		{"2.5", 2},
		{"asdf", 0},
		{"0", 0},
	};
	for (unsigned i = 0; i < sizeof(testcase) / sizeof(testcase[0]); i++) {
		int val = parse_frequency_string(testcase[i].str);
		if (val != testcase[i].expected) {
			fprintf(stderr, "selftest_parse_frequency_string[%d]: "
					"\"%s\": expected %d, actual %d\n",
					i, testcase[i].str, testcase[i].expected, val);
			abort();
		}
	}
}

bool parse_frequency(const char* frequency_str, bool* div5, int* divisor) {
	int frequency_hz = parse_frequency_string(frequency_str);
	if (!frequency_hz) {
		fprintf(stderr, "Invalid frequency '%s'.\n", frequency_str);
		return false;
	}
	float ideal_divisor_div1 = frequency_to_divisor(false, frequency_hz);
	if (frequency_hz == divisor_to_frequency(false, floor(ideal_divisor_div1))) {
		*div5 = false;
		*divisor = floor(ideal_divisor_div1);
		return true;
	}
	float ideal_divisor_div5 = frequency_to_divisor(true, frequency_hz);
	if (frequency_hz == divisor_to_frequency(false, floor(ideal_divisor_div5))) {
		*div5 = false;
		*divisor = floor(ideal_divisor_div5);
		return true;
	}
	fprintf(stderr, "Invalid frequency %dHz.\n", frequency_hz);
	// TODO: Show nearby frequencies
	return false;
}
