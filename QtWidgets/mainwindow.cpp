#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QRandomGenerator>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    createTimer = new QTimer(this);
    moveTimer = new QTimer(this);

    QObject::connect(createTimer, &QTimer::timeout, [this]() {
        QPushButton *button = new QPushButton(this);
        button->setFixedSize(25, 25);
        button->setText("*");
        int maxX = width();
        int maxY = 100;
        if(maxX < 0) maxX = 0;
        int randomX = QRandomGenerator::global()->generate() % (maxX - 25);
        int randomY = QRandomGenerator::global()->generate() % (maxY - 25);
        button->move(randomX, randomY);
        button->setProperty("lives", QRandomGenerator::global()->generate() % (3));
        button->show();

        QObject::connect(button, &QPushButton::clicked, [this, button]() {
            int lives = button->property("lives").toInt();
                        lives--;
            if (lives <= 0)
            {
                int index = buttons.indexOf(button);
                buttons.removeAt(index);
                delete button;
            }
            else button->setProperty("lives", lives);
        });


        buttons.append(button);

        createTimer->setInterval(QRandomGenerator::global()->bounded(100, 1000));
    });

    QObject::connect(moveTimer, &QTimer::timeout, [this]() {
        for(int i = buttons.size() - 1; i >= 0; i--) {
            QPushButton *btn = buttons[i];

            if (!btn) {
                buttons.removeAt(i);
                continue;
            }

            int speed = QRandomGenerator::global()->generate() % (5);

            if(btn->underMouse()) {
                speed *= 2;
            }

            btn->move(btn->x(), btn->y() + speed);

            if(btn->y() + btn->height() >= height()) {
                buttons.removeAt(i);
                setStyleSheet("QMainWindow { background-color: red; }");
                setWindowTitle("YOU LOOSE!");
                delete btn;
            }
        }
    });

    createTimer->start(500);
    moveTimer->start(100);
}

MainWindow::~MainWindow()
{
    for(int i = 0; i < buttons.size(); i++) {
        delete buttons[i];
        buttons[i] = nullptr;
    }
    buttons.clear();
    delete ui;
}

