program DelphiClient;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;

type


  EmissorRetornoDados = record
     status: integer;
     protocolo_sefaz:  array[0..15] of char;
     url_consulta: array[0..512] of char;
     dig_val: array[0..28] of char;
     chave: array[0..44] of char;
     det: array[0..512] of char;
  end;

  EmissorRetornoErro = record
    codigo: integer;
    pode_reutilizar_numero: integer;
    det: array[0..512] of char;
  end;

  EmissorRetorno = record
    situacao_operacao: integer;
    dados: EmissorRetornoDados;
    erro: EmissorRetornoErro;
  end;


var
   h: Thandle;
   initializar: function: Pointer ; {$IFDEF WIN32} stdcall; {$ENDIF}
   emissor: function(ptr: Pointer; str: PChar; len: integer; output: Pointer):integer;  {$IFDEF WIN32} stdcall; {$ENDIF}
   ptr, optr : Pointer;
   ret: EmissorRetorno;
   str: PChar;
begin
   h := LoadLibrary('ncfepack_agente.dll');
   if h >= 32 then { success }
   begin
     initializar := GetProcAddress(h, 'nfce_inicializa_emissor');
     emissor := GetProcAddress(h, 'nfce_emitir');

     ptr := initializar();
     str := 'Any string';
     emissor(ptr, str,StrLen(str), @ret);

     write('Status:');
     writeln(ret.situacao_operacao);
     write('Key:');
     writeln(ret.dados.chave);
     write('Det:');
     writeln(ret.dados.det);
     write('DigVal:');
     writeln(ret.dados.dig_val);
     write('Protocol:');
     writeln(ret.dados.protocolo_sefaz);
     write('Status:');
     writeln(ret.dados.status);
     write('URL:');
     writeln(ret.dados.url_consulta);

     FreeLibrary(h);

   end
end.
