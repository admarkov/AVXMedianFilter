#ifndef IMAGE_H
#define IMAGE_H

#include <QString>
#include <QLabel>
#include <QPointer>
#include <QImage>

#include <iostream>
#include <functional>

#include "filter.h"

using RenderedImagePtr = QSharedPointer<QLabel>;

class Image
{
public:
    Image(const QString& path)
    {
        QSharedPointer<QImage> img;
        img.reset(new QImage(path, "bmp"));
        width = img->width();
        height = img->height();
        for (int clr = 0; clr < 3; clr++) {
            pixmap[clr] = new uchar[getSize()];
            for (int i = 0; i < getSize(); i++) {
                pixmap[clr][i] = img->bits()[4 * i + 2 - clr];
            }
        }
    }

    ~Image() {
        for (int i = 0; i < 3; i++) {
            delete[] pixmap[i];
        }
    }

    int getWidth() {
        return width;
    }

    int getHeight() {
        return height;
    }

    int getSize() {
        return width * height;
    }

    RenderedImagePtr render(int x, int y, QWidget* parent) {
        QImage img(QSize(width, height), QImage::Format_RGB888);
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                img.setPixel(j, i, qRgb(pixmap[0][i * width + j], pixmap[1][i * width + j], pixmap[2][i * width + j]));
            }
        }
        RenderedImagePtr label;
        label.reset(new QLabel(parent));
        label->setPixmap(QPixmap::fromImage(img));
        label->setGeometry(x, y, width, height);
        label->show();
        return label;
    }

    uint32_t ApplyFilter(Filter* filter) {
        auto start = clock();
        for (int clr = 0; clr < 3; clr++) {
            for (int i = 0; i <= height - filter->getKernelSize(); i++) {
                for (int j = 0; j <= width - filter->getKernelSize(); j++) {
                    pixmap[clr][i * width + j] = filter->Apply(&pixmap[clr][i * width + j], width);
                }
            }
        }
        return clock() - start;
    }

private:
    uchar* pixmap[3];
    int width;
    int height;
};

using ImagePtr = QSharedPointer<Image>;

#endif // IMAGE_H
