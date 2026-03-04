* @ValidationCode : Mjo5MTk1OTIwNzpDcDEyNTI6MTc1OTcxMTk5MDY0MzpMdWlzIENhcHJhOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Oct 2025 21:53:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable

SUBROUTINE ABC.IPAB.CTA.BEN.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("CTA.ORG", EB.Template.T24String)    ;* Define Table id
*-----------------------------------------------------------------------------

    EB.Template.TableAddfield("CLIENTE", EB.Template.T24String, 'ANY', '')
    EB.Template.TableAddfield("SALDO.CUENTA", EB.Template.T24String, 'ANY', '')
    EB.Template.TableAddfield("INTERESES", EB.Template.T24String, 'ANY', '')
    EB.Template.TableAddfield("RETENCION.IMPUESTO", EB.Template.T24String, 'ANY', '')
    EB.Template.TableAddfield("SALDO.NETO", EB.Template.T24String, 'ANY', '')
    EB.Template.TableAddfield("FECHA.CORTE", EB.Template.T24String, 'ANY', '')
    EB.Template.TableAddfield("TASA", EB.Template.T24String, 'ANY', '')
    EB.Template.TableAddfield("SALDO.PROMEDIO" , EB.Template.T24String, 'ANY', '')

END
