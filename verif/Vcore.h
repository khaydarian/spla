#ifndef VCORE_H
#define VCORE_H

#include "verilated.h"
#include "verilated_vcd_c.h"

template <class V>
class Vcore : public V {
private:
	VerilatedVcdC* trace_ = nullptr;
	uint64_t cycle_ = 0;

public:
	~Vcore() {
		trace_off();
	}

	void trace_on(const char* outfile) {
		Verilated::traceEverOn(true);
		trace_ = new VerilatedVcdC();
		this->trace(trace_, 0);
		trace_->open(outfile);
		this->eval();
		trace_dump(0);
	}

	void trace_off() {
		if (!trace_) return;
		trace_->close();
		delete trace_;
	}

	void trace_dump(int edge_offset) {
		if (!trace_) return;
		trace_->dump(cycle_ * 10 + edge_offset);
		if (edge_offset > 0) {
			trace_->flush();
		}
	}

	void delay(unsigned n) {
		for (unsigned i = 0; i < n; i++)
			tick();
	}

	void tick(unsigned n = 1) {
		// Evaluate for inputs
		// (technically not always required, but safer)
		this->eval();
		trace_dump(8);

		for (unsigned i = 0; i < n; i++) {
			cycle_++;
			// Evaluate rising edge of clock
			this->clock = 1;
			this->eval();
			trace_dump(0);
			// Evaluate falling edge of clock
			this->clock = 0;
			this->eval();
			trace_dump(5);
		}
	}
};

#endif
