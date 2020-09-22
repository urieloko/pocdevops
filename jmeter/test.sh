rootPath=$1
testFile=$2
host=$3
idReporte=$4
fqdnContenedor="https://resulttests.blob.core.windows.net/%24web"
sasContenedor="sv=2019-10-10&st=2020-09-20T18%3A38%3A00Z&se=2020-12-31T19%3A38%3A00Z&sr=c&sp=rwl&sig=PA9SPfvV5HeCaSEMR6NL4HCfw%2FWNU%2Fkq5DJVr1DfpS4%3D"

echo "======================== PARAMETROS ========================"
echo "Root path: $rootPath"
echo "Test file: $testFile"
echo "Host: $host"
echo "Nombre reporte: $idReporte"

# echo "Permisos para archivo $rootPath/run.sh"
# chmod +x $rootPath/run.sh

T_DIR=.

# Reporting dir: start fresh
R_DIR=$T_DIR/report
rm -rf $R_DIR > /dev/null 2>&1
mkdir -p $R_DIR

rm -f $T_DIR/test-plan.jtl $T_DIR/jmeter.log  > /dev/null 2>&1

./run.sh $rootPath -Dlog_level.jmeter=DEBUG \
	-Jhost=$host \
	-n -t /test/$testFile -l $T_DIR/test-plan.jtl -j $T_DIR/jmeter.log \
	-e -o $R_DIR

echo "==== LS de $R_DIR ===="
ls -l $R_DIR

echo "==== LS de $T_DIR ===="
ls -l $T_DIR

# echo "==== jmeter.log ===="
# cat $T_DIR/jmeter.log

# echo "==== Raw Test Report ===="
# cat $T_DIR/test-plan.jtl

echo "==== HTML Test Report ===="
echo "See HTML test report in $R_DIR/index.html"

echo "===================== Descarga de AzCopy"
wget -O azcopy.tar.gz https://aka.ms/downloadazcopy-v10-linux && tar -xf azcopy.tar.gz --strip-components=1
echo "===================== Descarga de Index"
./azcopy copy "$fqdnContenedor/index.html?$sasContenedor" "./index.html"
echo "===================== Carga de reporte a $fqdnContenedor/rep/$idReporte"
./azcopy copy "./report" "$fqdnContenedor/rep/$idReporte?$sasContenedor" --recursive=true
liReporte="<li><a href='rep/$idReporte/report/index.html'>Build $idReporte</a></li>"
echo "===================== Actualizando Index con $liReporte"
echo "$liReporte" >> ./index.html
echo "===================== Carga de Index"
./azcopy copy "./index.html" "$fqdnContenedor/index.html?$sasContenedor" --recursive=true