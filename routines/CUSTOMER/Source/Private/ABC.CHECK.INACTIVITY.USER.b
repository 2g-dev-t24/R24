*-----------------------------------------------------------------------------
* <Rating>630</Rating>
*=============================================================================
* Nombre de Programa:   ABC.CHECK.INACTIVITY.USER
* Objetivo:
* Desarrollador:        
* Compania:             
* Fecha Creacion:       
* Modificaciones:
*==============================================================================
$PACKAGE ABC.BP
    SUBROUTINE ABC.CHECK.INACTIVITY.USER

    $USING EB.SystemTables
    $USING EB.Versions
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.Security
    $USING ST.Config
    $USING EB.Updates
    $USING AbcSpei
    $USING AbcGetGeneralParam
    $USING EB.API
    $USING AbcTable
    $USING EB.Foundation
    $USING EB.Interface
    $USING EB.TransactionControl
    
    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY
    RETURN

****************
INITIALIZE:
****************


    FN.USER ='F.USER'
    F.USER=''
    EB.DataAccess.Opf(FN.USER,F.USER)

    FN.DEPT.ACCT.OFFICER = 'F.DEPT.ACCT.OFFICER'
    F.DEPT.ACCT.OFFICER = ''
    EB.DataAccess.Opf(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)
    
    FN.ABC.PARAM.DAYS.INACTIVITY.LOG = 'F.ABC.PARAM.DAYS.INACTIVITY.LOG'
    F.ABC.PARAM.DAYS.INACTIVITY.LOG  = ''
    EB.DataAccess.Opf(FN.ABC.PARAM.DAYS.INACTIVITY.LOG,F.ABC.PARAM.DAYS.INACTIVITY.LOG)



    EB.Updates.MultiGetLocRef("USER","ESTATUS", POS.NO.ESTATUS)

    Y.MODULO.DAYS    = "DAYS.INAC"
    Y.SEPARADOR = "#"

    Y.CAMPOS.DAYS = "DAYS.INAC" : Y.SEPARADOR
    Y.CAMPOS.DAYS:= "VER.USER"  : Y.SEPARADOR
    Y.CAMPOS.DAYS:= "VER.LOG"   : Y.SEPARADOR
    Y.CAMPOS.DAYS:= "OFS.SOURCE": Y.SEPARADOR

    AbcSpei.AbcTraeGeneralParam(Y.MODULO.DAYS, Y.CAMPOS.DAYS, Y.DATOS.DAYS)

    Y.LIMITE.INACTIVIDAD = FIELD(Y.DATOS.DAYS,Y.SEPARADOR,1)
    Y.VER.USER = FIELD(Y.DATOS.DAYS,Y.SEPARADOR,2)
    Y.OFS.APLICACION = FIELD(Y.VER.USER,',',1)
    Y.VER.LOG = FIELD(Y.DATOS.DAYS,Y.SEPARADOR,3)
    Y.OFS.APLICACION.LOG = FIELD(Y.VER.LOG,',',1)
    Y.OFS.SOURCE=FIELD(Y.DATOS.DAYS,Y.SEPARADOR,4)


    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.LIST.USRS.EXCLUDED = ''
    Y.DEPT.CODE.EXCLUDED = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.MODULO.DAYS, Y.LIST.PARAMS, Y.LIST.VALUES)

    Y.TOTAL.PARAMS = DCOUNT(Y.LIST.PARAMS, @FM)
    FOR Y.IT.PARAMS = 1 TO Y.TOTAL.PARAMS
        Y.PARAM = ''
        Y.PARAM = Y.LIST.PARAMS<Y.IT.PARAMS>
        IF Y.PARAM EQ "USERS.EXCL" THEN
            Y.LIST.USRS.EXCLUDED := Y.LIST.VALUES<Y.IT.PARAMS> : '|'
        END
    NEXT Y.IT.PARAMS
    CHANGE '|' TO @VM IN Y.LIST.USRS.EXCLUDED

    LOCATE "DEPT.CODE.EXCL" IN Y.LIST.PARAMS SETTING Y.POS.DEPT THEN
        Y.DEPT.CODE.EXCLUDED = Y.LIST.VALUES<Y.POS.DEPT>
    END
    CHANGE '|' TO @VM IN Y.DEPT.CODE.EXCLUDED


    OFFUNCT = 'I'
    Y.PROCESS = 'PROCESS'
    Y.LAST.SIGN.ON = ''
    TOTAL.USUARIOS=''
    Y.FECHA = EB.SystemTables.getToday()
    Y.STATUS=''

    RETURN

