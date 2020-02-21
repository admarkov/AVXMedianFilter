#include "mainwindow.h"
#include "ui_mainwindow.h"

#include "image.h"
#include "cppmedian.h"
#include "avxmedian.h"

#include <QFileDialog>
#include <QFile>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , h(800)
    , w(1400)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

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

    fileMenu_filtercpp.reset(new QAction(this));
    fileMenu_filtercpp->setText("Применить фильтр на c++");
    fileMenu->addAction(fileMenu_filtercpp.get());
    fileMenu_filtercpp->setDisabled(true);
    connect(fileMenu_filtercpp.get(), SIGNAL(triggered(bool)), this, SLOT(filterPictureCpp()));

    fileMenu_filterasm.reset(new QAction(this));
    fileMenu_filterasm->setText("Применить фильтр на nasm");
    fileMenu->addAction(fileMenu_filterasm.get());
    fileMenu_filterasm->setDisabled(true);
    connect(fileMenu_filterasm.get(), SIGNAL(triggered(bool)), this, SLOT(filterPictureAsm()));
}

void MainWindow::showTicks(uint32_t ticks) {
    ticksLabel.reset(new QLabel(this));
    ticksLabel->setGeometry(10, h - 40, w, 30);
    ticksLabel->setText(QString::number(ticks) + " ticks");
    ticksLabel->setFont(QFont("Verdana", 18));
    ticksLabel->setAlignment(Qt::AlignCenter);
    ticksLabel->show();
}

void MainWindow::openPicture() {
    QString path = QFileDialog::getOpenFileName(0, "Открыть изображение", "", "*.bmp");
    img.reset(new Image(path));
    img1 = img->render(10, 40, this);
    img2.reset(nullptr);
    fileMenu_filtercpp->setEnabled(true);
    fileMenu_filterasm->setEnabled(true);
}

void MainWindow::filterPictureCpp() {
    CppMedianFilter filter;
    auto ticks = img->ApplyFilter(&filter);
    img2 = img->render(710, 40, this);
    showTicks(ticks);
}

void MainWindow::filterPictureAsm() {
    AvxMedianFilter filter;
    auto ticks = img->ApplyFilter(&filter);
    img2 = img->render(710, 40, this);
    showTicks(ticks);
}

MainWindow::~MainWindow()
{
    delete ui;
}

