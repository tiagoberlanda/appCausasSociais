unit FrmLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  FMX.TabControl;

type
  TFormLogin = class(TForm)
    TabControlLogin: TTabControl;
    TabLogin: TTabItem;
    TabCadastro: TTabItem;
    Layout_superior: TLayout;
    CirculoSuperior: TRoundRect;
    Layout_superiorCentral: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    Label_criarConta: TLabel;
    Layout_Central: TLayout;
    Label3: TLabel;
    RoundRect1: TRoundRect;
    Label4: TLabel;
    Edit_email: TEdit;
    RoundRect2: TRoundRect;
    Edit_senha: TEdit;
    RoundRect3: TRoundRect;
    Layout1: TLayout;
    Label6: TLabel;
    RoundRect4: TRoundRect;
    Edit_emailCad: TEdit;
    Label7: TLabel;
    RoundRect5: TRoundRect;
    Edit_senhaCad: TEdit;
    RoundRect6: TRoundRect;
    Label_CriaContaCad: TLabel;
    Layout2: TLayout;
    RoundRect7: TRoundRect;
    Layout3: TLayout;
    Label9: TLabel;
    Label10: TLabel;
    Label_acessarConta: TLabel;
    RoundRect9: TRoundRect;
    Edit_nomeCad: TEdit;
    CheckBox1: TCheckBox;
    RoundRect10: TRoundRect;
    RoundRect11: TRoundRect;
    Label_acessar: TLabel;
    Label_versao: TLabel;
    procedure Label_criarContaClick(Sender: TObject);
    procedure Label_acessarContaClick(Sender: TObject);
    procedure Label_CriaContaCadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label_acessarClick(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.fmx}
{$R *.XLgXhdpiTb.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.SmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}

uses DMConexao, FrmPrincipal;



procedure TFormLogin.CheckBox1Change(Sender: TObject);
begin
  if Edit_senha.Password = True then
  begin
    Edit_senha.Password := False;
  end
  else
  begin
    Edit_senha.Password := True;
  end;
end;

procedure TFormLogin.FormCreate(Sender: TObject);
begin
  //Define Tab Login como principal
  TabControlLogin.ActiveTab := TabLogin;
end;

procedure TFormLogin.Label_acessarClick(Sender: TObject);
begin
   //Valida��o de Digita��o dos Campos
  if (Edit_email.Text = '' ) or (Edit_senha.Text = '') then
  begin
     ShowMessage('Preencha os campos E-mail e Senha!')
  end
  else
  begin
    //verifica usu�rio ativo
    if DM_Conexao.VerificaUsuarioAtivo(Edit_email.Text) = True then
    begin

      //--Valida se o usu�rio e senha est�o corretos--//
      if DM_Conexao.ValidarUsuario(Edit_email.Text,Edit_senha.Text) then   //Se a Valida��o retornar True (defalt)
      begin
        FormPrincipal := TFormPrincipal.Create(self);
        Application.MainForm := FormPrincipal;

        //Coloca E-mail (usuario) na TagString da Label Nome Usu�rio
        FormPrincipal.Label_nomeUsuario.tagString := Edit_email.Text;

        //Coloca Nome do usuario na da Label Nome Usu�rio
        FormPrincipal.Label_nomeUsuario.text := 'Logado como: ' + DM_Conexao.RetornaNomePeloEmail(Edit_email.text);

        FormPrincipal.show;
        FormLogin.close;

      end
      else
      begin
        ShowMessage('Usu�rio ou senha Inv�lidos!');
      end;
    end
    else
    begin
      ShowMessage('Usu�rio ou senha Inv�lidos!')
    end;

  end;
end;

procedure TFormLogin.Label_acessarContaClick(Sender: TObject);
begin
  TabControlLogin.ActiveTab := TabLogin;
end;

procedure TFormLogin.Label_CriaContaCadClick(Sender: TObject);
begin
// Valida��o de Digita��o
  if (Edit_emailCad.text <> '' ) and ( Edit_senhaCad.text <> '') and
  (Edit_nomeCad.Text <> '' ) then
  begin
    //Valida se o usu�rio j� existe ou n�o.
    if DM_Conexao.ValidarCadastro(Edit_emailCad.Text) then  //Se retornar True � porque o usu�rio existe
    begin
      ShowMessage('E-mail j� cadastrado, use outro e tente novamente');
      Edit_emailCad.Text := '';    // Se o usu�rio j� existir ir� apagar o que foi digitado nos Edits
      Edit_senhaCad.Text := '';
      Edit_nomeCad.Text := '';
    end
    else
    begin
      //Se retornar False � porque o usu�rio n�o existe.
      DM_Conexao.InserirUsuario(Edit_emailCad.Text,Edit_senhaCad.Text,Edit_nomeCad.Text,1,0); //padr�o usu�rio ativo e n�o ADM
      ShowMessage('Cadastro Feito Com sucesso! Fa�a seu Login!');

      //Troca Tab
      TabControlLogin.ActiveTab := TabLogin;

      //Zera Valor dos Edits
      Edit_emailCad.Text := '';
      Edit_senhaCad.Text := '';
      Edit_nomeCad.Text := '';
    end;
  end
  else
  begin
    //Se n�o tiver tudo preenchdido exibe alerta
    ShowMessage('Preencha todas as informa��es!');
  end;

end;

procedure TFormLogin.Label_criarContaClick(Sender: TObject);
begin
  TabControlLogin.ActiveTab := TabCadastro;
end;

end.
