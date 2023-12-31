unit DMConexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.IOUtils;

type
  TDM_Conexao = class(TDataModule)
    FD_Conexao: TFDConnection;
    FD_Query: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private


    { Private declarations }
  public
    { Public declarations }
    function Criptografa(Action, Src: String): String;
    function ValidarUsuario(usuario, senha: string): Boolean;
    function ValidarCadastro(usuario: string): Boolean;
    procedure InserirUsuario(usuario, senha, nome: string; ativo, nivel: integer);
    function RetornaNomePeloEmail(email: string):string;
    function RetornaAdmPeloEmail(email: string): Boolean;
    function RetornaIdPeloEmail(email: string): integer;
    function VerificaUsuarioAtivo(email: string): Boolean;
    procedure ModificaUsuario(usuario, senha, nome: string; ativo,nivel, id: integer);
    function verificaProjeto(nome: string): Boolean;
    function InsereProjeto (nome: string): boolean;
    function InsereCausa(nome,objetivo,ondeEncontrar,comoAjudar: string; idProjeto,idUsuario: integer):Boolean;
    function AlteraCausa(nome,objetivo,ondeEncontrar,comoAjudar: string; id,idProjeto: integer):Boolean;
    function RetornaNomeProjetoId(id: integer): string;
    function ExcluiCausaId(id: integer): Boolean;
    function ExcluiContaId(id: integer): Boolean;
    function RetornaAdmId(id: integer): Integer;
    function InsereComentario(idCausa, idUsuario : integer; nome : string): Boolean;
  end;

var
  DM_Conexao: TDM_Conexao;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDM_Conexao.DataModuleCreate(Sender: TObject);
begin                            
  FD_Conexao.Params.Values['DriverID'] := 'SQLite';

  {$IFDEF MSWINDOWS}
  FD_Conexao.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\banco.db';
  {$ELSE}
  FD_Conexao.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'banco.db');
  {$ENDIF}

  try
    FD_Conexao.Connected := true;
  except on e:exception do
    raise Exception.Create('Erro de conex�o com o banco de dados: ' + e.Message);
  end;
  FD_Conexao.Close;

end;



function TDM_Conexao.ExcluiCausaId(id: integer): Boolean;
var
  Erro: boolean;
begin

  FD_Conexao.Close;
  FD_Conexao.Open();
  FD_Query.Close;
  FD_Query.SQL.Clear;


  try
    try
      FD_Query.SQL.Add('delete from causas where id = :id');

      FD_Query.ParamByName('id').AsInteger := id;
      FD_Query.ExecSQL;
      Erro := False;
    except
      Erro := True;
    end;
  finally
    if Erro = True then
    begin
      Result := False; //Se retornar False � que deu algum erro
    end
    else
    begin
      Result := True; //Se retornar True � porque est� tudo certo
    end;

  end;

end;

// Fun��o de Criptografia
function TDM_Conexao.AlteraCausa(nome, objetivo, ondeEncontrar,
  comoAjudar: string; id,idProjeto: integer): Boolean;
var
  Erro: boolean;
begin
 
  FD_Conexao.Close;
  FD_Conexao.Open();
  FD_Query.Close;
  FD_Query.SQL.Clear;

  try
    try
      FD_Query.SQL.Add('update causas SET nome = :nome, idProjeto = :idProjeto, ' +
      'OndeEncontrar = :ondeEncontrar, ComoAjudar = :comoAjudar , Objetivo = :objetivo '+ 
      'where id = :id');
       FD_Query.ParamByName('id').AsInteger := id;
      FD_Query.ParamByName('nome').AsString := nome;
      FD_Query.ParamByName('idProjeto').AsInteger := idProjeto;
      FD_Query.ParamByName('OndeEncontrar').AsString := ondeEncontrar;
      FD_Query.ParamByName('ComoAjudar').AsString := comoAjudar;
      FD_Query.ParamByName('Objetivo').AsString := objetivo;

      FD_Query.ExecSQL;
      Erro := False;
    except
      Erro := True;
    end;
  finally
    if Erro = True then
    begin
      Result := False; //Se retornar False � que deu algum erro
    end
    else
    begin
      Result := True; //Se retornar True � porque est� tudo certo
    end;

  end;
end;

function TDM_Conexao.Criptografa(Action, Src: String): String;
Label Fim;
var KeyLen, KeyPos, OffSet, SrcPos, SrcAsc, TmpSrcAsc, Range : Integer;
    Dest, Key : String;
