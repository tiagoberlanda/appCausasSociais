program ProjetoSocial;

uses
  System.StartUpCopy,
  FMX.Forms,
  DMConexao in 'DMConexao.pas' {DM_Conexao: TDataModule},
  FrmPrincipal in 'FrmPrincipal.pas' {FormPrincipal},
  FrmLogin in 'FrmLogin.pas' {FormLogin},
  FrmBase in 'FrmBase.pas' {Form_base},
  FrmMenu in 'FrmMenu.pas' {FormMenu},
  FrmAdministracao in 'FrmAdministracao.pas' {FormAdministracao},
  FrmUsuarios in 'FrmUsuarios.pas' {FormUsuarios},
  FrmUsuariosAdm in 'FrmUsuariosAdm.pas' {FormUsuariosAdm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM_Conexao, DM_Conexao);
  Application.CreateForm(TFormLogin, FormLogin);
  Application.Run;
end.
