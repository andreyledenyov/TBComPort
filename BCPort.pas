/////////////////////////////////////////////////////////////////////////////
//                                                                         //
//              TBComPort  ver.2.20  -  01.01.2012      freeware           //
//  ---------------------------------------------------------------------  //
//        Компонент для обмена данными с внешними устройствами через       //
//  интерфейс RS-232 в синхронном режиме. Состояние порта отслеживается    //
//  в отдельном потоке с генерацией соответствующих событий.               //
//        Работает с Delphi 3..10, 2007..2010 и C++ Builder 3..6           //
//  ---------------------------------------------------------------------  //
//        (c) 2001-2012 Брусникин И.В.        http://majar.nm.ru/          //
//                                                                         //
/////////////////////////////////////////////////////////////////////////////

unit BCPort;

{$I BCPort.inc}

interface

uses
  Windows, Messages, SysUtils, Classes;

type
  TBaudRate = (brCustom, br110, br300, br600, br1200, br2400, br4800, br9600,
    br14400, br19200, br38400, br56000, br57600, br115200, br128000, br230400,
    br256000, br460800, br500000, br576000, br921600, br1000000, br1152000,
    br1500000, br2000000, br2500000, br3000000, br3500000, br4000000);
  TByteSize = (bs5, bs6, bs7, bs8);
  TComErrors = set of (ceBreak, ceFrame, ceIO, ceMode, ceOverrun, ceRxOver,
                       ceRxParity, ceTxFull);
  TComEvents = set of (evRxChar, evTxEmpty, evRing, evBreak, evCTS, evDSR,
                       evError, evRLSD, evRx80Full);
  TComSignals = set of (csCTS, csDSR, csRing, csRLSD);
  TParity = (paNone, paOdd, paEven, paMark, paSpace);
  TStopBits = (sb1, sb1_5, sb2);
  TSyncMethod = (smThreadSync, smWindowSync, smNone);
  TComSignalEvent = procedure(Sender: TObject; State: Boolean) of object;
  TComErrorEvent = procedure(Sender: TObject; Errors: TComErrors) of object;
  TRxCharEvent = procedure(Sender: TObject; Count: Integer) of object;
  TComPackEvent = procedure(Sender: TObject; const Str: String) of object;

  TBComPort = class;

  TComThread = class(TThread)
  private
    FComPort: TBComPort;
    FEvents: TComEvents;
    FStopEvent: THandle;
  protected
    procedure DoEvents;
    procedure Execute; override;
    procedure SendEvents;
    procedure Stop;
  public
    constructor Create(AComPort: TBComPort);
    destructor Destroy; override;
  end;

  TComTimeouts = class(TPersistent)
  private
    FComPort: TBComPort;
    FReadInterval: Integer;
    FReadTotalM: Integer;
    FReadTotalC: Integer;
    FWriteTotalM: Integer;
    FWriteTotalC: Integer;
    procedure SetComPort(const AComPort: TBComPort);
    procedure SetReadInterval(const Value: Integer);
    procedure SetReadTotalM(const Value: Integer);
    procedure SetReadTotalC(const Value: Integer);
    procedure SetWriteTotalM(const Value: Integer);
    procedure SetWriteTotalC(const Value: Integer);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create;
  published
    property ReadInterval: Integer read FReadInterval write SetReadInterval;
    property ReadTotalMultiplier: Integer read FReadTotalM write SetReadTotalM;
    property ReadTotalConstant: Integer read FReadTotalC write SetReadTotalC;
    property WriteTotalMultiplier: Integer read FWriteTotalM write SetWriteTotalM;
    property WriteTotalConstant: Integer read FWriteTotalC write SetWriteTotalC;
  end;

  TComDataPacket = class(TPersistent)
  private
    FBuffer: String;
    FComPort: TBComPort;
    FEnabled: Boolean;
    FIncludeStrings: Boolean;
    FInPacket: Boolean;
    FMaxBufferSize: Integer;
    FSize: Integer;
    FStartString: String;
    FStopString: String;
    procedure EmptyBuffer;
    procedure HandleBuffer;
    function IsPacketDefined: Boolean;
    procedure SetComPort(const AComPort: TBComPort);
    procedure SetMaxBufferSize(const Value: Integer);
    procedure SetSize(const Value: Integer);
    procedure SetStartString(const Value: String);
    procedure SetStopString(const Value: String);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create;
    procedure AddData(const Value: String);
    property PacketDefined: Boolean read IsPacketDefined;
  published
    property Enabled: Boolean read FEnabled write FEnabled;
    property IncludeStrings: Boolean read FIncludeStrings write FIncludeStrings;
    property MaxBufferSize: Integer read FMaxBufferSize write SetMaxBufferSize;
    property PacketSize: Integer read FSize write SetSize;
    property StartString: String read FStartString write SetStartString;
    property StopString: String read FStopString write SetStopString;
  end;

  TBComPort = class(TComponent)
  private
    FBaudRate: TBaudRate;
    FByteSize: TByteSize;
    FConnected: Boolean;
    FCTPriority: TThreadPriority;
    FCustomBaudRate: Integer;
    FDataPacket: TComDataPacket;
    FEvents: TComEvents;
    FEventThread: TComThread;
    FHandle: THandle;
    FInBufSize: Integer;
    FOutBufSize: Integer;
    FParity: TParity;
    FPort: String;
    FStopBits: TStopBits;
    FSyncMethod: TSyncMethod;
    FTimeouts: TComTimeouts;
    FWindow: THandle;
    FOnBreak: TNotifyEvent;
    FOnCTSChange: TComSignalEvent;
    FOnDSRChange: TComSignalEvent;
    FOnError: TComErrorEvent;
    FOnPacket: TComPackEvent;
    FOnRing: TNotifyEvent;
    FOnRLSDChange: TComSignalEvent;
    FOnRx80Full: TNotifyEvent;
    FOnRxChar: TRxCharEvent;
    FOnTxEmpty: TNotifyEvent;
    procedure CallBreak;
    procedure CallCTSChange;
    procedure CallDSRChange;
    procedure CallError;
    procedure CallPacket(const Value: String);
    procedure CallRing;
    procedure CallRLSDChange;
    procedure CallRx80Full;
    procedure CallRxChar;
    procedure CallTxEmpty;
    function IsConnected: Boolean;
    procedure PurgeAll;
    procedure SetBaudRate(const Value: TBaudRate);
    procedure SetByteSize(const Value: TByteSize);
    procedure SetCTPriority(const Value: TThreadPriority);
    procedure SetCustomBaudRate(const Value: Integer);
    procedure SetDataPacket(const Value: TComDataPacket);
    procedure SetInBufSize(const Value: Integer);
    procedure SetOutBufSize(const Value: Integer);
    procedure SetParity(const Value: TParity);
    procedure SetPort(const Value: String);
    procedure SetStopBits(const Value: TStopBits);
    procedure SetSyncMethod(const Value: TSyncMethod);
    procedure SetTimeouts(const Value: TComTimeouts);
    procedure WindowMethod(var Message: TMessage);
  protected
    procedure ApplyBuffer;
    procedure ApplyDCB;
    procedure ApplyTimeouts;
    procedure CreateHandle;
    procedure DestroyHandle;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure EnumComPorts(Ports: TStrings);
    procedure Open;
    procedure Close;
    procedure ClearBuffer(Input, Output: Boolean);
    function InBufCount: Integer;
    function OutBufCount: Integer;
    function Read(var Buffer; Count: Integer): Integer;
    function ReadStr(var Str: string; Count: Integer): Integer;
    procedure SetBreak(State: Boolean);
    procedure SetDTR(State: Boolean);
    procedure SetRTS(State: Boolean);
    function Signals: TComSignals;
    function Write(const Buffer; Count: Integer): Integer;
    function WriteStr(const Str: string): Integer;
    property Connected: Boolean read FConnected;
  published
    property BaudRate: TBaudRate read FBaudRate write SetBaudRate;
    property ByteSize: TByteSize read FByteSize write SetByteSize;
    property CustomBaudRate: Integer read FCustomBaudRate write SetCustomBaudRate;
    property DataPacket: TComDataPacket read FDataPacket write SetDataPacket;
    property InBufSize: Integer read FInBufSize write SetInBufSize;
    property OutBufSize: Integer read FOutBufSize write SetOutBufSize;
    property Parity: TParity read FParity write SetParity;
    property Port: String read FPort write SetPort;
    property StopBits: TStopBits read FStopBits write SetStopBits;
    property SyncMethod: TSyncMethod read FSyncMethod write SetSyncMethod;
    property ThreadPriority: TThreadPriority read FCTPriority write SetCTPriority;
    property Timeouts: TComTimeouts read FTimeouts write SetTimeouts;
    property OnBreak: TNotifyEvent read FOnBreak write FOnBreak;
    property OnCTSChange: TComSignalEvent read FOnCTSChange write FOnCTSChange;
    property OnDSRChange: TComSignalEvent read FOnDSRChange write FOnDSRChange;
    property OnError: TComErrorEvent read FOnError write FOnError;
    property OnPacket: TComPackEvent read FOnPacket write FOnPacket;
    property OnRing: TNotifyEvent read FOnRing write FOnRing;
    property OnRLSDChange: TComSignalEvent read FOnRLSDChange write FOnRLSDChange;
    property OnRx80Full: TNotifyEvent read FOnRx80Full write FOnRx80Full;
    property OnRxChar: TRxCharEvent read FOnRxChar write FOnRxChar;
    property OnTxEmpty: TNotifyEvent read FOnTxEmpty write FOnTxEmpty;
  end;

  EComPort = class(Exception);

