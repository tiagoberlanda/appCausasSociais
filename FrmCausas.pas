unit FrmCausas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FrmBase, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TFormCausas = class(TForm_base)
    Image_voltar: TImage;
    Label_nome: TLabel;
    Label_info: TLabel;
    Layout1: TLayout;
    ListView1: TListView;
    Image_adicionar: TImage;
    procedure Image_voltarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCausas: TFormCausas;

implementation

{$R *.fmx}

uses FrmAdministracao;

procedure TFormCausas.Image_voltarClick(Sender: TObject);
begin
  inherited;
  FormAdministracao := TFormAdministracao.Create(self);
  application.MainForm := FormAdministracao;

  FormAdministracao.Label_nome.TagString := Label_nome.TagString;

  FormAdministracao.Show;
  FormCausas.Close;
end;

end.
