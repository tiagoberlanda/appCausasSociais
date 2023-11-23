unit FrmConta;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FrmBase, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation,fmx.DialogService, FMX.Edit;

type
  TFormConta = class(TForm_base)
    Image_voltar: TImage;
    Label_nome: TLabel;
    Label_info: TLabel;
    Layout_central: TLayout;
    Rectangle_central: TRectangle;
    RoundRect_nomeCausa: TRoundRect;
    Edit_nome: TEdit;
    Label_nomeUsuario: TLabel;
    RoundRect1: TRoundRect;
    Label_email: TLabel;
    Layout_inferior: TLayout;
    Rectangle_confirmar: TRectangle;
    Label_salvar: TLabel;
    Rectangle4: TRectangle;
    Label_cancelaExclui: TLabel;
    RoundRect2: TRoundRect;
    Edit_senhAtual: TEdit;
    Label2: TLabel;
    RoundRect3: TRoundRect;
    Edit_novaSenha: TEdit;
    Label3: TLabel;
    Edit_email: TEdit;
    CheckBox1: TCheckBox;
    procedure Image_voltarClick(Sender: TObject);
    procedure Label_cancelaExcluiClick(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure Label_salvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure preencheInformacoesConta(id: integer);
  end;

var
  FormConta: TFormConta;

implementation

{$R *.fmx}

uses FrmMenu, DMConexao, FrmLogin;

procedure TFormConta.CheckBox1Change(Sender: TObject);
begin
  inherited;
  Edit_novaSenha.Password := not Edit_novaSenha.Password;
  Edit_senhAtual.Password := not Edit_senhAtual.Password;
end;

procedure TFormConta.Image_voltarClick(Sender: TObject);
begin
  inherited;
  // Lembra de declarar no uses: fmx.DialogService
    TDialogService.MessageDialog('As alterações não salvas serão perdidas, deseja voltar?',
                                   TMsgDlgType.mtConfirmation,
                                   [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                                   TMsgDlgBtn.mbNo,
                                   0,
      procedure(const AResult: TModalResult)
      begin
        if AResult = mrYes then
        begin
            //Volta para o FormMenu
            FormMenu := TFormMenu.Create(self);
            application.MainForm := FormMenu;

            FormMenu.Label_nome.TagString := label_nome.TagString;

            FormMenu.Show;
            FormConta.Close;
        end
      end);
end;

procedure TFormConta.Label_cancelaExcluiClick(Sender: TObject);
begin
  inherited;
  // Lembra de declarar no uses: fmx.DialogService
    TDialogService.MessageDialog('Tem certeza que deseja excluir sua conta? Esse processo é irreversível.',
                                   TMsgDlgType.mtConfirmation,
                                   [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                                   TMsgDlgBtn.mbNo,
                                   0,
      procedure(const AResult: TModalResult)
      begin
        if AResult = mrYes then
        begin
            if DM_Conexao.ExcluiContaId(label_nome.Tag) = True then
            begin
              showmessage('Sua Conta foi apagada com sucesso, voltando para a tela de login');
              //Volta para o FormLogin
              FormLogin := TFormLogin.Create(self);
              application.MainForm := FormLogin;

              FormLogin.Show;
              FormConta.Close;
            end
            else
            begin
              showmessage('Erro ao deletar a conta!');
            end;

        end
      end);
end;

procedure TFormConta.Label_salvarClick(Sender: TObject);
var
  administrador : integer;
begin
  inherited;
  //Verificação de digitação
  if (Edit_nome.Text = '') or (Edit_email.Text = '') or (Edit_senhAtual.Text = '') or (Edit_novaSenha.Text = '') then
  begin
    ShowMessage('Preencha todas as informaçoes');
  end
  else
  begin
    //Valida se o usuário já existe ou não.
    if DM_Conexao.ValidarCadastro(Edit_email.Text) = True then  //Se retornar True é porque o usuário existe
    begin
      ShowMessage('E-mail já cadastrado, use outro e tente novamente');
      Edit_email.Text := '';
    end
    else
    begin
      //Faz as modificações
      administrador := DM_Conexao.RetornaAdmId(Label_nome.Tag);
      DM_Conexao.ModificaUsuario(Edit_email.Text,Edit_novaSenha.Text,Edit_nome.Text,1,administrador,Label_nome.Tag);

      showmessage('Informações alteradas com sucesso!');
      //Volta para o FormMenu
      FormMenu := TFormMenu.Create(self);
      application.MainForm := FormMenu;

      FormMenu.Label_nome.TagString := Edit_email.Text;

      FormMenu.Show;
      FormConta.Close;
    end;
  end;


end;

procedure TFormConta.preencheInformacoesConta(id: integer);
var
  senha : string;
begin
  // Inicia Conexão no Banco
  DM_Conexao.FD_Conexao.Close;
  DM_Conexao.FD_Conexao.Open();
  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('SELECT nome,email,senha FROM usuario WHERE id = :id');
  DM_Conexao.FD_Query.ParamByName('id').AsInteger := id;
  DM_Conexao.FD_Query.Open;

  Edit_nome.Text := DM_Conexao.FD_Query.FieldByName('nome').AsString;
  Edit_email.Text := DM_Conexao.FD_Query.FieldByName('email').AsString;
  senha := DM_Conexao.FD_Query.FieldByName('senha').AsString;
  Edit_senhAtual.text := DM_Conexao.Criptografa('D', senha);

end;

end.
