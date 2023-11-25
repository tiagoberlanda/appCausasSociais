unit FrmPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Ani,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TFormPrincipal = class(TForm)
    Label_nomeUsuario: TLabel;
    Layout_superior: TLayout;
    CirculoSuperior: TRoundRect;
    Label_nome: TLabel;
    Image1: TImage;
    Layout_centralSup: TLayout;
    Layout_direita: TLayout;
    Layout_esquerdo: TLayout;
    Label_info: TLabel;
    ListView_principal: TListView;
    Image_preto: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView_principalItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure PreencheInformacoes();

end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.fmx}

uses DMConexao, FrmMenu, FrmPublicacao;

procedure TFormPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FormPrincipal := Nil;
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
  //passa id usuario para tag da label_usuario
  Label_nome.Tag := DM_Conexao.RetornaIdPeloEmail(Label_nome.TagString);
 PreencheInformacoes();
end;

procedure TFormPrincipal.Image1Click(Sender: TObject);
begin
  FormMenu := TformMenu.Create(self);
  Application.MainForm := FormMenu;

  //Passa e-mail do usuário de um form para outro.
  FormMenu.Label_nome.tagString := Label_nome.TagString;
  FormMenu.Label_nome.Tag := label_nome.Tag;

  FormMenu.show;
  FormPrincipal.Close;
end;


procedure TFormPrincipal.ListView_principalItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject <> nil then // Usuário clicou em algum objeto
  begin
    if ItemObject.Name = 'saiba' then
    begin
      FormPublicacao := TFormPublicacao.Create(self);
      Application.MainForm := FormPublicacao;

      //Passa e-mail usuário.
      FormPublicacao.Label_nome.TagString := Label_nome.TagString; //email do usuario
      FormPublicacao.Label_nome.Tag := label_nome.Tag; //id do usuario
      FormPublicacao.Label_info.TagString := ListView_principal.Items[ItemIndex].TagString;  //id da causa
      FormPublicacao.Label_info.Tag := Label_info.Tag ;

      FormPublicacao.Show;
      FormPrincipal.Close;
    end
  end;
end;

procedure TFormPrincipal.PreencheInformacoes;
begin
//
  ListView_principal.Items.clear; // limpa informações
  DM_Conexao.FD_Conexao.Close;
  DM_Conexao.FD_Conexao.open;
  //consulta
  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('select c.id, c.nome,c.objetivo,c.idUsuario,p.nome as projeto from causas c, projeto p '+
  'where p.id = c.idProjeto');
  DM_Conexao.FD_Query.Open();

  //Inserindo no List View
  while not DM_Conexao.FD_Query.Eof do
  begin
    with ListView_principal.Items.Add do
    begin
      TagString := DM_Conexao.FD_Query.FieldByName('id').AsString;

      TListItemText(Objects.FindDrawable('titulo')).Text := DM_Conexao.FD_Query.FieldByName('nome').AsString;
      TListItemText(Objects.FindDrawable('objetivo')).Text := DM_Conexao.FD_Query.FieldByName('objetivo').AsString;
      TListItemText(Objects.FindDrawable('projeto')).Text := DM_Conexao.FD_Query.FieldByName('projeto').AsString;
      TListItemText(Objects.FindDrawable('txtSaiba')).Text := 'Clique para Saber Mais';
      // Adiciona Imagens
      TListItemImage(Objects.FindDrawable('linha1')).Bitmap := Image_preto.Bitmap;
      //TListItemImage(Objects.FindDrawable('linha2')).Bitmap := Image_preto.Bitmap;
      TListItemImage(Objects.FindDrawable('linha3')).Bitmap := Image_preto.Bitmap;
      TListItemImage(Objects.FindDrawable('saiba')).Bitmap := Image_preto.Bitmap;
    end;
    DM_Conexao.FD_Query.Next;

  end;

  if ListView_principal.Items.Count = 0 then
  // Se não tiver nenhum item no ListView
  begin
    with ListView_principal.Items.Add do
    begin
      TListItemText(Objects.FindDrawable('titulo')).Text :=
        'Sem Projetos...';
    end;
  end;
end;

end.
