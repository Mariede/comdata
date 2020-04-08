/*
	- Preenche calendario - FERIADOS (COMDATA_EVENTOS)
*/

USE [COMDATA]
GO

Declare
	@ano int
	,@out_retInfo int
	,@out_retErroNum int
	,@out_retErroDescr nvarchar(4000)
	,@procRet int

-- Ano a ser preenchido
Set
	@ano = 2020;

Execute
	@procRet = [COMDATA_EVENTOS].[PROC_EVENTOS_CALENDARIO_FERIADOS_PREENCHER]
		@ano
		,@out_retInfo OUTPUT
		,@out_retErroNum OUTPUT
		,@out_retErroDescr OUTPUT;

Select
	@procRet CODIGO_RETORNO
	,@out_retInfo RET_INFO
	,@out_retErroNum ERRO_NUM
	,@out_retErroDescr ERRO_DESCR;
