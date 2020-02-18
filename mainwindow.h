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

    RenderedImagePtr img1;

public slots:
    void openPicture();

private:
    Ui::MainWindow *ui;
};
#endif // MAINWINDOW_H
