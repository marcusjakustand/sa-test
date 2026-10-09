Arvestustöö raport
Nimi: Marcus Jakustand
Variant: A
Kuupäev: 09.10.2026

Kirjelda vähemalt 6 leitud probleemi.

Probleem 1
- Skript: scripts/system_info.sh
- Mida skript näiliselt tegi: Kuvas süsteemi nime ja praegust kasutajat.
- Mis oli tegelikult vale: Koodis olid käsuga väljad vahetuses: Hostname kohal oli `whoami` ja Kasutaja kohal `hostname`[cite: 6].
- Kuidas vea avastasin: Vaatasin skripti väljundit, kasutajanime kohal kuvas arvuti nime ja vastupidi[cite: 6].
- Millise käsuga kontrollisin: `whoami` ja `hostname`
- Parandus: Vahetasin käsud õigetesse kohtadesse: `echo "Hostname: $(hostname)"` ja `echo "Kasutaja: $(whoami)"`.
- Kuidas kontrollisin pärast parandust: Käivitasin `./scripts/system_info.sh` uuesti ja kontrollisin teksti.
- Vajadusel exit code enne / pärast: 0 / 0

Probleem 2
- Skript: scripts/system_info.sh
- Mida skript näiliselt tegi: Kuvas süsteemi kogu mälumahtu (RAM).
- Mis oli tegelikult vale: Skript luges `free -m` väljundist `/Swap:/` rida ehk kuvas vahemälu mahtu, mitte RAM-i[cite: 6].
- Kuidas vea avastasin: Kuvatud mälumaht ei klappinud süsteemi tegeliku RAM-i mahtuvusega[cite: 6].
- Millise käsuga kontrollisin: `free -m`
- Parandus: Muutsin koodis otsingu `/Mem:/` rida lugema.
- Kuidas kontrollisin pärast parandust: Käivitasin skripti uuesti ja võrdlesin `free -m` väljundiga.

Probleem 3
- Skript: scripts/user_check.sh
- Mida skript näiliselt tegi: Kontrollis kasutaja olemasolu süsteemis.
- Mis oli tegelikult vale: Otsis kasutajat `/etc/group` failist ja kontroll `[ "$matches" -ge 0 ]` oli alati tõene, sest `grep -c` annab tulemuseks alati 0 või rohkem[cite: 7].
- Kuidas vea avastasin: Sisestasin olematu kasutajanime, aga skript väitis ikka, et kasutaja on olemas[cite: 7].
- Millise käsuga kontrollisin: `bash -x scripts/user_check.sh suvaline_nimi`
- Parandus: Asendasin loogika süsteemse käsuga: `id "$username" &>/dev/null`.
- Kuidas kontrollisin pärast parandust: Testisin olemasoleva kasutajaga (`root`) ja olematu nimega.

Probleem 4
- Skript: scripts/service_check.sh
- Mida skript näiliselt tegi: Kontrollis, kas teenus töötab.
- Mis oli tegelikult vale: Kasutas käsku `systemctl list-unit-files`, mis näitab ainult seda, kas teenuse fail on kettal olemas, mitte seda, kas teenus tegelikult töötab[cite: 5].
- Kuidas vea avastasin: Seiskasin teenuse handitsi, kuid skript väitis ikka, et see töötab[cite: 5].
- Millise käsuga kontrollisin: `systemctl status <teenus>`
- Parandus: Panin teenuse oleku kontrolliks käsu `systemctl is-active --quiet "$service"`.
- Kuidas kontrollisin pärast parandust: Proovisin töötava teenusega (`cron`) ja seiskasin selle katseks.

Probleem 5
- Skript: scripts/disk_check.sh
- Mida skript näiliselt tegi: Kontrollis kettakasutuse protsenti.
- Mis oli tegelikult vale: Luges `df -h /` väljundist 4. veergu (vaba ruumi maht) ning lõikas tähed ära, mis andis valesid arve (nt 15G vaba ruumi muutus arvuks 15)[cite: 4].
- Kuidas vea avastasin: Kettakasutuse arv oli täiesti vale võrreldes tegelikkusega[cite: 4].
- Millise käsuga kontrollisin: `df -Ph /`
- Parandus: Muutsin käsu lugema 5. veergu (kasutus %) ja eemaldasin protsendimärgi: `df -Ph / | awk 'NR==2 {print $5}' | tr -d '%'`.
- Kuidas kontrollisin pärast parandust: Käivitasin skripti ja võrdlesin käsu `df -Ph /` tegeliku väljundiga.

Probleem 6
- Skript: scripts/backup.sh
- Mida skript näiliselt tegi: Lõi failidest `.tar.gz` arhiivi.
- Mis oli tegelikult vale: Kirjutas `find` käsu väljundi tekstina `.tar.gz` nimega faili sisse (tegi tavalise tekstifaili, mitte pakitud arhiivi)[cite: 3].
- Kuidas vea avastasin: Proovisin luua arhiivi ja seda lahti pakkida, aga `tar` andis vea[cite: 3].
- Millise käsuga kontrollisin: `file <backup_fail>`
- Parandus: Asendasin `find` käsu õige pakkimiskäsuga `tar -czf "$ARCHIVE" -C "$BACKUP_SOURCE" .` ja loendan failide arvu `tar -tzf` abil.
- Kuidas kontrollisin pärast parandust: Kontrollisin `file` käsuga faili tüüpi (näitas gzip compressed data) ja pakkisin failid prooviks lahti.

Uus funktsionaalsus
- Mida lisasin: Lisasin uue skripti `scripts/dashboard.sh`, mis käivitab korraga süsteemi info, kettakontrolli ning kontrollib olulisemate teenuste olekut ühes kohas.
- Kuidas käivitada: `./scripts/dashboard.sh`
- Kuidas kontrollisin, et tulemus on õige: Käivitasin skripti ja veendusin, et koondvaates kuvatavad andmed vastavad eraldiseisvate skriptide tulemustele.
