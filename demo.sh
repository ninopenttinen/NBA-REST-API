# =============================================
# Perustiedot:
# - Tuni-mail: nino.penttinen@tuni.fi
# - Kuvaus: Käytetään tietokantana supistettua versiota mallinnus-
#           harjoitustyössä tehdystä NBA:n statistiikka ja tulos-
#           palvelusta. (lisätietoja Githubin README:ssa)
# - Tekninen toteutus: Node.js backend ja PostgreSQL tietokanta joita
#                      ajetaan omissa Docker konteissaan.
#
# API-kuvaus:
#
#   - Hae kaikki joukkueet:   GET /api/v1/teams
#   - Hae tietty joukkue:     GET /api/v1/teams/:id
#   - Parametri haku:         GET /api/v1/teams?{attribute}={value}
#   - Lisää joukkue:          POST /api/v1/teams
#   - Muokkaa joukkuetta:     PUT /api/v1/teams/:id
#   - Poista joukkue:         DELETE /api/v1/teams/:id
#
#   - Hae kaikki pelaajat:    GET /api/v1/players
#   - Hae tietty pelaaja:     GET /api/v1/players/:id
#   - Hae joukkueen pelaajat: GET /api/v1/teams/:id/players
#   - Parametri haku:         GET /api/v1/players?{attribute}={value}
#   - Lisää pelaaja:          POST /api/v1/players
#   - Muokkaa pelaajaa:       PUT /api/v1/players/:id
#   - Poista pelaaja:         DELETE /api/v1/players/:id
#
#   - Hae kaikki pelit:       GET /api/v1/games
#   - Hae tietty peli:        GET /api/v1/games/:id
#   - Hae joukkueen pelit:    GET /api/v1/teams/:id/games
#   - Parametri haku:         GET /api/v1/games?{attribute}={value}
#   - Lisää peli:             POST /api/v1/games
#   - Muokkaa peliä:          PUT /api/v1/games/:id
#   - Poista peli:            DELETE /api/v1/games/:id
#
#   - Hae kaikki tulokset:    GET /api/v1/results
#   - Hae tietty tulos:       GET /api/v1/results/:id
#   - Hae joukkueen tulokset: GET /api/v1/teams/:id/results
#   - Hae pelaajan tulokset:  GET /api/v1/players/:id/results
#   - Parametri haku:         GET /api/v1/results?{attribute}={value}
#   - Lisää tulos:            POST /api/v1/results
#   - Muokkaa tulosta:        PUT /api/v1/results/:id
#   - Poista tulos:           DELETE /api/v1/results/:id
#
# Tekniset vaatimukset:
# - Docker & Docker-compose v3+
# - Yarn
#
# Konfiguraatio:
# - Käynnistä Docker
# - Aja tämä demo (huom. scripti ei sulje tai poista kontteja ajon
#   jälkeen, tämä täytyy tehdä itse ajamalla komento 
#   "docker-compose down" projektin juuressa)
# - HUOM. JOS DEMOA HALUAA KOKEILLA UUDESTAAN (ja haluaa että kaikki
#   toimii niin kuin ensimmäisellä kerralla), TÄYTYY POISTAA DOCKERIN
#   AUTOMAATTISESTI LUOMAT VOLYYMIT! Tämän voi tehdä ajamalla
#   komennon "docker-compose down --volumes"
#
# =============================================

echo  "----------- Haetaan koodi versionhallinnasta"
git clone https://github.com/ninopenttinen/NBA-REST-API
cd NBA-REST-API
pwd

echo; echo " ----------- Asennetaan sovellus"
docker-compose up -d --build --remove-orphans
echo; echo " ----------- Odotetaan 60s että kontit saadaan ajoon"
sleep 60s



echo; echo " ----------- Haetaan kaikki joukkueet:"
curl -i -X GET \
-H "Content-Type: application/json;charset=UTF-8" \
"http://localhost:9000/api/v1/teams"

echo; echo " ----------- Lisätään joukkue:"
curl -i -X POST \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "team_id": "POR_2019_2020", "name": "Portland Trail Blazers", "wins": "0", "losses": "0" }' \
"http://localhost:9000/api/v1/teams"

