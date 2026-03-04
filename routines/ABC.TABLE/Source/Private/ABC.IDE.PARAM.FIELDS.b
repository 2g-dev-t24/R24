* @ValidationCode : MjoyODA4ODU1NTA6Q3AxMjUyOjE3NTk3ODA1MDg3MTQ6THVpcyBDYXByYTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Oct 2025 16:55:08
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

SUBROUTINE ABC.IDE.PARAM.FIELDS
    $USING EB.SystemTables
    $USING EB.Template
    $USING AC.AccountOpening
    $USING ST.Config
    $USING ST.CurrencyConfig
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)
*-----------------------------------------------------------------------------

    EB.Template.TableAddfielddefinition('MONEDA', '3', 'A', '')
    EB.Template.FieldSetcheckfile('CURRENCY':@FM:ST.CurrencyConfig.Currency.EbCurCcyName:@FM:'L')
    EB.Template.TableAddfielddefinition('MTO.LIMITE', '19', 'AMT', '')
    EB.Template.TableAddfielddefinition('PORC.COBRO', '4', 'R', '')
    EB.Template.TableAddfielddefinition('TRANS.CR', '3', '', '')
    EB.Template.FieldSetcheckfile("TRANSACTION":@FM:ST.Config.Transaction.AcTraNarrative:@FM:'A.')
    EB.Template.TableAddfielddefinition('TRANS.AB', '3', '', '')
    EB.Template.FieldSetcheckfile("TRANSACTION":@FM:ST.Config.Transaction.AcTraNarrative:@FM:'A.')
    EB.Template.TableAddfielddefinition('CUENTA.AB', '16', 'A', '')
    EB.Template.FieldSetcheckfile('ACCOUNT':@FM:AC.AccountOpening.Account.ShortTitle:@FM:'L')
    EB.Template.TableAddfielddefinition('XX.COD.TRANS', '3', '', '')
    EB.Template.FieldSetcheckfile("TRANSACTION":@FM:ST.Config.Transaction.AcTraNarrative:@FM:'A.')
    EB.Template.TableAddoptionsfield('XX<TIPO.PERSONA','PF_PM', 'A', '')
    EB.Template.TableAddfielddefinition('XX>XX.EXC.TRANS', '3', '', '')
    EB.Template.FieldSetcheckfile("TRANSACTION":@FM:ST.Config.Transaction.AcTraNarrative:@FM:'A.')
    EB.Template.TableAddfielddefinition('REP.FIS.NOM', '35', 'A', '')
    EB.Template.TableAddfielddefinition('REP.FIS.PAT', '35', 'A', '')
    EB.Template.TableAddfielddefinition('REP.FIS.MAT', '35', 'A', '')
    EB.Template.TableAddfielddefinition('REP.FIS.RFC', '35', 'A', '')
    EB.Template.TableAddfielddefinition('REP.FIS.CURP', '35', 'A', '')
    EB.Template.TableAddfielddefinition('RUTA.REP', '35', 'A', '')
    EB.Template.TableAddfielddefinition('RUTA.REP.XSL', '35', 'A', '')
    EB.Template.TableAddfielddefinition('XX<PORC.COBRO.FEC', '8', 'D', '')
    EB.Template.TableAddfielddefinition('XX-PORC.LIMITE', '19', 'AMT', '')
    EB.Template.TableAddfielddefinition('XX>PORC.COBRO.HIS', '4', 'R', '')

    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()
RETURN
*-----------------------------------------------------------------------------
END

