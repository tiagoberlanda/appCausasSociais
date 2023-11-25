unit FrmPublicacao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FrmBase, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Edit;

type
  TFormPublicacao = class(TForm_base)
    Label_nome: TLabel;
    Label_info: TLabel;
    Image_voltar: TImage;
    Layou_central: TLayout;
    ListView_principal: TListView;
    Image_preto: TImage;
    Layout_inferiorCentral: TLayout;
    Edit_comentario: TEdit;
    Rectangle_comentario: TRectangle;
    Rectangle_cancelar: TRectangle;
    Layout1: TLayout;
    Rectangle_comentar: TRectangle;
    ListView_comentarios: TListView;
    Label_comentar: TLabel;
    Label_cancelar: TLabel;
    Label1: TLabel;
    procedure Image_voltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label_cancelarClick(Sender: TObject);
    procedure Label_comentarClick(Sender: TObject);
    procedure ListView_comentariosItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure PreencheInformacoes(id:integer);
    procedure PreencheComentarios(id: integer);
  end;

var
  FormPublicacao: TFormPublicacao;

implementation

{$R *.fmx}

uses FrmPrincipal, DMConexao, FrmComentario;

procedure TFormPublicacao.FormShow(Sender: TObject);
begin
  inherited;
  PreencheComentarios(Label_info.TagString.ToInteger());
  PreencheInformacoes(Label_info.TagString.ToInteger());
end;

procedure TFormPublicacao.Image_voltarClick(Sender: TObject);
begin
  inherited;
  FormPrincipal := TFormPrincipal.Create(self);
  application.MainForm := FormPrincipal;

  FormPrincipal.Label_nome.TagString := label_nome.TagString;
  FormPrincipal.Label_nome.Tag := label_nome.tag;

  FormPrincipal.Show;
  FormPublicacao.Close;
end;

procedure TFormPublicacao.Label_cancelarClick(Sender: TObject);
begin
  inherited;
  //Apaga informação digitada no campo comentario
  Edit_comentario.Text := '';
end;

procedure TFormPublicacao.Label_comentarClick(Sender: TObject);
begin
  inherited;
   //Label_info.TagString.ToInteger() id da causa
   if Edit_comentario.Text = '' then
   begin
     ShowMessage('Preencha o comentário para postar');
   end
   else
   begin
     // ShowMessage('idcausa:' + Label_info.TagString + ' | idUsuario: ' + label_nome.tag.ToString + ' | comentario: ' + Edit_comentario.Text);
     if DM_Conexao.InsereComentario(Label_info.TagString.ToInteger(),label_nome.Tag,Edit_comentario.Text) = True then
     begin
       showmessage('Comentario postado');
     end
     else
     begin
       showmessage('Erro ao postar comentario');
     end;
   end;

  //Apaga informação digitada no campo comentario
  PreencheComentarios(Label_info.TagString.ToInteger());
  Edit_comentario.Text := '';
end;

procedure TFormPublicacao.ListView_comentariosItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  inherited;
  if ItemObject <> nil then // Usuário clicou em algum objeto
  begin
    if ItemObject.Name = 'saibamais' then
    begin
      //Label_info.TagString.ToInteger()
      FormComentario := TFormComentario.Create(self);
      Application.MainForm := FormComentario;

      //Passa e-mail usuário.
      FormComentario.Label_nome.TagString := Label_nome.TagString; //email do usuario
      FormComentario.Label_nome.Tag := label_nome.Tag; //id do usuario
      FormComentario.Label_info.TagString := label_info.TagString;
      FormComentario.Label_info.Tag := Label_info.Tag ;

      FormComentario.Show;
      FormPublicacao.Close;
    end
  end;
end;

procedure TFormPublicacao.PreencheComentarios(id: integer);
begin
  ListView_comentarios.items.clear;
    // Inicia Conexão no Banco
  DM_Conexao.FD_Conexao.close;
  DM_Conexao.FD_Conexao.Open;
  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('select c.idCausa,c.comentario,c.data, u.nome from comentarios c, usuario u '+
    'where c.idUsuario = u.id and c.idCausa = :id order by c.data desc');
  DM_Conexao.FD_Query.ParamByName('id').AsInteger := id;
  DM_Conexao.FD_Query.Open();

  if DM_Conexao.FD_Query.RecordCount = 0 then
  begin
    with ListView_comentarios.Items.Add do
    begin
      TListItemText(Objects.FindDrawable('comentario')).Text :=
        'Sem comentários...';
    end;
  end
  else
  begin
    with ListView_comentarios.items.Add do
    begin
      // Adiciona o ID e Nome
      TagString := DM_Conexao.FD_Query.FieldByName('idCausa').AsString;

      TListItemText(Objects.FindDrawable('comentario')).Text := 'Usuario: ' + DM_Conexao.FD_Query.FieldByName('nome').AsString +
      ' - ' + DM_Conexao.FD_Query.FieldByName('data').AsString +
      #13#10 + 'Comentário: ' + DM_Conexao.FD_Query.FieldByName('comentario').AsString;

       TListItemText(Objects.FindDrawable('saibamais')).Text := 'Saiba Mais';
    end;
  end;

end;

procedure TFormPublicacao.PreencheInformacoes(id: integer);
begin
    // Inicia Conexão no Banco
  DM_Conexao.FD_Conexao.close;
  DM_Conexao.FD_Conexao.Open;
  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('select c.id,c.nome,p.nome as nomeProjeto,c.OndeEncontrar,c.ComoAjudar, '+
  'c.Objetivo from causas c,projeto p Where p.id = c.idProjeto and c.id = :id');
  DM_Conexao.FD_Query.ParamByName('id').AsInteger := id;
  DM_Conexao.FD_Query.Open();
  with ListView_principal.items.Add do
  begin
    TagString := DM_Conexao.FD_Query.FieldByName('id').AsString;
    // Adiciona o ID e Nome

    TListItemText(Objects.FindDrawable('titulo')).Text := DM_Conexao.FD_Query.FieldByName('nome').AsString;
    TListItemText(Objects.FindDrawable('projeto')).Text := DM_Conexao.FD_Query.FieldByName('nomeProjeto').AsString;
    TListItemText(Objects.FindDrawable('objetivo')).Text := 'Qual o objetivo? ' + #13#10 + DM_Conexao.FD_Query.FieldByName('objetivo').AsString;
    TListItemText(Objects.FindDrawable('ondeEncontrar')).Text := 'Onde Encontrar? ' + DM_Conexao.FD_Query.FieldByName('OndeEncontrar').AsString;
    TListItemText(Objects.FindDrawable('comoAjudar')).Text := 'Como Ajudar? ' + DM_Conexao.FD_Query.FieldByName('ComoAjudar').AsString;

    TListItemImage(Objects.FindDrawable('linha1')).Bitmap := Image_preto.Bitmap;
    TListItemImage(Objects.FindDrawable('linha2')).Bitmap := Image_preto.Bitmap;
    TListItemImage(Objects.FindDrawable('linha3')).Bitmap := Image_preto.Bitmap;
    TListItemImage(Objects.FindDrawable('linha4')).Bitmap := Image_preto.Bitmap;
    // Adiciona Imagens
    //TListItemImage(Objects.FindDrawable('editar')).Bitmap := Image_editar.Bitmap;
  end;

end;

end.
