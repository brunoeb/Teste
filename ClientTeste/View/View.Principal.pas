unit View.Principal;

interface

uses
  RESTRequest4D,
  DataSet.Serialize.Adapter.RESTRequest4D,
  System.JSON,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Util.Util,
  Vcl.StdCtrls,
  Vcl.Mask,
  JvExMask,
  JvToolEdit,
  JvMaskEdit,
  JvCheckedMaskEdit,
  JvDatePickerEdit, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Datasnap.DBClient, System.ImageList, Vcl.ImgList;

type
  TFormPrincipal = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Pagina: TPageControl;
    tabCadastrar: TTabSheet;
    TabConsultar: TTabSheet;
    tabResumos: TTabSheet;
    Panel6: TPanel;
    sbFechar: TSpeedButton;
    Panel2: TPanel;
    sbCadastro: TSpeedButton;
    Panel8: TPanel;
    sbConsultar: TSpeedButton;
    Panel9: TPanel;
    Panel10: TPanel;
    PanelCadstro: TPanel;
    Panel12: TPanel;
    Label2: TLabel;
    jvDataEmissao: TJvDatePickerEdit;
    Label1: TLabel;
    Label3: TLabel;
    jvDataPrevEntrega: TJvDatePickerEdit;
    Label4: TLabel;
    cbPrioridade: TComboBox;
    Label5: TLabel;
    cbTarefa: TComboBox;
    Label6: TLabel;
    edResponsavel: TEdit;
    Label7: TLabel;
    mDescricao: TMemo;
    Panel13: TPanel;
    Panel15: TPanel;
    sbSalvarTarefa: TSpeedButton;
    Panel16: TPanel;
    Panel17: TPanel;
    sbCancelar: TSpeedButton;
    Panel18: TPanel;
    Panel14: TPanel;
    Panel19: TPanel;
    Label8: TLabel;
    Panel20: TPanel;
    Panel21: TPanel;
    Label9: TLabel;
    Panel22: TPanel;
    sbEstatisticas: TSpeedButton;
    Panel23: TPanel;
    Label10: TLabel;
    jvDataEntrega: TJvDatePickerEdit;
    Label11: TLabel;
    edId: TEdit;
    Panel7: TPanel;
    Panel11: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    DBGrid1: TDBGrid;
    Panel26: TPanel;
    sbConsultarTarefas: TSpeedButton;
    MemTarefas: TFDMemTable;
    SrcTarefas: TDataSource;
    Label12: TLabel;
    edPesqId: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    pcbPrioridade: TComboBox;
    pcbStatus: TComboBox;
    ImageList1: TImageList;
    Panel27: TPanel;
    Image1: TImage;
    Label15: TLabel;
    Image2: TImage;
    Label16: TLabel;
    MemTarefasCADASTRO: TDateTimeField;
    MemTarefasENTREGA: TDateTimeField;
    MemTarefasPREVISAO: TDateTimeField;
    MemTarefasRESPONSAVEL: TStringField;
    MemTarefasDESCRICAO: TStringField;
    MemTarefasPRIORIDADE: TStringField;
    Panel28: TPanel;
    Label17: TLabel;
    Label18: TLabel;
    edTotalTarefas: TEdit;
    edUltimos: TEdit;
    Image3: TImage;
    Label19: TLabel;
    MemMedias: TFDMemTable;
    SrcMedias: TDataSource;
    MemMediasPRIORIDADE: TStringField;
    DBGrid2: TDBGrid;
    MemMediasMEDIA: TCurrencyField;
    Label20: TLabel;
    MemTarefasstatustarefa: TStringField;
    MemTarefasidtarefa: TIntegerField;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sbFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbCadastroClick(Sender: TObject);
    procedure sbSalvarTarefaClick(Sender: TObject);
    procedure mDescricaoKeyPress(Sender: TObject; var Key: Char);
    procedure cbPrioridadeKeyPress(Sender: TObject; var Key: Char);
    procedure cbTarefaKeyPress(Sender: TObject; var Key: Char);
    procedure sbCancelarClick(Sender: TObject);
    procedure sbConsultarTarefasClick(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure sbEstatisticasClick(Sender: TObject);
    procedure sbConsultarClick(Sender: TObject);
    procedure pcbStatusKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

  const USUARIO  = 'usuario';
  const SENHA    = 'T@r#fa';
  const URL_BASE = 'http://localhost:9000/';
implementation



{$R *.dfm}

procedure TFormPrincipal.cbPrioridadeKeyPress(Sender: TObject; var Key: Char);
begin
   if key=#13 then cbTarefa.setfocus;

end;

procedure TFormPrincipal.cbTarefaKeyPress(Sender: TObject; var Key: Char);
begin
   if key=#13 then edResponsavel.SetFocus;

end;

procedure TFormPrincipal.DBGrid1CellClick(Column: TColumn);
var
  lResponse: IResponse;
  objTarefa: TJSONObject;
begin
   {$REGION 'EXCLUINDO TAREFA'}
   if Column.FieldName = 'DEL' then begin
      try
         DBGrid1.Enabled :=  false;
         Screen.Cursor          := crSQLWait;
         try

           lResponse := TRequest.New.BaseURL(URL_BASE)
                                .Resource('tarefa/'+SrcTarefas.DataSet.fieldbyname('idtarefa').asstring)
                                .BasicAuthentication(USUARIO,SENHA)
                                .Accept('application/json')
                                .Delete;

           if  lResponse.StatusCode <> 200 then begin
              ShowMessage('Erro ao tentar excluir  a tarefa :  '+
                       lResponse.StatusCode.ToString+' '+
                       lResponse.Content);

              sbConsultarTarefas.Click;
           end else begin

              ShowMessage('Tarefa excluida com sucesso!');
           end;
         except on E: Exception do begin
             ShowMessage('Erro ao tentar se comunicar com o sevidor '+#13+E.Message);
             Exit
           end;
         end;


      finally
         DBGrid1.Enabled := True;
         Screen.Cursor          := crDefault;
      end;


     //sbConsultarTarefas.Click;
   end;
   {$ENDREGION 'EXCLUINDO TAREFA'}

   {$REGION 'ENCERRADNDO TAREFA'}
   if Column.FieldName = 'ENC' then begin
    try
       objTarefa  := TJSONObject.Create;
       objTarefa.AddPair('entrega' ,Formatdatetime('yyyy-mm-dd',Date)+'T'+Formatdatetime('hh:mm:ss',Now));
       objTarefa.AddPair('statustarefa','Encerrada');
       try

         lResponse := TRequest.New.BaseURL(URL_BASE)
                              .Resource('tarefa/'+SrcTarefas.DataSet.FieldByName('idtarefa').AsString)
                              .BasicAuthentication(USUARIO,SENHA)
                              .Accept('application/json')
                              .AddBody(objTarefa.ToString)
                              .Put;

         if lResponse.StatusCode <>200 then begin
            ShowMessage('Erro ao tentar Encerrar a tarefa :  '+
                     lResponse.StatusCode.ToString+' '+
                     lResponse.Content);


         end else begin

            ShowMessage('Tarefa Encerrada com sucesso!');
         end;
       except on E: Exception do begin
           ShowMessage('Erro ao tentar se comunicar com o sevidor '+#13+E.Message);
           Exit
         end;
       end;

       sbConsultarTarefas.Click;


    finally
       objTarefa.DisposeOf;
       sbSalvarTarefa.Enabled := True;
       Screen.Cursor          := crDefault;
    end;


   end;
   {$REGION 'ENCERRADNO'}
end;

procedure TFormPrincipal.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
   if Column.FieldName = 'DEL' then  begin
     TDBGrid(Sender).Canvas.FillRect(Rect);
     ImageList1.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 2);
   end;
   if Column.FieldName = 'ENC' then  begin
     TDBGrid(Sender).Canvas.FillRect(Rect);
     ImageList1.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 0);
   end;
end;

procedure TFormPrincipal.DBGrid1KeyPress(Sender: TObject; var Key: Char);
var
  dtConvert: string;
begin
   if key=#13 then begin
     if MemTarefas.IsEmpty then exit;
     sbCadastro.Click;

     edId.Text              := MemTarefas.FieldByName('idtarefa').AsString;
     jvDataEmissao.Date     := MemTarefas.FieldByName('cadastro').AsDateTime;
     jvDataPrevEntrega.Date := MemTarefas.FieldByName('previsao').AsDateTime;
     if MemTarefas.FieldByName('entrega').AsDateTime > 0 then
       jvDataEntrega.Date     := MemTarefas.FieldByName('entrega').AsDateTime;

     edResponsavel.Text     := MemTarefas.FieldByName('responsavel').AsString;
     mDescricao.Text        := MemTarefas.FieldByName('descricao').AsWideString;
     cbPrioridade.ItemIndex := cbPrioridade.Items.IndexOf(MemTarefas.FieldByName('prioridade').AsString);
     cbTarefa.ItemIndex     := cbTarefa.Items.IndexOf(MemTarefas.FieldByName('statustarefa').AsString);


   end;
end;

procedure TFormPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := cafree;
end;

procedure TFormPrincipal.FormKeyPress(Sender: TObject; var Key: Char);
begin
   //para ir para o proximo componente usando o enter
   if key=#13 then Perform(WM_NEXTDLGCTL,0,0);

end;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
   MudaTab(Pagina,1);
end;

procedure TFormPrincipal.mDescricaoKeyPress(Sender: TObject; var Key: Char);
begin
   if Key=#13 then begin
      mDescricao.SetFocus;
   end;

end;

procedure TFormPrincipal.pcbStatusKeyPress(Sender: TObject; var Key: Char);
begin
   if key=#13 then pcbPrioridade.SetFocus;


end;

procedure TFormPrincipal.sbCadastroClick(Sender: TObject);
begin
   Mudatab(Pagina,0);
   sbCancelar.Click;
   PanelCadstro.Enabled   := true;
   jvDataEmissao.Date     := Date;
   cbPrioridade.ItemIndex := 0;
   cbTarefa.ItemIndex     := 0;
   jvDataPrevEntrega.SetFocus;
   jvDataPrevEntrega.SelectAll;
end;

procedure TFormPrincipal.sbConsultarClick(Sender: TObject);
begin
   MudaTab(Pagina,1);
   edPesqId.SetFocus;
end;

procedure TFormPrincipal.sbConsultarTarefasClick(Sender: TObject);
var
  LResponse : IResponse;
begin
try
  sbConsultarTarefas.Enabled := false;
  Screen.Cursor              := crSQLWait;

  LResponse :=  TRequest.New
                        .BaseURL(URL_BASE)
                        .Resource('tarefas')
                        .BasicAuthentication(USUARIO,SENHA)
                        .Accept('application/json')
                        .Adapters(TDataSetSerializeAdapter.New(MemTarefas))
                        .AddParam('idtarefa'    ,edPesqId.Text,pkQUERY)
                        .AddParam('statustarefa',pcbStatus.Text,pkQUERY)
                        .AddParam('prioridade'  ,pcbPrioridade.Text,pkQUERY)
                        .AddParam('sort'  ,'prioridade',pkQUERY)

                        .get;

  if LResponse.StatusCode <> 200 then begin
    if LResponse.StatusCode = 404  then
       ShowMessage('Aten��o, Nenhuma tarefa econtrada com esses filtros')

    else
       ShowMessage('erro ao realizar consulta '+LResponse.Content);
    exit;
  end;






finally
  sbConsultarTarefas.Enabled := true;
  Screen.Cursor              := crDefault;
end;
end;

procedure TFormPrincipal.sbEstatisticasClick(Sender: TObject);
var
  LResponse : IResponse;
  objTarefa:TJSONObject;
begin
   Mudatab(Pagina,2);

try
  sbEstatisticas.Enabled := false;
  Screen.Cursor              := crSQLWait;

  {$REGION 'TOTAL DE TAREFAS'}
    LResponse :=  TRequest.New
                          .BaseURL(URL_BASE)
                          .Resource('tarefas/totaltarefas')
                          .BasicAuthentication(USUARIO,SENHA)
                          .Accept('application/json')
                          .get;

    if LResponse.StatusCode <> 201 then begin
      if LResponse.StatusCode = 404  then
         ShowMessage('Aten��o, Nenhuma tarefa econtrada com esses filtros')

      else
         ShowMessage('erro ao realizar consulta '+LResponse.Content);

       edTotalTarefas.Text :=  '0'
    end else begin
       try
         objTarefa := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(lResponse.Content), 0) as TJSONObject;
         edTotalTarefas.Text :=  FormatFloat('0',objTarefa.GetValue<integer>('totaltarefas',0));

       finally
          objTarefa.DisposeOf;
       end;
    end;
  {$ENDREGION }

  {$REGION 'TAREFAS NOS ULTIMOS 7 DIAS'}
     LResponse :=  TRequest.New
                          .BaseURL(URL_BASE)
                          .Resource('tarefas/encerradasultimosdias')
                          .BasicAuthentication(USUARIO,SENHA)
                          .Accept('application/json')
                          .AddParam('dias','7')
                          .get;

    if LResponse.StatusCode <> 201 then begin
      if LResponse.StatusCode = 404  then
         ShowMessage('Aten��o, Nenhuma tarefa econtrada com esses filtros')

      else
         ShowMessage('erro ao realizar consulta '+LResponse.Content);

       edTotalTarefas.Text :=  '0'
    end else begin
       try
         objTarefa      := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(lResponse.Content), 0) as TJSONObject;
         edUltimos.Text :=  FormatFloat('0',objTarefa.GetValue<integer>('totaltarefas',0));

       finally
          objTarefa.DisposeOf;
       end;
    end;
  {$ENDREGION 'TAREFAS NOS ULTIMOS 7 DIAS'}

  {$REGION 'MEDIA DE PRIORIADE'}

    LResponse :=  TRequest.New
                          .BaseURL(URL_BASE)
                          .Resource('tarefas/mediaprioridadependentes')
                          .BasicAuthentication(USUARIO,SENHA)
                          .Accept('application/json')
                          .Adapters(TDataSetSerializeAdapter.New(MemMedias))
                          .get;

    if LResponse.StatusCode <> 200 then begin
      if LResponse.StatusCode = 404  then
         ShowMessage('Aten��o, Nenhuma tarefa econtrada para ver a media')

      else
         ShowMessage('erro ao realizar consulta '+LResponse.Content);
      exit;
    end;
  {$ENDREGION 'MEDIA PRIORIDADE'}


