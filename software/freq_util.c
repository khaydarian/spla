// vi: ts=2:sw=2:sts=2:et

#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "freq_util.h"

static int divisor_to_frequency(bool div5, int divisor) {
  assert(divisor >= 0);
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

__attribute__((constructor)) static void selftest_divisors() {
  struct {
    bool div5;
    int divisor;
    int frequency_hz;
  } testcase[] = {
      {.div5 = false, .divisor = 0, .frequency_hz = 30000000},
      {.div5 = false, .divisor = 1, .frequency_hz = 15000000},
      {.div5 = false, .divisor = 2, .frequency_hz = 10000000},
      {.div5 = false, .divisor = 3, .frequency_hz = 7500000},
      {.div5 = false, .divisor = 4, .frequency_hz = 6000000},
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
      fprintf(stderr,
              "selftest_divisors.divisor_to_frequency[%d] "
              "(div%d, divisor %d): expected %d, actual %d\n",
              i, div5 ? 5 : 1, divisor, frequency_hz, actual_frequency_hz);
      abort();
    }
    int actual_divisor = frequency_to_divisor(div5, frequency_hz);
    if (actual_divisor != divisor) {
      fprintf(stderr,
              "selftest_divisors.frequency_to_divisor[%d] "
              "(div%d, frequency %d): expected %d, actual %d\n",
              i, div5 ? 5 : 1, frequency_hz, divisor, actual_divisor);
      abort();
    }
  }
}

status parse_frequency_string(const char* fstr, int* out) {
  int n = strlen(fstr);
  int mult = 1;
  if (fstr[n - 2] == 'H' && fstr[n - 1] == 'z') {
    n -= 2;
  }
  if (fstr[n - 1] == 'M') {
    mult = 1000000;
    n--;
  } else if (fstr[n - 1] == 'k') {
    mult = 1000;
    n--;
  }
  char* end;
  double freq = strtod(fstr, &end);
  if (end != fstr + n) {
    return errorf("Unparseable frequency: '%s'", fstr);
  }
  *out = (int)floor(mult * freq);
  return OK;
}

__attribute__((constructor)) static void selftest_parse_frequency_string() {
  struct {
    const char* str;
    bool ok;
    int expected;
  } testcase[] = {
      {"30000000", true, 30000000},
      {"30000k", true, 30000000},
      {"30M", true, 30000000},
      {"30MHz", true, 30000000},
      {"15M", true, 15000000},
      {"15MHz", true, 15000000},
      {"12M", true, 12000000},
      {"12MHz", true, 12000000},
      {"9M", true, 9000000},
      {"9MHz", true, 9000000},
      {"6M", true, 6000000},
      {"6MHz", true, 6000000},
      {"1M", true, 1000000},
      {"1MHz", true, 1000000},
      {"30.0", true, 30},
      {"30.0M", true, 30000000},
      {"30.0MHz", true, 30000000},
      {"30e6", true, 30000000},
      {"30.0e6", true, 30000000},
      {"2.5k", true, 2500},
      {"2.5", true, 2},
      {"asdf", false, 0},
      {"0", true, 0},
  };
  for (unsigned i = 0; i < sizeof(testcase) / sizeof(testcase[0]); i++) {
    int val = -1;
    status err = parse_frequency_string(testcase[i].str, &val);
    if (is_error(err)) {
      if (testcase[i].ok) {
        fprintf(stderr,
                "selftest_parse_frequency_string[%d]: "
                "\"%s\": unexpected error: %s.\n",
                i, testcase[i].str, err->message);
        status_free(err);
        abort();
      }
      status_free(err);
    } else if (!testcase[i].ok) {
      fprintf(stderr,
              "selftest_parse_frequency_string[%d]: "
              "\"%s\": no error when expected.\n",
              i, testcase[i].str);
      abort();
    } else if (val != testcase[i].expected) {
      fprintf(stderr,
              "selftest_parse_frequency_string[%d]: "
              "\"%s\": expected %d, actual %d\n",
              i, testcase[i].str, testcase[i].expected, val);
      abort();
    }
  }
}

status parse_frequency(const char* frequency_str, bool* div5, int* divisor) {
  int frequency_hz;
  RETURN_IF_ERROR(parse_frequency_string(frequency_str, &frequency_hz));

  float ideal_divisor_div1 = frequency_to_divisor(false, frequency_hz);
  if (ideal_divisor_div1 >= 0 &&
      frequency_hz == divisor_to_frequency(false, floor(ideal_divisor_div1))) {
    *div5 = false;
    *divisor = floor(ideal_divisor_div1);
    return OK;
  }
  float ideal_divisor_div5 = frequency_to_divisor(true, frequency_hz);
  if (ideal_divisor_div5 >= 0 &&
      frequency_hz == divisor_to_frequency(false, floor(ideal_divisor_div5))) {
    *div5 = false;
    *divisor = floor(ideal_divisor_div5);
    return OK;
  }
  // TODO: Show nearby frequencies in error message
  return errorf("Invalid frequency %dHz.\n", frequency_hz);
}
