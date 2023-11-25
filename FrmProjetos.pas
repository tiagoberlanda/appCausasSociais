unit FrmProjetos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FrmBase, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TFormProjetos = class(TForm_base)
    Image_voltar: TImage;
    Label_nome: TLabel;
    Label1: TLabel;
    Image_adicionar: TImage;
    Layout1: TLayout;
    ListView_projetos: TListView;
    Image_editar: TImage;
    procedure Image_adicionarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image_voltarClick(Sender: TObject);
    procedure ListView_projetosItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddListViewProjetos();
  end;

var
  FormProjetos: TFormProjetos;

implementation

{$R *.fmx}

uses FrmProjetoAdd, DMConexao, FrmAdministracao;

procedure TFormProjetos.AddListViewProjetos;
begin
  //
  ListView_projetos.Items.clear; // limpa informações

  // Inicia Conexão no Banco
  if DM_Conexao.FD_Conexao.Connected = False then
  begin
    DM_Conexao.FD_Conexao.Connected := True;
  end;

  //consulta
  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('select id, nome from projeto');
  DM_Conexao.FD_Query.Open();

  //Inserindo no List View
  while not DM_Conexao.FD_Query.Eof do
  begin
    with ListView_projetos.Items.Add do
    begin
      TagString := DM_Conexao.FD_Query.FieldByName('id').AsString;
      // Adiciona o ID e Nome
      TListItemText(Objects.FindDrawable('id')).Text := DM_Conexao.FD_Query.FieldByName('id').AsString;
      TListItemText(Objects.FindDrawable('projeto')).Text := DM_Conexao.FD_Query.FieldByName('nome').AsString;

      // Adiciona Imagens
      TListItemImage(Objects.FindDrawable('editar')).Bitmap := Image_editar.Bitmap;
    end;
    DM_Conexao.FD_Query.Next;

  end;

  if ListView_projetos.Items.Count = 0 then
  // Se não tiver nenhum item no ListView
  begin
    with ListView_projetos.Items.Add do
    begin
      TListItemText(Objects.FindDrawable('projeto')).Text :=
        'Sem Projetos...';
    end;
  end;


end;

procedure TFormProjetos.FormCreate(Sender: TObject);
begin
  inherited;
  AddListViewProjetos();
end;

procedure TFormProjetos.Image_adicionarClick(Sender: TObject);
begin
  inherited;
  FormProjetoAdd := TFormProjetoAdd.Create(self);
  Application.MainForm := FormProjetoAdd;

  FormProjetoAdd.Label_nome.TagString := Label_nome.TagString;

  //Informa que é novo registro
  FormProjetoAdd.Label_nome.Tag := 0;

  FormProjetoAdd.Show;
  FormProjetos.Close;
end;

procedure TFormProjetos.Image_voltarClick(Sender: TObject);
begin
  inherited;
  //Vai para Form Administracao
  FormAdministracao := TFormAdministracao.Create(self);
  Application.MainForm := FormAdministracao;

  FormAdministracao.Label_nome.tagString := Label_nome.TagString;

  FormAdministracao.show;
  FormProjetos.Close;
end;

procedure TFormProjetos.ListView_projetosItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  inherited;

  if ItemObject <> nil then // Usuário clicou em algum objeto
  begin
    if ItemObject.Name = 'editar' then
    begin

      // Busca informações do usuário no Banco.

      // Inicia Conexão no Banco
      if DM_Conexao.FD_Conexao.Connected = False then
      begin
       DM_Conexao.FD_Conexao.Connected := True;
      end;
      DM_Conexao.FD_Query.Close;
      DM_Conexao.FD_Query.SQL.Clear;
      DM_Conexao.FD_Query.SQL.Add('select id,nome from projeto Where id = :id');
      DM_Conexao.FD_Query.ParamByName('id').AsInteger := ListView_projetos.Items[ItemIndex].TagString.ToInteger();
      DM_Conexao.FD_Query.Open();

      //Preenche informações no Form

      FormProjetoAdd := TFormProjetoAdd.Create(self);
      Application.MainForm := FormProjetoAdd;

      //Informa que será uma edição de registro
      FormProjetoAdd.label_nome.Tag := 1; //Edição de Registro

      FormProjetoAdd.Edit_projetoEdit.Text := DM_Conexao.FD_Query.FieldByName('nome').AsString;

      FormProjetoAdd.Edit_projetoEdit.TagString := ListView_projetos.Items[ItemIndex].TagString; //passa iD do registro na TagString da Edit
      //Passa e-mail usuário.
      FormProjetoAdd.Label_nome.TagString := Label_nome.TagString;

      FormProjetoAdd.Show;
      FormProjetos.Close;
    end;
  end;
end;

end.
