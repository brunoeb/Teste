unit Controller.Tarefas;

interface

uses Horse,System.JSON,System.SysUtils,Model.Tarefas,ZDataset,DataSet.Serialize,Horse.Jhonson,Util.Util;

procedure Regsitry;

implementation


procedure TotalTarefas(Req:THorseRequest; Res : THorseResponse;Next: TProc);
var
    Tarefa : TTarefas;
    objTarefa: TJSONObject;
    qry : TZQuery;
    erro : string;
begin
    try
        Tarefa := TTarefas.Create;
         
    except on E:EHorseException do begin

        res.Send('Erro ao conectar com o banco').Status(500);
        exit;
       end;
    end;

    try                                      
      qry := Tarefa.TotalTarefas(erro);

      objTarefa := TJSONObject.Create;
      objTarefa.AddPair('totaltarefas', qry.FieldByName('IDTAREFA').AsInteger);

      res.Send<TJSONObject>(objTarefa).Status(201);
    finally
        qry.Free;
        tarefa.Free;
    end;
end;

procedure ListarTarefas(Req:THorseRequest; Res : THorseResponse;Next: TProc);
var
    Tarefa : TTarefas;
    objTarefa: TJSONObject;
    qry : TZQuery;
    arrayTarefas : TJSONArray;
    erro : string;
begin
    try
        Tarefa := TTarefas.Create;
         
    except on E:EHorseException do begin

        res.Send('Erro ao conectar com o banco').Status(500);
        exit;
       end;
    end;

    try                                      
        qry := Tarefa.ListarTarefas(Req.Query.Dictionary, erro);

        if qry.RecordCount > 0 then begin
          arrayTarefas := qry.ToJSONArray();
          res.Send<TJSONArray>(arrayTarefas);
        end else
          res.Send('Nenhuma tarefa encontrada').Status(404);
    finally
        qry.Free;
        tarefa.Free;
    end;
end;

procedure MediaPrioridadePendentes(Req:THorseRequest; Res : THorseResponse;Next: TProc);
var
    Tarefa : TTarefas;
    objTarefa: TJSONObject;
    qry : TZQuery;
    arrayTarefas : TJSONArray;
    erro : string;
begin
    try
        Tarefa := TTarefas.Create;
         
    except on E:EHorseException do begin

        res.Send('Erro ao conectar com o banco').Status(500);
        exit;
       end;
    end;

    try                                      
        qry := Tarefa.MediaPrioridadePendentes(erro);

        if qry.RecordCount > 0 then begin
          arrayTarefas := qry.ToJSONArray();
          res.Send<TJSONArray>(arrayTarefas);
        end else
          res.Send('Nenhuma tarefa encontrada').Status(404);
    finally
        qry.Free;
        tarefa.Free;
    end;
end;

procedure EncerradasUltimosDias(Req:THorseRequest; Res : THorseResponse;Next: TProc);
var
    Tarefa : TTarefas;
    objTarefa: TJSONObject;
    qry : TZQuery;
    arrayTarefas : TJSONArray;
    erro : string;
begin
    try
        Tarefa := TTarefas.Create;
         
    except on E:EHorseException do begin

        res.Send('Erro ao conectar com o banco').Status(500);
        exit;
       end;
    end;

    try                                      
      qry := Tarefa.EncerradasUltimosDias(Req.Query.Dictionary, erro);

      objTarefa := TJSONObject.Create;
      objTarefa.AddPair('totaltarefas', qry.FieldByName('IDTAREFA').AsInteger);

      res.Send<TJSONObject>(objTarefa).Status(201);
      
    finally
      qry.Free;
      tarefa.Free;
    end;
end;

procedure CadastrarTarefa(Req:THorseRequest; Res : THorseResponse;Next: TProc);
var
    Tarefa   : TTarefas;
    objTarefa: TJSONObject;
    Erro     : string;
    body     : TJsonValue;