begin
  if (Src = '') Then
    begin
      Result:= '';
      Goto Fim;
    end;

  Key := '*)&*(&%%&*(&%$#@!#%&%&)*_(*&%$#$@#$@#$&$*()(*&_)%%$&$1DFSBH2ST34TRH5RTH6RTH7T854Y4UI96O08LZ8A�P9QP809WPS6YXHGERCVDWEA34ERF34RWFG5F4WWYHVUJ76BIG8OT8Y6ERIH76NIO67MI7I6JRIU76II76KI6LI67OI7I76IPUI76I�76I';
  Dest := '';
  KeyLen := Length(Key);
  KeyPos := 0;
  SrcPos := 0;
  SrcAsc := 0;
  Range := 256;

  if (Action = UpperCase('C')) then
    begin
      Randomize;
      OffSet := Random(Range);
      Dest := Format('%1.2x',[OffSet]);
      for SrcPos := 1 to Length(Src) do
        begin
          SrcAsc := (Ord(Src[SrcPos]) + OffSet) Mod 255;

          if KeyPos < KeyLen then
            KeyPos := KeyPos + 1
          else
            KeyPos := 1;

          SrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
          Dest := Dest + Format('%1.2x',[SrcAsc]);
          OffSet := SrcAsc;
        end;
    end
  else
    if (Action = UpperCase('D')) then
      begin
        OffSet := StrToInt('$'+ copy(Src,1,2));
        SrcPos := 3;

        repeat
          SrcAsc := StrToInt('$'+ copy(Src,SrcPos,2));

          if (KeyPos < KeyLen) Then
            KeyPos := KeyPos + 1
          else
            KeyPos := 1;

          TmpSrcAsc := SrcAsc Xor Ord(Key[KeyPos]);

          if TmpSrcAsc <= OffSet then
            TmpSrcAsc := 255 + TmpSrcAsc - OffSet
          else
            TmpSrcAsc := TmpSrcAsc - OffSet;

          Dest := Dest + Chr(TmpSrcAsc);
          OffSet := SrcAsc;
          SrcPos := SrcPos + 2;
        until (SrcPos >= Length(Src));
      end;
  Result:= Dest;
  Fim:
end;

//Fun��o de verificar usu�rio
function TDM_Conexao.ValidarUsuario(usuario, senha: string): Boolean;
begin
   // Inicia Conex�o no Banco
  DM_Conexao.FD_Conexao.Close;
  DM_Conexao.FD_Conexao.Open();
  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('SELECT email,senha FROM usuario WHERE email = :email');  //verifica se o usu�rio est� ativo
  DM_Conexao.FD_Query.ParamByName('email').AsString := usuario;
  DM_Conexao.FD_Query.Open;

  if DM_Conexao.FD_Query.RecordCount = 0 then     // Se for 0, n�o existe o usu�rio
    begin
      Result := False;
    end
  else   // Se n�o for 0 o usu�rio existe
    begin
      if DM_Conexao.Criptografa('D', DM_Conexao.FD_Query.FieldByName('senha').AsString) = senha then //Descriptografa e valida a senha
        begin
          Result := True;    //Se for igual, retorna True
        end
      else
        begin
          Result := False;  // Se n�o retorna False
        end;
    end;

end;

function TDM_Conexao.verificaProjeto(nome: string): Boolean;
begin
  // Inicia Conex�o no Banco
  DM_Conexao.FD_Conexao.Close;
  DM_Conexao.FD_Conexao.Open();
  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.sql.add('select count(id) as total from projeto where nome = :nome');
  DM_Conexao.FD_Query.ParamByName('nome').AsString := nome;
  DM_Conexao.FD_Query.Open;

  if DM_Conexao.FD_Query.FieldByName('total').AsInteger = 1 then
  begin
    Result := True; //Existe um projeto com esse nome
  end
  else
  begin
    Result := False; //N�o existe um projeto com esse nome
  end;



end;

function TDM_Conexao.VerificaUsuarioAtivo(email: string): Boolean;
begin
  // Inicia Conex�o no Banco
  DM_Conexao.FD_Conexao.Close;
  DM_Conexao.FD_Conexao.Open();
  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('SELECT ativo FROM usuario WHERE email = :email');
  DM_Conexao.FD_Query.ParamByName('email').AsString := email;
  DM_Conexao.FD_Query.Open;

  if DM_Conexao.FD_Query.FieldByName('ativo').AsInteger = 1 then
  begin
    Result := True; //Retorna True se o usu�rio est� ativo
  end
  else
  begin
    Result := False; // Se n�o retorna False
  end;


end;

