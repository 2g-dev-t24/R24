* @ValidationCode : MjotNjI0MzIyMjI6Q3AxMjUyOjE3NTczODE2MDU5Njk6bWF1cmljaW8ubG9wZXo6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 08 Sep 2025 22:33:25
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
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.PN.COD.OPER.FIELDS
* ======================================================================
* Nombre de Programa : ABC.PN.COD.OPER.FIELDS
* Parametros         :
* Objetivo           : CATALOGO DE CODIGO DE OPERACION DE PORTABILIDAD DE NOMINA
* Desarrollador      : SANDRA FIGUEROA ESQUIVEL
* Compañia           : ABC
* Fecha Creacion     : 2016/09/23
* Modificaciones     :
* ======================================================================

    $USING EB.Template


    EB.Template.TableDefineid('ABC.PN.COD.OPER.ID', EB.Template.T24String)

    EB.Template.TableAddfielddefinition('DESCRIPCION', '60', 'ANY', '')

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

RETURN

END
