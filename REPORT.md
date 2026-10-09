Arvestustöö raport
Nimi: Marcus Jakustand
Variant: A
Kuupäev: 09.10.2026

## Töö käik ja metoodika
Analüüsisin `sa-test` repositooriumis olevaid skripte, otsisin koodist üles loogikavead ning parandasin need. Testimiseks käivitasin skripte käsureal, võrdlesin tulemusi süsteemi tegelike andmetega ja vajadusel jooksuasin koodi silumisrežiimis (`bash -x`). Iga paranduse kohta tegin eraldi Git commit'i ning laadisin lahenduse oma GitHubi repositooriumisse.

---

Kirjelda vähemalt 6 leitud probleemi.

Probleem 1
- Skript: scripts/system_info.sh
- Mida skript näiliselt tegi: Pidid väljastama arvuti nime (hostname) ja sisselogitud kasutaja nime.
- Mis oli tegelikult vale: Koodis olid käsud vahetuses: `Hostname:` kohal käivitati `whoami` ja `Kasutaja:` kohal `hostname`.
- Kuidas vea avastasin: Käivitasin skripti terminalis ja märkasin kohe, et minu kasutajanime kohal kuvati arvuti nime ja vastupidi.
- Millise käsuga kontrollisin: Käivitasin terminalis eraldi käsud `whoami` ja `hostname`.
- Parandus: Muutsin koodis käskude kohad õigeks: `echo "Hostname: $(hostname)"` ja `echo "Kasutaja: $(whoami)"`.
- Kuidas kontrollisin pärast parandust: Käivitasin skripti `./scripts/system_info.sh` uuesti ja veendusin, et andmed kuvatakse õigetel ridadel.
- Vajadusel exit code enne / pärast: 0 / 0

Probleem 2
- Skript: scripts/system_info.sh
- Mida skript näiliselt tegi: Pidid kuvama arvuti kogu mälumahtu (RAM).
- Mis oli tegelikult vale: Kood kasutas käsule `free -m` otsingut `/Swap:/`, mis tähendab, et see kuvas hoopis vahemälu (swap) suurust, mitte põhimälu (RAM).
- Kuidas vea avastasin: Skripti näidatud mälumaht oli liiga väike ega klappinud minu arvuti tegeliku mälumahuga.
- Millise käsuga kontrollisin: Vaatasin tegelikke mälunäiteid otse käsuga `free -m`.
- Parandus: Muutsin `awk` otsingutingimuse koodis `/Swap:/` asemel `/Mem:/`.
- Kuidas kontrollisin pärast parandust: Käivitasin skripti uuesti ja võrdlesin tulemust `free -m` väljundi real oleva `Mem:` väärtusega.

Probleem 3
- Skript: scripts/user_check.sh
- Mida skript näiliselt tegi: Kontrollis, kas antud kasutaja on süsteemis olemas.
- Mis oli tegelikult vale: Kood otsis kasutajat failist `/etc/group` (mis on gruppide, mitte kasutajakontode fail). Lisaks oli kontroll `[ "$matches" -ge 0 ]` alati tõene, sest `grep -c` tagastab alati numbri 0 või suurema.
- Kuidas vea avastasin: Sisestasin skriptile kontrolliks suvalise olematu kasutajanime, kuid skript väitis ikkagi, et selline kasutaja on olemas.
- Millise käsuga kontrollisin: Käivitasin käsu `bash -x scripts/user_check.sh olematu_kasutaja`, et näha koodi täitmist rea-realt.
- Parandus: Asendasin vigase otsingu lihtsa ja töökindla süsteemse käsuga: `id "$username" &>/dev/null`.
- Kuidas kontrollisin pärast parandust: Testisin skripti olemasoleva kasutajaga (`root`) ja olematu nimega — mõlemal juhul andis skript õige vastuse ja exit code'i (0 või 1).

