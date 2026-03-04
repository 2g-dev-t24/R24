* @ValidationCode : MjotMTMzNzAzNjMyNzpDcDEyNTI6MTc2MDU3NzcyMTI2MjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Oct 2025 22:22:01
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
$PACKAGE AbcActivityLine
*-----------------------------------------------------------------------------
PROGRAM ABC.ACTIVITY.STMT
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    $USING EB.Utility
    $USING AC.EntryCreation
    $USING RE.Config
    $USING EB.Updates

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

PROCESS:
    SEL.CMD=''
    Y.LIST.CT=''
    Y.CNT.CT=''
    Y.ERROR=''
    R.STMT.ENTRY.KEY=''
    ERR.STMT.ENT.KEY=''
    R.ACCT.ENT.LWORK.DAY=''
    ERR.ACCT.ENT.LWORK.DAY=''
    R.STMT.ENTRY=''
    Y.ID.STMT.ENT=''
    SEL.CMD = 'SSELECT ':FN.ACCT.ENT.LWORK.DAY
    EB.DataAccess.Readlist(SEL.CMD,Y.LIST.CT,'',Y.CNT.CT,Y.ERROR)

    FOR Y.NO=1 TO Y.CNT.CT

        PRINT "PROCESS: ":Y.NO:" TO ":Y.CNT.CT
        Y.ID = Y.LIST.CT<Y.NO>

        EB.DataAccess.FRead(FN.ACCT.ENT.LWORK.DAY,Y.ID,R.ACCT.ENT.LWORK.DAY,F.ACCT.ENT.LWORK.DAY,ERR.ACCT.ENT.LWORK.DAY)
        IF R.ACCT.ENT.LWORK.DAY THEN
            PRINT R.ACCT.ENT.LWORK.DAY
            Y.NO.REG.ENT=DCOUNT(R.ACCT.ENT.LWORK.DAY,@FM)
            FOR Y.NO.REG=1 TO Y.NO.REG.ENT
                Y.ID.STMT.ENT=R.ACCT.ENT.LWORK.DAY<Y.NO.REG>
                READ Y.REC.STMT FROM F.STMT.ENTRY, Y.ID.STMT.ENT ELSE CONTINUE
                Y.BALANCE.LINE=''
                Y.SYSTEM.ID=''
                IF Y.REC.STMT THEN
                    Y.BALANCE.LINE= Y.REC.STMT<AC.EntryCreation.StmtEntry.SteLocalRef,STMT.BAL.LINE.POS>
                    Y.SYSTEM.ID=Y.REC.STMT<AC.EntryCreation.StmtEntry.SteSystemId>

                    IF Y.BALANCE.LINE EQ "" AND Y.SYSTEM.ID NE 'AAAA' THEN

                        PRINT Y.ID.STMT.ENT
                        Y.DESC=''
                        Y.CONSOL.KEY=Y.REC.STMT<AC.EntryCreation.StmtEntry.SteConsolKey>
                        Y.CATEG=FIELD(Y.CONSOL.KEY,".",5)
                        Y.PERS=FIELD(Y.CONSOL.KEY,".",6)
                        Y.SECTOR=FIELD(Y.CONSOL.KEY,".",7)

                        Y.CONSOL.KEY=Y.CATEG:"*":Y.PERS:"*":Y.SECTOR
                        FINDSTR Y.CONSOL.KEY IN Y.ARR.LINES SETTING Ap, Vp, Sp  THEN

                            Y.BALANCE.LINE=Y.ARR.BALANCE<Ap>
                        END ELSE

                            SEL.CMD.LINE='';Y.LIST.LINE='';Y.CNT.LINE='';Y.ERR.LINE='';
                            Y.LIST.LINE='';LINE.REC='';F.ERR.LINE='';Y.DESC=''
                            IF Y.SECTOR EQ "" THEN
                                SEL.CMD.LINE = 'SSELECT ':FN.LINE:' WITH ASSET1 EQ ':Y.CATEG
                            END ELSE
                                SEL.CMD.LINE = 'SSELECT ':FN.LINE:' WITH ASSET1 EQ ':Y.CATEG:' AND ASSET3 EQ ':Y.SECTOR
                            END
                            EB.DataAccess.Readlist(SEL.CMD.LINE,Y.LIST.LINE,'',Y.CNT.LINE,Y.ERR.LINE)
                            IF Y.CNT.LINE EQ 0 THEN
                                SEL.CMD.LINE = 'SSELECT ':FN.LINE:' WITH ASSET1 EQ ':Y.CATEG
                                EB.DataAccess.Readlist(SEL.CMD.LINE,Y.LIST.LINE,'',Y.CNT.LINE,Y.ERR.LINE)
                            END


                        END
                        EB.DataAccess.FRead(FN.LINE,Y.LIST.LINE,LINE.REC,F.LINE,F.ERR.LINE)

                        IF Y.BALANCE.LINE EQ '' THEN
                            Y.DESC.LINE = LINE.REC<RE.Config.StatRepLine.SrlDesc,1,1>
                            Y.DESC = Y.DESC.LINE<1,1>
                            Y.BALANCE.LINE=Y.DESC
                            Y.ARR.BALANCE<-1>=Y.DESC
                            Y.ARR.LINES<-1>=Y.CONSOL.KEY
                        END


                        IF Y.REC.STMT<AC.EntryCreation.StmtEntry.SteAmountLcy> LT 0 THEN
                            Y.REC.STMT<AC.EntryCreation.StmtEntry.SteLocalRef,STMT.DEBIT.POS>= 'D'
                            Y.DEBIT.CREDIT=Y.REC.STMT<AC.EntryCreation.StmtEntry.SteLocalRef,STMT.DEBIT.POS>
                        END ELSE
                            Y.REC.STMT<AC.EntryCreation.StmtEntry.SteLocalRef,STMT.DEBIT.POS>= 'C'
                            Y.DEBIT.CREDIT=Y.REC.STMT<AC.EntryCreation.StmtEntry.SteLocalRef,STMT.DEBIT.POS>
                        END
                        Y.REC.STMT<AC.EntryCreation.StmtEntry.SteLocalRef,STMT.BAL.LINE.POS>=Y.BALANCE.LINE

                        PRINT "WRITE: ":Y.NO.REG :" TO ":Y.NO.REG.ENT:" ":Y.ID.STMT.ENT:" ": Y.BALANCE.LINE:" ":Y.DEBIT.CREDIT
                        WRITE Y.REC.STMT TO F.STMT.ENTRY ,Y.ID.STMT.ENT ON ERROR
                            PRINT " ERROR WRITING IN":F.STMT.ENTRY:" ID: ":Y.ID.STMT.ENT
                        END

                    END ELSE
                        PRINT "REGISTRO TIENE BALANCE LINE"
                    END
                END
            NEXT Y.NO.REG



        END

    NEXT Y.NO

