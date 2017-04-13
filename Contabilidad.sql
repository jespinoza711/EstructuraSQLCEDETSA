--Create database cnt drop database cnt
--drop table dbo.cntParametros 
--use cnt

 --select [dbo].[globalGetLastDayOftheMonth] ( '20170101') select [dbo].[globalDiaDelMes  ]( 'U', getdate()) 
 --drop function [dbo].[globalDiaDelMes] 
  
 CREATE FUNCTION [dbo].[globalDiaDelMes] 
(-- @Cual = 'U' ultimo Dia 'P' Primemr
	@Fecha datetime,
	@Cual nvarchar(1)
	
)
RETURNS datetime
AS
BEGIN
DECLARE @Date DATETIME
if upper(@Cual) = 'P' --Primer Dia
	SET @date = (SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@Fecha)-1),@Fecha),111) AS Date_Value) 
if upper(@Cual) = 'U' --Ultimo Dia	
	SET @date = (SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@Fecha))),DATEADD(mm,1,@Fecha)),111))
	RETURN @Date
END
go

-- drop table dbo.cntTipoCuenta 
Create table dbo.cntTipoCuenta ( IDTipo int not null, Descr nvarchar(255), Tipo nvarchar(1), Activo bit default 1 )
go

alter table dbo.cntTipoCuenta add constraint pkTipoCuenta primary key (IDtipo)
go
-- DROP TABLE Select * from dbo.cntSubTipoCuenta
Create table dbo.cntSubTipoCuenta ( IDTipo int not null, IDSubTipo int not null,  Descr nvarchar(255), 
SubTipo nvarchar(1), Activo bit default 1, Naturaleza nvarchar(1) )
go

alter table dbo.cntSubTipoCuenta add constraint pkcntSubTipoCuenta primary key (IDtipo, IDSubTipo)
go

alter table dbo.cntSubTipoCuenta add constraint fkcntSubTipoCuenta foreign key (IDtipo) references dbo.cntTipoCuenta ( IDtipo )
go

alter table dbo.cntSubTipoCuenta add constraint chkSubTipoCta CHECK ( Naturaleza in ('D', 'A'))
go
--*********** LOS TIPOS DE CUENTA SON VALORES POR DEFECTO DEL SISTEMA, SE TIENEN QUE INGRESAR AL CREAR LA BASE DE DATOS
insert dbo.cntTipoCuenta ( IDTipo, Descr, Tipo, Activo )
values (1, 'Balance de Situaci€n', 'B', 1)
go

insert dbo.cntTipoCuenta ( IDTipo, Descr, Tipo, Activo )
values (2, 'Estado de Resultado', 'R', 1)
go

insert dbo.cntTipoCuenta ( IDTipo, Descr, Tipo, Activo )
values (3, 'Cuenta de Orden', 'O', 1)
go

insert dbo.cntSubTipoCuenta ( IDTipo, IDSubTipo , Descr, SubTipo, Activo, Naturaleza  )
values (1,1,  'Activo', 'A', 1, 'D')
go

insert dbo.cntSubTipoCuenta ( IDTipo, IDSubTipo , Descr, SubTipo, Activo, Naturaleza  )
values (1,2,  'Pasivo', 'P', 1, 'A')
go
-- delete from dbo.cntSubTipoCuenta  
insert dbo.cntSubTipoCuenta ( IDTipo, IDSubTipo , Descr, SubTipo, Activo, Naturaleza  )
values (1,3,  'Patrimonio', 'T', 1, 'A')
go

insert dbo.cntSubTipoCuenta ( IDTipo, IDSubTipo , Descr, SubTipo, Activo, Naturaleza  )
values (2,1,  'Ingreso', 'I', 1, 'A')
go

insert dbo.cntSubTipoCuenta ( IDTipo, IDSubTipo , Descr, SubTipo, Activo, Naturaleza  )
values (2,2,  'Costos', 'C', 1, 'D')
--delete from dbo.cntSubTipoCuenta where IDTipo = 2 and IDSubTipo = 2
insert dbo.cntSubTipoCuenta ( IDTipo, IDSubTipo , Descr, SubTipo, Activo, Naturaleza  )
values (2,3,  'Gasto', 'G', 1, 'D')
go

Insert dbo.cntSubTipoCuenta ( IDTipo, IDSubTipo , Descr, SubTipo, Activo, Naturaleza  )
values (3,1,  'Orden', 'O', 1, 'D')
go



-- drop table dbo.cntGrupoCuenta SELECT * FROM dbo.cntGrupoCuenta 
Create Table dbo.cntGrupoCuenta ( 
IDGrupo int not null, 
Nivel1 nvarchar(10) not null, 
Descr nvarchar(255) not null, 
--Naturaleza nvarchar(1) not null , -- ( 'D' deudora 'A' Acreedora ) ESto se debe tomar del Subtipocuenta
UsaComplementaria bit default 0, 
IDTipo int not null,
IDSubTipo int not null, 
Activo bit default 1)
go

alter table dbo.cntGrupoCuenta add constraint pkGrupo primary key (IDGrupo)
go

alter table dbo.cntGrupoCuenta add constraint fkTipo foreign key (IDTipo) references dbo.cntTipoCuenta (IDTipo)
go

alter table dbo.cntGrupoCuenta add constraint fksubGrupo foreign key (IDTipo, IDSubTipo) references dbo.cntSubTipoCuenta (IDTipo, IDSubTipo)
go
--alter table dbo.cntGrupoCuenta add constraint chkcntGrupoCuenta CHECK ( Naturaleza in ('D', 'A'))
--go

insert  dbo.cntGrupoCuenta  (IDGrupo, Nivel1, Descr,   UsaComplementaria, IDTipo , IDSubTipo )
values (1, '1', 'ACTIVOS',   0, 1,1)
GO

insert  dbo.cntGrupoCuenta  (IDGrupo, Nivel1, Descr,   UsaComplementaria, IDTipo , IDSubTipo)
values (2, '1', 'PASIVOS',   0,1,2)
GO


-- drop table dbo.cntCuenta IDCuenta, IDGrupo, IDSubGrupo, Nivelcta, NivelSubcta, NivelSubSubCta, Naturaleza, Descr, Complementaria, Acumuladora, 
Create Table dbo.cntCuenta ( 
IDCuenta int not null identity (1,1), 
IDGrupo int not null, 
IDTipo int not null,
IDSubTipo int not null, 
Tipo nvarchar(1) not null,
SubTipo nvarchar(1) not null, 
Nivel1 nvarchar(50)  default '', 
Nivel2 nvarchar(50)  default '', 
Nivel3 nvarchar(50)  default '', 
Nivel4 nvarchar(50)  default '' , 
Nivel5 nvarchar(50)  default '',
Naturaleza nvarchar(1) not null, -- ( 'D' deudor 'A' Acreedor )
Cuenta nvarchar(50) not null default '', 
Descr nvarchar(255),
Complementaria bit default 0,
EsMayor bit default 0, 
AceptaDatos bit default 0,
Activa bit default 1, 
IDCuentaAnterior int not null,
IDCuentaMayor int not null,
UsaCentroCosto bit default 0
)
go

alter table dbo.cntCuenta add constraint chkMayorCentro CHECK ((cast(isnull(EsMayor,0) as int)+ cast(isnull(UsaCentroCosto,0) as int) )=1)
go

alter table dbo.cntCuenta add constraint chkMayor CHECK ((cast(isnull(EsMayor,0) as int)+ cast(isnull(AceptaDatos,0) as int) )=1)
go
Alter Table dbo.cntCuenta add constraint pkcntCuenta primary key (IDCuenta)
go

Alter Table dbo.cntCuenta add constraint ukcntCuenta unique  (IDGrupo, Cuenta)
go

Alter Table dbo.cntCuenta add constraint ukcntCuentaCuenta unique  (Cuenta)
go

Alter Table dbo.cntCuenta add constraint ukcntCuentaDescr unique  (Descr)
go

Alter Table dbo.cntCuenta add constraint fkcntCuentaGrupo 
foreign key  (IDGrupo) references dbo.cntGrupoCuenta (IDGrupo)
go

alter table dbo.cntCuenta add constraint chkcntCuenta CHECK ( Naturaleza in ('D', 'A'))
go

