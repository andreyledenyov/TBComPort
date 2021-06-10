///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//   ���������������� ������ ������������� ���������� TBComPort. ����������  //
// ������� �������� ������ ������� ����� ���-���� ���������� � ����������    //
// � �������� ����. ��������� ��������� ����������� � ��������� �������.     //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////

unit MainTerminal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, BSetUnit, BCPort, Registry, BDialog, TableUnit;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    lbPort: TLabel;
    cbPort: TComboBox;
    lbBaud: TLabel;
    cbBaud: TComboBox;
    btnSettings: TButton;
    cbSend: TComboBox;
    cbHx: TCheckBox;
    btnSend: TButton;
    btnSF: TButton;
    btnOpen: TButton;
    btnClose: TButton;
    Panel3: TPanel;
    Memo: TMemo;
    Panel4: TPanel;
    btnClear: TButton;
    btnSave: TButton;
    cbHex: TCheckBox;
    Bevel1: TBevel;
    cbDTR: TCheckBox;
    cbRTS: TCheckBox;
    cbBreak: TCheckBox;
    lbCTS: TLabel;
    lbDSR: TLabel;
    lbRI: TLabel;
    lbRLSD: TLabel;
    btnTable: TButton;
    CP: TBComPort;
    procedure btnSettingsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cbSendKeyPress(Sender: TObject; var Key: Char);
    procedure cbSendKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbSendKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOpenClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure cbPortChange(Sender: TObject);
    procedure cbBaudChange(Sender: TObject);
    procedure cbDTRClick(Sender: TObject);
    procedure cbRTSClick(Sender: TObject);
    procedure cbBreakClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnSFClick(Sender: TObject);
    procedure CPRxChar(Sender: TObject; Count: Integer);
    procedure CPCTSChange(Sender: TObject; State: Boolean);
    procedure CPRing(Sender: TObject);
    procedure btnTableClick(Sender: TObject);
  private
    { Private declarations }
    RG: TRegistry;
    FInitDir: String;
    procedure RGReadStrings(const AName: String; ALst: TStrings);
    procedure RGWriteStrings(const AName: String; ALst: TStrings);
    procedure DoSignals;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}
{$R xp.res}

const
  MKey = 'Software\Majar\Terminal';

(* ������ �� ������� ��������� REG_MULTI_SZ *)
procedure TMainForm.RGReadStrings(const AName: String; ALst: TStrings);
var
  VType, VLen: DWORD;
  P, Buffer: PChar;
begin
  ALst.Clear;
  if RegQueryValueEx(RG.CurrentKey, PChar(AName), nil, @VType,
    nil, @VLen) = ERROR_SUCCESS then if VType = REG_MULTI_SZ then
  begin
    GetMem(Buffer, VLen);
    try
      RegQueryValueEx(RG.CurrentKey, PChar(AName), nil,
        nil, PByte(Buffer), @VLen);
      P := Buffer;
      while P^ <> #0 do begin ALst.Add(P); Inc(P, lstrlen(P) + 1); end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

(* ������ � ������ ��������� REG_MULTI_SZ *)
procedure TMainForm.RGWriteStrings(const AName: String; ALst: TStrings);
var
  P, Buffer: PChar;
  I: Integer;
  Sz: DWORD;
begin
  Sz := 0; for I := 0 to ALst.Count - 1 do Inc(Sz, Length(ALst[I]) + 1) ;
  Inc(Sz); GetMem(Buffer, Sz);
  try
    P := Buffer;
    for I := 0 to ALst.Count - 1 do
      begin lstrcpy(P, PChar(ALst[I])); Inc(P, lstrlen(P) + 1); end;
    P^ := #0;
    RegSetValueEx(RG.CurrentKey, PChar(AName), 0, REG_MULTI_SZ, Buffer, Sz);
  finally
    FreeMem(Buffer);
  end;
end;

(* ����� ���� �������� *)
procedure TMainForm.btnSettingsClick(Sender: TObject);
begin
  SetForm.ShowModal;
end;

