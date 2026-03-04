* @ValidationCode : MjoxNjM0MDU2MDM4OkNwMTI1MjoxNzYwNTc2MzAyMDY1Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Oct 2025 21:58:22
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
PROGRAM ABC.ACTIVITY
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    $USING EB.Utility
    $USING AC.EntryCreation
    $USING RE.Config
    $USING EB.Updates

    Y.ID=''
    Y.ENT=''
    R.CATEG.ENT.ACTIVITY=''
    ERR.CATEG.ENT=''
    Y.DATES.LWKDAY=''
    Y.NO.REG.ENT=''
    CATEG.BAL.LINE.POS=''
    CATEG.DEBIT.POS=''
    Y.POS.ALL=''
    Y.APP=''
    Y.FLD=''
    Y.DATES.LWKDAY= EB.SystemTables.getRDates(EB.Utility.Dates.DatLastWorkingDay)


    FN.CATEG.ENT.ACTIVITY = 'F.CATEG.ENT.ACTIVITY'
    F.CATEG.ENT.ACTIVITY = ''
    EB.DataAccess.Opf(FN.CATEG.ENT.ACTIVITY, F.CATEG.ENT.ACTIVITY)

    FN.CATEG.ENTRY= 'F.CATEG.ENTRY'
    F.CATEG.ENTRY=''
    EB.DataAccess.Opf(FN.CATEG.ENTRY,F.CATEG.ENTRY)

    FN.LINE='F.RE.STAT.REP.LINE'
    F.LINE=''
    EB.DataAccess.Opf(FN.LINE,F.LINE)

    Y.APP = "CATEG.ENTRY"
    Y.FLD = "BALANCE.LINE":@VM:"DEBIT.CREDIT"
    EB.Updates.MultiGetLocRef(Y.APP,Y.FLD,Y.POS.ALL)
    CATEG.BAL.LINE.POS   = Y.POS.ALL<1,1>
    CATEG.DEBIT.POS      = Y.POS.ALL<1,2>
    Y.ARR.LINES=""
    Y.ARR.BALANCE=''

    SEL.CMD = ''; Y.LIST.CT = ''; Y.CNT.CT = ''; Y.ERROR = ''; Y.LIST = ''; Y.CNT = ''; Y.CAT.IDS = '';
    SEL.CMD = 'SSELECT ':FN.CATEG.ENT.ACTIVITY:' WITH @ID LIKE ':DQUOTE('...':SQUOTE(Y.DATES.LWKDAY):'...'):' BY @ID'
    EB.DataAccess.Readlist(SEL.CMD,Y.LIST.CT,'',Y.CNT.CT,Y.ERROR)

    FOR Y.NO=1 TO Y.CNT.CT

        PRINT "PROCESS: ":Y.NO:" TO ":Y.CNT.CT

        Y.ID = Y.LIST.CT<Y.NO>
        EB.DataAccess.FRead(FN.CATEG.ENT.ACTIVITY,Y.ID,R.CATEG.ENT.ACTIVITY,F.CATEG.ENT.ACTIVITY,ERR.CATEG.ENT)
        IF R.CATEG.ENT.ACTIVITY THEN
            Y.NO.REG.ENT=DCOUNT(R.CATEG.ENT.ACTIVITY,@FM)
            FOR Y.NO.REG=1 TO Y.NO.REG.ENT

                Y.ID.CATEG.ENT=R.CATEG.ENT.ACTIVITY<Y.NO.REG>
                EB.DataAccess.FRead(FN.CATEG.ENTRY, Y.ID.CATEG.ENT, Y.REC.CATEG, F.CATEG.ENTRY, Y.ERR.CATEG.ENTRY)
                Y.BALANCE.LINE=''
                IF Y.REC.CATEG THEN
                    Y.BALANCE.LINE= Y.REC.CATEG<AC.EntryCreation.CategEntry.CatLocalRef,CATEG.BAL.LINE.POS>

                    IF Y.BALANCE.LINE EQ "" THEN
                        Y.DESC=''

                        Y.CONSOL.KEY=Y.REC.CATEG<AC.EntryCreation.CategEntry.CatConsolKey>
                        Y.CATEG.PL=FIELD(Y.CONSOL.KEY,".",2)
                        Y.CATEG=FIELD(Y.CONSOL.KEY,".",3)
                        Y.PERS=FIELD(Y.CONSOL.KEY,".",5)
                        Y.TERM=FIELD(Y.CONSOL.KEY,".",8)
                        Y.CONSOL.KEY=Y.CATEG.PL:"*":Y.CATEG:"*":Y.PERS:"*":Y.TERM
                        FINDSTR Y.CONSOL.KEY IN Y.ARR.LINES SETTING Ap, Vp, Sp  THEN

                            Y.BALANCE.LINE=Y.ARR.BALANCE<Ap>
                        END ELSE

                            SEL.CMD.LINE='';Y.LIST.LINE='';Y.CNT.LINE='';Y.ERR.LINE='';
                            Y.LIST.LINE='';LINE.REC='';F.ERR.LINE='';Y.DESC=''
                            IF Y.TERM EQ "" THEN
                                SEL.CMD.LINE = 'SSELECT ':FN.LINE:' WITH PROFIT1 EQ ':Y.CATEG.PL:' AND PROFIT2 EQ ':Y.CATEG:' AND PROFIT4 EQ ':Y.PERS
                            END ELSE
                                SEL.CMD.LINE = 'SSELECT ':FN.LINE:' WITH PROFIT1 EQ ':Y.CATEG.PL:' AND PROFIT2 EQ ':Y.CATEG:' AND PROFIT4 EQ ':Y.PERS:' AND PROFIT7 EQ ':Y.TERM
                            END
                            EB.DataAccess.Readlist(SEL.CMD.LINE,Y.LIST.LINE,'',Y.CNT.LINE,Y.ERR.LINE)
                            IF Y.CNT.LINE EQ 0 THEN
                                SEL.CMD.LINE = 'SSELECT ':FN.LINE:' WITH PROFIT1 EQ ':Y.CATEG.PL:' AND PROFIT2 EQ ':Y.CATEG:' AND PROFIT4 EQ ':Y.PERS
                                EB.DataAccess.Readlist(SEL.CMD.LINE,Y.LIST.LINE,'',Y.CNT.LINE,Y.ERR.LINE)
                            END
                            IF  Y.CNT.LINE EQ 0 THEN
                                SEL.CMD.LINE = 'SSELECT ':FN.LINE:' WITH PROFIT1 EQ ':Y.CATEG.PL:' AND PROFIT2 EQ ':Y.CATEG
                                EB.DataAccess.Readlist(SEL.CMD.LINE,Y.LIST.LINE,'',Y.CNT.LINE,Y.ERR.LINE)
                            END
                            IF  Y.CNT.LINE EQ 0 THEN
                                SEL.CMD.LINE = 'SSELECT ':FN.LINE:' WITH PROFIT1 EQ ':Y.CATEG.PL
                                EB.DataAccess.Readlist(SEL.CMD.LINE,Y.LIST.LINE,'',Y.CNT.LINE,Y.ERR.LINE)
                            END

                        END
                        EB.DataAccess.FRead(FN.LINE,Y.LIST.LINE,LINE.REC,F.LINE,F.ERR.LINE)

                        IF Y.BALANCE.LINE EQ '' THEN
                            Y.DESC=LINE.REC<RE.Config.StatRepLine.SrlDesc,1,1>
                            Y.BALANCE.LINE=Y.DESC
                            Y.ARR.BALANCE<-1>=Y.DESC
                            Y.ARR.LINES<-1>=Y.CONSOL.KEY
                        END


                        IF Y.REC.CATEG<AC.EntryCreation.CategEntry.CatAmountLcy> LT 0 THEN
                            Y.REC.CATEG<AC.EntryCreation.CategEntry.CatLocalRef,CATEG.DEBIT.POS> = 'D'
                        END ELSE
                            Y.REC.CATEG<AC.EntryCreation.CategEntry.CatLocalRef,CATEG.DEBIT.POS> = 'C'
                        END
                        Y.REC.CATEG<AC.EntryCreation.CategEntry.CatLocalRef,CATEG.BAL.LINE.POS>=Y.BALANCE.LINE

                        PRINT "WRITE: ":Y.NO.REG :" TO ":Y.NO.REG.ENT:" ":Y.ID.CATEG.ENT:" ": Y.BALANCE.LINE
                        WRITE Y.REC.CATEG TO F.CATEG.ENTRY ,Y.ID.CATEG.ENT ON ERROR

                            PRINT " ERROR WRITING IN":F.CATEG.ENTRY:" ID: ":Y.ID.CATEG.ENT
                        END
                    END ELSE
                        PRINT "REGISTRO TIENE BALANCE LINE"
                    END
                END ELSE
                    PRINT "NO SE PUDO LEER REGISTRO: ":Y.REC.CATEG
                END
            NEXT Y.NO.REG

        END
    NEXT Y.NO

END