Alter Table dbo.cntCuenta add constraint fkcntCuentaAnterior 
foreign key  (IDCuenta) references dbo.cntCuenta (IDCuenta)
go

Alter Table dbo.cntCuenta add constraint fkcntCuentaMayor 
foreign key  (IDCuenta) references dbo.cntCuenta (IDCuenta)
go

--Alter Table dbo.cntCuenta add constraint fkcntSubTipoCuenta2
--foreign key  (IDTipo, IDSubTipo) references dbo.cntSubTipoCuenta (IDTipo, IDSubTipo)
--go


Create trigger trgCuenta on dbo.cntCuenta for Insert, Update
as
Declare @UsaSeparadorCta bit, @SeparadorCta nvarchar(1), @iCantidad int , @UsaPredecesor bit, @charPredecesor nvarchar(1), 
@cantCharNivel1 int,  @cantCharNivel2 int, @cantCharNivel3 int, @cantCharNivel4 int, @cantCharNivel5 int 
--set @iCantidad =( Select count(*) from dbo.cntCuenta )
Select top 1 @UsaSeparadorCta = UsaSeparadorCta, @SeparadorCta = SeparadorCta, @UsaPredecesor = UsaPredecesor,
@charPredecesor = charPredecesor, @cantCharNivel1 = cantCharNivel1, @cantCharNivel2 = cantCharNivel2,
@cantCharNivel3 = cantCharNivel3, @cantCharNivel4 = cantCharNivel4, @cantCharNivel5 = cantCharNivel5
from  dbo.cntParametros


Update c set Cuenta = right(replicate ( @charPredecesor, @cantCharNivel1) +  ISNULL(i.Nivel1,'')  , @cantCharNivel1 ) + 
case when @UsaSeparadorCta= 1 and i.Nivel2<> '' then @SeparadorCta else '' end 
+ case when ISNULL(i.Nivel2,'')<> '' then right (replicate ( @charPredecesor, @cantCharNivel2)+ i.Nivel2, @cantCharNivel2)  else '' end 
+ case when @UsaSeparadorCta= 1 and i.Nivel3<> '' then @SeparadorCta else '' end
+ case when ISNULL(i.Nivel3,'')<> '' then right (replicate ( @charPredecesor, @cantCharNivel3)+ i.Nivel3, @cantCharNivel3)  else '' end
+ case when @UsaSeparadorCta= 1 and i.Nivel4<> '' then @SeparadorCta else '' end
+ case when ISNULL(i.Nivel4,'')<> '' then right (replicate ( @charPredecesor, @cantCharNivel4)+ i.Nivel4, @cantCharNivel4)  else '' end
+ case when @UsaSeparadorCta= 1 and i.Nivel5<> '' then @SeparadorCta else '' end
+ case when ISNULL(i.Nivel5,'')<> '' then right (replicate ( @charPredecesor, @cantCharNivel5)+ i.Nivel4, @cantCharNivel5)  else '' end

From inserted i inner join dbo.cntCuenta c
on i.IDGrupo = c.IDGrupo and i.IDCuenta = c.IDCuenta 

go

--drop table  dbo.cntParametros 
Create Table dbo.cntParametros (  UsaSeparadorCta bit default 0, SeparadorCta nvarchar(1),
UsaPredecesor bit default 0, charPredecesor nvarchar(1), CantCharNivel1 int default 0, CantCharNivel2 int default 0, 
CantCharNivel3 int default 0, CantCharNivel4 int default 0, CantCharNivel5 int default 0, 
IDCtaUtilidadPeriodo int, IDCtaUtilidadAcumulada int, MesInicioPeriodoFiscal int default 0, MesFinalPeriodoFiscal int default 0,
UsaSeparadorCentro bit, SeparadorCentro nvarchar(1), UsaPredecesorCentro bit default 0, charPredecesorCentro nvarchar(1), LongAsiento int DEFAULT 10
)
go


Alter table dbo.cntParametros add constraint fkctautilperiodo foreign key (IDCtaUtilidadPeriodo) references dbo.cntCuenta (IDCuenta)
go

Alter table dbo.cntParametros add constraint fkctautilAcumPeriodo foreign key (IDCtaUtilidadAcumulada) references dbo.cntCuenta (IDCuenta)
go

insert dbo.cntParametros  ( UsaSeparadorCta, SeparadorCta, UsaPredecesor, charPredecesor, CantCharNivel1, CantCharNivel2,
CantCharNivel3, CantCharNivel4, CantCharNivel5, MesInicioPeriodoFiscal, MesFinalPeriodoFiscal,UsaSeparadorCentro, SeparadorCentro , UsaPredecesorCentro , charPredecesorCentro , LongAsiento    )
values ( 1, '-', 1,  '0',  1, 2,3,4, 5, 1, 12,1, '-', 1, '0', 10 )
go

--drop view dbo.vcntCatalogo SELECT * FROM  dbo.vcntCatalogodbo.cntParametros
Create View dbo.vcntCatalogo 
as 
SELECT C.IDGrupo, G.Descr DescrGrupo, C.IDCuenta, C.Nivel1, C.Nivel2, C.Nivel3, C.Nivel4, C.Nivel5,
C.Cuenta, C.Descr DescrCuenta, S.Naturaleza , C.Tipo,S.SubTipo, C.EsMayor, C.AceptaDatos , 
c.IDTipo,  C.IDSubTipo,  C.Complementaria, C.UsaCentroCosto
FROM dbo.cntCuenta C INNER JOIN dbo.cntGrupoCuenta G on C.IDGrupo = G.IDGrupo 
inner join dbo.cntSubTipoCuenta S on C.IDTipo = s.IDTipo and C.IDSubTipo = S.IDSubTipo 

go

--drop table  Select * from dbo.cntEjercicio drop table dbo.cntEjercicio drop table dbo.cntperiodocontable

Create Table dbo.cntEjercicio ( IDEjercicio int not null, Descr nvarchar(50), FechaInicio datetime, FechaFin datetime,
 Activo bit default 1, InicioOperaciones bit default 0, MesInicioOperaciones int, Cerrado bit default 0 ) 
go

alter table dbo.cntEjercicio add constraint pkcntEjercicio primary key (IDEjercicio)
go

CREATE FUNCTION [dbo].[cntInicioOperaciones] ()
RETURNS bit
AS
BEGIN
Declare @Resultado int, @Iniciado bit 
set @Resultado = (
	Select COUNT(*)
	From dbo.cntEjercicio
	where InicioOperaciones = 1 AND Activo = 1
	)
if @Resultado is null
	set @Resultado = 0
if @Resultado >= 1
	set @Iniciado = 1
else
	set @Iniciado = 0

RETURN @Iniciado
END
go

-- drop trigger trgcntEjercicio
/*
Create trigger trgcntEjercicio on dbo.cntEjercicio BEFORE INSERT, update
as
BEGIN
Declare @Iniciado bit, @InsertedIniciado bit, @Datos nvarchar(30)

select @InsertedIniciado = i.InicioOperaciones
from inserted i
set @Iniciado  = 0
set @Iniciado=(select  [dbo].[cntInicioOperaciones] ())
set @Datos = 'insertado '+cast( @InsertedIniciado as nvarchar(10)) + ' iniciado ' + cast( @Iniciado as nvarchar(10)) 
	if @InsertedIniciado = 0 and @Iniciado = 0
	begin
		  BEGIN  
			set nocount on
			ROLLBACK TRAN ;
			--RAISERROR ( 'Ud quiere incluir un ejercicio que no indica la apertura de operaciones !!!', 16, 1) ;
			RAISERROR ( @Datos, 16, 1) ;
		  END 
	end

	if @InsertedIniciado = 1 and @Iniciado = 1
	begin
		  BEGIN  
			set nocount on
			ROLLBACK TRAN ;
			RAISERROR ( @Datos, 16, 1) ;
			--RAISERROR ( 'Ud quiere indicar un inicio de Operaciones contable... pero ya existe dicha apertura !!!' , 16, 1) ;
		  END 
	end
END
GO
*/
-- Drop table dbo.cntPeriodoContable select * from dbo.cntEjercicio
Create Table dbo.cntPeriodoContable ( IDEjercicio int not null, Periodo nvarchar(10) not null, FechaFinal datetime not null, Descr nvarchar(255) ,
FinPeriodoFiscal bit default 0, Cerrado bit default 0, AjustesCierreFiscal bit default 0, Activo bit default 1 )
go 

