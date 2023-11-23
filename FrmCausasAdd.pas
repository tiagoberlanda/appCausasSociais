unit FrmCausasAdd;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FrmBase, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.Edit,
  FMX.ListBox, FMX.Memo.Types, FMX.ScrollBox,fmx.DialogService, FMX.Memo;

type
  TFormCausasAdd = class(TForm_base)
    Image_voltar: TImage;
    Label_nome: TLabel;
    Label_info: TLabel;
    Layout_central: TLayout;
    Rectangle_central: TRectangle;
    RoundRect_nomeCausa: TRoundRect;
    Label_nomeCausa: TLabel;
    Edit_nomeProjeto: TEdit;
    RoundRect1: TRoundRect;
    Label_projeto: TLabel;
    ComboBoxProjeto: TComboBox;
    Rectangle2: TRectangle;
    Label1: TLabel;
    Rectangle_confirmar: TRectangle;
    Layout_inferior: TLayout;
    Rectangle4: TRectangle;
    Memo_objetivo: TMemo;
    RoundRect2: TRoundRect;
    Edit_ondeEncontrar: TEdit;
    Label2: TLabel;
    RoundRect3: TRoundRect;
    Label3: TLabel;
    Edit_comoAjudar: TEdit;
    Label_cancelaExclui: TLabel;
    Label_salvar: TLabel;
    procedure Image_voltarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label_cancelaExcluiClick(Sender: TObject);
    procedure Label_salvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure preencheProjetos();
  end;

var
  FormCausasAdd: TFormCausasAdd;

implementation

{$R *.fmx}

uses FrmCausas, DMConexao;

procedure TFormCausasAdd.FormCreate(Sender: TObject);
begin
  inherited;
  preencheProjetos();
end;

procedure TFormCausasAdd.FormShow(Sender: TObject);
begin
  inherited;
  //Verifica se é novo registro e altera nome botão Cancelar/Excluir
  if label_info.Tag = 0 then  //Novo Registro
  begin
    Label_cancelaExclui.Text := 'Cancelar';
    Label_salvar.Text := 'Salvar';
  end
  else
  begin
    Label_cancelaExclui.Text := 'Exluir';
    Label_salvar.Text := 'Modificar';
  end;

end;

procedure TFormCausasAdd.Image_voltarClick(Sender: TObject);
begin
  inherited;
  FormCausas := TFormCausas.Create(Self);
  application.MainForm := FormCausas;

  FormCausas.Label_nome.TagString := Label_nome.TagString;
  FormCausas.Label_nome.Tag := label_nome.Tag;

  FormCausas.Show;
  FormCausasadd.close;
end;

procedure TFormCausasAdd.Label_salvarClick(Sender: TObject);
var
  idProjeto : integer;
