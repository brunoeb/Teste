program ClientTeste;

uses
  Vcl.Forms,
  View.Principal in 'View\View.Principal.pas' {FormPrincipal},
  Util.Util in 'Util\Util.Util.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