alter table dbo.cntPeriodoContable add constraint pkPeriodoContable primary key (IDEjercicio, Periodo)
go

alter table dbo.cntPeriodoContable add constraint fkPeriodoContable foreign key (IDEjercicio) references dbo.cntEjercicio ( IDEjercicio )
go

Create Function dbo.cntEjercicioConPeriodoCierreFiscal (@IDEjercicio int)
RETURNS bit
BEGIN
Declare @Resultado bit
	If exists ( Select * 
				From dbo.cntPeriodoContable 
				Where IDEjercicio = @IDEjercicio and AjustesCierreFiscal = 1 )	
		set @Resultado = 1
	ELSE
		set @Resultado = 0
return @Resultado
END
go


--Create Trigger trPeriodoContable on dbo.cntPeriodoContable after Insert, Update
--as
--Declare @IDPeriodo int, @IDEjercicio int, @AjustesCierreFiscal bit 
--SElect @IDEjercicio = i.IDEjercicio, @AjustesCierreFiscal = i.AjustesCierreFiscal
--from inserted i
--if @AjustesCierreFiscal = 1 and  dbo.cntEjercicioConPeriodoCierreFiscal (@IDEjercicio)=1
--begin
--		RAISERROR ( 'Se intenta crear un Periodo Contable indicando que inicia operaciones, pero ya Existe uno en ese Ejercicio...', 16, 1) ;
--		rollback tran 
--end
--go

/*
select [dbo].[cntInicioOperaciones] ()
Create trigger trgcntPeriodoContable on dbo.cntPeriodoContable for Insert, Update
as
Declare @Periodo13 nvarchar(10), @Fecha datetime  
select  @Periodo13  =(cast(year(i.FechaFinal) as nvarchar(4) ) + '13' ) , 
@Fecha = cast(year(i.FechaFinal) as nvarchar(4) )+ right('00'+ cast(month(i.FechaFinal) as nvarchar(4) ),2)+ '01'
from inserted i

Update c set Periodo = cast(year(i.FechaFinal) as nvarchar(4) ) + right ('00' + cast(month(i.FechaFinal) as nvarchar(4) ),2) 
From inserted i inner join dbo.cntPeriodoContable c
on i.FechaFinal = c.FechaFinal


if not exists (Select C.* from   dbo.cntPeriodoContable c where Periodo = @Periodo13 and AjustesCierreFiscal = 1)
begin
	insert  dbo.cntPeriodoContable ( Periodo , FechaFinal, Descr, FinPeriodoFiscal, AjustesCierreFiscal)
values ( @Periodo13, @Fecha, 'Ajustes al Cierre Fiscal ' + @Periodo13, 0,1)
end
go

Declare @AnioInicialPeriodo int
select * from dbo.cntperiodocontable 
exec dbo.cntCreaPeriodos 2017, 2017
drop procedure dbo.cntCreaPeriodos
SELECT * FROM dbo.cntPeriodoContable

select * from dbo.cntcuenta
*/
Create Procedure dbo.cntCreaPeriodos @IDEjercicio int,  @AnioInicialPeriodo int
as
set nocount on
--set @AnioInicialPeriodo = 2017
Declare @MesInicioPeriodoFiscal int, @MesFinalPeriodoFiscal int, @MesPivote int, 
@Fecha datetime, @Periodo13 nvarchar(10), @Fecha13 datetime, @Periodo nvarchar(10), @FinPeriodo bit
Declare @InicioOperaciones bit, @MesInicioOperaciones int, @Activo bit 
 Select @InicioOperaciones= InicioOperaciones, @MesInicioOperaciones =MesInicioOperaciones
 from dbo.cntejercicio
 where IDEjercicio = @IDEjercicio
-- validar si no existe movimientos en cualquier periodos del anio
if @InicioOperaciones = 0
	set @Activo = 1
SElect Top 1 @MesInicioPeriodoFiscal = MesInicioPeriodoFiscal, @MesFinalPeriodoFiscal = MesFinalPeriodoFiscal   
from dbo.cntParametros

Delete from dbo.cntPeriodoContable where FechaFinal >=  cast (cast(@AnioInicialPeriodo as nvarchar(4) ) + right ('00'+ cast ( @MesInicioPeriodoFiscal as nvarchar(2) ),2) + '01' as datetime )
and  FechaFinal <= dateadd ( month, 12, cast (cast(@AnioInicialPeriodo as nvarchar(4) ) + right ('00'+ cast ( @MesInicioPeriodoFiscal as nvarchar(2) ),2) + '01' as datetime ) )

set @MesPivote = 1
	set @Fecha = cast (cast(@AnioInicialPeriodo as nvarchar(4) ) + right ('00'+ cast ( @MesInicioPeriodoFiscal as nvarchar(2) ),2) + '01' as datetime )
	--set @Fecha = (select  [dbo].[globalDiaDelMes] (DATEADD (month,11, @Fecha ), 'U'))
	set @Fecha =  (select  [dbo].[globalDiaDelMes](@Fecha, 'U'))
While @MesPivote <= 13
begin
	set @Periodo = cast(year(@Fecha) as nvarchar(4) ) + right ('00' + cast(month(@Fecha) as nvarchar(4) ),2) 
	set @FinPeriodo = 0
	if @MesPivote <= 12
	begin	
	if @InicioOperaciones = 1 and   @MesPivote< @MesInicioOperaciones
		set @Activo = 0
	else
		set @Activo = 1
	
	
		if @MesPivote = 12
			set @FinPeriodo = 1
			Insert dbo.cntPeriodoContable ( IDEjercicio, Periodo , FechaFinal, Descr, FinPeriodoFiscal, Activo)
			Values (@IDEjercicio, @Periodo, @Fecha, 'Periodo ' + @Periodo , @FinPeriodo, @Activo )
	end

	
	if @MesPivote = 13
	begin
		set @Periodo13  =(cast(year(@Fecha) as nvarchar(4) ) + '13' )
		set @Fecha13 = DATEADD ( month, 1,  cast (cast(year(@Fecha) as nvarchar(4) )+ right('00'+ cast(month(@Fecha) as nvarchar(4) ),2)+ '01' as datetime ) )

			Insert dbo.cntPeriodoContable ( IDEjercicio, Periodo , FechaFinal, Descr, FinPeriodoFiscal, AjustesCierreFiscal )
			Values (@IDEjercicio, @Periodo13, @Fecha13, 'Ajustes al Cierre Fiscal  ' + cast (@IDEjercicio as nvarchar(20)) , 0, 1)		
		
	end 

	set @MesPivote = @MesPivote + 1
	if @MesPivote <= 12
		set @Fecha = dateadd(month,1,@Fecha)
		set @Fecha =  (select  [dbo].[globalDiaDelMes](@Fecha, 'U'))
		
	
end

go
/*
Declare @FechaFin datetime,  @IDEjercicio int, @Anio int
set @FechaInicio = '20170101'
set @InicioOperaciones = 1
set @MesInicioOperaciones = 7 SELECT * FROM DBO.cntPeriodocontable delete FROM DBO.cntPeriodocontable delete from dbo.cntEjercicio
*/

--******* para crear un EJERCICIO

Create Function dbo.cntExisteEjercicioConInicioOperaciones ()
Returns bit
begin
Declare @Existe bit
	set @Existe = (select  [dbo].[cntInicioOperaciones] ())
	Return @Existe
end
go
-- drop procedure dbo.cntCreaEjercicio exec dbo.cntCreaEjercicio  '20170101', 1,5 select * from cntperiodofiscal
Create Procedure dbo.cntCreaEjercicio @FechaInicio datetime, @InicioOperaciones bit, @MesInicioOperaciones int
--Parametros del proceso de crear ejercicio 
-- @FechaInicio Es la Fecha en donde se inicia el Ejercicio de doce meses
-- @InicioOperaciones Indica si el ejercicio a crearse inicia o no las operaciones por primera vez
-- @MesInicioOperaciones Si es inicio de operaciones se indica el mes en que se inician las operaciones
as
Declare @FechaFin datetime,  @IDEjercicio int, @Anio int
set nocount on 
if dbo.cntExisteEjercicioConInicioOperaciones () = 1 and @InicioOperaciones = 1
begin
	RAISERROR ( 'Se intenta crear un Ejercicio Contable indicando que inicia operaciones, pero ya Existe uno...', 16, 1) ;
	return
