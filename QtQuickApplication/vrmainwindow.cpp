#include "vrmainwindow.h"

VRMainWindow::VRMainWindow(QObject *parent) : QObject(parent)
{
    initMessages();

    // itsCurrentMessage must be initialized !!!
    itsCurrentMessage = itsMessages->at(2);     // for example choose this Message
}


QSharedPointer<QVector<QSharedPointer<VRMessage>>> VRMainWindow::getItsMessages() const
{
    return itsMessages;
}

QString VRMainWindow::getItsCurrentMessageLabel() const
{
    return itsCurrentMessage->getItsLabel();
}

QColor VRMainWindow::getItsCurrentMessageColor() const
{
    return itsCurrentMessage->getItsColor();
}

void VRMainWindow::setItsCurrentMessage(const QSharedPointer<VRMessage> &value)
{
    itsCurrentMessage = value;

    // emit a signal to qml -> messageLabel (statusBar_main) can be updated
    emit itsCurrentMessageChanged();
}

int VRMainWindow::getItsCurrentTab() const
{
    return itsCurrentTab;
}

void VRMainWindow::setItsCurrentTab(int value)
{
    itsLastTab = itsCurrentTab;
    itsCurrentTab = value;
}

int VRMainWindow::getItsLastTab() const
{
    return itsLastTab;
}

void VRMainWindow::setItsLastTab(int value)
{
    itsLastTab = value;
}


void VRMainWindow::initMessages()
{
    // fill itsMessages with the provided Messages
    itsMessages->append(QSharedPointer<VRMessage>(new VRMessage(QString(" "), QColor(255, 255, 255))));
    itsMessages->append(QSharedPointer<VRMessage>(new VRMessage(QString("loading..."), QColor(255, 255, 255))));
    itsMessages->append(QSharedPointer<VRMessage>(new VRMessage(QString("Datainterface connected successfully."), QColor(20, 200, 32))));
    itsMessages->append(QSharedPointer<VRMessage>(new VRMessage(QString("Problem with connecting datainterface!"), QColor(250, 32, 20))));
}
