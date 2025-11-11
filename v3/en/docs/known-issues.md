# Known Issues

| date | category | content | status |
|:--|:--|:--|:--|
| 2025/10/29 | Job | In the output of qrstat, the last part of each reservation ID is missing for the second and subsequent reservations.<br>$ qrstat R1234567 R1234568<br>Resv ID            Queue         User     State             Start / Duration / End<br>-------------------------------------------------------------------------------<br>R1234567.pbs1      R1234567         usrname  RN            Wed 10:40 / 1506000 / Sat Feb 01 21:00<br>R1234568.p         R1234568         usrname  RN            Wed 10:50 / 1506000 / Sat Feb 01 22:00 | 2025/10/29<br>Fix in progress |
