?
 TDEMOFORM 0?"  TPF0	TDemoFormDemoFormLeft? TopkBorderIconsbiSystemMenu
biMinimize BorderStylebsSingleCaptionBComPort_DemoClientHeightClientWidth?Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height?	Font.NameMS Sans Serif
Font.Style 
KeyPreview	Position	poDefaultShowHint	OnCreate
FormCreatePixelsPerInch`
TextHeight 	TGroupBox	GroupBox1LeftTopWidth-Height? Caption
 Settings TabOrder  TLabelLabel1LeftTopWidth-HeightCaptionCOM-port  TLabelLabel2LeftTop<Width0HeightCaptionBaudRate  TLabelLabel3LeftTophWidthSHeightCaptionCustomBaudRate  TLabelLabel4LefttTopWidth-HeightCaption	InBufSize  TLabelLabel5LefttTop<Width5HeightCaption
OutBufSize  TLabelLabel6LefttTophWidth)HeightCaptionByteSize  TLabelLabel7LeftTop? WidthHeightCaptionParity  TLabelLabel8LefttTop? Width'HeightCaptionStopBits  TLabelLabel9Left? TopWidth<HeightCaption
SyncMethod  TLabelLabel10Left? Top<WidthAHeightCaptionThreadPriority  TButtonbtnOpenLeft? ToppWidthiHeightHint??????? ????CaptionOPENTabOrder OnClickbtnOpenClick  TButtonbtnCloseLeft? Top? WidthiHeightHint??????? ????CaptionCLOSEEnabledTabOrderOnClickbtnCloseClick  	TComboBoxcbPortLeftTop WidthUHeightHint?????? ???-?????? ??????????StylecsDropDownList
ItemHeightTabOrderOnChangecbPortChange  	TComboBox
cbBaudRateLeftTopLWidthUHeightHint???????? ???????? ??????StylecsDropDownList
ItemHeightItems.StringsbrCustombr110br300br600br1200br2400br4800br9600br14400br19200br38400br56000br57600br115200br128000br230400br256000br460800br500000br576000br921600	br1000000	br1152000	br1500000	br2000000	br2500000	br3000000	br3500000	br4000000 TabOrderOnChangecbBaudRateChange  TEdit
edCustomBRLeftTopxWidthUHeightHint)???????????????? ???????? ???????? ??????TabOrderText9600
OnKeyPressedCustomBRKeyPress  TEditedInBufSizeLefttTop Width9HeightHint?????? ?????? ??????TabOrderText2048
OnKeyPressedCustomBRKeyPress  TEditedOutBufSizeLefttTopLWidth9HeightHint?????? ?????? ????????TabOrderText2048
OnKeyPressedCustomBRKeyPress  	TComboBox
cbByteSizeLefttTopxWidth9HeightHint?????? ????? ??????StylecsDropDownList
ItemHeightItems.Stringsbs5bs6bs7bs8 TabOrderOnChangecbByteSizeChange  	TComboBoxcbParityLeftTop? WidthUHeightHint????? ???????? ????????StylecsDropDownList
ItemHeightItems.StringspaNonepaOddpaEvenpaMarkpaSpace TabOrderOnChangecbParityChange  	TComboBox
cbStopBitsLefttTop? Width9HeightHint?????????? ???????? ???StylecsDropDownList
ItemHeightItems.Stringssb1sb1_5sb2 TabOrder	OnChangecbStopBitsChange  	TComboBoxcbSyncMethodLeft? Top WidthiHeightHint????? ????????????? ???????StylecsDropDownList
ItemHeightItems.StringssmThreadSyncsmWindowSyncsmNone TabOrder
OnChangecbSyncMethodChange  	TComboBoxcbThreadPriorityLeft? TopLWidthiHeightHint$????????? ?????? ??????????? ???????StylecsDropDownList
ItemHeightItems.StringstpIdletpLowesttpLowertpNormaltpHigher	tpHighesttpTimeCritical TabOrderOnChangecbThreadPriorityChange  	TGroupBox	GroupBox2Left4TopWidth? Height? Hint2????????? ????????? ???????? ??? ?????? ? ????????Caption
 Timeouts TabOrder TLabelLabel11LeftTopWidth=HeightCaptionReadInterval  TLabelLabel12LeftTopDWidth[HeightCaptionReadTotalMultiplier  TLabelLabel13LeftToptWidth\HeightCaptionReadTotalConstant  TLabelLabel14Left|TopWidthZHeightCaptionWriteTotalMultiplier  TLabelLabel15Left|TopDWidth[HeightCaptionWriteTotalConstant  TEditedRILeftTop$Width]HeightTabOrder Text-1
OnKeyPressedCustomBRKeyPress  TEditedRTMLeftTopTWidth]HeightTabOrderText0
OnKeyPressedCustomBRKeyPress  TEditedRTCLeftTop? Width]HeightTabOrderText0
OnKeyPressedCustomBRKeyPress  TEditedWTMLeft|Top$Width]HeightTabOrderText100
OnKeyPressedCustomBRKeyPress  TEditedWTCLeft|TopTWidth]HeightTabOrderText1000
OnKeyPressedCustomBRKeyPress    	TGroupBox	GroupBox3LeftTop? Width-HeightACaption DataPacket TabOrder TLabelLabel16LeftTopWidth6HeightCaption
PacketSize  TLabelLabel17Left\TopWidth1HeightCaptionStartString  TLabelLabel18Left?TopWidth1HeightCaption
StopString  TLabelLabel19Left? TopWidthDHeightCaptionMaxBufferSize  	TCheckBox	cbEnabledLeftTopWidthAHeightHint?????????? ?????????? ???????CaptionEnabledTabOrder OnClickcbEnabledClick  	TCheckBoxcbInStrLeftXTopWidthYHeightHint)???????? ? ????? StartString ? StopStringCaptionIncludeStringsState	cbCheckedTabOrderOnClickcbInStrClick  TEditedPacketSizeLeftTopWidth=HeightHint?????? ??????TabOrderText0
OnKeyPressedCustomBRKeyPress  TEditedStartStringLeft\TopWidth=HeightHint?????? ????????? ??????TabOrder  TEditedStopStringLeft?TopWidth=HeightHint?????? ????????? ??????TabOrder  TButtonbtnSetLeft?TopWidth)HeightHint7????????? ???????? PacketSize, StartString ? StopStringCaptionSETTabOrderOnClickbtnSetClick  TEditedMaxBufferSizeLeft? TopWidthEHeightHint-???????????? ?????? ?????? ??????? DataPacketTabOrderText1024
OnKeyPressedCustomBRKeyPress   TMemoMemoLeftTop,WidthYHeight? Hint#???? ??????????? ??????????? ??????Font.CharsetRUSSIAN_CHARSET
Font.ColorclWindowTextFont.Height?	Font.NameCourier New
Font.Style 
ParentFont
ScrollBars
ssVerticalTabOrder  TButtonbtnClearLefttTopdWidth-HeightHint??????? ???? ??????????? ??????CaptionClearTabOrderOnClickbtnClearClick  TEditedSendLeftTop?Width!HeightHint?????? ??? ????????Font.CharsetRUSSIAN_CHARSET
Font.ColorclWindowTextFont.Height?	Font.NameCourier New
Font.Style 
ParentFontTabOrder
OnKeyPressedSendKeyPress  TButtonbtnSendLeftfTop?Width;HeightHint???????? ?????? ? ????CaptionSENDTabOrderOnClickbtnSendClick  	TCheckBoxcbHexLeft8Top?Width-HeightHint.?????? ??? ???????? - ? ????????????????? ????CaptionHEXTabOrder  	TCheckBoxcbMHexLefttTop?Width-HeightHint6?????????? ??????????? ?????? ? ????????????????? ????CaptionHEXTabOrder  	TGroupBox	GroupBox4LeftFTopWidth[HeightCaption Port lines TabOrder TLabellbCTSLeftTopWidth+HeightHint????????? ??????? ????? CTSCaptionCTSFont.CharsetRUSSIAN_CHARSET
Font.ColoruVU Font.Height?	Font.NameArial Black
Font.Style 
ParentFont  TLabellbDSRLeftTop=Width,HeightHint????????? ??????? ????? DSRCaptionDSRFont.CharsetRUSSIAN_CHARSET
Font.ColoruVU Font.Height?	Font.NameArial Black
Font.Style 
ParentFont  TLabellbRILeftTopcWidthHeightHint????????? ??????? ????? RICaptionRIFont.CharsetRUSSIAN_CHARSET
Font.ColoruVU Font.Height?	Font.NameArial Black
Font.Style 
ParentFont  TLabellbRLSDLeftTop? Width9HeightHint????????? ??????? ????? RLSDCaptionRLSDFont.CharsetRUSSIAN_CHARSET
Font.ColoruVU Font.Height?	Font.NameArial Black
Font.Style 
ParentFont  	TCheckBoxcbDTRLeft
Top? WidthCHeightHint?????????/????? ??????? DTRCaptionSet DTRState	cbCheckedTabOrder OnClick
cbDTRClick  	TCheckBoxcbRTSLeft
Top? WidthCHeightHint?????????/????? ??????? RTSCaptionSet RTSState	cbCheckedTabOrderOnClick
cbRTSClick  	TCheckBoxcbBREAKLeft
Top? WidthMHeightHint.????????? ????????? "?????? ?????" ?? ????? TXCaption	Set BREAKTabOrderOnClickcbBREAKClick   	TCheckBoxcbEventsLefttTopDWidth9HeightHint+?????????? ??????? ????? ? ???? ???????????CaptionEventsState	cbCheckedTabOrder	  	TBComPort	BComPort1BaudRatebr9600ByteSizebs8CustomBaudRate?%DataPacket.EnabledDataPacket.IncludeStrings	DataPacket.MaxBufferSize DataPacket.PacketSize 	InBufSize 
OutBufSize ParitypaNonePortCOM1StopBitssb1
SyncMethodsmThreadSyncThreadPrioritytpNormalTimeouts.ReadInterval?Timeouts.ReadTotalMultiplier Timeouts.ReadTotalConstant Timeouts.WriteTotalMultiplierdTimeouts.WriteTotalConstant?OnBreakBComPort1BreakOnCTSChangeBComPort1CTSChangeOnDSRChangeBComPort1DSRChangeOnErrorBComPort1ErrorOnPacketBComPort1PacketOnRingBComPort1RingOnRLSDChangeBComPort1RLSDChange
OnRx80FullBComPort1Rx80FullOnRxCharBComPort1RxChar	OnTxEmptyBComPort1TxEmptyLeft Top?    