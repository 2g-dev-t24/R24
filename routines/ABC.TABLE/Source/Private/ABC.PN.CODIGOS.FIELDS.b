* @ValidationCode : MjotNzU5MjQ1MTI5OkNwMTI1MjoxNzU3Mzg0ODY4NTM5Om1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Sep 2025 23:27:48
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
* rights reserved.
$PACKAGE AbcTable
*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.PN.CODIGOS.FIELDS
* ======================================================================
* Nombre de Programa : ABC.PN.CODIGOS.FIELDS
* Parametros         :
* Objetivo           : CATALOGO DE CODIGOS DE RESPUESTA DE SOLICITUD DE PORTABILIDAD DE NOMINA
* Desarrollador      : SANDRA FIGUEROA ESQUIVEL
* Compania           : ABC
* Fecha Creacion     : 2016/09/23
* Modificaciones     :
* ======================================================================
    $USING EB.Service

    EB.Service.ClearFile(FileName, FileVar)
    $USING EB.Template

    EB.Template.TableDefineid('ABC.PN.CODIGOS.ID', EB.Template.T24String)

    EB.Template.TableAddfielddefinition('DESCRIPCION', '60', 'ANY', '')
    EB.Template.TableAddfielddefinition('ESTADO', '60', 'ANY', '')
    EB.Template.FieldSetcheckfile('ABC.PN.ESTATUS':FM:AbcTable.AbcPnEstatus.Descripcion:FM:'L.A')     ;* Use DEFAULT.ENRICH from SS or just field 1


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
