unit FrmMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FrmBase, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,fmx.DialogService;

type
  TFormMenu = class(TForm_base)
    Layout1: TLayout;
    RoundRect1: TRoundRect;
    RoundRect2: TRoundRect;
    RoundRect3: TRoundRect;
    RoundRect4: TRoundRect;
    RoundRect5: TRoundRect;
    RoundRect6: TRoundRect;
    Label_home: TLabel;
    Label_minhaConta: TLabel;
    Label_minhasCausas: TLabel;
    Label_publicarCausa: TLabel;
    Label_modoAdm: TLabel;
    Label_sair: TLabel;
    Label_nome: TLabel;
    Label1: TLabel;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image1: TImage;
    procedure Image1Click(Sender: TObject);
    procedure Label_sairClick(Sender: TObject);
    procedure Label_homeClick(Sender: TObject);
    procedure Label_modoAdmClick(Sender: TObject);
    procedure Label_minhaContaClick(Sender: TObject);
    procedure Label_minhasCausasClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label_publicarCausaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMenu: TFormMenu;

implementation

{$R *.fmx}

uses FrmPrincipal, DMConexao, FrmAdministracao, FrmConta, FrmCausas,
  FrmCausasAdd;

procedure TFormMenu.FormShow(Sender: TObject);
begin
  inherited;
  if DM_Conexao.RetornaAdmPeloEmail(Label_nome.TagString) = True then
  begin
    Label_modoAdm.Enabled := True;
    Label_modoAdm.HitTest := True;
  end
  else
  begin
    Label_modoAdm.Enabled := False;
    Label_modoAdm.HitTest := False;
  end;
end;

procedure TFormMenu.Image1Click(Sender: TObject);
begin
  inherited;
  //Volta para Form Inicial
  FormPrincipal:= TFormPrincipal.Create(self);
  Application.MainForm := FormPrincipal;
  //volta informação do usuário para o form
  FormPrincipal.Label_nomeUsuario.tagString := label_nome.TagString;
  FormPrincipal.Label_nomeUsuario.Text := DM_Conexao.RetornaNomePeloEmail(label_nome.TagString);

  FormPrincipal.show;
  FormMenu.Close;
end;

procedure TFormMenu.Label_homeClick(Sender: TObject);
begin
  inherited;
  //Volta para Form Inicial
  FormPrincipal:= TFormPrincipal.Create(self);
  Application.MainForm := FormPrincipal;
  //volta informação do usuário para o form
  FormPrincipal.Label_nomeUsuario.tagString := label_nome.TagString;
  FormPrincipal.Label_nomeUsuario.Text := DM_Conexao.RetornaNomePeloEmail(label_nome.TagString);

  FormPrincipal.show;
  FormMenu.Close;
end;

procedure TFormMenu.Label_minhaContaClick(Sender: TObject);
begin
  inherited;
  //Abre FormConta
  FormConta := TformConta.Create(self);
  application.MainForm := FormConta;
  //Coloca E-mail (usuario) na TagString da Label Nome Usuário
  FormConta.Label_nome.TagString := Label_nome.TagString;
  FormConta.Label_nome.Tag := DM_Conexao.RetornaIdPeloEmail(Label_nome.TagString); //Passa o ID do usuário no Banco

  FormConta.preencheInformacoesConta(FormConta.Label_nome.tag);

  FormConta.Show;
  FormMenu.Close;
end;

procedure TFormMenu.Label_minhasCausasClick(Sender: TObject);
begin
  inherited;
  FormCausas := TFormCausas.Create(self);
  Application.MainForm := FormCausas;

  FormCausas.Label_nome.TagString := label_nome.TagString;
  FormCausas.Label_info.TagString := 'M';
  FormCausas.Label_nome.Tag := DM_Conexao.RetornaIdPeloEmail(label_nome.TagString);
  FormCausas.show;
  FormMenu.Close;

end;

procedure TFormMenu.Label_modoAdmClick(Sender: TObject);
begin
  inherited;
   if DM_Conexao.RetornaAdmPeloEmail(Label_nome.TagString) = True then
   begin
      //Vai para Form Administracao
      FormAdministracao := TFormAdministracao.Create(self);
      Application.MainForm := FormAdministracao;
      //Coloca E-mail (usuario) na TagString da Label Nome Usuário
      FormAdministracao.Label_nome.tagString := Label_nome.TagString;
      FormAdministracao.show;
      FormMenu.Close;
   end
   else
   begin
     ShowMessage('Usuário:' + Label_nome.TagString + ' não é administrador!' )
   end;



end;


procedure TFormMenu.Label_publicarCausaClick(Sender: TObject);
begin
  inherited;
  FormCausasAdd := TFormCausasAdd.Create(self);
  application.MainForm := FormCausasAdd;

  FormCausasAdd.Label_nome.TagString := Label_nome.TagString;
  FormCausasAdd.Label_nome.Tag := DM_Conexao.RetornaIdPeloEmail(label_nome.TagString);

  FormCausasAdd.Show;
  FormMenu.close;
end;

procedure TFormMenu.Label_sairClick(Sender: TObject);
begin
  inherited;
// Lembra de declarar no uses: fmx.DialogService
    TDialogService.MessageDialog('Confirma sair do sistema?',
                                   TMsgDlgType.mtConfirmation,
                                   [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                                   TMsgDlgBtn.mbNo,
                                   0,
      procedure(const AResult: TModalResult)
      begin
        if AResult = mrYes then
        begin
          Application.Terminate;
        end
      end);
end;

end.
