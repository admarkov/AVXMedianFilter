#include "mainwindow.h"
#include "ui_mainwindow.h"

#include "image.h"

#include <QFileDialog>
#include <QFile>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    int h = 800, w = 1400;
    setFixedSize(w, h);

    setWindowTitle("Медианный фильтр");

    menuBar.reset(new QMenuBar(this));
    menuBar->setGeometry(0, 0, w, 25);

    fileMenu.reset(new QMenu(menuBar.get()));
    fileMenu->setTitle("Файл");
    menuBar->addMenu(fileMenu.get());

    fileMenu_open.reset(new QAction(this));
    fileMenu_open->setText("Открыть");
    fileMenu->addAction(fileMenu_open.get());
    connect(fileMenu_open.get(), SIGNAL(triggered(bool)), this, SLOT(openPicture()));

}

void MainWindow::openPicture() {
    QString path = QFileDialog::getOpenFileName(0, "Открыть изображение", "", "*.bmp");
    Image img(path);
    img1 = img.render(10, 40, this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