Probleem 4
- Skript: scripts/service_check.sh
- Mida skript näiliselt tegi: Kontrollis, kas soovitud teenus (nt `cron`) parajasti töötab.
- Mis oli tegelikult vale: Kood kasutas käsku `systemctl list-unit-files`, mis kontrollib ainult seda, kas teenuse fail on kettal olemas, mitte seda, kas teenus tegelikult praegu töötab.
- Kuidas vea avastasin: Seiskasin teenuse käsitsi ära, kuid skript raporteeris ikka, et teenus töötab edasi.
- Millise käsuga kontrollisin: Kontrollisin teenuse tegelikku olekut käsuga `systemctl status <teenus>`.
- Parandus: Asendasin kontrolli käsuga `systemctl is-active --quiet "$service"`, mis tagastab koodi 0 vaid siis, kui teenus tõesti töötab.
- Kuidas kontrollisin pärast parandust: Seiskasin teenuse (`sudo systemctl stop cron`), käivitasin skripti (ütles, et ei tööta) ja panin teenuse uuesti käima (`sudo systemctl start cron`), misjärel skript kinnitas töötamist.

Probleem 5
- Skript: scripts/disk_check.sh
- Mida skript näiliselt tegi: Kontrollis kettakasutuse protsenti ja hoiatas liigse täituvuse eest.
- Mis oli tegelikult vale: Kood luges `df -h /` väljundist 4. veergu (vaba ruumi maht gigabaitides, nt 15G), mitte 5. veergu (kasutusprotsent). Tähtede eemaldamisel tegi see `15G`-st arvu `15` ja võrdles seda piirmääraga.
- Kuidas vea avastasin: Võrdlesin skripti kuvatud arvu tegeliku kettakasutusega ja tulemused ei klappinud üldse.
- Millise käsuga kontrollisin: Käivitasin terminalis `df -Ph /`.
- Parandus: Muutsin koodi nii, et see loeb 5. veergu ja eemaldab protsendimärgi: `df -Ph / | awk 'NR==2 {print $5}' | tr -d '%'`.
- Kuidas kontrollisin pärast parandust: Käivitasin skripti ja veendusin, et kuvatud kasutusprotsent vastab täpselt `df -Ph /` tegelikule väljundile.

Probleem 6
- Skript: scripts/backup.sh
- Mida skript näiliselt tegi: Pidid tegema kaustast tihendatud `.tar.gz` varukoopia.
- Mis oli tegelikult vale: Koodis oli `find ... > "$ARCHIVE"`, mis kirjutas failiteede nimekirja tavalisse tekstifaili ja pani sellele lihtsalt nimeks `.tar.gz` (tegelikku arhiivi ei loodud).
- Kuidas vea avastasin: Proovisin tekitatud faili lahti pakkida, kuid `tar` andis vea, et tegemist pole arhiiviga.
- Millise käsuga kontrollisin: Kontrollisin tekitatud faili tüüpi käsuga `file <failinimi>`.
- Parandus: Muutsin skripti nii, et see kasutab õiget pakkimiskäsku `tar -czf "$ARCHIVE" -C "$BACKUP_SOURCE" .` ja loendab arhiivis olevaid faile käsuga `tar -tzf`.
- Kuidas kontrollisin pärast parandust: Käivitasin skripti, kontrollisin käsuga `file`, et väljund on `gzip compressed data`, ja pakkisin failid prooviks teise kausta lahti.

---

Uus funktsionaalsus
- Mida lisasin: Lisasin uue skripti `scripts/dashboard.sh`, mis koondab ühte vaatesse süsteemi info, kettakasutuse ning kontrollib automaatselt oluliste teenuste (`cron`, `ssh`, `systemd-journald`) olekut.
- Kuidas käivitada: `./scripts/dashboard.sh` (pärast käivitusõiguse andmist: `chmod +x scripts/dashboard.sh`)
- Kuidas kontrollisin, et tulemus on õige: Käivitasin skripti terminalis ja võrdlesin koondvaates kuvatavaid andmeid eraldiseisvate skriptide väljunditega.
