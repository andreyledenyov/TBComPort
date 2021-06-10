unit TableUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids;

type
  TTableForm = class(TForm)
    SG: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure SGDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure SGMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SGDblClick(Sender: TObject);
  private
    { Private declarations }
    CL, RW: Integer;
  public
    { Public declarations }
  end;

var
  TableForm: TTableForm;

implementation

{$R *.DFM}

uses
  MainTerminal;

const
  AA: array[0..32] of String =
    ('NUL', 'SOH', 'STX', 'ETX', 'EOT', 'ENQ', 'ACK', 'BEL', 'BS', 'HT', 'LF',
     'VT', 'FF', 'CR', 'SO', 'SI', 'DLE', 'DC1', 'DC2', 'DC3', 'DC4', 'NAK',
     'SYN', 'ETB', 'CAN', 'EM', 'SUB', 'ESC', 'FS', 'GS', 'RS', 'US', 'SP');

(* ��� ������� ��������� ����������� ������� �������� *)
procedure TTableForm.FormCreate(Sender: TObject);
var
  I, J, N: Integer;
  S: String;
begin
  // ���������� ������������ ����� � ��������
  for N := 0 to 15 do
  begin
    S := IntToHex(N, 1);
    SG.Cells[0, N + 1] := S; SG.Cells[17, N + 1] := S;
    SG.Cells[N + 1, 0] := S; SG.Cells[N + 1, 17] := S;
  end;
  // ���������� �������
  N := 0;
  for I := 1 to 16 do for J := 1 to 16 do
  begin
    S := #9 + IntToStr(N);
    if N < 33 then SG.Cells[J, I] := AA[N] + S else
      SG.Cells[J, I] := Chr(N) + S;
    Inc(N);
  end;
  // ��� ��������� ��� �����
  with Application do
  begin
    HintColor := $00F4F0EC; HintPause := 300;
    HintHidePause := 7000; HintShortPause := 0;
  end;
end;

(* ��������� ����� ������� *)
procedure TTableForm.SGDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  T, E: String;
begin
  SG.Canvas.Font.Name := 'Tahoma';
  T := SG.Cells[ACol, ARow];
  // ��������� ������������ ����� � ��������
  with SG.Canvas, Rect do
  if (ACol = 0) or (ARow = 0) or (ACol = 17) or (ARow = 17) then
  begin
    Brush.Color := $00AE8F71;
    FillRect(Rect);
    Font.Size := 10;
    Font.Color := clWhite;
    Font.Style := [fsBold];
    TextOut(Left + (Right - Left - TextWidth(T)) div 2,
            Top + (Bottom - Top - TextHeight(T)) div 2, T);
  end else
  // ��������� �������������� �����
  begin
    E := Copy(T, 1, Pos(#9, T) - 1); Delete(T, 1, Pos(#9, T));
    Brush.Color := clWindow;
    Font.Size := 10;
    Font.Color := $005E2F00;
    Font.Style := [fsBold];
    TextOut(Left + (Right - Left - TextWidth(E)) div 2, Top + 2, E);
    Font.Size := 8;
    Font.Color := $00B79B80;
    Font.Style := [];
    TextOut(Left + (Right - Left - TextWidth(T)) div 2,
            Bottom - TextHeight(T) - 1, T);
  end;
end;

(* ����������� ��������� ����� *)
procedure TTableForm.SGMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  C, R: Integer;
  E, T: String;

  function StrToBinS(Value: String): String;
  var
    I, V: Byte;
  begin
    V := StrToInt(Value); Result := '';
    for I := 7 downto 0 do
    if V and (1 shl I) <> 0 then Result := Result + '1'else
      Result := Result + '0';
    Insert(' ', Result, 5);
  end;

begin
  SG.MouseToCell(X, Y, C, R);
  if ((RW <> R) or (CL <> C)) and (C <> 0) and (C <> 17) and (R <> 0) and
     (R <> 17) then
  begin
    RW := R; CL := C;
    Application.CancelHint;
    T := SG.Cells[CL, RW];
    E := Copy(T, 1, Pos(#9, T) - 1); Delete(T, 1, Pos(#9, T));
    if E[1] = '|' then E := 'l';
    SG.Hint := 'CHR: ' + E + #13 + 'DEC: ' + T + #13 + 'HEX: 0x' +
      IntToHex(StrToInt(T), 2) + #13 + 'BIN: ' + StrToBinS(T);
  end;
end;

(* ������� ������ �� ����� ��������� ������ ������ � MainForm.cbSend *)
procedure TTableForm.SGDblClick(Sender: TObject);
var
  S: String;
begin
  S := SG.Cells[CL, RW]; Delete(S, 1, Pos(#9, S));
  with MainForm do if cbHx.Checked then
    cbSend.Text := cbSend.Text + IntToHex(StrToInt(S), 2) + ' '
  else
    cbSend.Text := cbSend.Text + Chr(StrToInt(S));
end;

end.