end
 
if @InicioOperaciones = 0
	set  @MesInicioOperaciones = 0
Set  @FechaInicio = (select  [dbo].[globalDiaDelMes] ( @FechaInicio, 'P')) 
set @FechaFin = (select  [dbo].[globalDiaDelMes] (DATEADD (month,11, @FechaInicio ), 'U'))

set @Anio = (YEAR ( @FechaInicio ))

if exists (Select IDEjercicio from dbo.cntEjercicio where IDEjercicio = @Anio )
begin
	RAISERROR ( 'Ejercicio Contable Existente ...', 16, 1) ;
	return	
end
insert dbo.cntEjercicio ( IDEjercicio, Descr, FechaInicio, FechaFin , Activo, InicioOperaciones, MesInicioOperaciones)
values ( @Anio , 'Ejercicio ' + CAST( @Anio as nvarchar(4) ), @FechaInicio, @FechaFin,
1, @InicioOperaciones,@MesInicioOperaciones)
EXEC dbo.cntCreaPeriodos  @Anio, @Anio

go

--drop table dbo.cntCentroCosto
Create Table dbo.cntCentroCosto ( IDCentro int identity(0,1) not null, Nivel1 nvarchar(2),  
Nivel2 nvarchar(2), Nivel3 nvarchar(2), Centro nvarchar(10), Descr nvarchar(255),
IDCentroAnterior int, Acumulador int default 0,IDCentroAcumulador int,  ReadOnlySys bit default 0)
go
Alter table dbo.cntCentroCosto add constraint pkCentro primary key (IDCentro)
go

alter table  dbo.cntCentroCosto add constraint fkCentroAcumulador foreign key (IDCentroAcumulador) references dbo.cntCentroCosto(IDCentro)
go

alter table  dbo.cntCentroCosto add constraint fkCentroAnterior foreign key (IDCentroAnterior) references dbo.cntCentroCosto(IDCentro)
go

alter table  dbo.cntCentroCosto add constraint ukcentroCentro unique (Centro)
go
-- drop trigger trgCentro select * delete from dbo.cntCentroCosto where idcentro = 1
Create trigger trgCentro on dbo.cntCentroCosto for Insert, Update
as
Declare @UsaSeparadorCentro bit, @SeparadorCentro nvarchar(1),  @UsaPredecesorCentro bit, @charPredecesorCentro nvarchar(1)

Select top 1 @UsaSeparadorCentro = UsaSeparadorCentro, @SeparadorCentro = SeparadorCentro, 
@UsaPredecesorCentro = UsaPredecesorCentro, @charPredecesorCentro = charPredecesorCentro
from  dbo.cntParametros


Update c set Centro = right(replicate ( @charPredecesorCentro, 2) +  ISNULL(i.Nivel1,'')  , 2 ) + 
case when @UsaSeparadorCentro= 1 and i.Nivel2<> '' then @SeparadorCentro else '' end 
+ case when ISNULL(i.Nivel2,'')<> '' then right (replicate ( @charPredecesorCentro, 2)+ i.Nivel2, 2)  else '' end 
+ case when @UsaSeparadorCentro= 1 and i.Nivel3<> '' then @SeparadorCentro else '' end
+ case when ISNULL(i.Nivel3,'')<> '' then right (replicate ( @charPredecesorCentro, 2)+ i.Nivel3, 2)  else '' end
From inserted i inner join dbo.cntCentroCosto c
on i.IDCentro = c.IDCentro

go

-- DElete from dbo.cntCentroCosto select * from dbo.cntCentroCosto

Insert dbo.cntCentroCosto ( Nivel1, Nivel2, Nivel3 , Descr ,  IDCentroAnterior, IDCentroAcumulador, Acumulador, ReadOnlySys )
values ( '0','0','0','No Definido', 0,0,0,1)
go


Create Table dbo.cntCuentaCentro ( IDCuenta int not null, IDCentro int not null )
go

alter table dbo.cntCuentaCentro add constraint pkCentroCuenta primary key (IDCuenta, IDCentro)
go

alter table dbo.cntCuentaCentro add constraint fkCentroctacta foreign key (IDCuenta) references dbo.cntCuenta (IDCuenta)
go

alter table dbo.cntCuentaCentro add constraint fkCentroctaCentro foreign key (IDCentro) references dbo.cntCentroCosto (IDCentro)
go
-- drop table dbo.cntTipoAsiento
Create Table dbo.cntTipoAsiento( Tipo nvarchar(2) not null, Descr nvarchar(255), Consecutivo int default 0, UltimoAsiento nvarchar(20), Activo bit default 1, ReadOnlySys bit default 0)
go
alter table dbo.cntTipoAsiento add constraint pkTipoAsiento primary key (Tipo)
go
Insert dbo.cntTipoAsiento (Tipo, Descr, Consecutivo, UltimoAsiento, Activo, ReadOnlySys)
values ('FA', 'FACTURACION', 0, 'FA00000000', 1, 1)
GO

Insert dbo.cntTipoAsiento (Tipo, Descr, Consecutivo, UltimoAsiento, Activo, ReadOnlySys)
values ('CC', 'CUENTAS POR COBRAR', 0, 'CC00000000', 1, 1)
GO

Insert dbo.cntTipoAsiento (Tipo, Descr, Consecutivo, UltimoAsiento, Activo, ReadOnlySys)
values ('CP', 'CUENTAS POR PAGAR', 0, 'CP00000000', 1, 1)
GO

Insert dbo.cntTipoAsiento (Tipo, Descr, Consecutivo, UltimoAsiento, Activo, ReadOnlySys)
values ('NM', 'NOMINA', 0, 'NM00000000', 1, 1)
GO

Insert dbo.cntTipoAsiento (Tipo, Descr, Consecutivo, UltimoAsiento, Activo, ReadOnlySys)
values ('CG', 'CONTABILIDAD GENERAL', 0, 'CG00000000', 1, 1)
GO

Insert dbo.cntTipoAsiento (Tipo, Descr, Consecutivo, UltimoAsiento, Activo, ReadOnlySys)
values ('IN', 'INVENTARIO', 0, 'IN00000000', 1, 1)
GO

Insert dbo.cntTipoAsiento (Tipo, Descr, Consecutivo, UltimoAsiento, Activo, ReadOnlySys)
values ('CO', 'COMPRAS', 0, 'CO00000000', 1, 1)
GO

Insert dbo.cntTipoAsiento (Tipo, Descr, Consecutivo, UltimoAsiento, Activo, ReadOnlySys)
values ('AF', 'FACTIVOS FIJOS', 0, 'AF00000000', 1, 1)
GO

Insert dbo.cntTipoAsiento (Tipo, Descr, Consecutivo, UltimoAsiento, Activo, ReadOnlySys)
values ('BA', 'BANCOS', 0, 'BA00000000', 1, 1)
GO

Insert dbo.cntTipoAsiento (Tipo, Descr, Consecutivo, UltimoAsiento, Activo, ReadOnlySys)
values ('CF', 'CIERRE FISCAL ( EJERCICIO )', 0, 'CF00000000', 1, 1)
GO


Create Table dbo.cntAsiento ( IDEjercicio int not null, Periodo nvarchar(10) not null, Asiento nvarchar(20) not null, Tipo nvarchar(2) not null, Fecha datetime, 
Createdby nvarchar(20), CreateDate datetime, Modifiedby nvarchar(20), UpdatedDate datetime,
Referencia nvarchar(255), Mayorizado bit default 0, Anulado bit default 0, TipoCambio decimal (28,4) default 0, ModuloFuente nvarchar(2), CuadreTemporal bit default 0 )
go

alter table  dbo.cntAsiento add constraint pkcntAsiento primary key (Asiento)
go

alter table  dbo.cntAsiento add constraint fkcntAsiento foreign key (Tipo) references dbo.cntTipoAsiento (Tipo)
go

alter table  dbo.cntAsiento add constraint fkcntAsientoEjercicio foreign key (IDEJercicio) references dbo.cntEjercicio (IDEjercicio)
go

