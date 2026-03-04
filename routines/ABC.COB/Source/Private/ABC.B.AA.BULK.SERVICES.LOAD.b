* @ValidationCode : Mjo3MjcxODQxOTQ6Q3AxMjUyOjE3NjEzNTI1MjIzMjE6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Oct 2025 21:35:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcCob

SUBROUTINE ABC.B.AA.BULK.SERVICES.LOAD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*===============================================
* Nombre de Programa:   ABC.B.AA.BULK.SERVICES
* Objetivo:
* Desarrollador:        ISAIAS RODRIGUEZ - FYG Solutions
* Compania:             ABC CAPITAL
* Fecha Creacion:       2016-10-05
* Modificaciones:
*===============================================
*-----------------------------------------------------------------------------
    $USING EB.DataAccess

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

    FN.BULK.LOAD='F.ABC.AA.BULK.PROCESS.LIST'
    F.BULK.LOAD=''
    EB.DataAccess.Opf(FN.BULK.LOAD,F.BULK.LOAD)
    AbcCob.setFnBulkLoad(FN.BULK.LOAD)
    AbcCob.setFBulkLoad(F.BULK.LOAD)
    
    FN.ABC.AA.PRE.PROCESS$NAU ='F.ABC.AA.PRE.PROCESS$NAU'
    F.ABC.AA.PRE.PROCESS$NAU=''
    EB.DataAccess.Opf(FN.ABC.AA.PRE.PROCESS$NAU,F.ABC.AA.PRE.PROCESS$NAU)
    AbcCob.setFnAbcAAPreProcessNau(FN.ABC.AA.PRE.PROCESS$NAU)
    AbcCob.setFAbcAAPreProcessNau(F.ABC.AA.PRE.PROCESS$NAU)

    FN.ABC.AA.BULK.AUTHORISE = 'F.ABC.AA.BULK.AUTHORISE'
    F.ABC.AA.BULK.AUTHORISE = ''
    EB.DataAccess.Opf(FN.ABC.AA.BULK.AUTHORISE,F.ABC.AA.BULK.AUTHORISE)
    AbcCob.setFnAbcAaBulkAuthorise(FN.ABC.AA.BULK.AUTHORISE)
    AbcCob.setFAbcAaBulkAuthorise(F.ABC.AA.BULK.AUTHORISE)
    
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
RETURN

*-----------------------------------------------------------------------------
FINALLY:
*-----------------------------------------------------------------------------
RETURN

END