begin
  inherited;

  //Verifica Digitação dos Campos

  if (Edit_nomeProjeto.Text = '') or (Edit_ondeEncontrar.Text = '') or (Edit_comoAjudar.Text = '') or (Memo_objetivo.Lines.GetText() = '' ) then
  begin
    showmessage('Preencha todos os campos para continuar');
  end
  else
  begin
    //Verifica se é um novo registro
    if Label_info.Tag = 0 then
    begin

      //Chama função para inserir a causa
      idProjeto := Integer(ComboBoxProjeto.Items.Objects[ComboBoxProjeto.ItemIndex]);

      if DM_Conexao.InsereCausa(Edit_nomeProjeto.Text,Memo_objetivo.Lines.GetText(),
      Edit_ondeEncontrar.Text,Edit_comoAjudar.Text,idProjeto,Label_nome.tag) = True then
      begin
        ShowMessage('Causa Inserida com Sucesso!');

        //Retorna para a tela de causas

        FormCausas := TFormCausas.Create(Self);
        application.MainForm := FormCausas;

        FormCausas.Label_nome.TagString := Label_nome.TagString;
        FormCausas.Label_nome.Tag := label_nome.Tag;

        FormCausas.Show;
        FormCausasadd.close;
      end
      else
      begin
        ShowMessage('Erro ao Inserir informações!');

        //Retorna para a tela de causas

        FormCausas := TFormCausas.Create(Self);
        application.MainForm := FormCausas;

        FormCausas.Label_nome.TagString := Label_nome.TagString;
        FormCausas.Label_nome.Tag := label_nome.tag;

        FormCausas.Show;
        FormCausasadd.close;
      end;

    end
    else //se for ediçao de registro
    begin
      //FormCausasAdd.Edit_nomeProjeto.Tag = id
      idProjeto := Integer(ComboBoxProjeto.Items.Objects[ComboBoxProjeto.ItemIndex]);
      if DM_Conexao.AlteraCausa(Edit_nomeProjeto.Text,Memo_objetivo.Lines.GetText(),
      Edit_ondeEncontrar.Text,Edit_comoAjudar.Text,Edit_nomeProjeto.Tag,idProjeto) = True then
      begin
        ShowMessage('Causa Alterada com sucesso!');
      end
      else
      begin
        ShowMessage('Erro ao Alterar Causa!');
      end;

      //Retorna para a tela de causas

      FormCausas := TFormCausas.Create(Self);
      application.MainForm := FormCausas;

      FormCausas.Label_nome.TagString := Label_nome.TagString;
      FormCausas.Label_nome.Tag := label_nome.Tag;

      FormCausas.Show;
      FormCausasadd.close;


    end;

  end;

end;

procedure TFormCausasAdd.Label_cancelaExcluiClick(Sender: TObject);
begin
  inherited;

  //Verifica se é um novo registro
  if Label_info.Tag = 0 then
  begin
    //Se Sim só cancela e volta.
    FormCausas := TformCausas.Create(self);
    application.MainForm := FormCausas;

    FormCausas.Label_nome.TagString := Label_nome.TagString;
    FormCausas.Label_nome.Tag := label_nome.Tag;

    FormCausas.Show;
    FormCausasadd.Close;

  end
  else
  begin
    // se não exclui o registro.
    // Lembra de declarar no uses: fmx.DialogService
    TDialogService.MessageDialog('Deseja Excluir essa causa?',
                                   TMsgDlgType.mtConfirmation,
                                   [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                                   TMsgDlgBtn.mbNo,
                                   0,
      procedure(const AResult: TModalResult)
      begin
        if AResult = mrYes then
        begin
          if  DM_Conexao.ExcluiCausaId(FormCausasAdd.Edit_nomeProjeto.Tag) = True then
          begin
             ShowMessage('Registro apagado com sucesso!')
          end
          else
          begin
            ShowMessage('Erro ao apagar registro!');
          end;


          FormCausas := TformCausas.Create(self);
          application.MainForm := FormCausas;

          FormCausas.Label_nome.TagString := Label_nome.TagString;
          FormCausas.Label_nome.Tag := label_nome.Tag;

          FormCausas.Show;
          FormCausasadd.Close;

        end
      end);

  end;
end;

procedure TFormCausasAdd.preencheProjetos;
begin

  DM_Conexao.FD_Conexao.Close;
  DM_Conexao.FD_Conexao.Open();
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('select id,nome from projeto order by nome asc');
  DM_Conexao.FD_Query.Open();

  ComboBoxProjeto.Clear;

  while not DM_Conexao.FD_Query.Eof do
  begin
    //ComboBox1.Items.AddObject(FDQuery1.FieldByName('nome_do_projeto').AsString,
      //TObject(FDQuery1.FieldByName('id').AsInteger));
    // id Integer(ComboBoxProjetos.Items.Objects[ComboBoxProjetos.ItemIndex])
    ComboBoxProjeto.Items.AddObject(DM_Conexao.FD_Query.FieldByName('nome').AsString,TObject(DM_Conexao.FD_Query.FieldByName('id').AsInteger));
    DM_Conexao.FD_Query.Next;
  end;


end;

end.
