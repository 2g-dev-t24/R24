* @ValidationCode : MjoxNTUzMjk0OTQxOkNwMTI1MjoxNzY0NzcwNTA4Mjk4Okx1Y2FzRmVycmFyaTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 03 Dec 2025 11:01:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTable
SUBROUTINE ABC.TT.ARQUEO.FIELDS
* ======================================================================
* Nombre de Programa : ABC.TT.ARQUEO
* Parametros         :
* Objetivo           : Template para registro de los arqueos de efectivo
* Requerimiento      : CORE-1305 Generar alertas para cuando se exceda el l�mite de efectivo y cuando se hacen arqueos
* Desarrollador      : CAST - FyG-Solutions
* Compania           :
* Fecha Creacion     :
* Modificaciones     :
* ======================================================================

*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $USING EB.Template
    $USING EB.SystemTables
    $USING TT.Contract
    $USING TT.Config
    $USING ST.CurrencyConfig

*** </region>

*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ABC.TT.ARQ.ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfielddefinition('CAJERO', '4', 'ANY', '')
    EB.Template.FieldSetcheckfile('TELLER.ID')
    EB.Template.TableAddfielddefinition('MONEDA', '5', 'CCY', '')
    EB.Template.FieldSetcheckfile('CURRENCY')
    EB.Template.TableAddfield('XX.NARRATIVA', EB.Template.T24String, '', '')
    EB.Template.TableAddfielddefinition('XX<DENOM', '12', 'ANY', '')
    EB.Template.FieldSetcheckfile('TELLER.DENOMINATION')
    EB.Template.TableAddfielddefinition('XX-CANTIDAD', '5', '', '')
    EB.Template.TableAddfielddefinition('XX-CANTIDAD.FIS', '5', '', '')
    EB.Template.TableAddfielddefinition('XX-RESERVADO.1.5', '35', 'ANY', '')
    EB.Template.TableAddfielddefinition('XX-RESERVADO.1.4', '35', 'ANY', '')
    EB.Template.TableAddfielddefinition('XX-RESERVADO.1.3', '35', 'ANY', '')
    EB.Template.TableAddfielddefinition('XX-RESERVADO.1.2', '35', 'ANY', '')
    EB.Template.TableAddfielddefinition('XX>RESERVADO.1.1', '35', 'ANY', '')
    EB.Template.TableAddfielddefinition('TOTAL', '20', 'ANY', '')
    EB.Template.TableAddfielddefinition('TOTAL.FIS', '20', 'ANY', '')
    EB.Template.TableAddfielddefinition('DIFERENCIA', '20', 'ANY', '')
    EB.Template.TableAddreservedfield('RESERVED.5')
    EB.Template.TableAddreservedfield('RESERVED.4')
    EB.Template.TableAddreservedfield('RESERVED.3')
    EB.Template.TableAddreservedfield('RESERVED.2')
    EB.Template.TableAddreservedfield('RESERVED.1')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()

*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