echo; echo " ----------- Muokataan joukkueen 'wins' ja 'losses' attribuutteja:"
curl -i -X PUT \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "wins": "35", "losses": "39" }' \
"http://localhost:9000/api/v1/teams/POR_2019_2020"

echo; echo " ----------- Haetaan lisätty (ja muokattu) joukkue sen id:llä:"
curl -i -X GET \
-H "Content-Type: application/json;charset=UTF-8" \
"http://localhost:9000/api/v1/teams/POR_2019_2020"

echo; echo " ----------- Poistetaan joukkue:"
curl -i -X DELETE "http://localhost:9000/api/v1/teams/POR_2019_2020"

echo; echo " ----------- Lisätäänkin joukkue vielä takaisin että saadaan lisättyä sinne kohta pelaaja:"
curl -i -X POST \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "team_id": "POR_2019_2020", "name": "Portland Trail Blazers", "wins": "35", "losses": "39" }' \
"http://localhost:9000/api/v1/teams"



echo; echo " ----------- Haetaan kaikki pelaajat:"
curl -i -X GET \
-H "Content-Type: application/json;charset=UTF-8" \
"http://localhost:9000/api/v1/players"

echo; echo " ----------- Haetaan kaikki Los Angeles Lakersin pelaajat:"
curl -i -X GET \
-H "Content-Type: application/json;charset=UTF-8" \
"http://localhost:9000/api/v1/teams/LAL_2019_2020/players"

echo; echo " ----------- Lisätään pelaaja:"
curl -i -X POST \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "team_id": "POR_2019_2020", "name": "Damian Lillard", "born": "1990-07-15", "height": "1.88" }' \
"http://localhost:9000/api/v1/players"

echo; echo " ----------- Muokataan pelaajan tietoja (vaihdetaan joukkuetta):"
curl -i -X PUT \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "team_id": "MIA_2019_2020" }' \
"http://localhost:9000/api/v1/players/11"

echo; echo " ----------- Haetaan lisätty (ja muokattu) pelaaja id:llä:"
curl -i -X GET \
-H "Content-Type: application/json;charset=UTF-8" \
"http://localhost:9000/api/v1/players/11"

echo; echo " ----------- Poistetaan juuri lisätty pelaaja:"
curl -i -X DELETE "http://localhost:9000/api/v1/players/11"



echo; echo " ----------- Haetaan kaikki pelit:"
curl -i -X GET \
-H "Content-Type: application/json;charset=UTF-8" \
"http://localhost:9000/api/v1/games"

echo; echo " ----------- Haetaan vain kaikki Los Angeles Lakersin pelaamat pelit (tässä esimerkki datassa Lakers on mukana kaikissa lisätyissä peleissä):"
curl -i -X GET \
-H "Content-Type: application/json;charset=UTF-8" \
"http://localhost:9000/api/v1/teams/LAL_2019_2020/games"

echo; echo " ----------- Lisätään peli:"
curl -i -X POST \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "game_id": "MIAvsLAL_07102020", "home_team_id": "MIA_2019_2020", "guest_team_id": "LAL_2019_2020", "home_team_score": "0", "guest_team_score": "0", "date": "2020-10-07" }' \
"http://localhost:9000/api/v1/games"

echo; echo " ----------- Muokataan pelin lopputulosta:"
curl -i -X PUT \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "home_team_score": "96", "guest_team_score": "102" }' \
"http://localhost:9000/api/v1/games/MIAvsLAL_07102020"

echo; echo " ----------- Haetaan lisätty (ja muokattu) peli sen id:llä:"
curl -i -X GET \
-H "Content-Type: application/json;charset=UTF-8" \
"http://localhost:9000/api/v1/games/MIAvsLAL_07102020"

echo; echo " ----------- Poistetaan juuri lisätty peli:"
curl -i -X DELETE "http://localhost:9000/api/v1/games/MIAvsLAL_07102020"

echo; echo " ----------- Ja lisätään taas peli uudestaan että saadaan kohta lisättyä kyseiseen peliin liittyvä tulos:"
curl -i -X POST \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "game_id": "MIAvsLAL_07102020", "home_team_id": "MIA_2019_2020", "guest_team_id": "LAL_2019_2020", "home_team_score": "96", "guest_team_score": "102", "date": "2020-10-07" }' \
"http://localhost:9000/api/v1/games"



