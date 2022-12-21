{
 *	PROGRAM:	UDR samples.
 *	MODULE:		UdrInit.pas
 *	DESCRIPTION:	A sample simple UDR.
 *
 *  The contents of this file are subject to the Initial
 *  Developer's Public License Version 1.0 (the "License");
 *  you may not use this file except in compliance with the
 *  License. You may obtain a copy of the License at
 *  http://www.ibphoenix.com/main.nfs?a=ibphoenix&page=ibp_idpl.
 *
 *  Software distributed under the License is distributed AS IS,
 *  WITHOUT WARRANTY OF ANY KIND, either express or implied.
 *  See the License for the specific language governing rights
 *  and limitations under the License.
 *
 *  The Original Code was created by Adriano dos Santos
 *  for the Firebird Open Source RDBMS project.
 *
 *  Copyright (c) 2008 Adriano dos Santos Fernandes <adrianosf@gmail.com>
 *  and all contributors signed below.
 *
 *  All Rights Reserved.
 *  Contributor(s): ______________________________________. 
 *
 *  20.05.2018 Simonov Denis - comments and simplificate trigger }

unit UdrInit;

{$IFDEF FPC}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses Firebird;

// точка входа для External Engine модуля UDR
function firebird_udr_plugin(AStatus: IStatus; AUnloadFlagLocal: BooleanPtr;
  AUdrPlugin: IUdrPlugin): BooleanPtr; cdecl;

implementation

uses
  SumArgsFunc,
  SumArgsProc,
  GenRowsProc,
  TestTrigger;

var
  myUnloadFlag: Boolean;
  theirUnloadFlag: BooleanPtr;

function firebird_udr_plugin(AStatus: IStatus; AUnloadFlagLocal: BooleanPtr;
  AUdrPlugin: IUdrPlugin): BooleanPtr; cdecl;
begin
  // регистрируем наши функции
  AUdrPlugin.registerFunction(AStatus, 'sum_args',
    TSumArgsFunctionFactory.Create());
  // регистрируем наши процедуры
  AUdrPlugin.registerProcedure(AStatus, 'sum_args_proc',
    TSumArgsProcedureFactory.Create());
  AUdrPlugin.registerProcedure(AStatus, 'gen_rows', TGenRowsFactory.Create());
  // регистриуем наши триггеры
  AUdrPlugin.registerTrigger(AStatus, 'test_trigger',
    TMyTriggerFactory.Create());

  theirUnloadFlag := AUnloadFlagLocal;
  Result := @myUnloadFlag;
end;

initialization

myUnloadFlag := false;

finalization

if ((theirUnloadFlag <> nil) and not myUnloadFlag) then
  theirUnloadFlag^ := true;

end.
