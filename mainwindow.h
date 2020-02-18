#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QPointer>

#include "image.h"

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

public:
    QSharedPointer<QMenuBar>    menuBar;
    QSharedPointer<QMenu>       fileMenu;
    QSharedPointer<QAction>     fileMenu_open;
    QSharedPointer<QAction>     fileMenu_filter;

    ImagePtr         img;
    RenderedImagePtr img1;
    RenderedImagePtr img2;

public slots:
    void openPicture();
    void filterPicture();

private:
    Ui::MainWindow *ui;
};
#endif // MAINWINDOW_H
