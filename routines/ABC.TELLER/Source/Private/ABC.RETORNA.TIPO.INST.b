* @ValidationCode : MjotMTk2NDg4MTA5MDpDcDEyNTI6MTc1NzM4MTIyNjU0MTpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Sep 2025 22:27:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

$PACKAGE AbcTeller

SUBROUTINE ABC.RETORNA.TIPO.INST(IN.CLABE, OUT.TIPO.INST)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display

    $USING AbcTable
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    FN.ABC.BANCOS   = "F.ABC.BANCOS"
    F.ABC.BANCOS    = ""
    EB.DataAccess.Opf(FN.ABC.BANCOS,F.ABC.BANCOS)

    FN.ABC.GENERAL.PARAM    = "F.ABC.GENERAL.PARAM"
    F.ABC.GENERAL.PARAM     = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.ID.GEN.PARAM      = "ABC.INSTITUCIONES"
    R.ABC.GENERAL.PARAM = ''
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,Y.ID.GEN.PARAM,R.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM,F.ERROR)
    
    IF R.ABC.GENERAL.PARAM THEN
        LISTA.TIPO = R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.DatoParametro>
        CONVERT @VM TO @FM IN LISTA.TIPO
        NUM.LISTA.TIPO = DCOUNT(LISTA.TIPO,@FM)
        FOR CT = 1 TO NUM.LISTA.TIPO
            Y.TIPO.INST     = LISTA.TIPO<CT>
            Y.BANCO         = Y.TIPO.INST:IN.CLABE[1,3]
            R.ABC.BANCOS    = ''
            EB.DataAccess.FRead(FN.ABC.BANCOS,Y.BANCO,R.ABC.BANCOS,F.ABC.BANCOS,F.ERROR.ABC.BANCOS)
            IF R.ABC.BANCOS THEN
                OUT.TIPO.INST = Y.TIPO.INST
                BREAK
            END
        NEXT CT
    END ELSE
        OUT.TIPO.INST = "40"
    END
    
RETURN
*-----------------------------------------------------------------------------
END