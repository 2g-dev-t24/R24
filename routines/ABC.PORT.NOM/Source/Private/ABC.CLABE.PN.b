* @ValidationCode : MjotODAyMjAzNTUyOkNwMTI1MjoxNzU4ODQwNzcyMzU4Om1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Sep 2025 19:52:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcPortNom
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.CLABE.PN
* ======================================================================
* Nombre de Programa : ABC.CLABE.PN
* Parametros         :
* Objetivo           : REGRESA LA CUENTA CLABE
* Desarrollador      : SANDRA FIGUEROA ESQUIVEL
* Compania           : ABC
* Fecha Creacion     : 2016/09/23
* Modificaciones     :
* ======================================================================

    $USING EB.SystemTables
    $USING AbcTable
    $USING AbcSpei
    $USING EB.ErrorProcessing
    $USING EB.DataAccess
    $USING AC.AccountOpening

    GOSUB INIT
    GOSUB WRITE.FIELDS
RETURN

INIT:

    Y.ACC= EB.SystemTables.getComi()
    R.ACC=''
    ERR.ACC=''
    Y.CLABE=''
    Y.CUS=''
    
    Y.CUS=EB.SystemTables.getRNew(AbcTable.AbcPortabilidadNomina.NoCliente)
    Y.ACC=FMT(Y.ACC,"R%11")
    Y.NIVEL =''

    AbcSpei.AbcValPostRest(Y.ACC)

    ERR.READ      = ''
    R.ACCT        = ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    EB.DataAccess.FRead(FN.ACCOUNT, Y.ACC, R.ACCT, F.ACCOUNT, ERR.READ) 

    IF NOT(ERR.READ) THEN
        
        Y.ARR = R.ACCT<AC.AccountOpening.Account.ArrangementId>

        IF Y.CUS EQ R.ACCT<AC.AccountOpening.Account.Customer> THEN
            Y.CLABE                 = ""
            LOCATE "CLABE" IN R.ACCT<AC.AccountOpening.Account.AltAcctType,1> SETTING Y.TYPE.POS THEN
                Y.CLABE = R.ACCT<AC.AccountOpening.Account.AltAcctId,Y.TYPE.POS>
            END
            Y.ACCOUNT.CATEGORY      = R.ACCT<AC.AccountOpening.Account.Category>
            Y.ABC.GENERAL.PARAM.ID  = "ABC.NIVEL.CUENTAS"
            R.ABC.GENERAL.PARAM     = ""
            Y.ABC.GENERAL.PARAM.ERR = ""
                
            FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
            F.ABC.GENERAL.PARAM = ''
            EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM)

            EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.ABC.GENERAL.PARAM.ID, R.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM, Y.ABC.GENERAL.PARAM.ERR)
                
            Y.LIST.PARAMS           = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.NombParametro>)
            Y.LIST.VALUES           = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.DatoParametro>)
                
            Y.NO.VALORES            = DCOUNT(Y.LIST.PARAMS,@FM)
            Y.NIVEL                 = ""
            FOR Y.AA=1 TO Y.NO.VALORES
                Y.PARAM     = Y.LIST.PARAMS<Y.AA>
                Y.CATEGORIA = Y.LIST.VALUES<Y.AA>
                CHANGE '|' TO @FM IN Y.CATEGORIA
                LOCATE Y.ACCOUNT.CATEGORY IN Y.CATEGORIA<1> SETTING Y.POS THEN
                    Y.NIVEL = Y.PARAM
                END
            NEXT Y.AA

            IF Y.NIVEL EQ 'NIVEL.1' OR Y.NIVEL EQ 'NIVEL.2' OR Y.NIVEL EQ 'NIVEL.3' THEN
                E='FUNCIONALIDAD NO PERMITIDA PARA EL NIVEL DE LA CUENTA'
                EB.SystemTables.setE(E)
                EB.ErrorProcessing.Err()
            END
        END ELSE
            E='LA CUENTA NO PERTENECE AL CLIENTE'
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.Err()
        END
    END ELSE
        E='LA CUENTA NO EXISTE'
        EB.SystemTables.setE(E)
        EB.ErrorProcessing.Err()
    END

RETURN

WRITE.FIELDS:
    EB.SystemTables.setRNew(AbcTable.AbcPortabilidadNomina.Clabe, Y.CLABE)
RETURN
END