procedure Register;

implementation

uses
  Forms;

const
  CM_COMPORT = WM_USER + 1;

  CEMess: array[1..14] of string =
   ('Попытка открыть несуществующий COM-порт',
    'Порт занят другой программой',
    'Порт не открыт',
    'Ошибка записи в порт',
    'Ошибка чтения из порта',
    'Ошибка функции PurgeComm',
    'Ошибка функции SetCommState',
    'Ошибка функции SetCommTimeouts',
    'Ошибка функции SetupComm',
    'Ошибка функции ClearCommError',
    'Ошибка функции GetCommModemStatus',
    'Ошибка функции EscapeCommFunction',
    'Нельзя менять свойство, пока порт открыт',
    'Ошибка обращения к системному реестру');

  CBR_230400 = $38400;
  CBR_460800 = $70800;
  CBR_500000 = $7A120;
  CBR_576000 = $8CA00;
  CBR_921600 = $E1000;
  CBR_1000000 = $F4240;
  CBR_1152000 = $119400;
  CBR_1500000 = $16E360;
  CBR_2000000 = $1E8480;
  CBR_2500000 = $2625A0;
  CBR_3000000 = $2DC6C0;
  CBR_3500000 = $3567E0;
  CBR_4000000 = $3D0900;

function EventsToInt(const Events: TComEvents): Integer;
begin
  Result := 0;
  if evRxChar in Events then Result := Result or EV_RXCHAR;
  if evTxEmpty in Events then Result := Result or EV_TXEMPTY;
  if evRing in Events then Result := Result or EV_RING;
  if evBreak in Events then Result := Result or EV_BREAK;
  if evCTS in Events then Result := Result or EV_CTS;
  if evDSR in Events then Result := Result or EV_DSR;
  if evError in Events then Result := Result or EV_ERR;
  if evRLSD in Events then Result := Result or EV_RLSD;
  if evRx80Full in Events then Result := Result or EV_RX80FULL;
