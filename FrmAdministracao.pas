unit FrmAdministracao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FrmBase, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, fmx.DialogService;

type
  TFormAdministracao = class(TForm_base)
    Image_voltar: TImage;
    Label_nome: TLabel;
    Layout_central: TLayout;
    RoundRect1: TRoundRect;
    Label_usuarios: TLabel;
    RoundRect2: TRoundRect;
    Label_sair: TLabel;
    RoundRect3: TRoundRect;
    Label_addCausaBd: TLabel;
    RoundRect4: TRoundRect;
    Label_Causa: TLabel;
    Label1: TLabel;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    procedure Image_voltarClick(Sender: TObject);
    procedure Label_sairClick(Sender: TObject);
    procedure Label_usuariosClick(Sender: TObject);
    procedure Label_addCausaBdClick(Sender: TObject);
    procedure Label_CausaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAdministracao: TFormAdministracao;

implementation

{$R *.fmx}

uses FrmMenu, FrmUsuarios, FrmCausas, FrmProjetos;

procedure TFormAdministracao.Image_voltarClick(Sender: TObject);
begin
  inherited;
  FormMenu := TformMenu.Create(self);
  Application.MainForm := FormMenu;

  //Passa e-mail do usuário de um form para outro.
  FormMenu.Label_nome.tagString := Label_nome.TagString;

  FormMenu.show;
  FormAdministracao.Close;
end;

procedure TFormAdministracao.Label_addCausaBdClick(Sender: TObject);
begin
  inherited;
  FormProjetos := TFormProjetos.Create(self);
  application.MainForm := FormProjetos;

  FormProjetos.Label_nome.TagString := Label_nome.TagString;

  FormProjetos.Show;
  FormAdministracao.Close;
end;

procedure TFormAdministracao.Label_CausaClick(Sender: TObject);
begin
  inherited;
  FormCausas := TformCausas.Create(self);
  Application.MainForm := FormCausas;

  FormCausas.Label_nome.TagString := Label_nome.TagString;

  FormCausas.Show;
  FormAdministracao.close;
end;

procedure TFormAdministracao.Label_sairClick(Sender: TObject);
begin
  inherited;
  // Lembra de declarar no uses: fmx.DialogService
  TDialogService.MessageDialog('Deseja Sair do Sistema?',
                                 TMsgDlgType.mtConfirmation,
                                 [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                                 TMsgDlgBtn.mbNo,
                                 0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
        begin
            Application.Terminate();
        end
    end);
end;

procedure TFormAdministracao.Label_usuariosClick(Sender: TObject);
begin
  inherited;
  FormUsuarios := TFormUsuarios.create(self);
  application.MainForm := FormUsuarios;

  FormUsuarios.Label_nome.TagString := Label_nome.TagString;

  FormUsuarios.Show;
  FormAdministracao.Close;

end;

end.
