## User manual
***
> Oracle Set UP for MacOS
1. Установка **colima** через *homebrew*
```
brew install colima
```
2. Запуск **colima**
```
colima start --arch x86_64 --memory 4
```
3. Контейнеризация **Oracle** через *docker*
```
docker run -d -p 1521:1521 -e ORACLE_PASSWORD=<password> -v oracle-volume:/opt/oracle/oradata gvenzl/oracle-xe
```
4. Запуск *bash-терминала* контейнера
```
docker exec -it <container_name> bash
```
5. Запуск **SQL*plus**
```
sqlplus system/password@//localhost/XEPDB1
```
