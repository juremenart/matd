# Place to plugins folder on my windows it was: AppData/Roaming/kicad/scripting/plugins

import pcbnew
import os
import re

class PlaceMatd(pcbnew.ActionPlugin):
    def defaults(self):
        self.name = "MATD 8x8 placing script"
        self.category = "A descriptive category name"
        self.description = "This script places the 8x8 transducer array into the PCB"
        self.show_toolbar_button = False # Optional, defaults to False

    def Run(self):
        board = pcbnew.GetBoard()

        for mod in board.GetModules():
            ref = mod.GetReference()

            # SG1 -> (31, 48), SG2 -> (41, 48), ...
            # SG8 -> (31, 58), SG9 -> (41, 58), ...

            if(ref.startswith("SG")):
                sg_num=int(ref[2:len(ref)])-1
                x_off=(180 + (sg_num%8)*39.5) * 25.4 * 1000.0 * 10;
                y_off=(280 + ((sg_num/8)-1)*39.5) * 25.4 * 1000.0 * 10;
                mod.SetOrientation(180*10)
                mod.SetPosition(pcbnew.wxPoint(x_off, y_off))

            if(ref.startswith("IC")):
                ic_num=int(ref[2:len(ref)])-1
                x_off=(180 + (ic_num%8)*39.5) * 25.4 * 1000.0 * 10;
                y_off=(340 + ((ic_num/8)-1)*39.5*2) * 25.4 * 1000.0 * 10;
#                mod.SetOrientation(180*10)
                mod.SetPosition(pcbnew.wxPoint(x_off, y_off))

            if(ref.startswith("C")):
                c_num=int(ref[1:len(ref)])-1

                # Odd Even pairs for each IC
                mod.SetOrientation(270*10)
                if((c_num % 2) == 0):
                    x_off=(175 + ((c_num)%16)*39.5/2) * 25.4 * 1000.0 * 10;
                    y_off=(307 + ((c_num/16)-1)*39.5*2) * 25.4 * 1000.0 * 10;
                else:
                    x_off=(185 + ((c_num-1)%16)*39.5/2) * 25.4 * 1000.0 * 10;
                    y_off=(307 + ((c_num/16)-1)*39.5*2) * 25.4 * 1000.0 * 10;
                mod.SetPosition(pcbnew.wxPoint(x_off, y_off))


        # when running as a plugin, this isn't needed. it's done for you
        #pcbnew.Refresh();


PlaceMatd().register() # Instantiate and register to Pcbnew