finally
  sbEstatisticas.Enabled := true;
  Screen.Cursor          := crDefault;
end;

end;

procedure TFormPrincipal.sbFecharClick(Sender: TObject);
begin
   Application.Terminate;
   abort;
end;

procedure TFormPrincipal.sbSalvarTarefaClick(Sender: TObject);
var
  lResponse: IResponse;
  objTarefa: TJSONObject;
begin

try
   objTarefa  := TJSONObject.Create;
   if edId.Text <> '' then
      objTarefa.AddPair('idtarefa' ,Strtoint(edId.Text));

   objTarefa.AddPair('dt_cadastro' ,Formatdatetime('yyyy-mm-dd',jvDataEmissao.Date)+'T'+Formatdatetime('hh:mm:ss',Now));
   objTarefa.AddPair('dt_previsao' ,Formatdatetime('yyyy-mm-dd',jvDataPrevEntrega.Date)+'T'+Formatdatetime('hh:mm:ss',Now));
   objTarefa.AddPair('responsavel' ,edResponsavel.Text);
   objTarefa.AddPair('statustarefa',cbTarefa.Text);
   objTarefa.AddPair('prioridade'  ,cbPrioridade.Text);
   objTarefa.AddPair('descricao'   ,mDescricao.Text);
   try

     lResponse := TRequest.New.BaseURL(URL_BASE)
                          .Resource('tarefa')
                          .BasicAuthentication(USUARIO,SENHA)
                          .Accept('application/json')
                          .AddBody(objTarefa.ToString)
                          .Post;

     if (lResponse.StatusCode <> 200) and (lResponse.StatusCode <> 201) then begin
        ShowMessage('Erro ao tentar castrar a tarefa :  '+
                 lResponse.StatusCode.ToString+' '+
                 lResponse.Content);
                 exit;


     end else begin

        if lResponse.StatusCode  = 200 then begin
           objTarefa := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(lResponse.Content), 0) as TJSONObject;
           edId.Text := objTarefa.GetValue<string>('idtarefa','');

        end;
        ShowMessage('Tarefa cadastrada com sucesso!');
     end;
   except on E: Exception do begin
       ShowMessage('Erro ao tentar se comunicar com o sevidor '+#13+E.Message);
       Exit
     end;
   end;

   sbCancelar.Click;
   sbConsultar.Click;
   sbConsultarTarefas.Click;

finally
  objTarefa.DisposeOf;
  sbSalvarTarefa.Enabled := True;
  Screen.Cursor          := crDefault;
end;
end;

procedure TFormPrincipal.sbCancelarClick(Sender: TObject);
var
  I: Integer;
begin
   PanelCadstro.Enabled := false;
   for I := 0 to ComponentCount-1 do begin
      if (Components[i].Tag = 1) and (Components[i] is TEdit) then TEdit(Components[i]).Text := '';
      if (Components[i].Tag = 1) and (Components[i] is TMemo) then TMemo(Components[i]).Text := '';
      if (Components[i].Tag = 1) and (Components[i] is TJvDatePickerEdit) then TJvDatePickerEdit(Components[i]).Date := 0;
      if (Components[i].Tag = 1) and (Components[i] is TComboBox) then TComboBox(Components[i]).ItemIndex :=-1;


   end;

end;

end.
