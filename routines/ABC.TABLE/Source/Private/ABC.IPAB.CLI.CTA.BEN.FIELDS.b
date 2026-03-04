* @ValidationCode : MjotMjQxNDMxMzAwOkNwMTI1MjoxNzU5NzEwNzMyMDI1Okx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Oct 2025 21:32:12
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
SUBROUTINE ABC.IPAB.CLI.CTA.BEN.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------


    EB.Template.TableAddfield("PERSONALIDAD", EB.Template.T24String, ANY, '')
    EB.Template.TableAddfield("NOMBRE", '80', 'ANY', '')
    EB.Template.TableAddfield("APELLIDO.PATERNO", '40', 'ANY', '')
    EB.Template.TableAddfield("APELLIDO.MATERNO", '40', 'ANY', '')
    EB.Template.TableAddfield("CALLE.NUMERO", EB.Template.T24String, ANY, '')
    EB.Template.TableAddfield("COLONIA", EB.Template.T24String, ANY, '')
    EB.Template.TableAddfield("MUNICIPIO" , EB.Template.T24String, ANY, '')
    EB.Template.TableAddfield("COD.POS", EB.Template.T24String, ANY, '')
    EB.Template.TableAddfield("PAIS", EB.Template.T24String, ANY, '')
    EB.Template.TableAddfield("ESTADO", EB.Template.T24String, ANY, '')
    EB.Template.TableAddfield("RFC", EB.Template.T24String, ANY, '')
    EB.Template.TableAddfield("CURP", EB.Template.T24String, ANY, '')
    EB.Template.TableAddfield("TELEFONO", EB.Template.T24String, ANY, '')
    EB.Template.TableAddfield("EMAIL" , EB.Template.T24String, ANY, '')
    EB.Template.TableAddfield("FECHA.NACIMIENTO", EB.Template.T24String, ANY, '')
    EB.Template.TableAddfield("SALDO.COMPENSADO" , EB.Template.T24String, ANY, '')

END
