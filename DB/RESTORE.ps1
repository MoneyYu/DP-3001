docker exec -it mssql2022 mkdir /var/opt/mssql/backup

docker cp AdventureWorksLT2019.bak mssql2022:/var/opt/mssql/backup

# docker exec -it mssql2022 /opt/mssql-tools18/bin/sqlcmd -S localhost `
#    -U SA -P 'P@ssw0rd' -C `
#    -Q 'RESTORE FILELISTONLY FROM DISK = "/var/opt/mssql/backup/AdventureWorksLT2019.bak"' 

# docker exec -it mssql2022 /opt/mssql-tools18/bin/sqlcmd -S localhost `
#    -U SA -P 'P@ssw0rd' -C `
#    -Q "RESTORE DATABASE [AdventureWorksLT2019] FROM DISK = N'/var/opt/mssql/backup/AdventureWorksLT2019.bak' WITH FILE = 1, NOUNLOAD, REPLACE, NORECOVERY, STATS = 5"



# docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd \
#    -S localhost -U SA -P '<YourNewStrong!Passw0rd>' \
#    -Q 'RESTORE DATABASE AdventureWorksLT2019 FROM DISK = "/var/opt/mssql/backup/AdventureWorksLT2019.bak" WITH MOVE "WWI_Primary" TO "/var/opt/mssql/data/WideWorldImporters.mdf", MOVE "WWI_UserData" TO "/var/opt/mssql/data/WideWorldImporters_userdata.ndf", MOVE "WWI_Log" TO "/var/opt/mssql/data/WideWorldImporters.ldf", MOVE "WWI_InMemory_Data_1" TO "/var/opt/mssql/data/WideWorldImporters_InMemory_Data_1"'