RETURN

OPEN.FILES:


    FN.RE.SPEC.ENT.LWORK.DAY='F.RE.SPEC.ENT.LWORK.DAY'
    F.RE.SPEC.ENT.LWORK.DAY=''
    EB.DataAccess.Opf(FN.RE.SPEC.ENT.LWORK.DAY, F.RE.SPEC.ENT.LWORK.DAY)

    FN.STMT.ENTRY= 'F.STMT.ENTRY'
    F.STMT.ENTRY=''
    EB.DataAccess.Opf(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.ACCT.ENT.LWORK.DAY='F.ACCT.ENT.LWORK.DAY'
    F.ACCT.ENT.LWORK.DAY=''
    EB.DataAccess.Opf(FN.ACCT.ENT.LWORK.DAY,F.ACCT.ENT.LWORK.DAY)

    FN.STMT.ENTRY.KEY= 'F.RE.CONSOL.STMT.ENT.KEY'
    F.STMT.ENTRY.KEY= ''
    EB.DataAccess.Opf(FN.STMT.ENTRY.KEY,F.STMT.ENTRY.KEY)

    FN.LINE='F.RE.STAT.REP.LINE'
    F.LINE=''
    EB.DataAccess.Opf(FN.LINE,F.LINE)


    Y.APP="STMT.ENTRY"
    Y.FLD = "BALANCE.LINE":@VM:"DEBIT.CREDIT"
    EB.Updates.MultiGetLocRef(Y.APP,Y.FLD,Y.POS.ALL)
    STMT.BAL.LINE.POS   = Y.POS.ALL<1,1>
    STMT.DEBIT.POS      = Y.POS.ALL<1,2>
RETURN
END
