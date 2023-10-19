unit FrmBase;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm_base = class(TForm)
    Layout_superior: TLayout;
    CirculoSuperior: TRoundRect;
    Layout_centralSup: TLayout;
    Layout_direita: TLayout;
    Layout_esquerdo: TLayout;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_base: TForm_base;

implementation

{$R *.fmx}

procedure TForm_base.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form_base := Nil;
end;

end.
