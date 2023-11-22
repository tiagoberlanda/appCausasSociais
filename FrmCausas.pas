unit FrmCausas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FrmBase, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TFormCausas = class(TForm_base)
    Image_voltar: TImage;
    Label_nome: TLabel;
    Label_info: TLabel;
    Layout_central: TLayout;
    ListView_causas: TListView;
    Image_adicionar: TImage;
    Image_editar: TImage;
    procedure Image_voltarClick(Sender: TObject);
    procedure Image_adicionarClick(Sender: TObject);
    procedure ListView_causasItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    procedure AddlistViewCausas();
  public
    { Public declarations }
  end;

var
  FormCausas: TFormCausas;

implementation

{$R *.fmx}

uses FrmAdministracao, FrmCausasAdd, DMConexao;

procedure TFormCausas.AddlistViewCausas;
begin
  ListView_causas.Items.clear; // limpa informações

  // Inicia Conexão no Banco
  if DM_Conexao.FD_Conexao.Connected = False then
  begin
    DM_Conexao.FD_Conexao.Connected := True;
  end;

  //consulta
  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('select id, nome from causas');
  DM_Conexao.FD_Query.Open();

  //Inserindo no List View
  while not DM_Conexao.FD_Query.Eof do
  begin
    with ListView_causas.Items.Add do
    begin
      TagString := DM_Conexao.FD_Query.FieldByName('id').AsString;


      // Adiciona o ID e Nome

      TListItemText(Objects.FindDrawable('id')).Text := DM_Conexao.FD_Query.FieldByName('id').AsString;
      TListItemText(Objects.FindDrawable('nome')).Text := DM_Conexao.FD_Query.FieldByName('nome').AsString;

      // Adiciona Imagens
      TListItemImage(Objects.FindDrawable('editar')).Bitmap := Image_editar.Bitmap;
    end;
    DM_Conexao.FD_Query.Next;

  end;

  if ListView_causas.Items.Count = 0 then
  // Se não tiver nenhum item no ListView
  begin
    with ListView_causas.Items.Add do
    begin
      TListItemText(Objects.FindDrawable('nome')).Text :=
        'Sem Causas cadastradas...';
    end;
  end;

end;

procedure TFormCausas.FormCreate(Sender: TObject);
begin
  inherited;
  AddlistViewCausas();
end;

procedure TFormCausas.Image_adicionarClick(Sender: TObject);
begin
  inherited;

  FormCausasAdd := TFormCausasAdd.Create(self);
  application.MainForm := FormCausasAdd;

  FormCausasAdd.Label_nome.TagString := Label_nome.TagString;

  //Informa que é um novo registro
  FormCausasAdd.Label_nome.Tag := 0;

  FormCausasAdd.Show;
  FormCausas.Close;

end;

procedure TFormCausas.Image_voltarClick(Sender: TObject);
begin
  inherited;
  FormAdministracao := TFormAdministracao.Create(self);
  application.MainForm := FormAdministracao;

  FormAdministracao.Label_nome.TagString := Label_nome.TagString;

  FormAdministracao.Show;
  FormCausas.Close;
end;

procedure TFormCausas.ListView_causasItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var
  nome,nomeProjeto,onde,como,objetivo: string;
  idProjeto : integer;
begin
  inherited;
  if ItemObject <> nil then // Usuário clicou em algum objeto
  begin
    if ItemObject.Name = 'editar' then
    begin

      DM_Conexao := TDM_Conexao.Create(self);
      // Busca informações do usuário no Banco.
      // Inicia Conexão no Banco
      if DM_Conexao.FD_Conexao.Connected = False then
      begin
       DM_Conexao.FD_Conexao.Connected := True;
      end;

      DM_Conexao.FD_Query.Close;
      DM_Conexao.FD_Query.SQL.Clear;
      DM_Conexao.FD_Query.SQL.Add('select id,nome,idProjeto,OndeEncontrar,ComoAjudar,Objetivo from causas Where id = :id');
      DM_Conexao.FD_Query.ParamByName('id').AsInteger := ListView_causas.Items[ItemIndex].TagString.ToInteger();
      DM_Conexao.FD_Query.Open();
      //Passa os valores para as variaveis
      nome := DM_Conexao.FD_Query.FieldByName('nome').AsString;
      onde := DM_Conexao.FD_Query.FieldByName('OndeEncontrar').AsString;
      idProjeto := DM_Conexao.FD_Query.FieldByName('idProjeto').AsInteger;
      como := DM_Conexao.FD_Query.FieldByName('ComoAjudar').AsString;
      objetivo := DM_Conexao.FD_Query.FieldByName('Objetivo').AsString;
      nomeProjeto := DM_Conexao.RetornaNomeProjetoId(idProjeto);

      //Preenche informações no Form

      FormCausasAdd := TFormCausasAdd.Create(self);
      Application.MainForm := FormCausasAdd;

      //Informa que será uma edição de registro
      FormCausasAdd.label_nome.Tag := 1; //Edição de Registro

      FormCausasAdd.Edit_nomeProjeto.Tag := ListView_causas.Items[ItemIndex].TagString.ToInteger();  //passa id do registro
      FormCausasAdd.Edit_nomeProjeto.Text := nome;
      FormCausasAdd.Edit_ondeEncontrar.Text := onde;
      FormCausasAdd.Edit_comoAjudar.Text := como;
      FormCausasAdd.Memo_objetivo.Lines.Add(objetivo);
      //ComboBox1.Items.IndexOf(´Teste´)
      FormCausasAdd.ComboBoxProjeto.ItemIndex := FormCausasAdd.ComboBoxProjeto.items.indexOf(nomeProjeto);

      //Passa e-mail usuário.
      FormCausasAdd.Label_nome.TagString := Label_nome.TagString;

      FormCausasAdd.Show;
      FormCausas.Close;
    end;
  end;
end;

end.
