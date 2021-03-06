USE [COMDATA]
GO

-- -------------------------------------------------------------------------------------
-- MODULO DE EVENTOS
-- -------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------
-- [COMDATA_EVENTOS].[VW_EVENTOS_CALENDARIO_PESQUISAR]
-- -------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [COMDATA_EVENTOS].[VW_EVENTOS_CALENDARIO_PESQUISAR]
AS
	Select
		E.ID_CALENDARIO
		,A.ID_DETALHE
		,E.ANO
		,E.MES
		,E.DIA
		,E.DATA_EXTENSO
		,G.DESCRICAO DIA_DA_SEMANA
		,A.DESCRICAO EVENTO
		,B.DESCRICAO CATEGORIA
		,C.DESCRICAO ABRANGENCIA
		,D.DESCRICAO PERIODO
		,E.DATA_INPUT ENTRADA_NO_CALENDARIO
	From
		COMDATA_EVENTOS.EVENTOS_DETALHE A (Nolock)
		Inner Join COMDATA_EVENTOS.EVENTOS_CATEGORIA B (Nolock)
			On (A.ID_CATEGORIA = B.ID_CATEGORIA)
		Inner Join COMDATA_EVENTOS.EVENTOS_ABRANGENCIA C (Nolock)
			On (A.ID_ABRANGENCIA = C.ID_ABRANGENCIA)
		Inner Join COMDATA_EVENTOS.EVENTOS_PERIODO D (Nolock)
			On (A.ID_PERIODO = D.ID_PERIODO)
		Inner Join COMDATA_EVENTOS.EVENTOS_CALENDARIO E (Nolock)
			On (A.ID_DETALHE = E.ID_DETALHE)
		Inner Join COMDATA_EVENTOS.EVENTOS_ANO F (Nolock)
			On (E.ANO = F.ANO)
		Inner Join COMDATA_EVENTOS.EVENTOS_DIA_DA_SEMANA G (Nolock)
			On (E.ID_DIA_DA_SEMANA = G.ID_DIA_DA_SEMANA);
GO
