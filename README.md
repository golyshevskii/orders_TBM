## User manual
***
> ! ��������� �� MacOS ! Oracle SetUP
1. ��������� **colima** ����� *homebrew*
```
brew install colima
```
2. ������ **colima**
```
colima start --arch x86_64 --memory 4
```
3. ��������������� **Oracle** ����� *docker*
```
docker run -d -p 1521:1521 -e ORACLE_PASSWORD=<password> -v oracle-volume:/opt/oracle/oradata gvenzl/oracle-xe
```
4. ������ *bash-���������* ����������
```
docker exec -it <container_name> bash
```
5. ������ **SQL*plus**
```
sqlplus system/password@//localhost/XEPDB1
```