(* �������� ��� ������� ��������� *)
procedure TMainForm.FormCreate(Sender: TObject);
begin
  // �������� ���� ��������
  SetForm := TSetForm.Create(Self);
  // ������ ���-������ ����������
  CP.EnumComPorts(cbPort.Items);
  // ��������� �� �������
  RG := TRegistry.Create; RG.LazyWrite := False;
  with RG do
  begin
    OpenKey(MKey, True);
    // ������� � ������ �������� ����
    if ValueExists('Left') then MainForm.Left := ReadInteger('Left');
    if ValueExists('Top') then MainForm.Top := ReadInteger('Top');
    if ValueExists('Height') then MainForm.Height := ReadInteger('Height');
    if ValueExists('Width') then MainForm.Width := ReadInteger('Width');
    // ��������� ������� �������
    if ValueExists('InitDir') then FInitDir := ReadString('InitDir') else
      FInitDir := '.';
    // COM-����
    if ValueExists('Port') then cbPort.ItemIndex := ReadInteger('Port') else
      cbPort.ItemIndex := 0; cbPortChange(Self);
    // BaudRate
    if ValueExists('BaudRate') then cbBaud.ItemIndex := ReadInteger('BaudRate') else
      cbBaud.ItemIndex := 10; cbBaudChange(Self);
    // CustomBaudRate
    if ValueExists('CustomBR') then SetForm.edCustom.Text := ReadString('CustomBR') else
      SetForm.edCustom.Text := '38400';
      CP.CustomBaudRate := StrToInt(SetForm.edCustom.Text);
    // ByteSize
    if ValueExists('ByteSize') then SetForm.cbByteSize.ItemIndex := ReadInteger('ByteSize') else
      SetForm.cbByteSize.ItemIndex := 3;
      CP.ByteSize := TByteSize(SetForm.cbByteSize.ItemIndex);
    // Parity
    if ValueExists('Parity') then SetForm.cbParity.ItemIndex := ReadInteger('Parity') else
      SetForm.cbParity.ItemIndex := 0;
      CP.Parity := TParity(SetForm.cbParity.ItemIndex);
    // StopBits
    if ValueExists('StopBits') then SetForm.cbStopBits.ItemIndex := ReadInteger('StopBits') else
      SetForm.cbStopBits.ItemIndex := 0;
      CP.StopBits := TStopBits(SetForm.cbStopBits.ItemIndex);
    // ����������������� ����������� Memo
    if ValueExists('MHex') then cbHex.Checked := ReadBool('MHex');
    // ����������������� ����� cbSend
    if ValueExists('SHex') then cbHx.Checked := ReadBool('SHex');
    // ������ cbSend
    if ValueExists('SendList') then RGReadStrings('SendList', cbSend.Items);
    if cbSend.Items.Count > 0 then cbSend.ItemIndex := 0;
    CloseKey;
  end;
end;

(* �������� ��� ���������� ��������� *)
procedure TMainForm.FormDestroy(Sender: TObject);
begin
  // ���������� �������� � �������
  with RG do
  begin
    OpenKey(MKey, True);
    WriteString('InitDir', FInitDir);
    WriteInteger('Left', MainForm.Left);
    WriteInteger('Top', MainForm.Top);
    WriteInteger('Height', MainForm.Height);
    WriteInteger('Width', MainForm.Width);
    WriteInteger('Port', cbPort.ItemIndex);
    WriteInteger('BaudRate', cbBaud.ItemIndex);
    WriteString('CustomBR', SetForm.edCustom.Text);
    WriteInteger('ByteSize', SetForm.cbByteSize.ItemIndex);
    WriteInteger('Parity', SetForm.cbParity.ItemIndex);
    WriteInteger('StopBits', SetForm.cbStopBits.ItemIndex);
    WriteBool('MHex', cbHex.Checked);
    WriteBool('SHex', cbHx.Checked);
    with cbSend do
    if Items.Count > 0 then
    begin
      while Items.Count > 10 do Items.Delete(Items.Count - 1);
      RGWriteStrings('SendList', Items);
    end;
    CloseKey;
  end;
  // ����������� ����� ��������� ��������
  RG.Free; SetForm.Free;