echo; echo " ----------- Haetaan kaikkien pelaajien tulokset kaikissa peleissä:"
curl -i -X GET \
-H "Content-Type: application/json;charset=UTF-8" \
"http://localhost:9000/api/v1/results"

echo; echo " ----------- Haetaan kaikkien Jimmy Butlerin pelaamien pelien tulokset:"
curl -i -X GET \
-H "Content-Type: application/json;charset=UTF-8" \
"http://localhost:9000/api/v1/players/6/results"

echo; echo " ----------- Haetaan yhden pelin (Los Angeles Lakers vs Miami Heat 10.10.2020) kaikki tulokset:"
curl -i -X GET \
-H "Content-Type: application/json;charset=UTF-8" \
"http://localhost:9000/api/v1/games/LALvsMIA_10102020/results"

echo; echo " ----------- Lisätään yhden pelaajan tulos"
curl -i -X POST \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "game_id": "MIAvsLAL_07102020", "player_id": "6", "points": "0", "rebounds": "0", "assists": "0" }' \
"http://localhost:9000/api/v1/results"

echo; echo " ----------- Muokataan tuloksen 'points', 'rebounds' ja 'assists' attribuutteja:"
curl -i -X PUT \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "points": "22", "rebounds": "10", "assists":"9" }' \
"http://localhost:9000/api/v1/results/21"

echo; echo " ----------- Haetaan lisätty (ja muokattu) tulos sen id:llä:"
curl -i -X GET \
-H "Content-Type: application/json;charset=UTF-8" \
"http://localhost:9000/api/v1/results/21"

echo; echo " ----------- Poistetaan juuri lisätty tulos:"
curl -i -X DELETE "http://localhost:9000/api/v1/results/21"



echo; echo " ----------- THE END ------------"

exit

# --------------------------------------------------------------

Esimerkki siitä miltä demon pitäisi näyttää

----------- Haetaan koodi versionhallinnasta
Cloning into 'NBA-REST-API'...
remote: Enumerating objects: 65, done.
remote: Counting objects: 100% (65/65), done.
remote: Compressing objects: 100% (44/44), done.
remote: Total 65 (delta 24), reused 60 (delta 19), pack-reused 0
Unpacking objects: 100% (65/65), 82.57 KiB | 472.00 KiB/s, done.
/home/nino/repo/testaus/NBA-REST-API

 ----------- Asennetaan sovellus
DOCKER LATAA IMAGEJA JA ASENTAA SOVELLUKSEN

Successfully built 3e5dbb65230b
Successfully tagged nba-rest-api_backend:latest
nba-rest-api_postgres_1 is up-to-date
nba-rest-api_backend_1 is up-to-date
nba-rest-api_adminer_1 is up-to-date

 ----------- Odotetaan 60s että kontit saadaan ajoon

 ----------- Haetaan kaikki joukkueet:
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 149
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

[{"team_id":"LAL_2019_2020","name":"Los Angeles Lakers","wins":52,"losses":19},{"team_id":"MIA_2019_2020","name":"Miami Heat","wins":44,"losses":29}]
 ----------- Lisätään joukkue:
HTTP/1.1 201 Created
Content-Type: application/json; charset=utf-8
Location: localhost:9000/api/v1/teams/POR_2019_2020
Content-Length: 79
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{"team_id":"POR_2019_2020","name":"Portland Trail Blazers","wins":0,"losses":0}
 ----------- Muokataan joukkueen 'wins' ja 'losses' attribuutteja:
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 81
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{"team_id":"POR_2019_2020","name":"Portland Trail Blazers","wins":35,"losses":39}
 ----------- Haetaan lisätty (ja muokattu) joukkue sen id:llä:
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 81
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{"team_id":"POR_2019_2020","name":"Portland Trail Blazers","wins":35,"losses":39}
 ----------- Poistetaan joukkue:
HTTP/1.1 204 No Content
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5


 ----------- Lisätäänkin joukkue vielä takaisin että saadaan lisättyä sinne kohta pelaaja:
