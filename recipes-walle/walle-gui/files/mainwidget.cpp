#include <QTimer>
#include "mainwidget.h"
#include "ui_mainwidget.h"

MainWidget::MainWidget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::MainWidget)
{
    ui->setupUi(this);
    QTimer::singleShot(100, this, SLOT(showFullScreen()));
}

MainWidget::~MainWidget()
{
    delete ui;
}