end;

(* ������� Memo *)
procedure TMainForm.btnClearClick(Sender: TObject);
begin
  Memo.Clear;
end;

(* ���������� Memo � ���� *)
procedure TMainForm.btnSaveClick(Sender: TObject);
var
  S: String;
begin
  if SaveFileDlg('', FInitDir, 'Text files (*.txt)' + #0 + '*.txt' + #0, S) then
    Memo.Lines.SaveToFile(S);
end;

/////////////////  ��������� ������������� ����� ��� cbSend  ///////////////////
//                 �� �������������, �� �����, ��� ������ :)
procedure TMainForm.cbSendKeyPress(Sender: TObject; var Key: Char);

  function VH: Boolean;
  begin
    Result := Key in ['0'..'9', 'A'..'F'];
  end;

  function VD: Boolean;
  begin
    if Key in ['a'..'f'] then Key := Chr(Ord(Key) - 32);
    Result := VH or (Key in [#3, #8, #22, #24, #26]);
    if not Result then Key := #0;
  end;

begin
  // ���� ������ ������� Enter, � ���� ���������� ���������� ���� �����
  // � ����������� �������� $0D
  if Key = #13 then CP.WriteStr(cbSend.Text + Key) else
  // ��������� ������������������ �����
  if cbHx.Checked and VD then
  if VH then
  begin
    if cbSend.SelStart = Length(cbSend.Text) then
    begin
      if Length(cbSend.Text) > 0 then
      if cbSend.Text[Length(cbSend.Text)] <> ' ' then
      begin
        cbSend.Text := cbSend.Text + Key + ' '; Key := #0;
        cbSend.SelStart := Length(cbSend.Text);
      end;
    end else
    begin
      if cbSend.Text[cbSend.SelStart + 1] = ' ' then
        cbSend.SelStart := cbSend.SelStart + 1;
      cbSend.SelLength := 1;
    end;
  end;
end;

procedure TMainForm.cbSendKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if cbHx.Checked then
  begin
    if Key = 37 then
    begin
      if cbSend.SelStart < 2 then cbSend.SelStart := 0 else
      if cbSend.Text[Length(cbSend.Text)] = ' ' then
        cbSend.SelStart := cbSend.SelStart - 2
      else
        cbSend.SelStart := cbSend.SelStart - 3;
    end;
    if Key = 39 then cbSend.SelStart := cbSend.SelStart + 2;
  end;
end;

procedure TMainForm.cbSendKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if cbHx.Checked and (Length(cbSend.Text) > 0) then
  if cbSend.Text[cbSend.SelStart + 1] = ' ' then
    cbSend.SelStart := cbSend.SelStart + 1;
end;

/////////////////   ��������, �������� � ��������� �����   /////////////////////

(* �������� ����� *)
procedure TMainForm.btnOpenClick(Sender: TObject);
begin
  // ��� �����
  cbPortChange(Self);
  // �������� ������
  CP.BaudRate := TBaudRate(cbBaud.ItemIndex);
  // �������� �����
  CP.Open;
  if CP.Connected then
  begin
    btnOpen.Enabled := False; btnClose.Enabled := True; DoSignals;
  end;
  cbSend.SetFocus;
end;

(* �������� ����� *)
procedure TMainForm.btnCloseClick(Sender: TObject);
begin
  CP.Close;
  if not CP.Connected then
  begin
    btnOpen.Enabled := True; btnClose.Enabled := False;
  end;
  cbSend.SetFocus;
end;

(* ����� ���-����� *)
procedure TMainForm.cbPortChange(Sender: TObject);
begin
  CP.Port := cbPort.Text;
end;

(* ��������� �������� ����� *)
procedure TMainForm.cbBaudChange(Sender: TObject);
begin
  CP.BaudRate := TBaudRate(cbBaud.ItemIndex);
end;

(* ���������/����� ������� DTR *)
procedure TMainForm.cbDTRClick(Sender: TObject);
begin
  CP.SetDTR(cbDTR.Checked);
end;

(* ���������/����� ������� RTS *)
procedure TMainForm.cbRTSClick(Sender: TObject);
begin
  CP.SetRTS(cbRTS.Checked);
end;

(* ���������/����� ��������� "������ �����" �� ����� TX ����� *)
procedure TMainForm.cbBreakClick(Sender: TObject);
begin
  CP.SetBreak(cbBreak.Checked);
end;

//////////////////////    �������� ������ � ����    ////////////////////////////

(* ������� ������ "Send" - �������� ������ �� cbSend � ���� *)
procedure TMainForm.btnSendClick(Sender: TObject);
var
  S, W: String;
begin
  if Length(cbSend.Text) > 0 then
  begin
    W := cbSend.Text;
    if cbHx.Checked then // ������ ��� �������� - � ����������������� ����
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
    if Length(W) > 0 then CP.WriteStr(W); // ���� ���� ��� ����������, ��������
    // ����������� ������ � ������ cbSend
    with cbSend.Items do
    if IndexOF(cbSend.Text) < 0 then Insert(0, cbSend.Text) else
    begin
      Move(IndexOF(cbSend.Text), 0); cbSend.ItemIndex := 0;
    end;
  end;
  cbSend.SetFocus;
end;

(* ������� ������ "Send_File" - �������� ����� � ���� *)
procedure TMainForm.btnSFClick(Sender: TObject);
var
  FN, S: String;
  F: TFileStream;
begin
  if OpenFileDlg('', FInitDir, 'All files (*.*)' + #0 + '*.*' + #0, FN) then
  begin
    F := TFileStream.Create(FN, fmOpenRead);
    try
      SetLength(S, F.Size); F.Read(S[1], F.Size);
    finally
      F.Free;
    end;
    CP.WriteStr(S);
  end;
end;

///////////////////////////    ��������� �������    ////////////////////////////

(* � �������� ����� ����� ��������� ������ *)
procedure TMainForm.CPRxChar(Sender: TObject; Count: Integer);
var
  S, W: String;
  N: Integer;
begin
  // ������ ����������� ������
  CP.ReadStr(S, CP.InBufSize);
  // ��������� ������ ��� �������� � ���� ����������� (Memo)
  if cbHex.Checked then
  // ���� ��������� ���������� ������ � ����������������� ����, ������������ ��
  begin
    W := ''; for N := 1 to Length(S) do W := W + IntToHex(Ord(S[N]), 2) + ' ';
  end else
  // ���� ��������� ���������� ������ � ���������� ����
  begin
    // ���������� ������� ���������� �� "."
    W := S; for N := 1 to Length(W) do if W[N] < ' ' then W[N] := '.';
  end;
  // ���������� ������ � ���� ����������� (Memo)
  Memo.Lines.Add(W);
end;

(* ����������� ��������� ������� ����� ����� ��� ��������� �� ��������� *)
procedure TMainForm.DoSignals;
var
  Sign: TComSignals;
begin
  Sign := CP.Signals;
  if (csCTS in Sign) then lbCTS.Font.Color := clRed else
    lbCTS.Font.Color := clInactiveCaption;
  if (csDSR in Sign) then lbDSR.Font.Color := clRed else
    lbDSR.Font.Color := clInactiveCaption;
  if (csRing in Sign) then lbRI.Font.Color := clRed else
    lbRI.Font.Color := clInactiveCaption;
  if (csRLSD in Sign) then lbRLSD.Font.Color := clRed else
    lbRLSD.Font.Color := clInactiveCaption;
end;

(* ���������� ��������� ������� ����� *)
procedure TMainForm.CPCTSChange(Sender: TObject; State: Boolean);
begin
  DoSignals;
end;

(* ���������� ��������� ������� ����� *)
procedure TMainForm.CPRing(Sender: TObject);
begin
  DoSignals;
end;

////////////////////////    ������� ASCII-��������    //////////////////////////

procedure TMainForm.btnTableClick(Sender: TObject);
begin
  TableForm.Show;
end;

end.