end;

function IntToEvents(Mask: Integer): TComEvents;
begin
  Result := [];
  if (EV_RXCHAR and Mask) <> 0 then Result := Result + [evRxChar];
  if (EV_TXEMPTY and Mask) <> 0 then Result := Result + [evTxEmpty];
  if (EV_RING and Mask) <> 0 then Result := Result + [evRing];
  if (EV_BREAK and Mask) <> 0 then Result := Result + [evBreak];
  if (EV_CTS and Mask) <> 0 then Result := Result + [evCTS];
  if (EV_DSR and Mask) <> 0 then Result := Result + [evDSR];
  if (EV_ERR and Mask) <> 0 then Result := Result + [evError];
  if (EV_RLSD and Mask) <> 0 then Result := Result + [evRLSD];
  if (EV_RX80FULL and Mask) <> 0 then Result := Result + [evRx80Full];
end;

{ TComThread }

constructor TComThread.Create(AComPort: TBComPort);
begin
  inherited Create(True);
  FStopEvent := CreateEvent(nil, True, False, nil);
  FComPort := AComPort;
  Priority := FComPort.ThreadPriority;
  SetCommMask(FComPort.FHandle, EventsToInt(FComPort.FEvents));
  Resume;
end;

destructor TComThread.Destroy;
begin
  Stop;
  inherited Destroy;
end;

procedure TComThread.Execute;
var
  EventHandles: array[0..1] of THandle;
  Overlapped: TOverlapped;
  Signaled, BytesTrans, Mask: DWORD;
begin
  FillChar(Overlapped, SizeOf(Overlapped), 0);
  Overlapped.hEvent := CreateEvent(nil, True, True, nil);
  EventHandles[0] := FStopEvent;
  EventHandles[1] := Overlapped.hEvent;
  repeat
    WaitCommEvent(FComPort.FHandle, Mask, @Overlapped);
    Signaled := WaitForMultipleObjects(2, @EventHandles, False, INFINITE);
    if (Signaled = WAIT_OBJECT_0 + 1) and
      GetOverlappedResult(FComPort.FHandle, Overlapped, BytesTrans, False) then
    begin
      FEvents := IntToEvents(Mask);
      case FComPort.SyncMethod of
        smThreadSync: Synchronize(DoEvents);
        smWindowSync: SendEvents;
        smNone      : DoEvents;
      end;
    end;
  until Signaled <> (WAIT_OBJECT_0 + 1);
  FComPort.PurgeAll;
  CloseHandle(Overlapped.hEvent);
  CloseHandle(FStopEvent);
end;

procedure TComThread.Stop;
begin
  SetEvent(FStopEvent);
  Sleep(0);
end;

procedure TComThread.SendEvents;
begin
  if evRxChar in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_RXCHAR, 0);
  if evTxEmpty in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_TXEMPTY, 0);
  if evRing in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_RING, 0);
  if evBreak in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_BREAK, 0);
  if evCTS in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_CTS, 0);
  if evDSR in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_DSR, 0);
  if evError in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_ERR, 0);
  if evRLSD in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_RLSD, 0);
  if evRx80Full in FEvents then
    SendMessage(FComPort.FWindow, CM_COMPORT, EV_RX80FULL, 0);
end;

