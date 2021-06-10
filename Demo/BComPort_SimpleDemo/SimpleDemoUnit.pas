///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//     ������� ���������������� ������ ������������� ���������� TBComPort.   //
// ��������������� ��������� ������ ���-������ ����������, �������� �        //
// �������� �����, ��������� �������� �����, �������� � ���� ������ �������� //
// � ��������� ������, ������ �� ����� ��� ������� ��������� ������ ������   //
// �� �������� ����������.                                                   //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////

unit SimpleDemoUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, BCPort, ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Bevel1: TBevel;
    Button3: TButton;
    Button4: TButton;
    Memo1: TMemo;
    BComPort1: TBComPort;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure BComPort1RxChar(Sender: TObject; Count: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

(* �������� ��� ������� ��������� *)
procedure TForm1.FormCreate(Sender: TObject);
begin
  // ��������� ������ ������������� �� ���������� ���-������
  BComPort1.EnumComPorts(ComboBox1.Items);
  // ���� ������ �� ���� (���� �����), ������ �� ��� �������� � ������
  if ComboBox1.Items.Count > 0 then ComboBox1.ItemIndex := 0;
  // � ������ ��������� (BaudRate) ������� �������� br9600
  ComboBox2.ItemIndex := 2;
end;

(* ��������� ����� ����� *)
procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  BComPort1.Port := ComboBox1.Text;
end;

(* ��������� �������� ������ ����� *)
procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  case ComboBox2.ItemIndex of
    0: BComPort1.BaudRate := br2400;
    1: BComPort1.BaudRate := br4800;
    2: BComPort1.BaudRate := br9600;
    3: BComPort1.BaudRate := br19200;
    4: BComPort1.BaudRate := br38400;
    5: BComPort1.BaudRate := br57600;
    6: BComPort1.BaudRate := br115200;
  end;
end;

(* �������� ����� *)
procedure TForm1.Button1Click(Sender: TObject);
begin
  // ��� �����
  ComboBox1Change(Self);
  // �������� �����
  BComPort1.Open;
  // ���� ���� ������� ������
  if BComPort1.Connected then
  begin
    // ������������� �������� ������
    ComboBox2Change(Self);
    // ����������� ������� ����������
    Button1.Enabled := False;
    Button2.Enabled := True;
  end;
end;

(* �������� ����� *)
procedure TForm1.Button2Click(Sender: TObject);
begin
  BComPort1.Close;
  // ����������� ������� ����������
  Button1.Enabled := True;
  Button2.Enabled := False;
end;

(* �������� � ���� ������ ������ *)
procedure TForm1.Button3Click(Sender: TObject);
var
  Str: String;
begin
  Str := 'To be, or not to be, that is the question';
  BComPort1.WriteStr(Str);
end;

(* �������� � ���� ������������������ ������ *)
procedure TForm1.Button4Click(Sender: TObject);
var
  N: Byte;
  B: array[0..255] of Byte;
begin
  for N := 0 to 255 do B[N] := N;
  BComPort1.Write(B, 256);
end;

(* ����������� � ���� ������ ����������� � ������������ � Memo1 *)
procedure TForm1.BComPort1RxChar(Sender: TObject; Count: Integer);
var
  Str: String;
begin
  BComPort1.ReadStr(Str, Count);
  Memo1.Lines.Add(Str);
end;

end.