alter table  dbo.cntAsiento add constraint fkcntAsientoPeriodo foreign key (IDEJercicio, Periodo) references dbo.cntPeriodoContable (IDEjercicio, Periodo)
go
alter table dbo.cntAsiento add constraint chkCuadretMayor CHECK ((cast(isnull(Mayorizado,0) as int)+ cast(isnull(CuadreTemporal,0) as int) ) IN (0,1))
go

-- Crear el codigo del asiento
-- drop table dbo.cntAsientoDetalle
Create Table dbo.cntAsientoDetalle ( Asiento nvarchar(20) not null, Linea int ,
IDCentro int not null, IDCuenta int not null, Centro nvarchar(10) not null, Cuenta nvarchar(50) not null,
Referencia nvarchar(255), Debito decimal (28,4) default 0,  Credito decimal (28,4) default 0,
Documento nvarchar(255)  )
go

alter table dbo.cntAsientoDetalle add constraint pkAsientoDetalle primary key (Asiento, IDCuenta, IDCentro)
go

alter table  dbo.cntAsientoDetalle add constraint fkcntAsientoCuenta foreign key (IDCuenta) references dbo.cntCuenta (IDCuenta)
go

alter table  dbo.cntAsientoDetalle add constraint fkcntAsientoCentro foreign key (IDCentro) references dbo.cntCentroCosto (IDCentro)
go

alter table  dbo.cntAsientoDetalle add constraint fkcntAsientodetasiento foreign key (Asiento) references dbo.cntAsiento(Asiento)
go
-- drop trigger trgAsientoDetalle
Create Trigger trgAsientoDetalle on dbo.cntAsientoDetalle for insert
as
Declare @Count int, @Asiento nvarchar(20) , @IDCentro int, @IDCuenta int, @Centro nvarchar(10), @Cuenta nvarchar(50)

SELECT @Asiento = i.Asiento, @IDCentro = IDCentro, @IDCuenta = IDCuenta
from inserted i 

Select @Centro = Centro from dbo.cntCentroCosto  where IDCentro = @IDCentro
Select @Cuenta = Cuenta from dbo.cntCuenta  where IDCuenta = @IDCuenta

set @Count = isnull((select  count(*) from dbo.cntAsientoDetalle where asiento =  @Asiento ),0)

update D set Linea = @Count, Cuenta = @Cuenta, Centro = @Centro
From inserted i inner join  dbo.cntAsientoDetalle D
ON i.Asiento = D.Asiento and i.IDCuenta = D.IDCuenta and i.IDCentro = D.IDCentro

go


Create Table dbo.cntSaldo( IDSaldo int not null, IDEjercicio int not null, 
Periodo nvarchar(10) not null, IDCuenta int not null, Cuenta nvarchar (50) not null, Fecha datetime,  
Saldo decimal(28,4) default 0, TipoCambio decimal(28,4)  default 0,FechaSaldoAnt datetime, SaldoAnterior  decimal(28,4) default 0, TipoCambioSaldoAnt decimal(28,4)  default 0 )
go

alter table dbo.cntSaldo add constraint pkcntSaldo primary key (IDSaldo)
go

alter table dbo.cntSaldo add constraint fkcntSaldoEjerc foreign key (IDEjercicio) references dbo.cntEjercicio (IDEjercicio)
go

alter table dbo.cntSaldo add constraint fkcntSaldoPeriodo foreign key (IDEjercicio, Periodo) references dbo.cntPeriodoContable (IDEjercicio, Periodo)
go

alter table dbo.cntSaldo add constraint fkcntSaldoCta foreign key (IDCuenta) references dbo.cntCuenta (IDCuenta)
go


Create Table dbo.cntSeccionEstadoFinanciero ( IDSeccion int identity(1,1) not null, DescrEstadoFinanciero nvarchar (250), IDTIpo int not null, IDSubtipo int not null, Orden int default 0 )
 go

Alter table dbo.cntSeccionEstadoFinanciero  add constraint pkSeccionEF primary key (IDSeccion)
go

alter table dbo.cntSeccionEstadoFinanciero add constraint fkSeccionEFSubTipoCta foreign key (IDTipo, IDSubtipo) references dbo.cntSubTipoCuenta  (IDTipo, IDSubtipo) 
go

alter table dbo.cntCuenta add IDSeccion int 
go 

alter table dbo.cntCuenta add constraint fkCtaSeccion foreign key (IDseccion) references dbo.cntSeccionEstadoFinanciero (IDSeccion)
go
--********************** procedimientos de Actualizacion de tablas y Procesos *************
-- EXEC cntUpdateEjercicio 'I', '201701', '20170101', 1, 1
Create Procedure cntUpdateEjercicio @Operacion nvarchar(1), @IDEjercicio int = 0,  @FechaInicio datetime, @InicioOperaciones bit, @MesInicioOperaciones int, @Descr nvarchar(50) = null
as
set nocount on 

if upper(@Operacion) = 'U'
begin
	Update dbo.cntEjercicio set Descr = @Descr 
	where IDEjercicio = @IDEjercicio 
end


if upper(@Operacion) = 'I'
begin
	exec dbo.cntCreaEjercicio  @FechaInicio, @InicioOperaciones,@MesInicioOperaciones
end
if upper(@Operacion) = 'D'
begin
	if exists (Select IDEjercicio  from dbo.cntAsiento where IDEjercicio = @IDEjercicio)
	begin
			RAISERROR ( 'No se puede eliminar un ejercicio con movimientos contables...', 16, 1) ;
			return	
	end
	-- borrarlo
	BEGIN TRANSACTION 
	BEGIN TRY
		Delete from dbo.cntPeriodoContable  where IDEjercicio = @IDEjercicio
		Delete from dbo.cntEjercicio where IDEjercicio = @IDEjercicio
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0  
			ROLLBACK TRANSACTION;
	END CATCH
		IF @@TRANCOUNT > 0  
			COMMIT TRANSACTION; 	
end

go

--Select * from dbo.cntTipoAsiento 
--DROP PROCEDURE dbo.cntUpdateTipoAsiento
Create Procedure dbo.cntUpdateTipoAsiento @Operacion nvarchar(1), @Tipo nvarchar(2), @Descr nvarchar(25), @Consecutivo int,  @Activo bit, @ReadOnlySys bit 
-- El ultimo asiento no se pasa como parametro
as
set nocount on 
declare @LongAsiento int, @tmpAsiento nvarchar (20)
	Select top 1  @LongAsiento = LongAsiento from dbo.cntParametros 	
	set @tmpAsiento = left(@Tipo + replicate ( '0', (@LongAsiento-2)),@LongAsiento)

if upper(@Operacion) = 'I'
begin
	if not exists (Select Tipo From dbo.cntTipoAsiento Where Tipo = @Tipo )
	begin
		insert dbo.cntTipoAsiento ( Tipo, Descr , Consecutivo ,Activo , ReadOnlySys, UltimoAsiento  )
		values ( @Tipo, @Descr, @Consecutivo, @Activo, @ReadOnlySys, @tmpAsiento )
	end
	else
	begin
			RAISERROR ( 'Ese Tipo de Asiento ya Existe', 16, 1) ;
			return			
	end
end	

if upper(@Operacion) in ('U', 'D') and Exists ( Select 	Tipo from  dbo.cntTipoAsiento  Where Tipo = @Tipo and ReadOnlySys = 1 )
begin
		RAISERROR ( 'Ese Tipo de Asiento est∑ protegido por el Sistema, Ud no puede alterarlo', 16, 1) ;
		return		
end

if upper(@Operacion) = 'U'
begin

	

	Update dbo.cntTipoAsiento set Descr = @Descr , Consecutivo = @Consecutivo, Activo = @Activo, ReadOnlySys = 0,
	UltimoAsiento = @tmpAsiento
	where Tipo = @Tipo and ReadOnlySys = 0
end	

if upper(@Operacion) = 'D'
begin

	if Exists ( Select 	Tipo from  dbo.cntAsiento  Where Tipo = @Tipo )	
	begin 
		RAISERROR ( 'Ese Tipo de Asiento no puede eliminarse porque tiene dependencias en asientos contables', 16, 1) ;
		return				
	end

	if Exists ( Select 	Tipo from  dbo.cntTipoAsiento  Where Tipo = @Tipo and ReadOnlySys = 0 )	
	begin 
		Delete from dbo.cntTipoAsiento where Tipo = @Tipo 
	end
