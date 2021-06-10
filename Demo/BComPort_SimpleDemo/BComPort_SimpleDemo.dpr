program BComPort_SimpleDemo;

uses
  Forms,
  SimpleDemoUnit in 'SimpleDemoUnit.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'BComPort_SimpleDemo';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