//Verifica se existe um usu�rio cadastrado ou n�o
function TDM_Conexao.ValidarCadastro(usuario: string): Boolean;
begin
  // Inicia Conex�o no Banco
  DM_Conexao.FD_Conexao.Close;
  DM_Conexao.FD_Conexao.Open();

  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('SELECT email FROM usuario WHERE email = :email');
  DM_Conexao.FD_Query.ParamByName('email').AsString := usuario;
  DM_Conexao.FD_Query.Open;

  //Se existe o usuario retorna True, se n�o retorna False.
  if  DM_Conexao.FD_Query.RecordCount > 0 then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;



function TDM_Conexao.InsereCausa(nome, objetivo, ondeEncontrar,
  comoAjudar: string; idProjeto,idUsuario: integer): Boolean;
var
  Erro: Boolean;
begin

  FD_Conexao.Close;
  FD_Conexao.Open();
  FD_Query.Close;
  FD_Query.SQL.Clear;

  try
    try
      FD_Query.SQL.Add('insert into causas (nome,idProjeto,OndeEncontrar,ComoAjudar, ' +
      'Objetivo,idUsuario) Values (:nome,:idProjeto,:ondeEncontrar,:comoAjudar,:objetivo,:idUsuario) ');
      FD_Query.ParamByName('nome').AsString := nome;
      FD_Query.ParamByName('idUsuario').AsInteger := idUsuario;
      FD_Query.ParamByName('idProjeto').AsInteger := idProjeto;
      FD_Query.ParamByName('OndeEncontrar').AsString := ondeEncontrar;
      FD_Query.ParamByName('ComoAjudar').AsString := comoAjudar;
      FD_Query.ParamByName('Objetivo').AsString := objetivo;

      FD_Query.ExecSQL;
      Erro := False;
    except
      Erro := True;
    end;
  finally
    if Erro = True then
    begin
      Result := False; //Se retornar False � que deu algum erro
    end
    else
    begin
      Result := True; //Se retornar True � porque est� tudo certo
    end;

  end;

end;

function TDM_Conexao.InsereComentario(idCausa, idUsuario: integer;
  nome: string): Boolean;
var
  Erro: boolean;
  data : string;
begin

  FD_Conexao.Close;
  FD_Conexao.Open();
  FD_Query.Close;
  FD_Query.SQL.Clear;

  try
    try
      FD_Query.SQL.Add('insert into comentarios (idCausa,idUsuario,comentario,data) ' +
      'Values (:idCausa,:idUsuario,:comentario,:data) ');
      FD_Query.ParamByName('idCausa').AsInteger := idCausa;
      FD_Query.ParamByName('idUsuario').AsInteger := idUsuario;
      FD_Query.ParamByName('comentario').AsString := nome;
      FD_Query.ParamByName('data').AsDateTime := StrToDateTime(FormatDateTime('dd/mm/yyyy hh:mm:ss', now));
      FD_Query.ExecSQL;
      Erro := False;
    except
      Erro := True;
    end;
  finally
    if Erro = True then
    begin
      Result := False; //Se retornar False � que deu algum erro
    end
    else
    begin
      Result := True; //Se retornar True � porque est� tudo certo
    end;

  end;

end;

function TDM_Conexao.InsereProjeto(nome: string): boolean;
var
  Erro: Boolean;
begin
  //Inicia Conex�o
  DM_Conexao.FD_Conexao.Close;
  DM_Conexao.FD_Conexao.Open();
  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;

  try
    try
      DM_Conexao.FD_Query.SQL.Add('insert into projeto (nome) Values (:nome)');
      DM_Conexao.FD_Query.ParamByName('nome').AsString := nome;
      DM_Conexao.FD_Query.ExecSQL;
       Erro := False;
    except
      Erro := True;
    end;
  finally
    if Erro = True then
    begin
      Result := False; //Se retornar False � que deu algum erro
    end
    else
    begin
      Result := True; //Se retornar True � porque est� tudo certo
    end;

  end;

end;

procedure TDM_Conexao.InserirUsuario(usuario, senha, nome: string; ativo, nivel: integer);
begin
  //Inicia Conex�o
  DM_Conexao.FD_Conexao.Close;
  DM_Conexao.FD_Conexao.Open();
  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('INSERT INTO usuario (email,nome,senha,ativo,nivel) VALUES (:email,:nome,:senha,:ativo,:nivel); ');
  DM_Conexao.FD_Query.ParamByName('email').AsString := usuario;
  DM_Conexao.FD_Query.ParamByName('nome').AsString := nome;
  DM_Conexao.FD_Query.ParamByName('senha').AsString := DM_Conexao.Criptografa('C', senha);
  DM_Conexao.FD_Query.ParamByName('ativo').AsInteger := ativo;
  DM_Conexao.FD_Query.ParamByName('nivel').AsInteger := nivel;
  DM_Conexao.FD_Query.ExecSQL;