end
go

-- drop procedure dbo.cntUpdateCentroCosto exec dbo.cntUpdateCentroCosto 'I', 
Create Procedure dbo.cntUpdateCentroCosto @Operacion nvarchar(1), @IDCentro int, @Nivel1 nvarchar(2), @Nivel2 nvarchar(2),
@Nivel3 nvarchar(2), @Descr nvarchar(255), @IDCentroAnterior int, @Acumulador bit, @IDCentroAcumulador int
as
set nocount on 

if upper(@Operacion) = 'I'
begin
	INSERT  dbo.cntCentroCosto ( Nivel1, Nivel2 , Nivel3 , Descr , IDCentroAnterior, Acumulador, IDCentroAcumulador )
	VALUES ( @Nivel1 , @Nivel2 , @Nivel3, @Descr , @IDCentroAnterior , @Acumulador , @IDCentroAcumulador )
end

if upper(@Operacion) = 'D'
begin

	if Exists ( Select IDCentro  from  dbo.cntCuentaCentro    Where IDCentro  = @IDCentro)	
	begin 
		RAISERROR ( 'Ese Centro de Costo no puede eliminarse porque tiene dependencias en la Relacion Cuentas - Centros', 16, 1) ;
		return				
	end
	if Exists ( Select IDCentro  from  dbo.cntAsientoDetalle   Where IDCentro  = @IDCentro)	
	begin 
		RAISERROR ( 'Ese Centro de Costo no puede eliminarse porque tiene dependencias en asientos contables', 16, 1) ;
		return				
	end
	DELETE  FROM dbo.cntCentroCosto WHERE IDCentro = @IDCentro and  ReadOnlySys = 1
end

if upper(@Operacion) = 'U' 
begin
	Update dbo.cntCentroCosto set Descr = @Descr , Nivel1 = @Nivel1 , Nivel2 = @Nivel2 , Nivel3 = @Nivel3 ,
	Acumulador = @Acumulador ,  IDCentroAcumulador = @IDCentroAcumulador, IDCentroAnterior= @IDCentroAnterior
	where IDCentro = @IDCentro and ReadOnlySys = 1
end

go

-- drop procedure dbo.cntUpdateSeccionEstadoFinanciero exec dbo.cntUpdateSeccionEstadoFinanciero 'I', 1, 'Activosss', 1,1, 1 select * from dbo.cntSeccionEstadoFinanciero
Create Procedure dbo.cntUpdateSeccionEstadoFinanciero @Operacion nvarchar(1), @IDSeccion int, @DescrEstadoFinanciero nvarchar(255), 
@IDTipo int, @IDSubTipo bit, @Orden int
as
set nocount on 

if upper(@Operacion) = 'I'
begin
	INSERT  dbo.cntSeccionEstadoFinanciero ( DescrEstadoFinanciero, IDTipo , IDSubTipo , Orden )
	values ( @DescrEstadoFinanciero, @IDTipo , @IDSubTipo , @Orden)
end

if upper(@Operacion) = 'D'
begin

	if Exists ( Select IDCuenta  from  dbo.cntCuenta   Where IDSeccion  = @IDSeccion)	
	begin 
		RAISERROR ( 'Esa Secci€n no puede eliminarse porque tiene dependencias en las Cuentas Contables', 16, 1) ;
		return				
	end
	
	DELETE  FROM dbo.cntSeccionEstadoFinanciero WHERE IDSeccion  = @IDSeccion
end

if upper(@Operacion) = 'U' 
begin
	Update dbo.cntSeccionEstadoFinanciero set DescrEstadoFinanciero = @DescrEstadoFinanciero , Orden  = @Orden ,
	IDTipo = @IDTipo , IDSubTipo = @IDSubTipo 
	where IDSeccion  = @IDSeccion
end

go

--Select * from dbo.cntGrupoCuenta
Create Procedure dbo.cntUpdateCuenta @Operacion nvarchar(1), @IDCuenta int , @IDGrupo int , @IDTipo int , @Complementaria bit, 
@IDSubTipo int ,  @Nivel1 nvarchar(50)  , 
@Nivel2 nvarchar(50)  , @Nivel3 nvarchar(50) , @Nivel4 nvarchar(50)   , @Nivel5 nvarchar(50)  ,
 @Descr nvarchar(255),  @EsMayor bit , 
@AceptaDatos bit , @Activa bit , @IDCuentaAnterior int , @IDCuentaMayor int ,
@UsaCentroCosto bit, @IDSeccion int = null 
as
Declare @Tipo nvarchar(1) , @SubTipo nvarchar(1) , @UsaComplementaria bit, @Naturaleza nvarchar(1) 
set nocount on

Select @UsaComplementaria = UsaComplementaria 
from dbo.cntGrupoCuenta 
where IDGrupo = @IDGrupo 

select @Tipo = Tipo 
from dbo.cntTipoCuenta  
where IDTipo = @IDTipo 

Select @SubTipo = SubTipo, @Naturaleza = Naturaleza
from dbo.cntSubTipoCuenta 
where IDTipo = @Tipo and IDSubTipo = @IDSubTipo 

if @Complementaria = 1
begin
	set @Naturaleza = case when @Naturaleza = 'D' then 'A' else 'D' end
end

if upper(@Operacion) = 'I'
begin
	INSERT  dbo.cntcuenta  (IDGrupo,IDTipo,IDSubTipo, Tipo, SubTipo , Nivel1, Nivel2, Nivel3, Nivel4 , Nivel5, Naturaleza ,  
							Descr, Complementaria , EsMayor , AceptaDatos, IDCuentaAnterior , IDCuentaMayor, 
							UsaCentroCosto , IDSeccion  ) 
	values ( @IDGrupo , @IDTipo , @IDSubTipo , @Tipo , @SubTipo , @Nivel1 , @Nivel2 , @Nivel3 , @Nivel4 , @Nivel5 , @Naturaleza,
							@Descr, @Complementaria, @EsMayor, @AceptaDatos , @IDCuentaAnterior , @IDCuentaMayor,
							@UsaCentroCosto , @IDSeccion )
end

if upper(@Operacion) = 'U'
begin
	Update dbo.cntcuenta set Descr = @Descr , Complementaria = @Complementaria , AceptaDatos = @AceptaDatos , Activa = @Activa , 
	IDCuentaAnterior = @IDCuentaAnterior , IDCuentaMayor = @IDCuentaMayor
	where IDCuenta = @IDCuenta 
end

if upper(@Operacion) = 'D'
begin

	if Exists ( Select IDCtaUtilidadAcumulada   from  dbo.cntParametros    Where (IDCtaUtilidadAcumulada   = @IDCuenta) or IDCtaUtilidadPeriodo= @IDCuenta )	
	begin 
		RAISERROR ( 'Esa Cuenta Contable no puede eliminarse porque tiene dependencias en los Parametros del Sistema', 16, 1) ;
		return				
	end
	if Exists ( Select IDCuenta   from  dbo.cntCuentaCentro   Where IDCuenta  = @IDCuenta)	
	begin 
		RAISERROR ( 'Esa Cuenta Contable no puede eliminarse porque tiene dependencias en la Relacion Cuentas - Centros', 16, 1) ;
		return				
	end
	if Exists ( Select IDcuenta  from  dbo.cntAsientoDetalle   Where IDCuenta  = @IDCuenta)	
	begin 
		RAISERROR ( 'La Cuenta no puede eliminarse porque tiene dependencias en asientos contables', 16, 1) ;
		return				
	end

	Delete from dbo.cntcuenta Where IDCuenta = @IDCuenta 
end
go

