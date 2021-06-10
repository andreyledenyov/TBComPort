///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//     ���������������� ������ ������������� ���������� TBComPort v.2.20     //
// ����������� ������� ������������� ���� ������� � ��������� ���� �������   //
// ����������, � ����� ���������� ������������ ����� ������� ����������.     //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////

unit MainDemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, BCPort, ExtCtrls;

type
  TDemoForm = class(TForm)
    GroupBox1: TGroupBox;
    btnOpen: TButton;
    btnClose: TButton;
    cbPort: TComboBox;
    Label1: TLabel;
    cbBaudRate: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    edCustomBR: TEdit;
    Label4: TLabel;
    edInBufSize: TEdit;
    Label5: TLabel;
    edOutBufSize: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    cbByteSize: TComboBox;
    cbParity: TComboBox;
    cbStopBits: TComboBox;
    cbSyncMethod: TComboBox;
    cbThreadPriority: TComboBox;
    GroupBox2: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    edRI: TEdit;
    edRTM: TEdit;
    edRTC: TEdit;
    edWTM: TEdit;
    edWTC: TEdit;
    GroupBox3: TGroupBox;
    cbEnabled: TCheckBox;
    cbInStr: TCheckBox;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    edPacketSize: TEdit;
    edStartString: TEdit;
    edStopString: TEdit;
    btnSet: TButton;
    Memo: TMemo;
    btnClear: TButton;
    edSend: TEdit;
    btnSend: TButton;
    cbHex: TCheckBox;
    cbMHex: TCheckBox;
    Label19: TLabel;
    edMaxBufferSize: TEdit;
    GroupBox4: TGroupBox;
    lbCTS: TLabel;
    cbDTR: TCheckBox;
    cbRTS: TCheckBox;
    cbBREAK: TCheckBox;
    lbDSR: TLabel;
    lbRI: TLabel;
    lbRLSD: TLabel;
    cbEvents: TCheckBox;
    BComPort1: TBComPort;
    procedure FormCreate(Sender: TObject);
    procedure edCustomBRKeyPress(Sender: TObject; var Key: Char);
    procedure edSendKeyPress(Sender: TObject; var Key: Char);
    procedure btnClearClick(Sender: TObject);
    procedure cbPortChange(Sender: TObject);
    procedure cbBaudRateChange(Sender: TObject);
    procedure cbParityChange(Sender: TObject);
    procedure cbByteSizeChange(Sender: TObject);
    procedure cbStopBitsChange(Sender: TObject);
    procedure cbSyncMethodChange(Sender: TObject);
    procedure cbThreadPriorityChange(Sender: TObject);
    procedure cbEnabledClick(Sender: TObject);
    procedure cbInStrClick(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure cbBREAKClick(Sender: TObject);
    procedure cbDTRClick(Sender: TObject);
    procedure cbRTSClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure BComPort1RxChar(Sender: TObject; Count: Integer);
    procedure BComPort1Packet(Sender: TObject; const Str: String);
    procedure BComPort1Break(Sender: TObject);
    procedure BComPort1CTSChange(Sender: TObject; State: Boolean);
    procedure BComPort1DSRChange(Sender: TObject; State: Boolean);
    procedure BComPort1Ring(Sender: TObject);
    procedure BComPort1RLSDChange(Sender: TObject; State: Boolean);
    procedure BComPort1Rx80Full(Sender: TObject);
    procedure BComPort1TxEmpty(Sender: TObject);
    procedure BComPort1Error(Sender: TObject; Errors: TComErrors);
  private
    { Private declarations }
    function StringHandling(const Value: String): String;
    procedure DoSignals;
  public
    { Public declarations }
  end;

var
  DemoForm: TDemoForm;

implementation

{$R *.DFM}

(* ��� ������� ��������� *)
procedure TDemoForm.FormCreate(Sender: TObject);
begin
  // ��������� ������ ���-������
  BComPort1.EnumComPorts(cbPort.Items);
  if cbPort.Items.Count > 0 then cbPort.ItemIndex := 0;
  // ��������� �������������� ������� (ComboBox) � ��������� ���������
  cbBaudRate.ItemIndex := 7;       // BaudRate       = br9600
  cbParity.ItemIndex := 0;         // Parity         = paNone
  cbByteSize.ItemIndex := 3;       // ByteSize       = bs8
  cbStopBits.ItemIndex := 0;       // StopBits       = sb1
  cbSyncMethod.ItemIndex := 0;     // SyncMethod     = smThreadSync
  cbThreadPriority.ItemIndex := 3; // ThreadPriority = tpNormal
end;

(* ���������� ������������� ����� ��� ����������� TEdit � ��������� ������� *)
procedure TDemoForm.edCustomBRKeyPress(Sender: TObject; var Key: Char);
begin
  // ����������� ���� ������ ����, ����� "-" � ������ ���������� ��������
  if not (Key in ['0'..'9', '-', #3, #8, #22, #24, #26]) then Key := #1;
end;

(* ���������� ������������� ����� ���� ����� ������������ ������ *)
procedure TDemoForm.edSendKeyPress(Sender: TObject; var Key: Char);
begin
  // ����������� ���� ������ �������� ����������������� ��������, �������
  // � ������ ���������� ��������, ���� ������ ����� ��� ������������� ������
  if cbHex.Checked and (not (Key in ['0'..'9', 'A'..'F', 'a'..'f', ' ', #3,
    #8, #22, #24, #26])) then Key := #1;
end;

(* ������� ���� ����������� ����������� ������ (Memo) *)
procedure TDemoForm.btnClearClick(Sender: TObject);
begin
  Memo.Lines.Clear;
end;


///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                   ��������� ������� (��������) ����������                 //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


(* ��������� �������� "Port" *)
procedure TDemoForm.cbPortChange(Sender: TObject);
begin
  BComPort1.Port := cbPort.Text;
end;

(* ��������� �������� "BaudRate" � "CustomBaudRate" *)
procedure TDemoForm.cbBaudRateChange(Sender: TObject);
begin
  BComPort1.CustomBaudRate := StrToInt(edCustomBR.Text); // CustomBaudRate
  BComPort1.BaudRate := TBaudRate(cbBaudRate.ItemIndex); // BaudRate
end;

(* ��������� �������� "Parity" *)
procedure TDemoForm.cbParityChange(Sender: TObject);
begin
  BComPort1.Parity := TParity(cbParity.ItemIndex);
end;

(* ��������� �������� "ByteSize" *)
procedure TDemoForm.cbByteSizeChange(Sender: TObject);
begin
  BComPort1.ByteSize := TByteSize(cbByteSize.ItemIndex);
end;

(* ��������� �������� "StopBits" *)
procedure TDemoForm.cbStopBitsChange(Sender: TObject);
begin
  BComPort1.StopBits := TStopBits(cbStopBits.ItemIndex);
end;

(* ��������� �������� "SyncMethod" *)
procedure TDemoForm.cbSyncMethodChange(Sender: TObject);
begin
  BComPort1.SyncMethod := TSyncMethod(cbSyncMethod.ItemIndex);
end;

(* ��������� �������� "ThreadPriority" *)
procedure TDemoForm.cbThreadPriorityChange(Sender: TObject);
begin
  BComPort1.ThreadPriority := TThreadPriority(cbThreadPriority.ItemIndex);
end;

(* ��������� �������� "DataPacket.Enabled" *)
procedure TDemoForm.cbEnabledClick(Sender: TObject);
begin
  BComPort1.DataPacket.Enabled := cbEnabled.Checked;
end;

(* ��������� �������� "DataPacket.IncludeStrings" *)
procedure TDemoForm.cbInStrClick(Sender: TObject);
begin
   BComPort1.DataPacket.IncludeStrings := cbInStr.Checked;
end;

(* ��������� ������� DataPacket: MaxBufferSize, PacketSize, StartString � StopString *)
procedure TDemoForm.btnSetClick(Sender: TObject);
begin
  with BComPort1.DataPacket do
  begin
    MaxBufferSize := StrToInt(edMaxBufferSize.Text);
    PacketSize := StrToInt(edPacketSize.Text);
    StartString := edStartString.Text;
    StopString :=  edStopString.Text;
  end;
end;


///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                            ��������-�������� �����                        //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


(* ������� ������ "OPEN" - �������� ����� *)
procedure TDemoForm.btnOpenClick(Sender: TObject);
begin

  // ��������� �������� � ������������ � �������� ����������
  // ����� �� ���������, ���� ����� ������������ ��������, �������� �
  // ���������� BComPort1 �� ����� ��������������� �����
//-----------------------------------------------------------------------------

  cbPortChange(Self);           // Port
  cbBaudRateChange(Self);       // BaudRate (CustomBaudRate)
  cbByteSizeChange(Self);       // ByteSize
  BComPort1.InBufSize := StrToInt(edInBufSize.Text);   // InBufSize
  BComPort1.OutBufSize := StrToInt(edOutBufSize.Text); // OutBufSize
  cbParityChange(Self);         // Parity
  cbStopBitsChange(Self);       // StopBits
  cbSyncMethodChange(Self);     // SyncMethod
  cbThreadPriorityChange(Self); // ThreadPriority

  // ��������
  with BComPort1.Timeouts do
  begin
    ReadInterval := StrToInt(edRI.Text);
    ReadTotalMultiplier := StrToInt(edRTM.Text);
    ReadTotalConstant := StrToInt(edRTC.Text);
    WriteTotalMultiplier := StrToInt(edWTM.Text);
    WriteTotalConstant := StrToInt(edWTC.Text);
  end;

  // DataPacket
  cbEnabledClick(Self);
  cbInStrClick(Self);
  btnSetClick(Self);

//-----------------------------------------------------------------------------

  // �������� �����
  BComPort1.Open;
  if BComPort1.Connected then // ���� ������� ������
  begin
    btnClose.Enabled := True;  btnOpen.Enabled := False;
    DoSignals; // ��������� ��������� ������� ����� �����
  end;
  // ������ ������� ����� ����������� ������� � ����� ��������� ������
  // ������ � ���� � ������ �� �����
end;

(* ������� ������ "CLOSE" - �������� ����� *)
procedure TDemoForm.btnCloseClick(Sender: TObject);
begin
  BComPort1.Close;
  if not BComPort1.Connected then // ���� ������� ������
  begin
    btnClose.Enabled := False;  btnOpen.Enabled := True;
  end;
  // ������ ����� ����������� ������� ����������, ������ ������ � ����
  // � ������ �� ����� ��������� ������
end;


///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                     ���������� ��������� ������� �����                    //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


(* ���������/����� ��������� "������ �����" �� ����� TX ����� *)
procedure TDemoForm.cbBREAKClick(Sender: TObject);
begin
  BComPort1.SetBreak(cbBREAK.Checked);
end;

(* ���������/����� ������� DTR ����� *)
procedure TDemoForm.cbDTRClick(Sender: TObject);
begin
  BComPort1.SetDTR(cbDTR.Checked);
end;

(* ���������/����� ������� RTS ����� *)
procedure TDemoForm.cbRTSClick(Sender: TObject);
begin
  BComPort1.SetRTS(cbRTS.Checked);
end;


///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                            �������� ������ � ����                         //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


(* ������� ������ "SEND" - �������� ������ � ���� *)
procedure TDemoForm.btnSendClick(Sender: TObject);
var
  S, W: String;
begin
  W := edSend.Text;
  if cbHex.Checked then // ������ ��� �������� - � ����������������� ����
  begin
    // �������� �������� �� ������ � �������
    while Pos(' ', W) > 0 do Delete(W, Pos(' ', W), 1);
    // ���� �������� ���������� �������� � ������, ������� ���������
    if (Length(W) mod 2) > 0 then Delete(W, Length(W), 1);
    // ������������ ������ ��� �������� � ����
    S := '';
    if Length(W) > 0 then
    repeat
      S := S + Chr(StrToInt('$' + Copy(W, 1, 2))); Delete(W, 1, 2);
    until Length(W) = 0;
    W := S;
  end;
  if Length(W) > 0 then   // ���� ���� ��� ����������...
    BComPort1.WriteStr(W);
  edSend.SetFocus;
end;


///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//              ����� ������ �� ����� � ��������� ������ �������             //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


(* ��������� ������ ��� �������� � ���� ����������� (Memo) *)
function TDemoForm.StringHandling(const Value: String): String;
var
  N: Integer;
begin
  if cbMHex.Checked then
  // ���� ��������� ���������� ������ � ����������������� ����, ������������ ��
  begin
    Result := '';
    for N := 1 to Length(Value) do
      Result := Result + IntToHex(Ord(Value[N]), 2) + ' ';
  end else
  // ���� ��������� ���������� ������ � ���������� ����
  begin
      Result := Value;
    // ���������� ������� ���������� �� "."
    for N := 1 to Length(Result) do
      if Result[N] < ' ' then Result[N] := '.';
  end;
end;

(* � �������� ����� ����� ��������� ������ *)
procedure TDemoForm.BComPort1RxChar(Sender: TObject; Count: Integer);
var
  S: String;
begin
  // ������ ����������� ������
  BComPort1.ReadStr(S, Count);
  // ���������� ������ � ���� ����������� (Memo)
  Memo.Lines.Add('<OnRxChar> ' + StringHandling(S));
end;

(* �� �������� ������ ������ ��������� ����� *)
procedure TDemoForm.BComPort1Packet(Sender: TObject; const Str: String);
begin
  // ���������� ������ � ���� ����������� (Memo)
  Memo.Lines.Add('<OnPacket> ' + StringHandling(Str));
end;

(* ���������� ��������� ������� ����� *)
procedure TDemoForm.BComPort1Break(Sender: TObject);
begin
  if cbEvents.Checked then
    Memo.Lines.Add('<OnBreak> - ���������� ��������� BREAK (������ �����)');
end;

(* ����������� ��������� ������� ����� ����� ��� ��������� �� ��������� *)
procedure TDemoForm.DoSignals;
var
  Sign: TComSignals;
begin
  Sign := BComPort1.Signals;
  if (csCTS in Sign) then lbCTS.Font.Color := clRed else
    lbCTS.Font.Color := $00555675;
  if (csDSR in Sign) then lbDSR.Font.Color := clRed else
    lbDSR.Font.Color := $00555675;
  if (csRing in Sign) then lbRI.Font.Color := clRed else
    lbRI.Font.Color := $00555675;
  if (csRLSD in Sign) then lbRLSD.Font.Color := clRed else
    lbRLSD.Font.Color := $00555675;
end;

(* ���������� ��������� ������� ����� CTS *)
procedure TDemoForm.BComPort1CTSChange(Sender: TObject; State: Boolean);
var
  S: String;
begin
  DoSignals;
  if State then S := '���������� ������ CTS' else S := '������� ������ CTS';
  if cbEvents.Checked then Memo.Lines.Add('<OnCTSChange> - ' + S);
end;

(* ���������� ��������� ������� ����� DSR *)
procedure TDemoForm.BComPort1DSRChange(Sender: TObject; State: Boolean);
var
  S: String;
begin
  DoSignals;
  if State then S := '���������� ������ DSR' else S := '������� ������ DSR';
  if cbEvents.Checked then Memo.Lines.Add('<OnDSRChange> - ' + S);
end;

(* ��������� ������� ������ RING (������ �� �����) *)
procedure TDemoForm.BComPort1Ring(Sender: TObject);
begin
  DoSignals;
  if cbEvents.Checked then
    Memo.Lines.Add('<OnBreak> - ��������� ������ RING (������ �� �����)');
end;

(* ���������� ��������� ������� ����� RLSD *)
procedure TDemoForm.BComPort1RLSDChange(Sender: TObject; State: Boolean);
var
  S: String;
begin
  DoSignals;
  if State then S := '���������� ������ RLSD' else S := '������� ������ RLSD';
  if cbEvents.Checked then Memo.Lines.Add('<OnRLSDChange> - ' + S);
end;

(* �������� ����� �������� �� 80 ��������� *)
procedure TDemoForm.BComPort1Rx80Full(Sender: TObject);
begin
  if cbEvents.Checked then
    Memo.Lines.Add('<OnRx80Full> - �������� ����� �������� �� 80 ���������');
end;

(* ����� �������� ����� ���� *)
procedure TDemoForm.BComPort1TxEmpty(Sender: TObject);
begin
  if cbEvents.Checked then
    Memo.Lines.Add('<OnTxEmpty> - ����� �������� ����� ����');
end;

(* ���������� ������ ����� *)
procedure TDemoForm.BComPort1Error(Sender: TObject; Errors: TComErrors);
var
  S: String;
begin
  if ceBreak in Errors then S := '���������� ��������� ������� �����';
  if ceFrame in Errors then S := '������ ������� �����';
  if ceIO in Errors then S := '������ �����-������';
  if ceMode in Errors then S := '����������� ����� �� ��������������';
  if ceOverrun in Errors then S := '������������ ����������� ������';
  if ceRxOver in Errors then S := '������������ ��������� ������ �������� �����';
  if ceRxParity in Errors then S := '������ ��������';
  if ceTxFull in Errors then S := '������������ ������ �������� �������� �����';
  if cbEvents.Checked then Memo.Lines.Add('<OnError> - ' + S);
end;

end.
