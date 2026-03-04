* @ValidationCode : MjotMTEwODYxNTc4MjpDcDEyNTI6MTc1NzU2MDQ2ODc2MzptYXVyaWNpby5sb3BlejotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Sep 2025 00:14:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable
*-----------------------------------------------------------------------------
* <Rating>-5</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.PORTABILIDAD.NOMINA.FIELDS
* ======================================================================
* Nombre de Programa : ABC.PORTABILIDAD.NOMINA.FIELDS
* Parametros         :
* Objetivo           :
* Desarrollador      : REGISTRAR LAS SOLICITUDES DE PORTABILIDAD DE NOMINA
* Compania           : ABC
* Fecha Creacion     : 2016/09/22
* Modificaciones     :
* ======================================================================
*    CAMBIO MADM - uala
*    Se agrega la configuracion de NON-STOP
*    2024-feb-27
* ===================

    $USING EB.Template
    $USING EB.SystemTables
    $USING AbcTable

    EB.Template.TableDefineid('ABC.PN.ID', EB.Template.T24String)

    EB.Template.TableAddfielddefinition('NO.CLIENTE','10','ANY','')
    EB.Template.TableAddfielddefinition('T.O','3','ANY','')
    EB.Template.TableAddfielddefinition('TIPO.CTA.BEN','3','ANY','')
    EB.Template.TableAddfielddefinition('CTA.BEN','12','ANY','')
    EB.Template.TableAddfielddefinition('CLABE','18','ANY','')
    EB.Template.TableAddfieldwitheblookup('BANCO.BEN','CLB.BANK.CODE','')
    EB.Template.TableAddfielddefinition('NOMBRE','90','ANY','')
    EB.Template.TableAddfielddefinition('RFC','13','ANY','')
    EB.Template.TableAddfielddefinition('CURP','18','ANY','')
    EB.Template.TableAddfielddefinition('FEC.NAC','8','ANY','')
    EB.Template.TableAddfielddefinition('TIPO.CTA.ORD','3','ANY','')
    EB.Template.TableAddfielddefinition('CTA.ORD','18','ANY','')
    EB.Template.TableAddfieldwitheblookup('BANCO.ORD','CLB.BANK.CODE','')
    EB.Template.TableAddfielddefinition('FECHA.SOLICITUD','8','ANY','')
    EB.Template.TableAddfielddefinition('FOLIO.SOLICITUD','30','ANY','')
    EB.Template.TableAddfielddefinition('TIPO.OPERA','3','ANY','')
    EB.Template.FieldSetcheckfile('ABC.PN.COD.OPER')
    EB.Template.TableAddfielddefinition('ESTATUS','15','ANY','')
    EB.Template.FieldSetcheckfile('ABC.PN.ESTATUS')
    EB.Template.TableAddfielddefinition('CVE.ACEP.RECH','2','ANY','')
    EB.Template.FieldSetcheckfile('ABC.PN.CODIGOS')
    EB.Template.TableAddfielddefinition('FEC.ACEP.RECH','8','ANY','')
    EB.Template.TableAddfielddefinition('FEC.CANCELACION','8','ANY','')
    EB.Template.TableAddfielddefinition('FOLIO.CANCELACION','30','ANY','')

    EB.Template.TableAddreservedfield('RESERVED.15')
    EB.Template.TableAddreservedfield('RESERVED.14')
    EB.Template.TableAddreservedfield('RESERVED.13')
    EB.Template.TableAddreservedfield('RESERVED.12')
    EB.Template.TableAddreservedfield('RESERVED.11')
    EB.Template.TableAddreservedfield('RESERVED.10')
    EB.Template.TableAddreservedfield('RESERVED.9')
    EB.Template.TableAddreservedfield('RESERVED.8')
    EB.Template.TableAddreservedfield('RESERVED.7')
    EB.Template.TableAddreservedfield('RESERVED.6')
    EB.Template.TableAddreservedfield('RESERVED.5')
    EB.Template.TableAddreservedfield('RESERVED.4')
    EB.Template.TableAddreservedfield('RESERVED.3')
    EB.Template.TableAddreservedfield('RESERVED.2')
    EB.Template.TableAddreservedfield('RESERVED.1')
    EB.Template.TableAddoverridefield()

*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()
*-----------------------------------------------------------------------------
    EB.SystemTables.setCNsOperation("ALL")

RETURN

END
