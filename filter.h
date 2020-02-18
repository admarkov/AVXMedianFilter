#ifndef FILTER_H
#define FILTER_H

#include <functional>

#include <QTypeInfo>

using KernelFunction = std::function<uchar(uchar* data, int width)>;

class Filter {
public:
    Filter(int _kernelSize = 1)
        : kernelSize(_kernelSize)
    {

    }

    ~Filter() = default;

    int getKernelSize() const {
        return kernelSize;
    }

    virtual uchar Apply(uchar* data, int width) const {
        Q_UNUSED(width);
        return *data;
    }

protected:
    int kernelSize;
};

#endif // FILTER_H
