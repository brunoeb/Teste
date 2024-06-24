unit Util.Util;

interface

uses
  System.SysUtils,System.DateUtils;

function Ifthen(Condicao:boolean;ValorTrue,ValorFalse:Variant):variant;
function JSONDate_To_Datetime(JSONDate: string): TDatetime;

implementation

function Ifthen(Condicao:boolean;ValorTrue,ValorFalse:Variant):variant;
begin
  if Condicao then
    Result := ValorTrue
  else
    Result := ValorFalse;
end;

function JSONDate_To_Datetime(JSONDate: string): TDatetime;
var Year, Month, Day, Hour, Minute, Second, Millisecond: Word;
begin
  Year        := StrToInt(Copy(JSONDate, 1, 4));
  Month       := StrToInt(Copy(JSONDate, 6, 2));
  Day         := StrToInt(Copy(JSONDate, 9, 2));
  Hour        := StrToInt(Copy(JSONDate, 12, 2));
  Minute      := StrToInt(Copy(JSONDate, 15, 2));
  Second      := StrToInt(Copy(JSONDate, 18, 2));
  Millisecond := Round(StrToFloat(Copy(JSONDate, 19, 4)));

  Result := EncodeDateTime(Year, Month, Day, Hour, Minute, Second, Millisecond);
end;
end.
