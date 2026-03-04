#! /bin/bash
#Modificado por : Carlos Sandoval
# Fecha          : 19 Septiembre 2024
# Descripcion    : ABCCORE-2824 Reingenieria Saldos Operativos
# Script para generacion de archivo Account

pathTemp=$1
diaAnt=$2
otrFile=$3
ctaFile=$4


find "$pathTemp" -name ""$diaAnt"*Otros*" -exec cat {} ';' >>"$pathTemp"Otros.txt
sort -t',' -k 4.3 "$pathTemp"Otros.txt -o "$otrFile"
echo "CUENTA,NO. CLIENTE,SUCURSAL,NOMBRE DE CLIENTE,SALDO AL CORTE,SALDO RETENIDO,SALDO DISPONIBLE,SALDO PROMEDIO,INT. DEV. NO PAGADO O PAGADO AL FIN DE MES,TASA,FECHA APERTURA,FECHA ULTIMO MOVIMIENTO,EJECUTIVO,PRODUCTO,TIPO CLIENTE,RFC,ESTATUS DE LA CUENTA,NUMERO DE TARJETA TITULAR,NUMERO DE TARJETA ADICIONAL,BANCA ELECTRONICA,NUMERO DE PRESONAS FACULTADAS,NIVEL DE CUENTA,PROM. ENLACE">"$ctaFile"
find "$pathTemp" -name ""$diaAnt"*Cuentas004*" -exec cat {} ';' >>"$pathTemp"Cuentas.004.txt
sort -t',' -k1 "$pathTemp"Cuentas.004.txt -o "$pathTemp"Cuentas.004.txt
cat "$pathTemp"Cuentas.004.txt >> "$ctaFile"
awk -F',' 'BEGIN {OFMT = "%.2f"} {saldo+=$5;} END {printf "\n""TOTAL CUENTA AHORRO,,,,%.2f,,,,,,,,\n""\n",saldo }' "$pathTemp"Cuentas.004.txt >>"$ctaFile"
find "$pathTemp" -name ""$diaAnt"*Cuentas005*" -exec cat {} ';' >>"$pathTemp"Cuentas.005.txt
sort -t',' -k1 "$pathTemp"Cuentas.005.txt -o "$pathTemp"Cuentas.005.txt
cat "$pathTemp"Cuentas.005.txt >> "$ctaFile"
awk -F',' 'BEGIN {OFMT = "%.2f"} {saldo+=$5;} END {printf "\n""TOTAL CUENTA DE CHEQUES SIN CHEQUERA,,,,%.2f,,,,,,,,\n""\n",saldo }' "$pathTemp"Cuentas.005.txt >>"$ctaFile"
find "$pathTemp" -name ""$diaAnt"*Cuentas006*" -exec cat {} ';' >>"$pathTemp"Cuentas.006.txt
sort -t',' -k1 "$pathTemp"Cuentas.006.txt -o "$pathTemp"Cuentas.006.txt
cat "$pathTemp"Cuentas.006.txt >> "$ctaFile"
awk -F',' 'BEGIN {OFMT = "%.2f"} {saldo+=$5;} END {printf "\n""TOTAL CUENTA DE CHEQUES CON CHEQUERA,,,,%.2f,,,,,,,,\n""\n",saldo }' "$pathTemp"Cuentas.006.txt >>"$ctaFile"