--************ para grabar el Asiento Contable 
/*
DECLARE @XML xml
set @XML =
'<Root>
 <Asiento>
  <IDEjercicio>2017</IDEjercicio>
  <Periodo>201701</Periodo>
  <Asiento>FA0000000006</Asiento>
  <Fecha>2017-01-02T00:00:00</Fecha>
  <Tipo>FA</Tipo>
  <Createdby>azepeda</Createdby>
  <CreateDate>2017-01-01T00:00:00</CreateDate>
  <Modifiedby>azepeda</Modifiedby>
  <UpdatedDate>2017-01-01T00:00:00</UpdatedDate>
  <Referencia>APERTURA</Referencia>
  <Mayorizado>0</Mayorizado>
  <Anulado>0</Anulado>
  <TipoCambio>0.0000</TipoCambio>
  <CuadreTemporal>0</CuadreTemporal>
  <Detalle>
    <Asiento>FA0000000006</Asiento>
    <Linea>1</Linea>
    <IDCentro>0</IDCentro>
    <IDCuenta>1</IDCuenta>
    <Centro>00-00-00</Centro>
    <Cuenta>1</Cuenta>
    <Referencia>APERTURA</Referencia>
    <Debito>2500.0000</Debito>
    <Credito>0.0000</Credito>
    <Documento>APERTURA</Documento>
  </Detalle>
  <Detalle>
    <Asiento>FA0000000006</Asiento>
    <Linea>2</Linea>
    <IDCentro>0</IDCentro>
    <IDCuenta>2</IDCuenta>
    <Centro>00-00-00</Centro>
    <Cuenta>1-07</Cuenta>
    <Referencia>APERTURA</Referencia>
    <Debito>0.0000</Debito>
    <Credito>2500.0000</Credito>
    <Documento>APERTURA</Documento>
  </Detalle>
</Asiento>
</Root>'
--select @XML

exec dbo.cntUpdateAsiento 'I', @XML , 'FA0000000002', 'FA'
select * from dbo.cntAsiento where Asiento = 'FA0000000005'
select * from dbo.cntAsientoDetalle  where Asiento = 'FA0000000005'
select * from dbo.cntTipoAsiento 
*/

--drop procedure dbo.cntUpdateAsiento 
Create procedure dbo.cntUpdateAsiento @Operacion nvarchar(1), @XML xml, @Asiento nvarchar(20), @Tipo nvarchar(2)
-- El Tipo se pasa para el proceso de insercion, para crear el numero del asiento en el tipo correspondiente...
as

set nocount on 
declare @LongAsiento INT , @Consecutivo int 

select @LongAsiento = LongAsiento from dbo.cntParametros 
-- LECTURA DE CABECERA 
select
    Tab.Col.value('IDEjercicio[1]', 'int') as IDEjercicio,
    Tab.Col.value('Periodo[1]', 'nvarchar(10)') as Periodo,
    Tab.Col.value('Asiento[1]', 'nvarchar(20)') as Asiento,
    --@Asiento Asiento, 
    Tab.Col.value('Tipo[1]', 'nvarchar(2)') as Tipo,
    Tab.Col.value('Fecha[1]', 'datetime') as Fecha,
    Tab.Col.value('Createdby[1]', 'nvarchar(20)') as Createdby,
    Tab.Col.value('CreateDate[1]', 'datetime') as CreateDate,
    Tab.Col.value('Modifiedby[1]', 'nvarchar(20)') as Modifiedby,
    Tab.Col.value('UpdatedDate[1]', 'datetime') as UpdatedDate,
	Tab.Col.value('Referencia[1]', 'nvarchar(255)') as Referencia,
    Tab.Col.value('Mayorizado[1]', 'bit') as Mayorizado,
    Tab.Col.value('Anulado[1]', 'bit') as Anulado,
    Tab.Col.value('TipoCambio[1]', 'decimal(28,4)') as TipoCambio,
    Tab.Col.value('ModuloFuente[1]', 'nvarchar(2)') as ModuloFuente,
    Tab.Col.value('CuadreTemporal[1]', 'bit') as CuadreTemporal
into #Asiento
from @XML.nodes('//Root/Asiento') as Tab(Col)

-- LECTURA DE LINEAS DETALLE
select
	--@Asiento Asiento,  
	Tab1.Col1.value('Asiento[1]', 'nvarchar(20)') as Asiento,
    Tab1.Col1.value('Linea[1]', 'int') as Linea,
    Tab1.Col1.value('IDCentro[1]', 'int') as IDCentro,
    Tab1.Col1.value('IDCuenta[1]', 'int') as IDCuenta,
    Tab1.Col1.value('Centro[1]', 'nvarchar(10)') as Centro,
    Tab1.Col1.value('Cuenta[1]', 'nvarchar(50)') as Cuenta,
    Tab1.Col1.value('Referencia[1]', 'nvarchar(255)') as ReferenciaDet,
    Tab1.Col1.value('Debito[1]', 'float') as Debito,
    Tab1.Col1.value('Credito[1]', 'float') as Credito,
    Tab1.Col1.value('Documento[1]', 'nvarchar(255)') as Documento
into #AsientoDetalle    
from @XML.nodes('//Root/Asiento/Detalle') as Tab1(Col1)

declare @msgDescuadre nvarchar(250), @Descuadrado bit
Select @Descuadrado = case when (SUM(Debito) <> sum(Credito) ) then  1 else 0 end,
@msgDescuadre = 'Debito: ' + cast(SUM(Debito) as nvarchar(20)) + 
' Credito: ' + cast(SUM(Credito) as nvarchar(20)) + ' Diferencia : ' + cast( SUM(Debito) - sum(Credito) as nvarchar(20)) 
From #AsientoDetalle

if Upper(@Operacion) in ('I', 'U')
begin 
	if  @Descuadrado  = 1
	begin
		begin
			declare @msg nvarchar(255)
			set @msg =  'El asiento Contable esta descuadrado ' + @msgDescuadre
			RAISERROR ( @msg , 16, 1) ;
			return		
		end

	end
end
BEGIN TRANSACTION 
BEGIN TRY

	if upper(@Operacion) = 'D'
	begin
		if exists (Select Asiento From dbo.cntAsiento  where Asiento = @Asiento  and mayorizado = 1)
		begin
			RAISERROR ( 'Ese asiento contable no se puede eliminar porque ya ha sido mayorizado', 16, 1) ;
		
		end

			Delete From dbo.cntAsientoDetalle Where Asiento = @Asiento
			Delete From dbo.cntAsiento Where Asiento = @Asiento	

	end		

	if upper(@Operacion) = 'I'
	begin
 

			 	SELECT @Asiento = (tipo + RIGHT( replicate('0', @LongAsiento ) + cast (Consecutivo + 1 as nvarchar(20)), @LongAsiento ) ),
 				@Consecutivo = Consecutivo + 1     
				FROM dbo.cntTipoAsiento (UPDLOCK)                             
				WHERE TIPO = @Tipo
				if exists (Select Asiento From dbo.cntAsiento (NOLOCK)  where Asiento = @Asiento )
				begin
					RAISERROR ( 'Ya Existe ese asiento contable, no se puede crear', 16, 1) ;		
				end	
				Update dbo.cntTipoAsiento set UltimoAsiento = @Asiento , Consecutivo = @Consecutivo 		 			
				where Tipo = @Tipo 
					
				INSERT  dbo.cntAsiento ( IDEjercicio, Periodo, Asiento, Tipo, Fecha, Createdby, CreateDate, Referencia, Mayorizado,
				Anulado, TipoCambio, ModuloFuente, CuadreTemporal  )
				Select IDEjercicio, Periodo, @Asiento Asiento, Tipo, Fecha, Createdby, CreateDate, Referencia, Mayorizado,
				Anulado, TipoCambio, ModuloFuente, CuadreTemporal
				From #Asiento 
				--where asiento = @Asiento 

				INSERT dbo.cntAsientoDetalle( Asiento, Linea , IDCentro, IDCuenta , Centro, Cuenta, Referencia , Debito, Credito , Documento )
				Select @Asiento Asiento, Linea , IDCentro, IDCuenta , 'CCX' Centro,'CtaX' Cuenta, ReferenciaDet , Debito, Credito , Documento 
				from #AsientoDetalle 
				--where asiento = @Asiento 
		
				--return
	end	
	
	if upper(@Operacion) = 'U'
	begin

		if exists (Select Asiento From dbo.cntAsiento  where Asiento = @Asiento  and mayorizado = 1)
		begin
			RAISERROR ( 'Ese asiento contable no se puede editar porque ya ha sido mayorizado', 16, 1) ;
			--return		
		end

			Delete From dbo.cntAsientoDetalle Where Asiento = @Asiento
			Delete From dbo.cntAsiento Where Asiento = @Asiento	
			
				INSERT  dbo.cntAsiento ( IDEjercicio, Periodo, Asiento, Tipo, Fecha, Createdby, CreateDate, Referencia, Mayorizado,
				Anulado, TipoCambio, ModuloFuente )
				Select IDEjercicio, Periodo, @Asiento Asiento, Tipo, Fecha, Createdby, CreateDate, Referencia, Mayorizado,
				Anulado, TipoCambio, ModuloFuente
				From #Asiento 
				--where asiento = @Asiento 
			
				INSERT dbo.cntAsientoDetalle( Asiento, Linea , IDCentro, IDCuenta , Centro, Cuenta, Referencia , Debito, Credito , Documento )
				Select @Asiento Asiento, Linea , IDCentro, IDCuenta , 'CCX' Centro,'CtaX' Cuenta, ReferenciaDet , Debito, Credito , Documento 
				from #AsientoDetalle 
				--where asiento = @Asiento		
		

	end		
