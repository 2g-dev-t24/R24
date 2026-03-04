* @ValidationCode : MjotMTc0NjQ0NjQ1MjpDcDEyNTI6MTc2MTI2MjE0ODkwMDpMdWlzIENhcHJhOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 Oct 2025 20:29:08
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

SUBROUTINE ABC.BANCA.INTERNET.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid('ID', EB.Template.T24String)
*-----------------------------------------------------------------------------
    EB.Template.TableAddfield('CLAV.CONFIR',EB.Template.T24BigString   , EB.Template.FieldNoChange, '')
    EB.Template.TableAddoptionsfield("ESTATUS"         ,'INACTIVA_ACTIVA_BLOQUEADA_CANCELADA', 'A', '')
    EB.Template.TableAddfielddefinition('FECHA.CONTRAT'        ,'8'       , 'D', '')
    EB.Template.TableAddfielddefinition('FECHA.CANCELA'        ,'8'       , 'D', '')
    EB.Template.TableAddfielddefinition('XX<TER.CTA'      ,'12'        , 'A', '')
    EB.Template.FieldSetcheckfile("ACCOUNT":FM:AC.AccountOpening.Account.AccountTitleOne:FM:'A.')
    EB.Template.TableAddoptionsfield("XX-TER.STATUS"         ,'ACTIVA_INACTIVA', 'A', '')
    EB.Template.TableAddfielddefinition('XX-TER.ALIAS'    ,'50'       , 'A', '')
    EB.Template.TableAddfielddefinition('XX-TER.BENEFI'    ,'35'       , 'A', '')
    EB.Template.TableAddfielddefinition('XX-TER.MAIL'    ,'30'       , 'A', '')
    EB.Template.TableAddfielddefinition('XX-TEL.MOV'    ,'10'       , 'A', '')
    EB.Template.TableAddreservedfield("XX-RESERVED.T.1")
    EB.Template.TableAddreservedfield("XX>RESERVED.T.2")
    EB.Template.TableAddoptionsfield   ("XX<INT.BAN.TIPO"         ,'CLABE_TARJETA DE DEBITO', 'A', '')
    EB.Template.TableAddfielddefinition('XX-INT.BAN.BANCO'      ,'5'        , '', '')
    EB.Template.FieldSetcheckfile("ABC.BANCOS":FM:AbcTable.AbcBancos.ClavePuntoTrans:FM:'A.')
    EB.Template.TableAddfielddefinition('XX-INT.BAN.CTA'      ,'18'        , 'A', '')
    EB.Template.TableAddoptionsfield("XX-INT.BAN.STATUS"         ,'ACTIVA_INACTIVA', 'A', '')
    EB.Template.TableAddfielddefinition('XX-INT.BAN.ALIAS'      ,'50'        , 'A', '')
    EB.Template.TableAddfielddefinition('XX-INT.BAN.BENEFI'      ,'35'        , 'A', '')
    EB.Template.TableAddfielddefinition('XX-INT.BAN.RFC'      ,'13'        , 'A', '')
    EB.Template.TableAddfielddefinition('XX-INT.BAN.MAIL'      ,'30'        , 'A', '')
    EB.Template.TableAddfielddefinition('XX-INT.BAN.TEL.MOV'      ,'10'        , 'A', '')
    EB.Template.TableAddreservedfield("XX-RESERVED.I.1")
    EB.Template.TableAddreservedfield("XX>RESERVED.I.2")
    EB.Template.TableAddfielddefinition('NO.TOKEN'        ,'13'       , 'A', '')
    EB.Template.TableAddfielddefinition('RSA.USER'        ,'20'       , 'A', '')
    EB.Template.TableAddfielddefinition('SUCURSAL'        ,'5'       , '', '')
    EB.Template.FieldSetcheckfile("DEPT.ACCT.OFFICER":FM:ST.Config.DeptAcctOfficer.EbDaoName:FM:'A.')
    EB.Template.TableAddfielddefinition('TOKEN.NUEVO'        ,'13'       , 'A', '')
    EB.Template.TableAddoptionsfield('STATUS.TOKEN.NVO'          ,'ASIGNADO_CANCELADO', 'A', '')
    EB.Template.TableAddfield('XX<ID.ADMIN'   ,EB.Template.T24String, EB.Template.FieldNoInput, '')
    EB.Template.TableAddfielddefinition('XX-AP.PAT.ADMIN','35', 'ANY', '')
    EB.Template.TableAddfielddefinition('XX-AP.MAT.ADMIN','35', 'ANY', '')
    EB.Template.TableAddfielddefinition('XX-NOMBRE.ADMIN','40', 'ANY', '')
    EB.Template.TableAddoptionsfield('XX-STATUS.ADMIN','ACTIVO_INACTIVO', 'A', '')
    EB.Template.TableAddoptionsfield('XX-FACULTADES.ADMIN','A INDIVIDUAL_B MANCOMUNADO', 'A', '')
    EB.Template.TableAddfielddefinition('XX-TOKEN.ADMIN','13', 'A', '')
    EB.Template.TableAddfielddefinition('XX-EMAIL.ADMIN','70', 'ANY', '')
    EB.Template.TableAddfielddefinition('XX>CEL.ADMIN','10', 'A', '')
    EB.Template.TableAddoptionsfield('TIPO.CONTRATO','A INDIVIDUAL_B MANCOMUNADO', 'A', '')
    EB.Template.TableAddoptionsfield('TIPO.BANCA','BANCA PATRIMONIAL_BANCA EMPRESARIAL', 'A', '')
    EB.Template.TableAddoptionsfield('PREVENCION.FRAUDE','ON_OFF', 'A', '')
    EB.Template.TableAddfielddefinition('FECHA.PREV.FRAUDE'        ,'8'       , 'D', '')


    EB.Template.TableAddreservedfield('RESERVED.20')
    EB.Template.TableAddreservedfield('RESERVED.19')
    EB.Template.TableAddreservedfield('RESERVED.18')
    EB.Template.TableAddreservedfield('RESERVED.17')
    EB.Template.TableAddreservedfield('RESERVED.16')
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
*****************************************************************************

    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()
*****************************************************************************
END

