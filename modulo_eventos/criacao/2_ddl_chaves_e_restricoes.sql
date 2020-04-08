USE [COMDATA]
GO

-- -------------------------------------------------------------------------------------
-- MODULO DE EVENTOS
-- -------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------
-- [COMDATA_EVENTOS].[EVENTOS_ANO]
-- -------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------
-- [COMDATA_EVENTOS].[EVENTOS_DIA_DA_SEMANA]
-- -------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------
-- [COMDATA_EVENTOS].[EVENTOS_ABRANGENCIA]
-- -------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------
-- [COMDATA_EVENTOS].[EVENTOS_PERIODO]
-- -------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------
-- [COMDATA_EVENTOS].[EVENTOS_CATEGORIA]
-- -------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------
-- [COMDATA_EVENTOS].[EVENTOS_DETALHE]
-- -------------------------------------------------------------------------------------
ALTER TABLE [COMDATA_EVENTOS].[EVENTOS_DETALHE]  WITH CHECK ADD  CONSTRAINT [FK_EVENTOS_DETALHE_EVENTOS_CATEGORIA] FOREIGN KEY([ID_CATEGORIA])
REFERENCES [COMDATA_EVENTOS].[EVENTOS_CATEGORIA] ([ID_CATEGORIA])
GO
ALTER TABLE [COMDATA_EVENTOS].[EVENTOS_DETALHE] CHECK CONSTRAINT [FK_EVENTOS_DETALHE_EVENTOS_CATEGORIA]
GO

ALTER TABLE [COMDATA_EVENTOS].[EVENTOS_DETALHE]  WITH CHECK ADD  CONSTRAINT [FK_EVENTOS_DETALHE_EVENTOS_ABRANGENCIA] FOREIGN KEY([ID_ABRANGENCIA])
REFERENCES [COMDATA_EVENTOS].[EVENTOS_ABRANGENCIA] ([ID_ABRANGENCIA])
GO
ALTER TABLE [COMDATA_EVENTOS].[EVENTOS_DETALHE] CHECK CONSTRAINT [FK_EVENTOS_DETALHE_EVENTOS_ABRANGENCIA]
GO

ALTER TABLE [COMDATA_EVENTOS].[EVENTOS_DETALHE]  WITH CHECK ADD  CONSTRAINT [FK_EVENTOS_DETALHE_EVENTOS_PERIODO] FOREIGN KEY([ID_PERIODO])
REFERENCES [COMDATA_EVENTOS].[EVENTOS_PERIODO] ([ID_PERIODO])
GO
ALTER TABLE [COMDATA_EVENTOS].[EVENTOS_DETALHE] CHECK CONSTRAINT [FK_EVENTOS_DETALHE_EVENTOS_PERIODO]
GO

-- -------------------------------------------------------------------------------------
-- [COMDATA_EVENTOS].[EVENTOS_CALENDARIO]
-- -------------------------------------------------------------------------------------
ALTER TABLE [COMDATA_EVENTOS].[EVENTOS_CALENDARIO]  WITH CHECK ADD  CONSTRAINT [FK_EVENTOS_CALENDARIO_EVENTOS_ANO] FOREIGN KEY([ANO])
REFERENCES [COMDATA_EVENTOS].[EVENTOS_ANO] ([ANO])
GO
ALTER TABLE [COMDATA_EVENTOS].[EVENTOS_CALENDARIO] CHECK CONSTRAINT [FK_EVENTOS_CALENDARIO_EVENTOS_ANO]
GO

ALTER TABLE [COMDATA_EVENTOS].[EVENTOS_CALENDARIO]  WITH CHECK ADD  CONSTRAINT [FK_EVENTOS_CALENDARIO_EVENTOS_DETALHE] FOREIGN KEY([ID_DETALHE])
REFERENCES [COMDATA_EVENTOS].[EVENTOS_DETALHE] ([ID_DETALHE])
GO
ALTER TABLE [COMDATA_EVENTOS].[EVENTOS_CALENDARIO] CHECK CONSTRAINT [FK_EVENTOS_CALENDARIO_EVENTOS_DETALHE]
GO

ALTER TABLE [COMDATA_EVENTOS].[EVENTOS_CALENDARIO]  WITH CHECK ADD  CONSTRAINT [FK_EVENTOS_CALENDARIO_EVENTOS_DIA_DA_SEMANA] FOREIGN KEY([ID_DIA_DA_SEMANA])
REFERENCES [COMDATA_EVENTOS].[EVENTOS_DIA_DA_SEMANA] ([ID_DIA_DA_SEMANA])
GO
ALTER TABLE [COMDATA_EVENTOS].[EVENTOS_CALENDARIO] CHECK CONSTRAINT [FK_EVENTOS_CALENDARIO_EVENTOS_DIA_DA_SEMANA]
GO
