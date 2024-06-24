unit Controller.Tarefas;

interface

uses Horse,
     RESTRequest4D,
     System.JSON,
     System.SysUtils,

     ZDataset,
     DataSet.Serialize,
     Horse.Jhonson,
     Util.Util;

type
    TTarefas = class
      private
      public
        function CadastrarTarefa(objTarefa:TJSONObject; out erro: string):boolean;

    end;



implementation


function TTarefas.CadastrarTarefa(objTarefa:TJSONObject; out erro: string):boolean;
begin

end;



end.
