object DM: TDM
  Height = 750
  Width = 1000
  PixelsPerInch = 120
  object RESTTarefas: TRESTClient
    Authenticator = HTTPBasicAuthenticator1
    BaseURL = 'http://localhost:9000'
    Params = <>
    SynchronizedEvents = False
    Left = 64
    Top = 16
  end
  object ResTarefasPost: TRESTRequest
    AssignedValues = [rvAccept, rvConnectTimeout, rvReadTimeout]
    Accept = 'a\\\\\\\\\\\\\\\ MS'
    Client = RESTTarefas
    Method = rmPOST
    Params = <
      item
        Kind = pkREQUESTBODY
        Name = 'body5A548CB0E2ED463DA8BDB12FC945A49B'
        Value = 
          '{'#13#10'   "dt_cadastro": "2024-06-22T21:00:04",'#13#10'   "dt_previsao": "' +
          '2024-06-23T21:00:04",'#13#10#13#10'   "responsavel":"Bruno",'#13#10'   "statusta' +
          'refa":"Pendente",'#13#10'   "descricao":"faxer cachorro quente",'#13#10'   "' +
          'prioridade":"Baixa"'#13#10#13#10'}'
        ContentTypeStr = 'application/json'
      end>
    Resource = 'tarefa'
    SynchronizedEvents = False
    Left = 56
    Top = 90
  end
  object HTTPBasicAuthenticator1: THTTPBasicAuthenticator
    Username = 'usuario'
    Password = 'T@r#fa'
    Left = 229
    Top = 29
  end
end