END TRY
BEGIN CATCH
	declare @error nvarchar(500)
    SELECT @error = ERROR_MESSAGE()  
    RAISERROR ( @error, 16, 1) ;
	IF @@TRANCOUNT > 0  
		ROLLBACK TRANSACTION;
END CATCH
	IF @@TRANCOUNT > 0  
		COMMIT TRANSACTION; 	


drop table #AsientoDetalle
drop table #Asiento
 
go




--exec dbo.cntUpdateCentroCosto 'i', 0, '1','1', '0', 'Departamento de Desarrollo', 0, 1, 1
--exec dbo.cntUpdateTipoAsiento 'D', 'GA', 'CIERRES DE GASTOSXX', 0,  1, 0




-- EXEC cntUpdateEjercicio 'i', 2017, '20170101', 1, 5 @IDEjercicio int = 0,  @FechaInicio datetime, @InicioOperaciones bit, @MesInicioOperaciones int
--Select * from dbo.cntEjercicio cntUpdateEjercicio @Operacion nvarchar(1), @IDEjercicio int = 0,  @FechaInicio datetime, @InicioOperaciones bit, @MesInicioOperaciones int dbo.cntAsiento dbo.cntCuenta order by idcuentaanterior delete From dbo.cntCuenta
-- select * from dbo.cntPeriodocontable
-- SELECT * FROM DBO.cntAsiento  SELECT * FROM DBO.cntAsientoDetalle
-- select * from dbo.cntCuenta

-- ********************************************************************************************************************* 


 INSERT dbo.cntCuenta (  IDGrupo, IDtipo, IDSubTipo, Tipo, Subtipo, Nivel1, Nivel2 ,  Nivel3, Nivel4, Nivel5, Naturaleza, Descr, 
 Complementaria, EsMayor, AceptaDatos, IDCuentaAnterior , IDCuentaMayor )
 Values( 1,1,1,'B', 'A',  '1','', '','','', 'D','ACTIVO',  1,1, 0, 1,1)
go 
  INSERT dbo.cntCuenta (  IDGrupo, IDtipo, IDSubTipo, Tipo, Subtipo, Nivel1, Nivel2 ,  Nivel3, Nivel4, Nivel5, Naturaleza, Descr, 
 Complementaria, EsMayor, AceptaDatos, IDCuentaAnterior , IDCuentaMayor )
  Values( 1,1,1,'B', 'A',  '1','7', '','','', 'D','ACTIVO FIJO', 1,1, 0, 1,1)
go
 INSERT dbo.cntCuenta (  IDGrupo, IDtipo, IDSubTipo, Tipo, Subtipo, Nivel1, Nivel2 ,  Nivel3, Nivel4, Nivel5, Naturaleza, Descr, 
 Complementaria, EsMayor, AceptaDatos, IDCuentaAnterior , IDCuentaMayor )
  Values( 1,1,1,'B', 'A',  '1','1', '2','','', 'D','ACTIVO FIJO xx', 1,1, 0, 1,1)
go

 INSERT dbo.cntCuenta (  IDGrupo, IDtipo, IDSubTipo, Tipo, Subtipo, Nivel1, Nivel2 ,  Nivel3, Nivel4, Nivel5, Naturaleza, Descr, 
 Complementaria, EsMayor, AceptaDatos, IDCuentaAnterior , IDCuentaMayor )
  Values( 1,2,1,'B', 'A',  '1','1', '3','','', 'D','ACTIVO FIJO xxxxx', 1,1, 0, 1,1)
go
/*
select *
from dbo.cntEJERCICIO
select *
from dbo.cntAsientoDETALLE

insert dbo.cntAsiento  (IDEjercicio, Periodo,   Asiento,Tipo, Fecha)
values (2017, '201705', 'CG00000001', 'CG', '20170501')
delete FROM DBO.cntAsientoDetalle
select * FROM DBO.cntAsientoDetalle
insert DBO.cntAsientoDetalle (ASiento, IDCENTRO, IDCUENTA, CENTRO, CUENTA, DEbitO, CREDITO, DOCUMENTO)
VALUES (  'CG00000001', 0,1,'1','1',10,0,'ND')

insert DBO.cntAsientoDetalle (ASiento, IDCENTRO, IDCUENTA, CENTRO, CUENTA, DEbitO, CREDITO, DOCUMENTO)
VALUES (  'CG00000001', 0,2,'1','1',10,0,'ND')

insert DBO.cntAsientoDetalle (ASiento, IDCENTRO, IDCUENTA, CENTRO, CUENTA, DEbitO, CREDITO, DOCUMENTO)
VALUES (  'CG00000001', 0,3,'1','1',10,0,'ND')
*/

-- INSERT dbo.cntCuenta (  IDGrupo, IDtipo, IDSubTipo, Tipo, Subtipo, Nivel1, Nivel2 ,  Nivel3, Nivel4, Nivel5, Naturaleza, Descr, 
-- Complementaria, EsMayor, AceptaDatos, IDCuentaAnterior , IDCuentaMayor )
--  Values( 1,1,1,'B', 'A',  '1','1', '2','3','', 'D','ACTIVO FIJO xxx', 1,1, 0, 1,1)
--  go
--   INSERT dbo.cntCuenta (  IDGrupo, IDtipo, IDSubTipo, Tipo, Subtipo, Nivel1, Nivel2 ,  Nivel3, Nivel4, Nivel5, Naturaleza, Descr, 
-- Complementaria, EsMayor, AceptaDatos, IDCuentaAnterior , IDCuentaMayor )
--  Values( 1,1,1,'B', 'A',  '1','1', '2','3','5', 'D','ACTIVO FIJO xxxxx', 1,1, 0, 1,1)
--go
/*
select * from dbo.cntSubTipocuenta
select * from dbo.cntEjercicio 
Select * from dbo.cntPeriodoContable 

select * from dbo.cntCuenta 

select * from dbo.vcntCatalogo

select * from dbo.cntTipoCuenta 
select * from dbo.cntSubTipoCuenta

*/

/*
if upper(@Operacion) = 'I'
begin
	if exists (Select Asiento From dbo.cntAsiento where Asiento = @Asiento )
	begin
		RAISERROR ( 'Ya Existe ese asiento contable, no se puede crear', 16, 1) ;
		return		
	end
	BEGIN TRANSACTION 
	BEGIN TRY	
		INSERT  dbo.cntAsiento ( IDEjercicio, Periodo, Asiento, Tipo, Fecha, Createdby, CreateDate, Referencia, Mayorizado,
		Anulado, TipoCambio, ModuloFuente )
		values ( @IDEjercicio , @Periodo , @Asiento , @Tipo, @Fecha , @Createdby, @CreateDate, @Referencia , @Mayorizado ,
		@Anulado , @TipoCambio , @ModuloFuente ) 
end

if upper(@Operacion) = 'D'
begin

	if exists (Select Asiento From dbo.cntAsiento  where Asiento = @Asiento  and mayorizado = 1)
	begin
		RAISERROR ( 'Ese asiento contable no se puede eliminar porque ya ha sido mayorizado', 16, 1) ;
		return		
	end
	BEGIN TRANSACTION 
	BEGIN TRY
		Delete From dbo.cntAsientoDetalle Where Asiento = @Asiento
		Delete From dbo.cntAsiento Where Asiento = @Asiento
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0  
			ROLLBACK TRANSACTION;
	END CATCH
		IF @@TRANCOUNT > 0  
			COMMIT TRANSACTION; 	
	

end	

*/
