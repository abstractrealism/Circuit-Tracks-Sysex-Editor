import sys
import os
import threading
import binascii
from time import sleep
from time import strftime, localtime
from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtQuick import QQuickWindow
from PyQt6.QtCore import QObject, pyqtSignal

class Backend(QObject):

    def __init__(self):
        QObject.__init__(self)

    updated = pyqtSignal(str, arguments=['updater'])

    def updater(self, curr_time):
        self.updated.emit(curr_time)

    def bootUp(self):
        t_thread = threading.Thread(target=self._bootUp)
        t_thread.daemon = True
        t_thread.start()

    def _bootUp(self):
        while True:
            curr_time = strftime("%H:%M:%S", localtime())
            self.updater(curr_time)
            # print(curr_time)
            sleep(0.1)


QQuickWindow.setSceneGraphBackend('software')




app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()
engine.quit.connect(app.quit)
engine.load('./UI/main.qml')
back_end = Backend()
engine.rootObjects()[0].setProperty('backend', back_end)

# Do Sys Ex Stuff HERE
def insert_newlines(string, every=48):
    return '\n'.join(string[i:i+every] for i in range(0, len(string), every))



with open('../Boards2.syx', 'r') as fp:
    hex_list = ["{:02x}".format(ord(c)) for c in fp.read()]

intro = hex_list[0:213]
macro1 = hex_list[213:230]
macro2 = hex_list[230:247]
macro3 = hex_list[247:264]
macro4 = hex_list[264:281]
macro5 = hex_list[281:298]
macro6 = hex_list[298:315]
macro7 = hex_list[315:332]
macro8 = hex_list[332:349]
end = hex_list[349]


# print("Macro 1: %s" % macro1)
output = intro + macro8 + macro7 + macro6 + macro5 + macro4 + macro3 + macro2 + macro1 + [end]
sys_ex_in = hex_list
print(sys_ex_in)
# sys_ex_pass = insert_newlines(" ".join(sys_ex_in))
sys_ex_pass = sys_ex_in

## Send it to QML here
# engine.load('./UI/main.qml')
engine.rootObjects()[0].setProperty('sysExIn', sys_ex_pass)



back_end.bootUp()
sys.exit(app.exec())
