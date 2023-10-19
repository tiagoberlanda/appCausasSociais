unit FrmPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Ani;

type
  TFormPrincipal = class(TForm)
    Label_nomeUsuario: TLabel;
    Layout_superior: TLayout;
    CirculoSuperior: TRoundRect;
    Label_doelocal: TLabel;
    Image1: TImage;
    Layout_centralSup: TLayout;
    Layout_direita: TLayout;
    Layout_esquerdo: TLayout;
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label_nomeUsuarioClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.fmx}

uses DMConexao, FrmMenu;

procedure TFormPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FormPrincipal := Nil;
end;

procedure TFormPrincipal.Image1Click(Sender: TObject);
begin
  FormMenu := TformMenu.Create(self);
  Application.MainForm := FormMenu;

  //Passa e-mail do usuário de um form para outro.
  FormMenu.Label_nome.tagString := Label_nomeUsuario.TagString;

  FormMenu.show;
  FormPrincipal.Close;
end;


procedure TFormPrincipal.Label_nomeUsuarioClick(Sender: TObject);
begin
showmessage('E-mail: ' + Label_nomeUsuario.tagString);
end;

end.
