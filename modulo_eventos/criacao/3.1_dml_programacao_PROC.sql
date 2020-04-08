USE [COMDATA]
GO

-- -------------------------------------------------------------------------------------
-- MODULO DE EVENTOS
-- -------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------
-- [COMDATA_EVENTOS].[PROC_EVENTOS_CALENDARIO_FERIADOS_PREENCHER]
-- -------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [COMDATA_EVENTOS].[PROC_EVENTOS_CALENDARIO_FERIADOS_PREENCHER]
	@in_ano
		int
	,@out_retInfo
		int OUTPUT
	,@out_retErroNum
		int OUTPUT
	,@out_retErroDescr
		nvarchar(4000) OUTPUT
AS
BEGIN
/*
	- Preenche calendario (COMDATA_EVENTOS)
*/
	Set NOCOUNT On;
	Set XACT_ABORT On;

	Begin Try

		Begin Transaction

		-- Passo 1: Declare variaveis de apoio
		Declare
			@DATA_AGORA datetime = GetDate();

		-- Passo 2: Declara a tabela de eventos e tabela de emendas
		Declare
			@EVENTOS Table (
			ID_EVENTOS_UNICO [int] IDENTITY(1, 1) NOT NULL,
			ID_DETALHE [int] NOT NULL,
			DATA_EXTENSO [datetime] NOT NULL
		);

		Declare
			@EMENDAS Table (
			ID_EMENDAS_UNICO [int] IDENTITY(1, 1) NOT NULL,
			DATA_EMENDA [datetime] NOT NULL
		);

		-- Passo 3: Inicio do procedimento
		Set @out_retInfo = 0;
		Set @out_retErroNum = 0;
		Set @out_retErroDescr = N'';

		If (
			Select
				EA.ANO
			From
				COMDATA_EVENTOS.EVENTOS_ANO EA
			Where
				EA.ANO = @in_ano
		) is not Null
		Begin
			-- Passo 4 Limpa Calendario para o ano solicitado
			Delete From
				COMDATA_EVENTOS.EVENTOS_CALENDARIO
			Where
				COMDATA_EVENTOS.EVENTOS_CALENDARIO.ANO = @in_ano;

			-- -----------------------------------------------------------------------------
			-- Passo 5: Calculo da Pascoa
			Declare
				@a int = @in_ano % 19
				,@b int = @in_ano / 100
				,@c int = @in_ano % 100;

			Declare
				@d int = @b / 4
				,@e int = @b % 4
				,@f int = (@b + 8) / 25;

			Declare
				@g int = (@b - @f + 1) / 3;

			Declare
				@h int = (19 * @a + @b - @d - @g + 15) % 30
				,@i int = @c / 4
				,@j int = @c % 4;

			Declare
				@k int = (32 + 2 * @e + 2 * @i - @h - @j) % 7;

			Declare
				@l int = (@a + 11 * @h + 22 * @k) / 451;

			Declare
				@mes_pascoa int = (@h + @k - 7 * @l + 114) / 31
				,@dia_pascoa int = ((@h + @k - 7 * @l + 114) % 31) + 1;

			Declare
				@pascoa_s varchar(10) = Cast(@in_ano as varchar(4)) + '/' + Cast(@mes_pascoa as varchar(2)) + '/' + Cast(@dia_pascoa as varchar(2));

			Declare
				@pascoa datetime = Convert(datetime, @pascoa_s, 111);
			-- -----------------------------------------------------------------------------
			-- -----------------------------------------------------------------------------

			-- -----------------------------------------------------------------------------
			-- Passo 6: Preenche tabela de eventos

			-- FERIADOS VARIAVEIS
			-- DEPENDEM DE ID_DETALHE NA TABELA
			Insert Into @EVENTOS ( -- CARNAVAL
				ID_DETALHE
				,DATA_EXTENSO
			)
			Values (
				2
				,DateAdd(dd, -47, @pascoa)
			);

			Insert Into @EVENTOS ( -- QUARTA-FEIRA DE CINZAS
				ID_DETALHE
				,DATA_EXTENSO
			)
			Values (
				3
				,DateAdd(dd, -46, @pascoa)
			);

			Insert Into @EVENTOS ( -- SEXTA-FEIRA SANTA (PAIXAO DE CRISTO)
				ID_DETALHE
				,DATA_EXTENSO
			)
			Values (
				4
				,DateAdd(dd, -2, @pascoa)
			);

			Insert Into @EVENTOS ( -- PASCOA
				ID_DETALHE
				,DATA_EXTENSO
			)
			Values (
				5
				,DateAdd(dd, 0, @pascoa)
			);

			Insert Into @EVENTOS ( -- CORPUS CHRISTI
				ID_DETALHE
				,DATA_EXTENSO
			)
			Values (
				8
				,DateAdd(dd, 60, @pascoa)
			);


			-- FERIADOS FIXOS
			-- NAO DEPENDEM DE ID_DETALHE NA TABELA (BASE E MES_DIA)
			Insert Into @EVENTOS (
				ID_DETALHE
				,DATA_EXTENSO
			)
			Select
				ED.ID_DETALHE
				,Convert(datetime, Cast(@in_ano as varchar(4)) + '/' + ED.MES_DIA, 111)
			From
				COMDATA_EVENTOS.EVENTOS_DETALHE ED
			Where
				ED.MES_DIA is not Null;
			-- -----------------------------------------------------------------------------
			-- -----------------------------------------------------------------------------

			-- -----------------------------------------------------------------------------
			-- Passo 7: Preenche COMDATA_EVENTOS.EVENTOS_CALENDARIO (parte 1)
			Insert Into COMDATA_EVENTOS.EVENTOS_CALENDARIO (
				ID_CALENDARIO
				,ID_DETALHE
				,ID_DIA_DA_SEMANA
				,ANO
				,MES
				,DIA
				,DATA_EXTENSO
				,DATA_INPUT
			)
			Select
				Cast (
					Cast(Datepart(year, EV.DATA_EXTENSO) as varchar(4))
					+ Cast(EV.ID_DETALHE as varchar(10))
					+ Cast(EV.ID_EVENTOS_UNICO as varchar(6)) as varchar(20)
				)
				,EV.ID_DETALHE
				,Datepart(dw, EV.DATA_EXTENSO)
				,Datepart(year, EV.DATA_EXTENSO)
				,Datepart(month, EV.DATA_EXTENSO)
				,Datepart(day, EV.DATA_EXTENSO)
				,EV.DATA_EXTENSO
				,@DATA_AGORA
			From
				@EVENTOS EV;
			-- -----------------------------------------------------------------------------
			-- -----------------------------------------------------------------------------

			Set @out_retInfo = @out_retInfo + @@ROWCOUNT;

			-- -----------------------------------------------------------------------------
			-- Passo 8: Algoritmo para preencher emendas automaticamente
			Insert Into @EMENDAS (
				DATA_EMENDA
			)
			Select Distinct
				Case
					When (Datepart(dw, EV_EM1.DATA_EXTENSO) = 3) Then
						DateAdd(day, -1, EV_EM1.DATA_EXTENSO)
					Else
						DateAdd(day, +1, EV_EM1.DATA_EXTENSO)
				End
			From
				@EVENTOS EV_EM1
			Where (
				Datepart(dw, EV_EM1.DATA_EXTENSO) = 3	-- Terca
				And not Exists (
					Select
						*
					From
						@EVENTOS EV_EM2
					Where
						EV_EM2.DATA_EXTENSO = DateAdd(day, -1, EV_EM1.DATA_EXTENSO)
				)
			)
			Or
			(
				Datepart(dw, EV_EM1.DATA_EXTENSO) = 5	-- Quinta
				And not Exists (
					Select
						*
					From
						@EVENTOS EV_EM3
					Where
						EV_EM3.DATA_EXTENSO = DateAdd(day, +1, EV_EM1.DATA_EXTENSO)
				)
			);

			-- Passo 9: Preenche COMDATA_EVENTOS.EVENTOS_CALENDARIO (parte 2)
			Insert Into COMDATA_EVENTOS.EVENTOS_CALENDARIO (
				ID_CALENDARIO
				,ID_DETALHE
				,ID_DIA_DA_SEMANA
				,ANO
				,MES
				,DIA
				,DATA_EXTENSO
				,DATA_INPUT
			)
			Select
				Cast (
					Cast(Datepart(year, EM.DATA_EMENDA) as varchar(4))
					+ '9999'
					+ Cast(EM.ID_EMENDAS_UNICO as varchar(6)) as varchar(20)
				)
				,9999
				,Datepart(dw, EM.DATA_EMENDA)
				,Datepart(year, EM.DATA_EMENDA)
				,Datepart(month, EM.DATA_EMENDA)
				,Datepart(day, EM.DATA_EMENDA)
				,EM.DATA_EMENDA
				,@DATA_AGORA
			From
				@EMENDAS EM
			Where
				Datepart(year, EM.DATA_EMENDA) = @in_ano;
			-- -----------------------------------------------------------------------------
			-- -----------------------------------------------------------------------------

			Set @out_retInfo = @out_retInfo + @@ROWCOUNT;
		End
		Else
		Begin
			Set @out_retErroDescr = N'Ano informado não cadastrado na tabela COMDATA_EVENTOS.EVENTOS_ANO';
			RaisError(@out_retErroDescr,11,1);
		End

		Commit Transaction
		Return 0

	End Try
	Begin Catch

		Set @out_retInfo = -1;
		Set @out_retErroNum = ERROR_NUMBER();
		Set @out_retErroDescr = ERROR_MESSAGE();

		If (@@TRANCOUNT > 0) Rollback Transaction
		Return -1

	End Catch

END
GO
