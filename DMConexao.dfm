object DM_Conexao: TDM_Conexao
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object FD_Conexao: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\berla\OneDrive - UNIVALI\how9 e how10\Projeto ' +
        'Social\Win32\Debug\banco.db'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 248
    Top = 96
  end
  object FD_Query: TFDQuery
    Connection = FD_Conexao
    SQL.Strings = (
      
        '          select id,nome,idProjeto,ondeEncontrar,ComoAjudar,Obje' +
        'tivo from causas Where id = :id')
    Left = 128
    Top = 288
    ParamData = <
      item
        Name = 'ID'
        DataType = ftString
        ParamType = ptInput
        Value = '4'
      end>
  end
end
