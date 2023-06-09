PULSONIX_LIBRARY_ASCII "SamacSys ECAD Model"
//883754/360937/2.47/9/3/Integrated Circuit

(asciiHeader
	(fileUnits MM)
)
(library Library_1
	(padStyleDef "r152.5_65"
		(holeDiam 0)
		(padShape (layerNumRef 1) (padShapeType Rect)  (shapeWidth 0.65) (shapeHeight 1.525))
		(padShape (layerNumRef 16) (padShapeType Ellipse)  (shapeWidth 0) (shapeHeight 0))
	)
	(padStyleDef "r310_241"
		(holeDiam 0)
		(padShape (layerNumRef 1) (padShapeType Rect)  (shapeWidth 2.41) (shapeHeight 3.1))
		(padShape (layerNumRef 16) (padShapeType Ellipse)  (shapeWidth 0) (shapeHeight 0))
	)
	(textStyleDef "Normal"
		(font
			(fontType Stroke)
			(fontFace "Helvetica")
			(fontHeight 1.27)
			(strokeWidth 0.127)
		)
	)
	(patternDef "SOIC127P602X168-9N" (originalName "SOIC127P602X168-9N")
		(multiLayer
			(pad (padNum 1) (padStyleRef r152.5_65) (pt -2.712, 1.905) (rotation 90))
			(pad (padNum 2) (padStyleRef r152.5_65) (pt -2.712, 0.635) (rotation 90))
			(pad (padNum 3) (padStyleRef r152.5_65) (pt -2.712, -0.635) (rotation 90))
			(pad (padNum 4) (padStyleRef r152.5_65) (pt -2.712, -1.905) (rotation 90))
			(pad (padNum 5) (padStyleRef r152.5_65) (pt 2.712, -1.905) (rotation 90))
			(pad (padNum 6) (padStyleRef r152.5_65) (pt 2.712, -0.635) (rotation 90))
			(pad (padNum 7) (padStyleRef r152.5_65) (pt 2.712, 0.635) (rotation 90))
			(pad (padNum 8) (padStyleRef r152.5_65) (pt 2.712, 1.905) (rotation 90))
			(pad (padNum 9) (padStyleRef r310_241) (pt 0, 0) (rotation 0))
		)
		(layerContents (layerNumRef 18)
			(attr "RefDes" "RefDes" (pt 0, 0) (textStyleRef "Normal") (isVisible True))
		)
		(layerContents (layerNumRef Courtyard_Top)
			(line (pt -3.725 2.695) (pt 3.725 2.695) (width 0.05))
		)
		(layerContents (layerNumRef Courtyard_Top)
			(line (pt 3.725 2.695) (pt 3.725 -2.695) (width 0.05))
		)
		(layerContents (layerNumRef Courtyard_Top)
			(line (pt 3.725 -2.695) (pt -3.725 -2.695) (width 0.05))
		)
		(layerContents (layerNumRef Courtyard_Top)
			(line (pt -3.725 -2.695) (pt -3.725 2.695) (width 0.05))
		)
		(layerContents (layerNumRef 28)
			(line (pt -1.95 2.445) (pt 1.95 2.445) (width 0.025))
		)
		(layerContents (layerNumRef 28)
			(line (pt 1.95 2.445) (pt 1.95 -2.445) (width 0.025))
		)
		(layerContents (layerNumRef 28)
			(line (pt 1.95 -2.445) (pt -1.95 -2.445) (width 0.025))
		)
		(layerContents (layerNumRef 28)
			(line (pt -1.95 -2.445) (pt -1.95 2.445) (width 0.025))
		)
		(layerContents (layerNumRef 28)
			(line (pt -1.95 1.175) (pt -0.68 2.445) (width 0.025))
		)
		(layerContents (layerNumRef 18)
			(line (pt -3.475 2.58) (pt -1.95 2.58) (width 0.2))
		)
	)
	(symbolDef "MIC4127YME" (originalName "MIC4127YME")

		(pin (pinNum 1) (pt 0 mils 0 mils) (rotation 0) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinName (text (pt 230 mils -25 mils) (rotation 0]) (justify "Left") (textStyleRef "Normal"))
		))
		(pin (pinNum 2) (pt 0 mils -100 mils) (rotation 0) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinName (text (pt 230 mils -125 mils) (rotation 0]) (justify "Left") (textStyleRef "Normal"))
		))
		(pin (pinNum 3) (pt 0 mils -200 mils) (rotation 0) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinName (text (pt 230 mils -225 mils) (rotation 0]) (justify "Left") (textStyleRef "Normal"))
		))
		(pin (pinNum 4) (pt 0 mils -300 mils) (rotation 0) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinName (text (pt 230 mils -325 mils) (rotation 0]) (justify "Left") (textStyleRef "Normal"))
		))
		(pin (pinNum 5) (pt 600 mils -800 mils) (rotation 90) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinName (text (pt 625 mils -570 mils) (rotation 90]) (justify "Left") (textStyleRef "Normal"))
		))
		(pin (pinNum 6) (pt 1200 mils 0 mils) (rotation 180) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinName (text (pt 970 mils -25 mils) (rotation 0]) (justify "Right") (textStyleRef "Normal"))
		))
		(pin (pinNum 7) (pt 1200 mils -100 mils) (rotation 180) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinName (text (pt 970 mils -125 mils) (rotation 0]) (justify "Right") (textStyleRef "Normal"))
		))
		(pin (pinNum 8) (pt 1200 mils -200 mils) (rotation 180) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinName (text (pt 970 mils -225 mils) (rotation 0]) (justify "Right") (textStyleRef "Normal"))
		))
		(pin (pinNum 9) (pt 1200 mils -300 mils) (rotation 180) (pinLength 200 mils) (pinDisplay (dispPinName true)) (pinName (text (pt 970 mils -325 mils) (rotation 0]) (justify "Right") (textStyleRef "Normal"))
		))
		(line (pt 200 mils 100 mils) (pt 1000 mils 100 mils) (width 6 mils))
		(line (pt 1000 mils 100 mils) (pt 1000 mils -600 mils) (width 6 mils))
		(line (pt 1000 mils -600 mils) (pt 200 mils -600 mils) (width 6 mils))
		(line (pt 200 mils -600 mils) (pt 200 mils 100 mils) (width 6 mils))
		(attr "RefDes" "RefDes" (pt 1050 mils 300 mils) (justify Left) (isVisible True) (textStyleRef "Normal"))
		(attr "Type" "Type" (pt 1050 mils 200 mils) (justify Left) (isVisible True) (textStyleRef "Normal"))

	)
	(compDef "MIC4127YME" (originalName "MIC4127YME") (compHeader (numPins 9) (numParts 1) (refDesPrefix IC)
		)
		(compPin "1" (pinName "NC_1") (partNum 1) (symPinNum 1) (gateEq 0) (pinEq 0) (pinType Unknown))
		(compPin "2" (pinName "INA") (partNum 1) (symPinNum 2) (gateEq 0) (pinEq 0) (pinType Unknown))
		(compPin "3" (pinName "GND") (partNum 1) (symPinNum 3) (gateEq 0) (pinEq 0) (pinType Unknown))
		(compPin "4" (pinName "INB") (partNum 1) (symPinNum 4) (gateEq 0) (pinEq 0) (pinType Unknown))
		(compPin "9" (pinName "EP") (partNum 1) (symPinNum 5) (gateEq 0) (pinEq 0) (pinType Unknown))
		(compPin "8" (pinName "NC_2") (partNum 1) (symPinNum 6) (gateEq 0) (pinEq 0) (pinType Unknown))
		(compPin "7" (pinName "OUTA") (partNum 1) (symPinNum 7) (gateEq 0) (pinEq 0) (pinType Unknown))
		(compPin "6" (pinName "VS") (partNum 1) (symPinNum 8) (gateEq 0) (pinEq 0) (pinType Unknown))
		(compPin "5" (pinName "OUTB") (partNum 1) (symPinNum 9) (gateEq 0) (pinEq 0) (pinType Unknown))
		(attachedSymbol (partNum 1) (altType Normal) (symbolName "MIC4127YME"))
		(attachedPattern (patternNum 1) (patternName "SOIC127P602X168-9N")
			(numPads 9)
			(padPinMap
				(padNum 1) (compPinRef "1")
				(padNum 2) (compPinRef "2")
				(padNum 3) (compPinRef "3")
				(padNum 4) (compPinRef "4")
				(padNum 5) (compPinRef "5")
				(padNum 6) (compPinRef "6")
				(padNum 7) (compPinRef "7")
				(padNum 8) (compPinRef "8")
				(padNum 9) (compPinRef "9")
			)
		)
		(attr "Manufacturer_Name" "Microchip")
		(attr "Manufacturer_Part_Number" "MIC4127YME")
		(attr "Arrow Part Number" "MIC4127YME")
		(attr "Arrow Price/Stock" "https://www.arrow.com/en/products/mic4127yme/microchip-technology")
		(attr "Mouser Part Number" "998-MIC4127YME")
		(attr "Mouser Price/Stock" "https://www.mouser.com/Search/Refine.aspx?Keyword=998-MIC4127YME")
		(attr "Description" "1.5A 2xHigh Spd MOSFET Driver,MIC4127YME Micrel MIC4127YME, Dual MOSFET Power Driver 1.5A, 4.5  20 V, Non-Inverting, 8-Pin SOIC")
		(attr "<Hyperlink>" "http://ww1.microchip.com/downloads/en/DeviceDoc/MIC4126-27-28-Data-Sheet-20006084A.pdf")
		(attr "<Component Height>" "1.68")
		(attr "<STEP Filename>" "MIC4127YME.stp")
		(attr "<STEP Offsets>" "X=0;Y=0;Z=0")
		(attr "<STEP Rotation>" "X=0;Y=0;Z=0")
	)

)
