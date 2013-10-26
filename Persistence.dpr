program Persistence;

uses
  Forms,
  PersistenceForm in 'PersistenceForm.pas' {Form1},
  ClassesRTTI in 'ClassesRTTI.pas',
  Constants in 'Constants.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
