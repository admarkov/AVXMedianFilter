#ifndef AVXMEDIANFILTER_H
#define AVXMEDIANFILTER_H

#include "filter.h"
#include "kernel.h"

class AvxMedianFilter : public Filter {
public:
    AvxMedianFilter()
        : Filter(5)
    {

    }

    ~AvxMedianFilter() = default;

    uchar Apply(uchar* data, int width) const override {
        return _kernel(data, width);
    }

};

#endif // AVXMEDIANFILTER_H