procedure TComThread.DoEvents;
begin
  if evRxChar in FEvents then FComPort.CallRxChar;
  if evTxEmpty in FEvents then FComPort.CallTxEmpty;
  if evRing in FEvents then FComPort.CallRing;
  if evBreak in FEvents then FComPort.CallBreak;
  if evCTS in FEvents then FComPort.CallCTSChange;
  if evDSR in FEvents then FComPort.CallDSRChange;
  if evError in FEvents then FComPort.CallError;
  if evRLSD in FEvents then FComPort.CallRLSDChange;
  if evRx80Full in FEvents then FComPort.CallRx80Full;
end;

{ TComTimeouts }

constructor TComTimeouts.Create;
begin
  inherited Create;
  FReadInterval := -1;
  FWriteTotalM := 100;
  FWriteTotalC := 1000;
end;

procedure TComTimeouts.AssignTo(Dest: TPersistent);
begin
  if Dest is TComTimeouts then
    with TComTimeouts(Dest) do
    begin
      FReadInterval := Self.ReadInterval;
      FReadTotalM   := Self.ReadTotalMultiplier;
      FReadTotalC   := Self.ReadTotalConstant;
      FWriteTotalM  := Self.WriteTotalMultiplier;
      FWriteTotalC  := Self.WriteTotalConstant;
    end
  else
    inherited AssignTo(Dest);
end;

procedure TComTimeouts.SetComPort(const AComPort: TBComPort);
begin
  FComPort := AComPort;
end;

procedure TComTimeouts.SetReadInterval(const Value: Integer);
begin
  if Value <> FReadInterval then
  begin
    FReadInterval := Value;
    FComPort.ApplyTimeouts;
  end;
end;

procedure TComTimeouts.SetReadTotalC(const Value: Integer);
begin
  if Value <> FReadTotalC then
  begin
    FReadTotalC := Value;
    FComPort.ApplyTimeouts;
  end;
end;

procedure TComTimeouts.SetReadTotalM(const Value: Integer);
begin
  if Value <> FReadTotalM then
  begin
    FReadTotalM := Value;
    FComPort.ApplyTimeouts;
  end;
end;

procedure TComTimeouts.SetWriteTotalC(const Value: Integer);
begin
  if Value <> FWriteTotalC then
  begin
    FWriteTotalC := Value;
    FComPort.ApplyTimeouts;
  end;
end;

procedure TComTimeouts.SetWriteTotalM(const Value: Integer);
begin
  if Value <> FWriteTotalM then
  begin
    FWriteTotalM := Value;
    FComPort.ApplyTimeouts;
  end;
end;

{ TComDataPacket }

constructor TComDataPacket.Create;
begin
  inherited Create;
  FBuffer := '';
  FEnabled := False;
  FInPacket := False;
  FIncludeStrings := True;
  FMaxBufferSize := 1024;
  FSize := 0;
  FStartString := '';
  FStopString := '';
end;

procedure TComDataPacket.AssignTo(Dest: TPersistent);
begin
  if Dest is TComDataPacket then
    with TComDataPacket(Dest) do
    begin
      FEnabled        := Self.Enabled;
      FIncludeStrings := Self.IncludeStrings;
      FMaxBufferSize  := Self.MaxBufferSize;
      FSize           := Self.PacketSize;
      FStartString    := Self.StartString;
      FStopString     := Self.StopString;
    end
  else
    inherited AssignTo(Dest);
end;

procedure TComDataPacket.SetComPort(const AComPort: TBComPort);
begin
  FComPort := AComPort;
end;

procedure TComDataPacket.EmptyBuffer;
begin
  FBuffer := '';
  FInPacket := False;
end;

procedure TComDataPacket.HandleBuffer;
var
  B, C, E: Integer;
  S: String;

  procedure StartPacket;
  begin
    if Length(FStartString) = 0 then FInPacket := True else
    begin
      B := Pos(FStartString, FBuffer);
      if B > 0 then
      begin
        FInPacket := True;
        if B > 1 then Delete(FBuffer, 1, B - 1);
      end;
    end;
  end;

  procedure EndPacket;
  begin
    B := Length(FStartString); E := Length(FStopString);
    if FSize > 0 then
    begin
      C := FSize;
      if Length(FBuffer) >= FSize then
      if E = 0 then FInPacket := False else
      begin
        FInPacket := False;
        if Copy(FBuffer, FSize - E + 1, E) <> FStopString then
        begin
          Delete(FBuffer, 1, 1); Exit;
        end;
      end;
    end else
    begin
      C := Pos(FStopString, Copy(FBuffer, B + 1, Length(FBuffer) - B));
      if C > 0 then
      begin
        C := C + E + B - 1;
        FInPacket := False;
      end;
    end;
    if not FInPacket then
    begin
      S := Copy(FBuffer, 1, C);
      Delete(FBuffer, 1, C);
      if not FIncludeStrings then
      begin
        if Pos(FStartString, S) = 1 then Delete(S, 1, B);
        B := Length(S) - E + 1;
        if Copy(S, B, E) = FStopString then Delete(S, B, E);
      end;
      FComPort.CallPacket(S);
    end;
  end;

begin
  try
    if not FInPacket then StartPacket;
    if FInPacket then
    begin
      EndPacket;
      if not FInPacket then HandleBuffer;
    end;
  finally
    if Length(FBuffer) >= FMaxBufferSize then EmptyBuffer;
  end;
