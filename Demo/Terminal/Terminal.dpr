program Terminal;

uses
  Forms,
  MainTerminal in 'MainTerminal.pas' {MainForm},
  BSetUnit in 'BSetUnit.pas' {SetForm},
  BDialog in 'BDialog.pas',
  TableUnit in 'TableUnit.pas' {TableForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Terminal';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TTableForm, TableForm);
  Application.Run;
end.
