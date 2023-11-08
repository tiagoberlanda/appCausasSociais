unit FrmProjetoAdd;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FrmBase, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.Edit,
  FMX.TabControl,fmx.DialogService;

type
  TFormProjetoAdd = class(TForm_base)
    Image_voltar: TImage;
    Label_nome: TLabel;
    Label1: TLabel;
    Layout_centralAdd: TLayout;
    Rectangle_principal: TRectangle;
    Rectangle_projeto: TRectangle;
    Label2: TLabel;
    Edit_projeto: TEdit;
    Rectangle_adicionar: TRectangle;
    Label_adicionar: TLabel;
    TabControl1: TTabControl;
    TabAdd: TTabItem;
    TabEdit: TTabItem;
    Layout_centralEdit: TLayout;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Edit_projetoEdit: TEdit;
    Label3: TLabel;
    Rectangle_modificar: TRectangle;
    Label_modificar: TLabel;
    Layout1: TLayout;
    Rectangle_excluir: TRectangle;
    Label4_excluir: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Image_voltarClick(Sender: TObject);
    procedure Label_adicionarClick(Sender: TObject);
    procedure Label_modificarClick(Sender: TObject);
    procedure Label4_excluirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormProjetoAdd: TFormProjetoAdd;

implementation

{$R *.fmx}

uses FrmProjetos, DMConexao;

procedure TFormProjetoAdd.FormShow(Sender: TObject);
begin
  inherited;

  //Verifica se é novo registro

  if Label_nome.Tag = 0 then
  begin
    Label_nome.Text := 'Adicionar Projeto';
    TabControl1.ActiveTab := TabAdd;
  end
  else
  begin
    Label_nome.Text := 'Modificar Projeto';
    TabControl1.ActiveTab := TabEdit;
  end;

end;

procedure TFormProjetoAdd.Image_voltarClick(Sender: TObject);
begin
  inherited;
  FormProjetos := TFormProjetos.Create(self);
  Application.MainForm := FormProjetos;

  FormProjetos.Label_nome.TagString := LabeL_nome.TagString;

  FormProjetos.AddListViewProjetos();
  FormProjetos.show;
  FormProjetoAdd.close;
  end;

procedure TFormProjetoAdd.Label4_excluirClick(Sender: TObject);
begin
  inherited;
// Lembra de declarar no uses: fmx.DialogService
    TDialogService.MessageDialog('Deseja excluir o projeto ' + Edit_projetoEdit.Text + '?',
                                   TMsgDlgType.mtConfirmation,
                                   [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                                   TMsgDlgBtn.mbNo,
                                   0,
      procedure(const AResult: TModalResult)
      begin
        if AResult = mrYes then
        begin
          // Apaga projeto do Banco de dados
          DM_Conexao.FD_Conexao.Close;
          DM_Conexao.FD_Conexao.open();
          DM_Conexao.FD_Query.SQL.Clear;
          DM_Conexao.FD_Query.SQL.Add('delete from projeto where id = :id');
          DM_Conexao.FD_Query.ParamByName('id').AsInteger := Edit_projetoEdit.TagString.ToInteger();
          DM_Conexao.FD_Query.ExecSQL;
          ShowMessage('Projeto deletado com sucesso!');

          //Volta para tela anterior
          FormProjetos := TFormProjetos.Create(self);
          Application.MainForm := FormProjetos;

          FormProjetos.Label_nome.TagString := LabeL_nome.TagString;

          FormProjetos.AddListViewProjetos();
          FormProjetos.show;
          FormProjetoAdd.close;
        end
      end);
end;

procedure TFormProjetoAdd.Label_adicionarClick(Sender: TObject);
begin
  inherited;
  if Edit_projeto.Text = '' then
  begin
    ShowMessage('Preencha o nome do Projeto!');
  end
  else
  begin
    //verifica se o projeto já existe

    if DM_Conexao.verificaProjeto(Edit_projeto.text) = True then
    begin
      ShowMessage('Esse nome de Projeto já foi utilizado, use outro.');
    end
    else
    begin
      //Insere no banco
      if DM_Conexao.InsereProjeto(Edit_projeto.text) = False then
      begin
        ShowMessage('Ocorreu um erro ao inserir essa informação, verifique!');
      end
      else
      begin
        ShowMessage('Projeto inserido com sucesso');
        //Volta para tela anterior
        FormProjetos := TFormProjetos.Create(self);
        Application.MainForm := FormProjetos;

        FormProjetos.Label_nome.TagString := LabeL_nome.TagString;

        FormProjetos.AddListViewProjetos();
        FormProjetos.show;
        FormProjetoAdd.close;

      end;


    end;


  end;
end;

procedure TFormProjetoAdd.Label_modificarClick(Sender: TObject);
begin
  inherited;

  //verifica digitação
  if Edit_projetoEdit.Text = '' then
  begin
    ShowMessage('Preencha um nome para o Projeto!');
  end
  else
  begin

    //verifica se o projeto já existe
    if DM_Conexao.verificaProjeto(Edit_projetoEdit.text) = True then
    begin
      ShowMessage('Esse nome de Projeto já foi utilizado, use outro.');
    end
    else //Se não existir faz a alteração no banco de dados
    begin
      DM_Conexao.FD_Conexao.Close;
      DM_Conexao.FD_Conexao.Open;
      DM_Conexao.FD_Query.SQL.Clear;
      DM_Conexao.FD_Query.SQL.Add('update projeto set nome = :nome where id = :id');
      DM_Conexao.FD_Query.ParamByName('nome').AsString := Edit_projetoEdit.text;
      DM_Conexao.FD_Query.ParamByName('id').AsInteger := Edit_projetoEdit.TagString.ToInteger();
      DM_Conexao.FD_Query.ExecSQL;

      ShowMessage('Projeto alterado com sucesso!');

      //Volta para tela anterior
      FormProjetos := TFormProjetos.Create(self);
      Application.MainForm := FormProjetos;

      FormProjetos.Label_nome.TagString := LabeL_nome.TagString;

      FormProjetos.AddListViewProjetos();
      FormProjetos.show;
      FormProjetoAdd.close;

    end;
  end;

end;

end.