****************
PROCESS:
****************

    SEL.CMD = 'SELECT ':FN.USER: ' BY @ID'
    EB.DataAccess.Readlist(SEL.CMD,ID.LIST,'',REC.NO,ERR.SEL)

    TOTAL.USUARIOS = DCOUNT(ID.LIST,@FM)
    FOR I = 1 TO TOTAL.USUARIOS

        ID.USUARIO = ''
        NO.DAYS = ''
        ID.USUARIO= ID.LIST<I>

        IF ID.USUARIO EQ '' THEN CONTINUE

        IF ID.USUARIO MATCHES Y.LIST.USRS.EXCLUDED THEN CONTINUE  

        EB.DataAccess.FRead(FN.USER,ID.USUARIO,R.USER,F.USER,ERR.USER)

        Y.START.DATE.PROFILE = R.USER<EB.Security.User.UseStartDateProfile>
        Y.LAST.SIGN.ON = R.USER<EB.Security.User.UseDateLastSignOn>
        Y.END.DATE.PROFILE = R.USER<EB.Security.User.UseEndDateProfile>
        Y.DEPT.CODE = R.USER<EB.Security.User.UseDepartmentCode>
        Y.STATUS = R.USER<EB.Security.User.UseLocalRef,POS.NO.ESTATUS>
        Y.STATUS = FIELD(Y.STATUS, @VM,1)

        IF Y.DEPT.CODE MATCHES Y.DEPT.CODE.EXCLUDED THEN CONTINUE 

        IF Y.END.DATE.PROFILE LT Y.FECHA THEN

            IF Y.STATUS NE 'INACTIVO' THEN
                EB.DataAccess.FRead(FN.DEPT.ACCT.OFFICER,Y.DEPT.CODE,R.DEPT.CODE,F.DEPT.ACCT.OFFICER,ERR.DAO)
                IF R.DEPT.CODE EQ '' THEN
                    NEW.DEPT.CODE = SUBSTRINGS(Y.DEPT.CODE,0,5)
                    Y.RECORD<EB.Security.User.UseDepartmentCode>=NEW.DEPT.CODE
                END
                Y.RECORD.LOG<AbcTable.AbcParamDaysInactivityLog.NoDays>="BAJA"
                ID.LOG=ID.USUARIO:'.':Y.END.DATE.PROFILE
                Y.RECORD.LOG<AbcTable.AbcParamDaysInactivityLog.FechaProceso>=Y.END.DATE.PROFILE
                GOSUB ARMA.OFS
            END
        END ELSE

            IF Y.LAST.SIGN.ON NE '' THEN
                EB.API.Cdd('',Y.LAST.SIGN.ON,Y.FECHA,NO.DAYS)
            END ELSE
                EB.API.Cdd('',Y.START.DATE.PROFILE,Y.FECHA,NO.DAYS)
            END

            IF NO.DAYS GT Y.LIMITE.INACTIVIDAD THEN
                IF Y.STATUS NE 'INACTIVO' THEN
                    IF ID.USUARIO NE '' THEN
                        Y.RECORD<EB.Security.User.UseStartDateProfile>=Y.FECHA
                        ID.LOG=ID.USUARIO:'.':Y.FECHA
                        Y.RECORD.LOG<AbcTable.AbcParamDaysInactivityLog.FechaProceso>=Y.FECHA
                        Y.RECORD.LOG<AbcTable.AbcParamDaysInactivityLog.NoDays>=NO.DAYS
                        GOSUB ARMA.OFS
                    END
                END
            END
        END
    NEXT I
    RETURN

ARMA.OFS:

    Y.RECORD<EB.Security.User.UseLocalRef,POS.NO.ESTATUS>="INACTIVO"
    EB.Foundation.OfsBuildRecord(Y.OFS.APLICACION,OFFUNCT,Y.PROCESS,Y.VER.USER,GTSMODE,NO.OF.AUTH,ID.USUARIO,Y.RECORD,Y.OFS.MSG)
    EB.Interface.OfsPostMessage(Y.OFS.MSG,OFS.MSG.ID,Y.OFS.SOURCE,Y.OFS.OPTIONS)

    EB.TransactionControl.JournalUpdate('')

    Y.RECORD.LOG<AbcTable.AbcParamDaysInactivityLog.Usuario>=ID.USUARIO

    EB.Foundation.OfsBuildRecord(Y.OFS.APLICACION.LOG,OFFUNCT,Y.PROCESS,Y.VER.LOG,GTSMODE,NO.OF.AUTH,ID.LOG,Y.RECORD.LOG,Y.OFS.MSG.LOG)

    EB.Interface.OfsPostMessage(Y.OFS.MSG.LOG,OFS.MSG.ID.LOG,Y.OFS.SOURCE,Y.OFS.OPTIONS.LOG)
    EB.TransactionControl.JournalUpdate('')

    RETURN

****************
FINALLY:
****************
    RETURN

END
