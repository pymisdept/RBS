C:
forfiles /p "C:\backup" /s /m *.* /D -7 /C "cmd /c del @path"

set today=%DATE:~-4%%DATE:~3,2%%DATE:~0,2%
cd "C:\Program Files\MariaDB 10.3\bin"
mariabackup --backup --user root --password rb920711 --databases="booked" --stream=xbstream > C:\backup\%today%_backup.xb
mysqldump -u root -prb920711 "booked" > C:\backup\%today%_backup.sql