HTTP/1.1 201 Created
Content-Type: application/json; charset=utf-8
Location: localhost:9000/api/v1/teams/POR_2019_2020
Content-Length: 81
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{"team_id":"POR_2019_2020","name":"Portland Trail Blazers","wins":35,"losses":39}
 ----------- Haetaan kaikki pelaajat:
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 1154
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

[{"player_id":1,"team_id":"LAL_2019_2020","name":"LeBron James","born":"1984-12-30T00:00:00.000Z","height":"2.06"},{"player_id":2,"team_id":"LAL_2019_2020","name":"Anthony Davis","born":"1993-03-11T00:00:00.000Z","height":"2.08"},{"player_id":3,"team_id":"LAL_2019_2020","name":"Kentavious Caldwell-Pope","born":"1993-02-18T00:00:00.000Z","height":"1.96"},{"player_id":4,"team_id":"LAL_2019_2020","name":"Kyle Kuzma","born":"1995-07-24T00:00:00.000Z","height":"2.03"},{"player_id":5,"team_id":"LAL_2019_2020","name":"Danny Green","born":"1987-06-22T00:00:00.000Z","height":"1.98"},{"player_id":6,"team_id":"MIA_2019_2020","name":"Jimmy Butler","born":"1989-10-14T00:00:00.000Z","height":"2.01"},{"player_id":7,"team_id":"MIA_2019_2020","name":"Bam Adebayo","born":"1997-07-18T00:00:00.000Z","height":"2.06"},{"player_id":8,"team_id":"MIA_2019_2020","name":"Tyler Herro","born":"2000-01-20T00:00:00.000Z","height":"1.96"},{"player_id":9,"team_id":"MIA_2019_2020","name":"Duncan Robinson","born":"1994-04-22T00:00:00.000Z","height":"2.01"},{"player_id":10,"team_id":"MIA_2019_2020","name":"Kendrick Nunn","born":"1995-08-03T00:00:00.000Z","height":"1.88"}]
 ----------- Haetaan kaikki Los Angeles Lakersin pelaajat:
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 581
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

[{"player_id":1,"team_id":"LAL_2019_2020","name":"LeBron James","born":"1984-12-30T00:00:00.000Z","height":"2.06"},{"player_id":2,"team_id":"LAL_2019_2020","name":"Anthony Davis","born":"1993-03-11T00:00:00.000Z","height":"2.08"},{"player_id":3,"team_id":"LAL_2019_2020","name":"Kentavious Caldwell-Pope","born":"1993-02-18T00:00:00.000Z","height":"1.96"},{"player_id":4,"team_id":"LAL_2019_2020","name":"Kyle Kuzma","born":"1995-07-24T00:00:00.000Z","height":"2.03"},{"player_id":5,"team_id":"LAL_2019_2020","name":"Danny Green","born":"1987-06-22T00:00:00.000Z","height":"1.98"}]
 ----------- Lisätään pelaaja:
HTTP/1.1 201 Created
Content-Type: application/json; charset=utf-8
Location: localhost:9000/api/v1/players/11
Content-Length: 116
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{"player_id":11,"team_id":"POR_2019_2020","name":"Damian Lillard","born":"1990-07-15T00:00:00.000Z","height":"1.88"}
 ----------- Muokataan pelaajan tietoja (vaihdetaan joukkuetta):
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 116
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{"player_id":11,"team_id":"MIA_2019_2020","name":"Damian Lillard","born":"1990-07-15T00:00:00.000Z","height":"1.88"}
 ----------- Haetaan lisätty (ja muokattu) pelaaja id:llä:
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 116
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{"player_id":11,"team_id":"MIA_2019_2020","name":"Damian Lillard","born":"1990-07-15T00:00:00.000Z","height":"1.88"}
 ----------- Poistetaan juuri lisätty pelaaja:
HTTP/1.1 204 No Content
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5


 ----------- Haetaan kaikki pelit:
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 348
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

