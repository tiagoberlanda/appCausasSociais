unit FrmComentario;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FrmBase, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Edit;

type
  TFormComentario = class(TForm_base)
    Image_voltar: TImage;
    Label_nome: TLabel;
    Label_info: TLabel;
    Layout_central: TLayout;
    Layout_superiorCentral: TLayout;
    Rectangle_comentario: TRectangle;
    Edit_comentario: TEdit;
    Layout1: TLayout;
    Rectangle_cancelar: TRectangle;
    Label_cancelar: TLabel;
    Rectangle_comentar: TRectangle;
    Label_comentar: TLabel;
    ListView_comentarios: TListView;
    Image_preto: TImage;
    procedure Image_voltarClick(Sender: TObject);
    procedure Label_cancelarClick(Sender: TObject);
    procedure Label_comentarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure PreencheComentarios (id:integer);
  end;

var
  FormComentario: TFormComentario;

implementation

{$R *.fmx}

uses FrmPublicacao, DMConexao;

procedure TFormComentario.FormShow(Sender: TObject);
begin
  inherited;
  PreencheComentarios(Label_info.TagString.ToInteger());
end;

procedure TFormComentario.Image_voltarClick(Sender: TObject);
begin
  inherited;
  //volta para a tela de publicacao
  FormPublicacao := TFormPublicacao.create(self);
  Application.MainForm := FormPublicacao;

  FormPublicacao.Label_nome.TagString := label_nome.TagString;
  FormPublicacao.Label_info.Tag := label_info.Tag;
  FormPublicacao.Label_nome.Tag := label_nome.Tag;
   FormPublicacao.Label_info.TagString := label_info.TagString;
  FormPublicacao.Show;
  FormComentario.Close;
end;

procedure TFormComentario.Label_cancelarClick(Sender: TObject);
begin
  inherited;
  //Limpa campo comentário
  Edit_comentario.Text := '';
end;

procedure TFormComentario.Label_comentarClick(Sender: TObject);
begin
  inherited;
   //Label_info.TagString.ToInteger() id da causa
   if Edit_comentario.Text = '' then
   begin
     ShowMessage('Preencha o comentário para postar');
   end
   else
   begin
      //ShowMessage('idcausa:' + Label_info.TagString + ' | idUsuario: ' + label_nome.tag.ToString + ' | comentario: ' + Edit_comentario.Text);
     if DM_Conexao.InsereComentario(Label_info.TagString.ToInteger(),label_nome.tag,Edit_comentario.Text) = True then
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

procedure TFormComentario.PreencheComentarios(id: integer);
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
  while not DM_Conexao.FD_Query.Eof do  //Faz a consulta e percore os resultados para inserir todos os comentários.
  begin
    with ListView_comentarios.items.Add do
    begin
      // Adiciona o ID e Nome
      //TagString := DM_Conexao.FD_Query.FieldByName('idCausa').AsString;

      TListItemText(Objects.FindDrawable('usuario')).Text := 'Usuario: ' + DM_Conexao.FD_Query.FieldByName('nome').AsString +
      ' - ' + DM_Conexao.FD_Query.FieldByName('data').AsString;
      TListItemText(Objects.FindDrawable('comentario')).Text := DM_Conexao.FD_Query.FieldByName('comentario').AsString;

    end;
    DM_Conexao.FD_Query.Next;
  end;

end;

end.