end;

procedure TComDataPacket.SetMaxBufferSize(const Value: Integer);
begin
  if (FMaxBufferSize <> Value) and (Value > 0) and (Value > FSize) then
  begin
    FMaxBufferSize := Value;
    EmptyBuffer;
  end;
end;

procedure TComDataPacket.SetSize(const Value: Integer);
begin
  if (FSize <> Value) and (0 < Value) and (Value < FMaxBufferSize) then
  begin
    FSize := Value;
    EmptyBuffer;
  end;
end;

procedure TComDataPacket.SetStartString(const Value: String);
begin
  if (FStartString <> Value) and ((FSize = 0) or (FSize > 0) and
     (FSize > (Length(Value) + Length(FStopString)))) then
  begin
    FStartString := Value;
    EmptyBuffer;
  end;
end;

procedure TComDataPacket.SetStopString(const Value: String);
begin
  if (FStopString <> Value) and ((FSize = 0) or (FSize > 0) and
     (FSize > (Length(Value) + Length(FStartString)))) then
  begin
    FStopString := Value;
    EmptyBuffer;
  end;
end;

procedure TComDataPacket.AddData(const Value: String);
begin
  if FEnabled and IsPacketDefined then
  begin
    FBuffer := FBuffer + Value;
    HandleBuffer;
  end;
end;

function TComDataPacket.IsPacketDefined: Boolean;
begin
  Result := (FSize > 0) or (Length(FStopString) > 0);
end;

{ TBComPort }

constructor TBComPort.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComponentStyle := FComponentStyle - [csInheritable];
  FBaudRate := br9600;
  FCustomBaudRate := 9600;
  FByteSize := bs8;
  FConnected := False;
  FCTPriority := tpNormal;
  FEvents := [evRxChar, evTxEmpty, evRing, evBreak, evCTS, evDSR, evError,
              evRLSD, evRx80Full];
  FHandle := INVALID_HANDLE_VALUE;
  FInBufSize := 2048;
  FOutBufSize := 2048;
  FParity := paNone;
  FPort := 'COM1';
  FStopBits := sb1;
  FSyncMethod := smThreadSync;
  FTimeouts := TComTimeouts.Create;
  FTimeouts.SetComPort(Self);
  FDataPacket := TComDataPacket.Create;
  FDataPacket.SetComPort(Self);
end;

destructor TBComPort.Destroy;
begin
  try
    Close;
  finally
    FDataPacket.Free;
    FTimeouts.Free;
    inherited Destroy;
  end;
end;

procedure TBComPort.EnumComPorts(Ports: TStrings);
var
  KeyHandle: HKEY;
  ErrCode, Index: Integer;
  ValueName, Data: String;
  ValueLen, DataLen, ValueType: DWORD;
  TmpPorts: TStringList;
begin
  ErrCode := RegOpenKeyEx(HKEY_LOCAL_MACHINE, 'HARDWARE\DEVICEMAP\SERIALCOMM',
                          0, KEY_READ, KeyHandle);
  if ErrCode <> ERROR_SUCCESS then
    raise EComPort.Create(CEMess[14]);
  TmpPorts := TStringList.Create;
  try
    Index := 0;
    repeat
      ValueLen := 256;
      DataLen := 256;
      SetLength(ValueName, ValueLen);
      SetLength(Data, DataLen);
      ErrCode := RegEnumValue(KeyHandle, Index, PChar(ValueName),
                              {$IFDEF DELPHI_4_OR_HIGHER}
                              Cardinal(ValueLen),
                              {$ELSE}
                              ValueLen,
                              {$ENDIF}
                              nil, @ValueType, PByte(PChar(Data)), @DataLen);
      if ErrCode = ERROR_SUCCESS then
      begin
        SetLength(Data, DataLen - 1);
        TmpPorts.Add(Data);
        Inc(Index);
      end
      else
        if ErrCode <> ERROR_NO_MORE_ITEMS then
          raise EComPort.Create(CEMess[14]);
    until (ErrCode <> ERROR_SUCCESS) ;
    TmpPorts.Sort;
    Ports.Assign(TmpPorts);
  finally
    RegCloseKey(KeyHandle);
    TmpPorts.Free;
  end;
end;

