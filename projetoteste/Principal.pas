unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, ZAbstractConnection, ZConnection, SqlExpr, DBXCommon, Data.FMTBcd,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ZAbstractTable;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
   ZConnection1: TZConnection;
   ZQuery1 : TZQuery;
begin
   TRY
//    ADOConnection1.ConnectionString := 'Provider=MSDASQL.1;Persist Security Info=False;Data Source=tarefas';
//    ADOConnection1.LoginPrompt := False;
//    ADOConnection1.Provider := 'MSDASQL.1';

//    ADOConnection1.Connected := true;
  ZConnection1 := TZConnection.Create(nil);
  ZConnection1.Connected   := False;
  ZConnection1.Database    := 'Provider=MSDASQL.1;Data Source=tarefas';
  ZConnection1.LoginPrompt := false;
  ZConnection1.HostName    := 'BRUNO\SQLEXPRESS';
  ZConnection1.Protocol    := 'ado';

  ZConnection1.Connected := True;
      ZQuery1 := TZQuery.Create(nil);
      DataSource1.DataSet := ZQuery1;
      ZQuery1.Connection := ZConnection1;
      ZQuery1.close;
      ZQuery1.SQL.Text := 'SELECT * FROM [tarefas].[dbo].[TAREFAS]';
      ZQuery1.Open;

   EXCEPT ON EX:EXCEPTION DO BEGIN
         ShowMessage('ERRO : '+EX.Message);
         ABORT;
      END;

   END;


end;

end.