end;


//Faz a modifica��o de um usu�rio, nome e senha na base
procedure TDM_Conexao.ModificaUsuario(usuario, senha, nome: string; ativo, nivel,id: integer);
begin
  //Inicia Conex�o
  DM_Conexao.FD_Conexao.Close;
  DM_Conexao.FD_Conexao.Open();
  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('UPDATE usuario SET email = :email ,nome = :nome ,senha = :senha ,ativo = :ativo ,nivel = :nivel '+
  'Where id = :id');
  DM_Conexao.FD_Query.ParamByName('id').AsInteger := id;
  DM_Conexao.FD_Query.ParamByName('email').AsString := usuario;
  DM_Conexao.FD_Query.ParamByName('nome').AsString := nome;
  DM_Conexao.FD_Query.ParamByName('senha').AsString := DM_Conexao.Criptografa('C', senha);
  DM_Conexao.FD_Query.ParamByName('ativo').AsInteger := ativo;
  DM_Conexao.FD_Query.ParamByName('nivel').AsInteger := nivel;
  DM_Conexao.FD_Query.ExecSQL;
end;


function TDM_Conexao.RetornaAdmPeloEmail(email: string): Boolean;
var
  adm: integer;
begin
  //Inicia Conex�o
  DM_Conexao.FD_Conexao.Close;
  DM_Conexao.FD_Conexao.Open();
  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('select nivel from usuario where email = :email ');
  DM_Conexao.FD_Query.ParamByName('email').AsString := email;
  DM_Conexao.FD_Query.Open();
  adm := DM_Conexao.FD_Query.FieldByName('nivel').AsInteger;

  if adm = 1 then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;

end;

function TDM_Conexao.RetornaIdPeloEmail(email: string): integer;
begin
//Inicia Conex�o
  DM_Conexao.FD_Conexao.Close;
  DM_Conexao.FD_Conexao.Open();

  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('select id from usuario where email = :email');
  DM_Conexao.FD_Query.ParamByName('email').AsString := email;
  DM_Conexao.FD_Query.Open();
  Result := DM_Conexao.FD_Query.FieldByName('id').AsInteger;
end;


function TDM_Conexao.ExcluiContaId(id: integer): Boolean;
var
  Erro: boolean;
begin
    //Inicia Conex�o
  DM_Conexao.FD_Conexao.Close;
  DM_Conexao.FD_Conexao.Open();
  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;

  try
    try
      DM_Conexao.FD_Query.SQL.Add('delete from usuario where id = :id');
      DM_Conexao.FD_Query.ParamByName('id').AsInteger := id;
      DM_Conexao.FD_Query.ExecSQL;
      Erro := False;
    except
      Erro := True;
    end;
  finally
    if Erro = True then
    begin
      Result := False; //Se retornar False � que deu algum erro
    end
    else
    begin
      Result := True; //Se retornar True � porque est� tudo certo
    end;
  end;
end;

function TDM_Conexao.RetornaNomePeloEmail(email: string): string;
begin
//Inicia Conex�o
  DM_Conexao.FD_Conexao.Close;
  DM_Conexao.FD_Conexao.Open();

  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('select nome from usuario where email = :email ');
  DM_Conexao.FD_Query.ParamByName('email').AsString := email;
  DM_Conexao.FD_Query.Open();
  Result := DM_Conexao.FD_Query.FieldByName('nome').AsString;
end;

function TDM_Conexao.RetornaNomeProjetoId(id: integer): string;
begin
 //Inicia Conex�o
  DM_Conexao.FD_Conexao.Close;
  DM_Conexao.FD_Conexao.Open();

  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('select nome from projeto where id = :id');
  DM_Conexao.FD_Query.ParamByName('id').AsInteger := id;
  DM_Conexao.FD_Query.Open();

  Result := DM_Conexao.FD_Query.FieldByName('nome').AsString;
end;

function TDM_Conexao.RetornaAdmId(id: integer): Integer;
var
  adm: integer;
begin
  //Inicia Conex�o
  DM_Conexao.FD_Conexao.Close;
  DM_Conexao.FD_Conexao.Open();
  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('select nivel from usuario where id = :id ');
  DM_Conexao.FD_Query.ParamByName('id').AsInteger := id;
  DM_Conexao.FD_Query.Open();
  adm := DM_Conexao.FD_Query.FieldByName('nivel').AsInteger;
  // 1 ADM , 0 Usu�rio
  Result := adm;
end;


end.
