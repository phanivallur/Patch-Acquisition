REM Creation of URLs not added
set xml_custom_path="C:\Program Files (x86)\PSL\RCA\Data\PatchManager\patch\custom\applicationpatch"
set xml_novadigm_path="C:\Program Files (x86)\PSL\RCA\Data\PatchManager\patch\novadigm\applicationpatch"
set patchdir="C:\Program Files (x86)\PSL\RCA\PatchManager"
set logfile=%patchdir%\logs\april_patch-acquisition.log
set cmdline=nvdkit-rca-patch.exe modules\patch.tkd acquire -config etc\APSB_MAY.acq -logfile %logfile% -rcs_user admin -RCS_PASS secret

mkdir Logs
mkdir Input
mkdir Download
mkdir Output
mkdir Backup
perl.exe ./Script/URLCreator.pl
java -cp "support_latest.jar;jsoup-1.7.2.jar" com.radia.support.utilities.AdobePageParser
java -cp "support_latest.jar;jsoup-1.7.2.jar" com.radia.support.utilities.VersionSorting
java -cp "support_latest.jar;jsoup-1.7.2.jar" com.radia.support.utilities.CatalogDownloader
java -cp "support_latest.jar;jsoup-1.7.2.jar" com.radia.support.utilities.FileDownloader
cd ./Download
nvdkit ../Script/UpdateDownloader.tcl  "../Input/Adobe_Reader.txt"
nvdkit ../Script/UpdateDownloader.tcl  "../Input/Adobe_Reader.txt"
nvdkit ../Script/UpdateDownloader.tcl  "../Input/Adobe_Acrobat.txt"
nvdkit ../Script/UpdateDownloader.tcl  "../Input/Adobe_Acrobat.txt"
cd ..
REM nvdkit ./Script/AdobePageParser.tcl
nvdkit ./Script/VersionToURLMapper.tcl ./Input/AdobeBulletinInfo.xml
nvdkit ./Script/CatalogCreator.tcl ./Input/AdobeBulletinInfo.xml
cd Output
del /F adobecat.xml
ren "Adobe Catalog.xml" "adobecat_single_bulletin.xml"
cd ..
nvdkit ./Script/Comparator.tcl
cd Output
rem ren adobecat.xml adobecat_single_bulletin.xml
ren adobecat-old.xml adobecat.xml
echo "Catalog creation for new bulletin has been completed"

echo "Starting acquisition of latest bulletin"
copy adobecat.xml %xml_custom_path%
copy adobecat.xml %xml_novadigm_path%
java -jar AdobeBulletins.jar
cd %patchdir%
%cmdline%


 