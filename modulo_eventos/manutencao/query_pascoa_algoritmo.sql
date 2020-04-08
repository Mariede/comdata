-- variaveis de entrada
Declare
	@in_ano int = 2015;

-- -----------------------------------------------------------------------------
-- Calculo da Pascoa
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

-- Calculo Feriados/ Pontos Facultativos Moveis
select
	@pascoa											'Páscoa'
	,Datepart(dw, @pascoa)							'Weekday Páscoa'
	,DateAdd(dd, -46, @pascoa)						'Quarta-feira de Cinzas'
	,Datepart(dw, DateAdd(dd, -46, @pascoa))		'Weekday Quarta-feira de Cinzas'
	,DateAdd(dd, -2, @pascoa)						'Sexta-feira Santa (Paixão de Cristo)'
	,Datepart(dw, DateAdd(dd, -2, @pascoa))			'Weekday Sexta-feira Santa (Paixão de Cristo)'
	,DateAdd(dd, 60, @pascoa)						'Corpus Christi (Quinta-feira)'
	,Datepart(dw, DateAdd(dd, 60, @pascoa))			'Weekday Corpus Christi (Quinta-feira)';
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