procedure TBComPort.CreateHandle;
begin
  FHandle := CreateFile(PChar('\\.\' + FPort), GENERIC_READ or GENERIC_WRITE,
                        0, nil, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);
  if FHandle = INVALID_HANDLE_VALUE then
  case GetLastError of
    ERROR_FILE_NOT_FOUND: raise EComPort.Create(CEMess[1]);
    ERROR_ACCESS_DENIED : raise EComPort.Create(CEMess[2]);
  end;
end;

procedure TBComPort.DestroyHandle;
begin
  if FHandle <> INVALID_HANDLE_VALUE then
    if CloseHandle(FHandle) then FHandle := INVALID_HANDLE_VALUE;
end;

procedure TBComPort.WindowMethod(var Message: TMessage);
begin
  with Message do
  if Msg = CM_COMPORT then
  try
    if InSendMessage then ReplyMessage(0);
    if IsConnected then
    case wParam of
      EV_RXCHAR:   CallRxChar;
      EV_TXEMPTY:  CallTxEmpty;
      EV_RING:     CallRing;
      EV_BREAK:    CallBreak;
      EV_CTS:      CallCTSChange;
      EV_DSR:      CallDSRChange;
      EV_ERR:      CallError;
      EV_RLSD:     CallRLSDChange;
      EV_RX80FULL: CallRx80Full;
    end;
  except
    Application.HandleException(Self);
  end
  else
    Result := DefWindowProc(FWindow, Msg, wParam, lParam);
end;

procedure TBComPort.Open;
begin
  if not FConnected then
  begin
    CreateHandle;
    FConnected := True;
    try
      ApplyDCB;
      ApplyBuffer;
      ApplyTimeouts;
      if (FSyncMethod = smWindowSync) then
      {$IFDEF DELPHI_6_OR_HIGHER}
        {$WARN SYMBOL_DEPRECATED OFF}
      {$ENDIF}
        FWindow := AllocateHWnd(WindowMethod);
      {$IFDEF DELPHI_6_OR_HIGHER}
        {$WARN SYMBOL_DEPRECATED ON}
      {$ENDIF}
      FEventThread := TComThread.Create(Self);
    except
      DestroyHandle;
      FConnected := False;
      raise;
    end;
  end;
end;

procedure TBComPort.Close;
begin
  if FConnected then
  begin
    FEventThread.Free;
    if FSyncMethod = smWindowSync then
    {$IFDEF DELPHI_6_OR_HIGHER}
      {$WARN SYMBOL_DEPRECATED OFF}
    {$ENDIF}
      DeallocateHWnd(FWindow);
    {$IFDEF DELPHI_6_OR_HIGHER}
      {$WARN SYMBOL_DEPRECATED ON}
    {$ENDIF}
    DestroyHandle;
    FConnected := False;
  end;
end;

procedure TBComPort.ApplyBuffer;
begin
  if FConnected then
    if not SetupComm(FHandle, FInBufSize, FOutBufSize) then
      raise EComPort.Create(CEMess[9]);
end;

procedure TBComPort.ApplyDCB;
const
  CBaudRate: array[TBaudRate] of Integer = (0, CBR_110, CBR_300, CBR_600,
    CBR_1200, CBR_2400, CBR_4800, CBR_9600, CBR_14400, CBR_19200, CBR_38400,
    CBR_56000, CBR_57600, CBR_115200, CBR_128000, CBR_230400, CBR_256000,
    CBR_460800, CBR_500000, CBR_576000, CBR_921600, CBR_1000000, CBR_1152000,
    CBR_1500000, CBR_2000000, CBR_2500000, CBR_3000000, CBR_3500000,
    CBR_4000000);
var
  DCB: TDCB;
begin
  if FConnected then
  begin
    FillChar(DCB, SizeOf(TDCB), 0);
    DCB.DCBlength := SizeOf(TDCB);
    if FBaudRate = brCustom then
      DCB.BaudRate := FCustomBaudRate
    else
      DCB.BaudRate := CBaudRate[FBaudRate];
    DCB.Flags := 1 or ($30 and (DTR_CONTROL_ENABLE shl 4))
                   or ($3000 and (RTS_CONTROL_ENABLE shl 12));
    if FParity <> paNone then
      DCB.Flags := DCB.Flags or 2;
    DCB.ByteSize := Ord(TByteSize(FByteSize)) + 5;
    DCB.Parity   := Ord(TParity(FParity));
    DCB.StopBits := Ord(TStopBits(FStopBits));
    DCB.XonChar  := #17;
    DCB.XoffChar := #19;
    if not SetCommState(FHandle, DCB) then
      raise EComPort.Create(CEMess[7]);
  end;
end;

procedure TBComPort.ApplyTimeouts;
var
  Timeouts: TCommTimeouts;

  function MValue(const Value: Integer): DWORD;
  begin
    if Value < 0 then Result := MAXDWORD else Result := Value;
  end;

begin
  if FConnected then
  begin
    Timeouts.ReadIntervalTimeout := MValue(FTimeouts.ReadInterval);
    Timeouts.ReadTotalTimeoutMultiplier := MValue(FTimeouts.ReadTotalMultiplier);
    Timeouts.ReadTotalTimeoutConstant := MValue(FTimeouts.ReadTotalConstant);
    Timeouts.WriteTotalTimeoutMultiplier := MValue(FTimeouts.WriteTotalMultiplier);
    Timeouts.WriteTotalTimeoutConstant := MValue(FTimeouts.WriteTotalConstant);
    if not SetCommTimeouts(FHandle, Timeouts) then
      raise EComPort.Create(CEMess[8]);
  end;
end;

procedure TBComPort.CallBreak;
begin
  if Assigned(FOnBreak) then FOnBreak(Self);
end;

procedure TBComPort.CallCTSChange;
begin
  if Assigned(FOnCTSChange) then FOnCTSChange(Self, csCTS in Signals);
end;

procedure TBComPort.CallDSRChange;
begin
  if Assigned(FOnDSRChange) then FOnDSRChange(Self, csDSR in Signals);
end;

procedure TBComPort.CallError;
var
  Errs: TComErrors;
  Errors: DWORD;
  ComStat: TComStat;
begin
  if not ClearCommError(FHandle, Errors, @ComStat) then
    raise EComPort.Create(CEMess[10]);
  Errs := [];
  if (CE_FRAME and Errors) <> 0 then Errs := Errs + [ceFrame];
  if ((CE_RXPARITY and Errors) <> 0) and (FParity <> paNone) then
    Errs := Errs + [ceRxParity];
  if (CE_OVERRUN and Errors) <> 0 then Errs := Errs + [ceOverrun];
  if (CE_RXOVER and Errors) <> 0 then Errs := Errs + [ceRxOver];
  if (CE_TXFULL and Errors) <> 0 then Errs := Errs + [ceTxFull];
  if (CE_BREAK and Errors) <> 0 then Errs := Errs + [ceBreak];
  if (CE_IOE and Errors) <> 0 then Errs := Errs + [ceIO];
  if (CE_MODE and Errors) <> 0 then Errs := Errs + [ceMode];
  if (Errs <> []) and Assigned(FOnError) then FOnError(Self, Errs);
end;

procedure TBComPort.CallPacket(const Value: String);
begin
  if Assigned(FOnPacket) then FOnPacket(Self, Value);
end;

procedure TBComPort.CallRing;
begin
  if Assigned(FOnRing) then FOnRing(Self);
end;

procedure TBComPort.CallRLSDChange;
begin
  if Assigned(FOnRLSDChange) then FOnRLSDChange(Self, csRLSD in Signals);
end;

procedure TBComPort.CallRx80Full;
begin
  if Assigned(FOnRx80Full) then FOnRx80Full(Self);
end;

procedure TBComPort.CallRxChar;
var
  S: String;
  Count: Integer;
begin
  Count := InBufCount;
  if Count > 0 then
  if FDataPacket.Enabled and FDataPacket.PacketDefined then
  begin
    ReadStr(S, Count); FDataPacket.AddData(S);
  end else
  begin
    if Assigned(FOnRxChar) then FOnRxChar(Self, Count);
  end;
end;

procedure TBComPort.CallTxEmpty;
begin
  if Assigned(FOnTxEmpty) then FOnTxEmpty(Self);
end;

function TBComPort.IsConnected: Boolean;
begin
  Result := FConnected;
  if not Result then raise EComPort.Create(CEMess[3]);
end;

procedure TBComPort.PurgeAll;
begin
  if not PurgeComm(FHandle, PURGE_TXABORT or PURGE_RXABORT or
    PURGE_TXCLEAR or PURGE_RXCLEAR) then
      raise EComPort.Create(CEMess[6]);
end;

procedure TBComPort.SetBaudRate(const Value: TBaudRate);
begin
  if Value <> FBaudRate then
  begin
    FBaudRate := Value;
    ApplyDCB;
  end;
end;

procedure TBComPort.SetByteSize(const Value: TByteSize);
begin
  if Value <> FByteSize then
  begin
    FByteSize := Value;
    ApplyDCB;
  end;
end;

procedure TBComPort.SetCTPriority(const Value: TThreadPriority);
begin
  if Value <> FCTPriority then
    if FConnected then
      raise EComPort.Create(CEMess[13])
    else
      FCTPriority := Value;
end;

procedure TBComPort.SetCustomBaudRate(const Value: Integer);
begin
  if Value <> FCustomBaudRate then
  begin
    FCustomBaudRate := Value;
    ApplyDCB;
  end;
end;

procedure TBComPort.SetDataPacket(const Value: TComDataPacket);
begin
  FDataPacket.Assign(Value);
end;

procedure TBComPort.SetInBufSize(const Value: Integer);
begin
  if Value <> FInBufSize then
  begin
    FInBufSize := Value;
    if (FInBufSize mod 2) = 1 then Dec(FInBufSize);
    ApplyBuffer;
  end;
end;

procedure TBComPort.SetOutBufSize(const Value: Integer);
begin
  if Value <> FOutBufSize then
  begin
    FOutBufSize := Value;
    if (FOutBufSize mod 2) = 1 then Dec(FOutBufSize);
    ApplyBuffer;
  end;
end;

procedure TBComPort.SetParity(const Value: TParity);
begin
  if Value <> FParity then
  begin
    FParity := Value;
    ApplyDCB;
  end;
end;

procedure TBComPort.SetPort(const Value: String);
begin
  if FConnected then
    raise EComPort.Create(CEMess[13])
  else
    if Value <> FPort then FPort := Value;
end;

procedure TBComPort.SetStopBits(const Value: TStopBits);
begin
  if Value <> FStopBits then
  begin
    FStopBits := Value;
    ApplyDCB;
  end;
end;

procedure TBComPort.SetSyncMethod(const Value: TSyncMethod);
begin
  if Value <> FSyncMethod then
    if FConnected then
      raise EComPort.Create(CEMess[13])
    else
      FSyncMethod := Value;
end;

procedure TBComPort.SetTimeouts(const Value: TComTimeouts);
begin
  FTimeouts.Assign(Value);
  ApplyTimeouts;
end;

procedure TBComPort.ClearBuffer(Input, Output: Boolean);
var Flag: DWORD;
begin
  Flag := 0;
  if Input then
    Flag := PURGE_RXCLEAR;
  if Output then
    Flag := Flag or PURGE_TXCLEAR;
  if not PurgeComm(FHandle, Flag) then
     raise EComPort.Create(CEMess[6]);
end;

function TBComPort.InBufCount: Integer;
var
  Errors: DWORD;
  ComStat: TComStat;
begin
  if not ClearCommError(FHandle, Errors, @ComStat) then
    raise EComPort.Create(CEMess[10]);
  Result := ComStat.cbInQue;
end;

function TBComPort.OutBufCount: Integer;
var
  Errors: DWORD;
  ComStat: TComStat;
begin
//  закоментировано мной 28.04.2012
  if not ClearCommError(FHandle, Errors, @ComStat) then
    raise EComPort.Create(CEMess[10]);

  Result := ComStat.cbOutQue;
end;

function TBComPort.Read(var Buffer; Count: Integer): Integer;
var
  BytesRead: DWORD;
  Overlap: TOverlapped;
begin
  Result := 0;
  if IsConnected and (Count > 0) then
  begin
    FillChar(Overlap, SizeOf(TOverlapped), 0);
    Overlap.hEvent := CreateEvent(nil, True, True, nil);
    try
      if (ReadFile(FHandle, Buffer, Count, BytesRead, @Overlap) or
         (GetLastError = ERROR_IO_PENDING)) and
         ((WaitForSingleObject(Overlap.hEvent, INFINITE) = WAIT_OBJECT_0) and
          GetOverlappedResult(FHandle, Overlap, BytesRead, False)) then
        Result := BytesRead
      else
        raise EComPort.Create(CEMess[5]);
    finally
      CloseHandle(Overlap.hEvent);
    end;
  end;
end;

function TBComPort.ReadStr(var Str: String; Count: Integer): Integer;
begin
  SetLength(Str, Count);
  Result := Read(Str[1], Count);
  SetLength(Str, Result);
end;

procedure TBComPort.SetBreak(State: Boolean);
var
  Act: DWORD;
begin
  if State then Act := Windows.SETBREAK else Act := Windows.CLRBREAK;
  if IsConnected then if not EscapeCommFunction(FHandle, Act) then
    raise EComPort.Create(CEMess[12]);
end;

procedure TBComPort.SetDTR(State: Boolean);
var
  Act: DWORD;
begin
  if State then Act := Windows.SETDTR else Act := Windows.CLRDTR;
  if IsConnected then if not EscapeCommFunction(FHandle, Act) then
    raise EComPort.Create(CEMess[12]);
end;

procedure TBComPort.SetRTS(State: Boolean);
var
  Act: DWORD;
begin
  if State then Act := Windows.SETRTS else Act := Windows.CLRRTS;
  if IsConnected then if not EscapeCommFunction(FHandle, Act) then
    raise EComPort.Create(CEMess[12]);
end;

function TBComPort.Signals: TComSignals;
var
  Status: DWORD;
begin
  if IsConnected then  if not GetCommModemStatus(FHandle, Status) then
    raise EComPort.Create(CEMess[11]);
  Result := [];
  if (MS_CTS_ON and Status) <> 0 then Result := Result + [csCTS];
  if (MS_DSR_ON and Status) <> 0 then Result := Result + [csDSR];
  if (MS_RING_ON and Status) <> 0 then Result := Result + [csRing];
  if (MS_RLSD_ON and Status) <> 0 then Result := Result + [csRLSD];
end;

function TBComPort.Write(const Buffer; Count: Integer): Integer;
var
  BytesTrans: DWORD;
  Overlap: TOverlapped;
begin
  Result := 0;
  if IsConnected and (Count > 0) then
  begin
    FillChar(Overlap, SizeOf(TOverlapped), 0);
    Overlap.hEvent := CreateEvent(nil, True, True, nil);
    try
      if (WriteFile(FHandle, Buffer, Count, BytesTrans, @Overlap) or
         (GetLastError = ERROR_IO_PENDING)) and
         ((WaitForSingleObject(Overlap.hEvent, INFINITE) = WAIT_OBJECT_0) and
          GetOverlappedResult(FHandle, Overlap, BytesTrans, False)) then
        Result := BytesTrans
      else
        raise EComPort.Create(CEMess[4]);
    finally
      CloseHandle(Overlap.hEvent);
    end;
  end;
end;

function TBComPort.WriteStr(const Str: String): Integer;
begin
  Result := Write(Str[1], Length(Str));
end;

procedure Register;
begin
  RegisterComponents('Samples', [TBComPort]);
end;

end.

