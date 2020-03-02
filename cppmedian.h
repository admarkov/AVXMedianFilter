#ifndef CPPMEDIANFILTER_H
#define CPPMEDIANFILTER_H

#include "filter.h"

#include <vector>
#include <algorithm>

using std::vector;
using std::sort;

class CppMedianFilter : public Filter {
public:
    CppMedianFilter()
        : Filter(5)
    {

    }

    ~CppMedianFilter() = default;

    uchar Apply(uchar* data, int width) const override {
        vector<uchar> v;
        for (int i = 0; i < kernelSize; i++) {
            for (int j = 0; j < kernelSize; j++) {
                v.push_back(*(data + i * width + j));
            }
        }
        sort(begin(v), end(v));
        return v[kernelSize * kernelSize / 2];
    }

};

#endif // CPPMEDIANFILTER_H
