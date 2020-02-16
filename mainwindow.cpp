#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QFileDialog>
#include <QLabel>

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
    QLabel* label = new QLabel(this);
    label->setGeometry(100,100,600,600);
    label->show();
    label->setText(path);
}

MainWindow::~MainWindow()
{
    delete ui;
}

