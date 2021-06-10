program BComPort_Demo;

uses
  Forms,
  MainDemo in 'MainDemo.pas' {DemoForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'BComPort_Demo';
  Application.CreateForm(TDemoForm, DemoForm);
  Application.Run;
end.
