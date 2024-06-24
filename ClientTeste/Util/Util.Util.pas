unit Util.Util;

interface

uses Vcl.ComCtrls;

function Ifthen(Condicao:boolean;ValorTrue,ValorFalse:Variant):variant;
procedure MudaTab(Pagina:TPageControl;TabIndex:Integer);


implementation

function Ifthen(Condicao:boolean;ValorTrue,ValorFalse:Variant):variant;
begin
  if Condicao then
    Result := ValorTrue
  else
    Result := ValorFalse;
end;

procedure MudaTab(Pagina:TPageControl;TabIndex:Integer);
var
  i: Integer;
begin

   //esta deixando todas as abas invisivel e deixando somente a tabsheet desejada visivel
   for i := 0 to Pagina.PageCount-1 do
      Pagina.Pages[i].TabVisible := false;

   Pagina.ActivePageIndex := TabIndex;

end;
end.