begin


  try
    // no create esta criando a conexao com o banco de dados
    Tarefa := TTarefas.Create;
  except on E:EHorseException do begin

      res.Send('Erro ao conectar com o banco').Status(500);
      exit;
     end;
  end;


  try
      try
          body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
        try
          
          Tarefa.ID_TAREFA     := body.GetValue<Integer>('idtarefa', 0);
          Tarefa.DT_CADASTRO   := JSONDate_To_Datetime(body.GetValue<string>('dt_cadastro', ''));
          Tarefa.DT_PREVISAO   := JSONDate_To_Datetime(body.GetValue<string>('dt_previsao',''));
          Tarefa.RESPONSAVEL   := body.GetValue<string>('responsavel', '');
          Tarefa.STATUS_TAREFA := body.GetValue<string>('statustarefa', '');
          Tarefa.DESCRICAO     := body.GetValue<String>('descricao', '');
          Tarefa.PRIORIDADE    := body.GetValue<String>('prioridade', '');

        finally
          body.Free;
        end;

        if NOT Tarefa.Cadastrar(erro) then begin
          Res.Send(erro).Status(404);
          Exit
        end;
      except on ex:EHorseException do   begin
          res.Send(ex.Message).Status(400);
          exit;
        end;
      end;


      objTarefa := TJSONObject.Create;
      objTarefa.AddPair('success', true);
      objTarefa.AddPair('idtarefa', Tarefa.ID_TAREFA.ToString);

      res.Send<TJSONObject>(objTarefa).Status(201);

    finally
      Tarefa.Free;
    end;
end;

procedure AtualizarStatus(Req:THorseRequest; Res : THorseResponse;Next: TProc);
var
  Tarefa   : TTarefas;
  objTarefa: TJSONObject;
  erro     : string;
  body     : TJsonValue;
begin
    // Conexao com o banco...
  try
    // no create esta criando a conexao com o banco de dados
    Tarefa := TTarefas.Create;
  except on E:EHorseException do begin

      res.Send('Erro ao conectar com o banco').Status(500);
      exit;
     end;
  end;

  try
    try
      Tarefa.ID_TAREFA := Req.Params['id'].ToInteger;
      try
        body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
        Tarefa.STATUS_TAREFA := body.GetValue<string>('statustarefa', '');
        if body.GetValue<string>('entrega',  '') <> '' then
           Tarefa.DT_ENTREGA    := JSONDate_To_Datetime(body.GetValue<string>('entrega',  ''));

      finally
        body.Free;
      end;

      if NOT Tarefa.AlterarStatus(erro) then begin
         Res.Send(erro).Status(404);
         Exit
      end;

    except on ex:exception do begin
        res.Send(ex.Message).Status(400);
        exit;
      end;
    end;

    objTarefa := TJSONObject.Create;
    objTarefa.AddPair('success', true);

    res.Send<TJSONObject>(objTarefa).Status(200);
  finally
    Tarefa.Free;
  end;

end;

procedure ExcluirTarefa(Req:THorseRequest; Res : THorseResponse;Next: TProc);
var
    Tarefa : TTarefas;
    objTarefa: TJSONObject;
    erro : string;
begin
    // Conexao com o banco...
  try
      Tarefa := TTarefas.Create;
  except on e:EHorseException do begin
      res.Send('Erro ao conectar com o banco').Status(500);
      exit;
    end;
  end;

  try
    try
      Tarefa.ID_TAREFA := Req.Params['id'].ToInteger;

      if NOT Tarefa.Excluir(erro) then begin
         Res.Send(erro).Status(404);
         Exit
      end;

    except on ex:EHorseException do begin
        res.Send(ex.Message).Status(400);
        exit;
      end;
    end;


    objTarefa := TJSONObject.Create;
    objTarefa.AddPair('success', true);
    objTarefa.AddPair('id', Tarefa.ID_TAREFA.ToString);

    res.Send<TJSONObject>(objTarefa).Status(200);
  finally
    Tarefa.Free;
  end;
end;


procedure Regsitry;
begin
   THorse.Get('/tarefas',ListarTarefas);
   THorse.Get('/tarefas/totaltarefas',TotalTarefas);
   THorse.Get('/tarefas/encerradasultimosdias',EncerradasUltimosDias);
   THorse.Get('/tarefas/mediaprioridadependentes',MediaPrioridadePendentes);
   
   THorse.PUT('/tarefa/:id',AtualizarStatus);
   THorse.Post('/tarefa',CadastrarTarefa);
   THorse.Delete('/tarefa/:id',ExcluirTarefa);
end;

end.
