///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//     Демонстрационный пример использования компонента TBComPort v.2.20     //
// Реализованы примеры использования всех свойств и обработки всех событий   //
// компонента, а также применение значительной части методов компонента.     //
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

(* При запуске программы *)
procedure TDemoForm.FormCreate(Sender: TObject);
begin
  // Получение списка СОМ-портов
  BComPort1.EnumComPorts(cbPort.Items);
  if cbPort.Items.Count > 0 then cbPort.ItemIndex := 0;
  // Установка раскрывающихся списков (ComboBox) в начальное состояние
  cbBaudRate.ItemIndex := 7;       // BaudRate       = br9600
  cbParity.ItemIndex := 0;         // Parity         = paNone
  cbByteSize.ItemIndex := 3;       // ByteSize       = bs8
  cbStopBits.ItemIndex := 0;       // StopBits       = sb1
  cbSyncMethod.ItemIndex := 0;     // SyncMethod     = smThreadSync
  cbThreadPriority.ItemIndex := 3; // ThreadPriority = tpNormal
end;

(* Фильтрация клавиатурного ввода для компонентов TEdit с числовыми данными *)
procedure TDemoForm.edCustomBRKeyPress(Sender: TObject; var Key: Char);
begin
  // Разрешается ввод только цифр, знака "-" и клавиш управления курсором
  if not (Key in ['0'..'9', '-', #3, #8, #22, #24, #26]) then Key := #1;
end;

(* Фильтрация клавиатурного ввода поля ввода передаваемых данных *)
procedure TDemoForm.edSendKeyPress(Sender: TObject; var Key: Char);
begin
  // Разрешается ввод только символов шестнадцатеричных значений, пробела
  // и клавиш управления курсором, если выбран такой вид представления данных
  if cbHex.Checked and (not (Key in ['0'..'9', 'A'..'F', 'a'..'f', ' ', #3,
    #8, #22, #24, #26])) then Key := #1;
end;

(* Очистка окна отображения принимаемых данных (Memo) *)
procedure TDemoForm.btnClearClick(Sender: TObject);
begin
  Memo.Lines.Clear;
end;


///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                   Установка свойств (настроек) компонента                 //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


(* Установка свойства "Port" *)
procedure TDemoForm.cbPortChange(Sender: TObject);
begin
  BComPort1.Port := cbPort.Text;
end;

(* Установка свойства "BaudRate" и "CustomBaudRate" *)
procedure TDemoForm.cbBaudRateChange(Sender: TObject);
begin
  BComPort1.CustomBaudRate := StrToInt(edCustomBR.Text); // CustomBaudRate
  BComPort1.BaudRate := TBaudRate(cbBaudRate.ItemIndex); // BaudRate
end;

(* Установка свойства "Parity" *)
procedure TDemoForm.cbParityChange(Sender: TObject);
begin
  BComPort1.Parity := TParity(cbParity.ItemIndex);
end;

(* Установка свойства "ByteSize" *)
procedure TDemoForm.cbByteSizeChange(Sender: TObject);
begin
  BComPort1.ByteSize := TByteSize(cbByteSize.ItemIndex);
end;

(* Установка свойства "StopBits" *)
procedure TDemoForm.cbStopBitsChange(Sender: TObject);
begin
  BComPort1.StopBits := TStopBits(cbStopBits.ItemIndex);
end;

(* Установка свойства "SyncMethod" *)
procedure TDemoForm.cbSyncMethodChange(Sender: TObject);
begin
  BComPort1.SyncMethod := TSyncMethod(cbSyncMethod.ItemIndex);
end;

(* Установка свойства "ThreadPriority" *)
procedure TDemoForm.cbThreadPriorityChange(Sender: TObject);
begin
  BComPort1.ThreadPriority := TThreadPriority(cbThreadPriority.ItemIndex);
end;

(* Установка свойства "DataPacket.Enabled" *)
procedure TDemoForm.cbEnabledClick(Sender: TObject);
begin
  BComPort1.DataPacket.Enabled := cbEnabled.Checked;
end;

(* Установка свойства "DataPacket.IncludeStrings" *)
procedure TDemoForm.cbInStrClick(Sender: TObject);
begin
   BComPort1.DataPacket.IncludeStrings := cbInStr.Checked;
end;

(* Установка свойств DataPacket: MaxBufferSize, PacketSize, StartString и StopString *)
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
//                            Открытие-закрытие порта                        //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


(* Нажатие кнопки "OPEN" - открытие порта *)
procedure TDemoForm.btnOpenClick(Sender: TObject);
begin

  // Установка настроек в соответствии с органами управления
  // Можно не выполнять, если будут использованы значения, заданные в
  // компоненте BComPort1 на этапе конструирования формы
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

  // Таймауты
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

  // Открытие порта
  BComPort1.Open;
  if BComPort1.Connected then // Порт успешно открыт
  begin
    btnClose.Enabled := True;  btnOpen.Enabled := False;
    DoSignals; // Индикация состояния входных линий порта
  end;
  // Теперь запущен поток мониторинга событий и можно применять методы
  // записи в порт и чтения из порта
end;

(* Нажатие кнопки "CLOSE" - закрытие порта *)
procedure TDemoForm.btnCloseClick(Sender: TObject);
begin
  BComPort1.Close;
  if not BComPort1.Connected then // Порт успешно закрыт
  begin
    btnClose.Enabled := False;  btnOpen.Enabled := True;
  end;
  // Теперь поток мониторинга событий остановлен, методы записи в порт
  // и чтения из порта применять нельзя
end;


///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                     Управление выходными линиями порта                    //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


(* Установка/сброс состояния "Разрыв связи" на линии TX порта *)
procedure TDemoForm.cbBREAKClick(Sender: TObject);
begin
  BComPort1.SetBreak(cbBREAK.Checked);
end;

(* Установка/сброс сигнала DTR порта *)
procedure TDemoForm.cbDTRClick(Sender: TObject);
begin
  BComPort1.SetDTR(cbDTR.Checked);
end;

(* Установка/сброс сигнала RTS порта *)
procedure TDemoForm.cbRTSClick(Sender: TObject);
begin
  BComPort1.SetRTS(cbRTS.Checked);
end;


///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                            Передача данных в порт                         //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


(* Нажатие кнопки "SEND" - передача данных в порт *)
procedure TDemoForm.btnSendClick(Sender: TObject);
var
  S, W: String;
begin
  W := edSend.Text;
  if cbHex.Checked then // Данные для передачи - в шестнадцатеричном виде
  begin
    // Удаление пробелов из строки с данными
    while Pos(' ', W) > 0 do Delete(W, Pos(' ', W), 1);
    // Если нечетное количество символов в строке, удаляем последний
    if (Length(W) mod 2) > 0 then Delete(W, Length(W), 1);
    // Формирование строки для передачи в порт
    S := '';
    if Length(W) > 0 then
    repeat
      S := S + Chr(StrToInt('$' + Copy(W, 1, 2))); Delete(W, 1, 2);
    until Length(W) = 0;
    W := S;
  end;
  if Length(W) > 0 then   // Если есть что передавать...
    BComPort1.WriteStr(W);
  edSend.SetFocus;
end;


///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//              Прием данных из порта и обработка других событий             //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


(* Обработка строки для передачи в окно отображения (Memo) *)
function TDemoForm.StringHandling(const Value: String): String;
var
  N: Integer;
begin
  if cbMHex.Checked then
  // Если требуется отображать данные в шестнадцатеричном виде, конвертируем их
  begin
    Result := '';
    for N := 1 to Length(Value) do
      Result := Result + IntToHex(Ord(Value[N]), 2) + ' ';
  end else
  // Если требуется отображать данные в символьном виде
  begin
      Result := Value;
    // Непечатные символы заменяются на "."
    for N := 1 to Length(Result) do
      if Result[N] < ' ' then Result[N] := '.';
  end;
end;

(* В приемный буфер порта поступили данные *)
procedure TDemoForm.BComPort1RxChar(Sender: TObject; Count: Integer);
var
  S: String;
begin
  // Читаем поступившие данные
  BComPort1.ReadStr(S, Count);
  // Добавление данных в окно отображения (Memo)
  Memo.Lines.Add('<OnRxChar> ' + StringHandling(S));
end;

(* Во входящем потоке данных обнаружен пакет *)
procedure TDemoForm.BComPort1Packet(Sender: TObject; const Str: String);
begin
  // Добавление данных в окно отображения (Memo)
  Memo.Lines.Add('<OnPacket> ' + StringHandling(Str));
end;

(* Обнаружено состояние разрыва связи *)
procedure TDemoForm.BComPort1Break(Sender: TObject);
begin
  if cbEvents.Checked then
    Memo.Lines.Add('<OnBreak> - Обнаружено состояние BREAK (разрыв связи)');
end;

(* Определение состояния входных линий порта для индикации их состояния *)
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

(* Изменилось состояние входной линии CTS *)
procedure TDemoForm.BComPort1CTSChange(Sender: TObject; State: Boolean);
var
  S: String;
begin
  DoSignals;
  if State then S := 'Установлен сигнал CTS' else S := 'Сброшен сигнал CTS';
  if cbEvents.Checked then Memo.Lines.Add('<OnCTSChange> - ' + S);
end;

(* Изменилось состояние входной линии DSR *)
procedure TDemoForm.BComPort1DSRChange(Sender: TObject; State: Boolean);
var
  S: String;
begin
  DoSignals;
  if State then S := 'Установлен сигнал DSR' else S := 'Сброшен сигнал DSR';
  if cbEvents.Checked then Memo.Lines.Add('<OnDSRChange> - ' + S);
end;

(* Обнаружен входной сигнал RING (звонок на модем) *)
procedure TDemoForm.BComPort1Ring(Sender: TObject);
begin
  DoSignals;
  if cbEvents.Checked then
    Memo.Lines.Add('<OnBreak> - Обнаружен сигнал RING (звонок на модем)');
end;

(* Изменилось состояние входной линии RLSD *)
procedure TDemoForm.BComPort1RLSDChange(Sender: TObject; State: Boolean);
var
  S: String;
begin
  DoSignals;
  if State then S := 'Установлен сигнал RLSD' else S := 'Сброшен сигнал RLSD';
  if cbEvents.Checked then Memo.Lines.Add('<OnRLSDChange> - ' + S);
end;

(* Приемный буфер заполнен на 80 процентов *)
procedure TDemoForm.BComPort1Rx80Full(Sender: TObject);
begin
  if cbEvents.Checked then
    Memo.Lines.Add('<OnRx80Full> - Приемный буфер заполнен на 80 процентов');
end;

(* Буфер передачи порта пуст *)
procedure TDemoForm.BComPort1TxEmpty(Sender: TObject);
begin
  if cbEvents.Checked then
    Memo.Lines.Add('<OnTxEmpty> - Буфер передачи порта пуст');
end;

(* Обнаружена ошибка порта *)
procedure TDemoForm.BComPort1Error(Sender: TObject; Errors: TComErrors);
var
  S: String;
begin
  if ceBreak in Errors then S := 'Обнаружено состояние разрыва связи';
  if ceFrame in Errors then S := 'Ошибка формата кадра';
  if ceIO in Errors then S := 'Ошибка ввода-вывода';
  if ceMode in Errors then S := 'Запрошенный режим не поддерживается';
  if ceOverrun in Errors then S := 'Переполнение аппаратного буфера';
  if ceRxOver in Errors then S := 'Переполнение приемного буфера драйвера порта';
  if ceRxParity in Errors then S := 'Ошибка четности';
  if ceTxFull in Errors then S := 'Переполнение буфера передачи драйвера порта';
  if cbEvents.Checked then Memo.Lines.Add('<OnError> - ' + S);
end;

end.