[{"game_id":"LALvsMIA_10102020","home_team_id":"LAL_2019_2020","guest_team_id":"MIA_2019_2020","home_team_score":108,"guest_team_score":111,"date":"2020-10-10T00:00:00.000Z"},{"game_id":"MIAvsLAL_12102020","home_team_id":"MIA_2019_2020","guest_team_id":"LAL_2019_2020","home_team_score":93,"guest_team_score":106,"date":"2020-10-12T00:00:00.000Z"}]
 ----------- Haetaan vain kaikki Los Angeles Lakersin pelaamat pelit (tässä esimerkki datassa Lakers on mukana kaikissa lisätyissä peleissä):
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 348
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

[{"game_id":"LALvsMIA_10102020","home_team_id":"LAL_2019_2020","guest_team_id":"MIA_2019_2020","home_team_score":108,"guest_team_score":111,"date":"2020-10-10T00:00:00.000Z"},{"game_id":"MIAvsLAL_12102020","home_team_id":"MIA_2019_2020","guest_team_id":"LAL_2019_2020","home_team_score":93,"guest_team_score":106,"date":"2020-10-12T00:00:00.000Z"}]
 ----------- Lisätään peli:
HTTP/1.1 201 Created
Content-Type: application/json; charset=utf-8
Location: localhost:9000/api/v1/games/MIAvsLAL_07102020
Content-Length: 169
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{"game_id":"MIAvsLAL_07102020","home_team_id":"MIA_2019_2020","guest_team_id":"LAL_2019_2020","home_team_score":0,"guest_team_score":0,"date":"2020-10-07T00:00:00.000Z"}
 ----------- Muokataan pelin lopputulosta:
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 172
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{"game_id":"MIAvsLAL_07102020","home_team_id":"MIA_2019_2020","guest_team_id":"LAL_2019_2020","home_team_score":96,"guest_team_score":102,"date":"2020-10-07T00:00:00.000Z"}
 ----------- Haetaan lisätty (ja muokattu) peli sen id:llä:
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 172
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{"game_id":"MIAvsLAL_07102020","home_team_id":"MIA_2019_2020","guest_team_id":"LAL_2019_2020","home_team_score":96,"guest_team_score":102,"date":"2020-10-07T00:00:00.000Z"}
 ----------- Poistetaan juuri lisätty peli:
HTTP/1.1 204 No Content
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5


 ----------- Ja lisätään taas peli uudestaan että saadaan kohta lisättyä kyseiseen peliin liittyvä tulos:
HTTP/1.1 201 Created
Content-Type: application/json; charset=utf-8
Location: localhost:9000/api/v1/games/MIAvsLAL_07102020
Content-Length: 172
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{"game_id":"MIAvsLAL_07102020","home_team_id":"MIA_2019_2020","guest_team_id":"LAL_2019_2020","home_team_score":96,"guest_team_score":102,"date":"2020-10-07T00:00:00.000Z"}
 ----------- Haetaan kaikkien pelaajien tulokset kaikissa peleissä:
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 1957
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

