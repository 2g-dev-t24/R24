* @ValidationCode : MjotNTIyODkxMzQ5OkNwMTI1MjoxNzYzMzIyMDMyMzQ0Okx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Nov 2025 16:40:32
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


SUBROUTINE GENERIC.EXTRACT.PARAM.LV.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
    $USING ST.Config
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24BigString)        ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddoptionsfield   ('HEADER'         ,'Y_N'     , 'A', '')
    EB.Template.TableAddfielddefinition('SEPARADOR'      ,'7'       , 'A', '')
    EB.Template.TableAddfielddefinition('VM.SEP'         ,'7'       , 'A', '')
    EB.Template.TableAddfielddefinition('SM.SEP'         ,'7'       , 'A', '')
    EB.Template.TableAddfielddefinition('FILE.PATH'      ,'60'      , 'A', '')
    EB.Template.TableAddfielddefinition('FILE.NAME'      ,'60'      , 'A', '')
    EB.Template.TableAddfielddefinition('FILE.EXT'       ,'5'       , 'A', '')
    EB.Template.TableAddfielddefinition('XX<COMPANY'     ,'3'       , 'A', '')
    EB.Template.TableAddoptionsfield   ('XX>LOAD.TYPE'   ,'ALL_CHANGED'     , 'A', '')
    EB.Template.TableAddfielddefinition('LOAD.DATE.INI'  ,'8'       , 'A', '')
    EB.Template.TableAddfielddefinition('LOAD.DATE.FIN'  ,'8'       , 'A', '')
    EB.Template.TableAddfielddefinition('HELP.FILE'      ,'150'      , 'A', '')
    EB.Template.TableAddfielddefinition('XX<FIELD'       ,'40'      , 'A', '')
    
    EB.Template.TableAddfielddefinition('XX-LOCAL.NAME'       ,'35'      , 'A', '')
    EB.Template.TableAddfielddefinition('XX-SPEC.VM.SEP'      ,'7'       , 'A', '')
    EB.Template.TableAddfielddefinition('XX-NO.POS.VM'        ,'40'      , 'A', '')
    EB.Template.TableAddfielddefinition('XX-SPEC.SM.SEP'      ,'7'       , 'A', '')
    EB.Template.TableAddfielddefinition('XX-NO.POS.SM'        ,'40'      , 'A', '')
    EB.Template.TableAddfielddefinition('XX-FLD.HEDR.NAME'    ,'40'      , 'A', '')
    EB.Template.TableAddfielddefinition('XX-OPERADOR'         ,'40'      , 'A', '')
    EB.Template.TableAddfielddefinition('XX-OPERANDO'         ,'40'      , 'A', '')
    EB.Template.TableAddfielddefinition('XX-VISUALIZA'        ,'20'      , 'A', '')
    EB.Template.TableAddfielddefinition('XX-LINK.APP.FIELD'   ,'100'      , 'A', '')
    EB.Template.TableAddfield          ('XX-RESERVED02'   ,40, EB.Template.FieldNoInput, '')
    EB.Template.TableAddfield          ('XX-RESERVED03'   ,40, EB.Template.FieldNoInput, '')
    EB.Template.TableAddfield          ('XX-RESERVED04'   ,40, EB.Template.FieldNoInput, '')
    EB.Template.TableAddfield          ('XX>RESERVED05'   ,40, EB.Template.FieldNoInput, '')

    EB.Template.TableAddfielddefinition('SEL.FILTER.ROUTINE'       ,'50'      , 'A', '')

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

    EB.Template.TableSetauditposition()
END