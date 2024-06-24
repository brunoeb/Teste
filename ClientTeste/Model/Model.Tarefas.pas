unit Model.Tarefas;

interface

uses Horse,Horse.Jhonson,System.JSON,REST.Types,ZAbstractConnection, ZConnection,
     System.SysUtils,ZDataset,Util.Util,System.Generics.Collections,REST.Client, 
     REST.Authenticator.Basic
     ;

type
   TTarefas = class
     private
       FID_TAREFA     : integer;
       FDT_CADASTRO   : TDateTime;
       FDT_PREVISAO   : TDateTime;
       FDT_ENTREGA    : TDateTime;
       FRESPONSAVEL   : String;
       FSTATUS_TAREFA : String;
       FDESCRICAO     : String;
       FPRIORIDADE    : String;

     public
       constructor Create;
       destructor  Destroy; override;
       property ID_TAREFA     : integer    read FID_TAREFA     write FID_TAREFA;
       property DT_CADASTRO   : TDateTime  read FDT_CADASTRO   write FDT_CADASTRO;
       property DT_PREVISAO   : TDateTime  read FDT_PREVISAO   write FDT_PREVISAO;
       property DT_ENTREGA    : TDateTime  read FDT_ENTREGA    write FDT_ENTREGA;
       property RESPONSAVEL   : String     read FRESPONSAVEL   write FRESPONSAVEL;
       property STATUS_TAREFA : String     read FSTATUS_TAREFA write FSTATUS_TAREFA;
       property DESCRICAO     : String     read FDESCRICAO     write FDESCRICAO;
       property PRIORIDADE    : String     read FPRIORIDADE    write FPRIORIDADE;

       function EncerradasUltimosDias(const AQuery:TDictionary<string, string>;out erro: string): TZQuery;
       function MediaPrioridadePendentes(out erro: string): TZQuery;
       function TotalTarefas(out erro: string): TZQuery;
       function ListarTarefas(const AQuery:TDictionary<string, string>;out erro:string):TZQuery;
       function Cadastrar_Atualizar(const tarefa :TTarefas;out erro : string;out jsonTarefa:TJSONObject):Boolean;
       function Excluir(out erro : string):Boolean;
       function AlterarStatus(out erro:String):Boolean;



   end;
var
   RESTTarefas : TRESTClient;
   HTTPBasicAuthenticator1: THTTPBasicAuthenticator;
   ReqTarefas: TRESTRequest;

implementation


{ TTarefas }

function TTarefas.AlterarStatus(out erro: String): Boolean;
var
    qry : TZQuery;
begin


  try
    qry := TZQuery.Create(nil);

    //acionar api
    qry.Free;
    erro   := '';
    result := true;

    except on ex:EHorseException do begin
        erro := 'Erro ao alterar cliente: ' + ex.Message;
        Result := false;
      end;
  end;

end;

function TTarefas.Cadastrar_Atualizar(const tarefa :TTarefas; out erro: string;out jsonTarefa:TJSONObject): Boolean;
var
   jsonBody : TJsonValue;

begin
try
  try

    erro   := '';
    result := true;

    jsonBody.Create();
    jsonBody :=  TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(tarefa.ToString), 0) as TJSONObject;

    ReqTarefas.Params.Clear;
    ReqTarefas.Body.ClearBody;
    ReqTarefas.Method := rmPOST;
    ReqTarefas.Body.Add(jsonBody.c,ContentTypeFromString('application/json'));
    ReqTarefas.Execute;

    erro   := '';

    if not  ReqTarefas.Response.StatusCode in [200,201] then begin
       Result := false;
       erro   := 'Erro ao tentar castrar a tarefa :  '+
                  ReqTarefas.Response.StatusCode.ToString+' '+
                  ReqTarefas.Response.Content;
       exit;
    end;
    jsonTarefa := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(ReqTarefas.Response.JSONValue.ToString), 0) as TJSONObject;
    result := true;



  except on ex:EHorseException do begin
      erro   := 'Erro ao cadastrar tarefas: ' + ex.Message;
      Result := false;
    end;
  end;
finally
  jsonBody.DisposeOf;
end;
end;

constructor TTarefas.Create;
begin
  HTTPBasicAuthenticator1 := THTTPBasicAuthenticator.Create('usuario','T@r#fa');

  RESTTarefas.Create(nil);
  with RESTTarefas do begin
    RESTTarefas.Authenticator := HTTPBasicAuthenticator1;
    RESTTarefas.BaseURL       := 'http://localhost:9000';
    SynchronizedEvents        := False;
  end;
  ReqTarefas.Create(nil);
  with ReqTarefas do begin
    Accept             := 'a\\\\\\\\\\\\\\\ MS';
    Client             := RESTTarefas;
    Method             := rmPOST;
    Resource           := 'tarefa';
    SynchronizedEvents := False;
    Params.AddItem('ContentTypeStr','application/json');
  end;

end;

destructor TTarefas.Destroy;
begin
   HTTPBasicAuthenticator1.Free;
   RESTTarefas.Free;
   inherited;
end;

function TTarefas.Excluir(out erro: string): Boolean;
begin
  if ID_TAREFA =0  then begin
     Result := false;
     erro := 'Informe o codigo da tarefa para ser excluida ';
     exit;
  end;

  try
    try

      erro   := '';
      result := true;

    except on ex:EHorseException do begin
        erro := 'Erro ao excluir a tarefa: ' + ex.Message;
        Result := false;
      end;
    end;
  finally
  end;
end;

function TTarefas.ListarTarefas(const AQuery:TDictionary<string, string>;out erro: string): TZQuery;
var
    qry : TZQuery;
begin
   try
     qry := TZQuery.Create(nil);

     erro := '';

     Result := qry;

   except on ex:EHorseException do begin
       erro := 'Erro ao consultar tarefas: ' + ex.Message;
       Result := nil;
      end;
   end;
end;


function TTarefas.MediaPrioridadePendentes(out erro: string): TZQuery;
var
    qry : TZQuery;
begin
   try
     qry := TZQuery.Create(nil);



     erro := '';

     Result := qry;

   except on ex:EHorseException do begin
       erro := 'Erro ao consultar tarefas: ' + ex.Message;
       Result := nil;
     end;
   end;

end;

function TTarefas.TotalTarefas(out erro: string): TZQuery;
var
    qry : TZQuery;
begin
   try
     qry := TZQuery.Create(nil);



     erro := '';

     Result := qry;

   except on ex:EHorseException do begin
       erro := 'Erro ao consultar tarefas: ' + ex.Message;
       Result := nil;
      end;
   end;
end;

function TTarefas.EncerradasUltimosDias(const AQuery:TDictionary<string, string>;out erro: string): TZQuery;
var
    qry : TZQuery;
begin
   try
     qry := TZQuery.Create(nil);


     erro := '';

     Result := qry;

   except on ex:EHorseException do begin
       erro := 'Erro ao consultar tarefas: ' + ex.Message;
       Result := nil;
      end;
   end;
end;


end.