[{"result_id":1,"game_id":"LALvsMIA_10102020","player_id":1,"points":40,"rebounds":13,"assists":7},{"result_id":2,"game_id":"LALvsMIA_10102020","player_id":2,"points":28,"rebounds":12,"assists":3},{"result_id":3,"game_id":"LALvsMIA_10102020","player_id":3,"points":16,"rebounds":3,"assists":2},{"result_id":4,"game_id":"LALvsMIA_10102020","player_id":4,"points":7,"rebounds":1,"assists":0},{"result_id":5,"game_id":"LALvsMIA_10102020","player_id":5,"points":8,"rebounds":1,"assists":1},{"result_id":6,"game_id":"LALvsMIA_10102020","player_id":6,"points":35,"rebounds":12,"assists":11},{"result_id":7,"game_id":"LALvsMIA_10102020","player_id":7,"points":13,"rebounds":4,"assists":4},{"result_id":8,"game_id":"LALvsMIA_10102020","player_id":8,"points":12,"rebounds":1,"assists":3},{"result_id":9,"game_id":"LALvsMIA_10102020","player_id":9,"points":26,"rebounds":5,"assists":2},{"result_id":10,"game_id":"LALvsMIA_10102020","player_id":10,"points":14,"rebounds":4,"assists":3},{"result_id":11,"game_id":"MIAvsLAL_12102020","player_id":1,"points":28,"rebounds":14,"assists":10},{"result_id":12,"game_id":"MIAvsLAL_12102020","player_id":2,"points":19,"rebounds":15,"assists":3},{"result_id":13,"game_id":"MIAvsLAL_12102020","player_id":3,"points":17,"rebounds":2,"assists":0},{"result_id":14,"game_id":"MIAvsLAL_12102020","player_id":4,"points":2,"rebounds":1,"assists":0},{"result_id":15,"game_id":"MIAvsLAL_12102020","player_id":5,"points":11,"rebounds":5,"assists":1},{"result_id":16,"game_id":"MIAvsLAL_12102020","player_id":6,"points":12,"rebounds":7,"assists":8},{"result_id":17,"game_id":"MIAvsLAL_12102020","player_id":7,"points":25,"rebounds":19,"assists":5},{"result_id":18,"game_id":"MIAvsLAL_12102020","player_id":8,"points":7,"rebounds":3,"assists":4},{"result_id":19,"game_id":"MIAvsLAL_12102020","player_id":9,"points":10,"rebounds":1,"assists":3},{"result_id":20,"game_id":"MIAvsLAL_12102020","player_id":10,"points":8,"rebounds":3,"assists":1}]
 ----------- Haetaan kaikkien Jimmy Butlerin pelaamien pelien tulokset:
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 198
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

[{"result_id":6,"game_id":"LALvsMIA_10102020","player_id":6,"points":35,"rebounds":12,"assists":11},{"result_id":16,"game_id":"MIAvsLAL_12102020","player_id":6,"points":12,"rebounds":7,"assists":8}]
 ----------- Haetaan yhden pelin (Los Angeles Lakers vs Miami Heat 10.10.2020) kaikki tulokset:
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 975
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

[{"result_id":1,"game_id":"LALvsMIA_10102020","player_id":1,"points":40,"rebounds":13,"assists":7},{"result_id":2,"game_id":"LALvsMIA_10102020","player_id":2,"points":28,"rebounds":12,"assists":3},{"result_id":3,"game_id":"LALvsMIA_10102020","player_id":3,"points":16,"rebounds":3,"assists":2},{"result_id":4,"game_id":"LALvsMIA_10102020","player_id":4,"points":7,"rebounds":1,"assists":0},{"result_id":5,"game_id":"LALvsMIA_10102020","player_id":5,"points":8,"rebounds":1,"assists":1},{"result_id":6,"game_id":"LALvsMIA_10102020","player_id":6,"points":35,"rebounds":12,"assists":11},{"result_id":7,"game_id":"LALvsMIA_10102020","player_id":7,"points":13,"rebounds":4,"assists":4},{"result_id":8,"game_id":"LALvsMIA_10102020","player_id":8,"points":12,"rebounds":1,"assists":3},{"result_id":9,"game_id":"LALvsMIA_10102020","player_id":9,"points":26,"rebounds":5,"assists":2},{"result_id":10,"game_id":"LALvsMIA_10102020","player_id":10,"points":14,"rebounds":4,"assists":3}]
 ----------- Lisätään yhden pelaajan tulos
HTTP/1.1 201 Created
Content-Type: application/json; charset=utf-8
Location: localhost:9000/api/v1/results/21
Content-Length: 96
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{"result_id":21,"game_id":"MIAvsLAL_07102020","player_id":6,"points":0,"rebounds":0,"assists":0}
 ----------- Muokataan tuloksen 'points', 'rebounds' ja 'assists' attribuutteja:
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 98
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{"result_id":21,"game_id":"MIAvsLAL_07102020","player_id":6,"points":22,"rebounds":10,"assists":9}
 ----------- Haetaan lisätty (ja muokattu) tulos sen id:llä:
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 98
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{"result_id":21,"game_id":"MIAvsLAL_07102020","player_id":6,"points":22,"rebounds":10,"assists":9}
 ----------- Poistetaan juuri lisätty tulos:
HTTP/1.1 204 No Content
Date: Sun, 13 Dec 2020 17:31:10 GMT
Connection: keep-alive
Keep-Alive: timeout=5


 ----------- THE END ------------
