unit BSetUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, BCPort;

type
  TSetForm = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lbCustom: TLabel;
    edCustom: TEdit;
    lbByteSize: TLabel;
    cbByteSize: TComboBox;
    lbParity: TLabel;
    cbParity: TComboBox;
    lbStopBits: TLabel;
    cbStopBits: TComboBox;
    procedure edCustomKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    CBRText: String;
    BS, P, SB: Integer;
  public
    { Public declarations }
  end;

var
  SetForm: TSetForm;

implementation

{$R *.DFM}

uses
  MainTerminal;

(* ����������� ������ ������� ���������� �������� � ���� ����  *)
procedure TSetForm.edCustomKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #3, #8, #22, #24, #26]) then Key := #1;
end;

(* ��� ������ ���� �������� *)
procedure TSetForm.FormShow(Sender: TObject);
begin
  // ���������� ������� ���� �� ��������� � ������� �����
  SetForm.Top := MainForm.Top + 77;
  SetForm.Left := MainForm.Left + 192;
  // ���������� ��������� ��������� ���������
  CBRText := edCustom.Text; BS := cbByteSize.ItemIndex;
  P :=  cbParity.ItemIndex; SB := cbStopBits.ItemIndex;
end;

(* ������� ��������� � ������� ���� �������� *)
procedure TSetForm.btnOKClick(Sender: TObject);
begin
  with MainForm.CP do
  begin
    if cbByteSize.ItemIndex <> BS then
      ByteSize := TByteSize(cbByteSize.ItemIndex);
    if cbParity.ItemIndex <> P then
      Parity := TParity(cbParity.ItemIndex);
    if cbStopBits.ItemIndex <> SB then
      StopBits := TStopBits(cbStopBits.ItemIndex);
    if edCustom.Text <> CBRText then
      CustomBaudRate := StrToInt(edCustom.Text);
  end;
end;

(* �������� ��������� � ������� ���� �������� *)
procedure TSetForm.btnCancelClick(Sender: TObject);
begin
  edCustom.Text := CBRText; cbByteSize.ItemIndex:= BS;
  cbParity.ItemIndex := P; cbStopBits.ItemIndex := SB;
end;

(* Enter ��� Esc *)
procedure TSetForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then btnOK.Click;
  if Key = VK_ESCAPE then btnCancel.Click;
end;

end.
