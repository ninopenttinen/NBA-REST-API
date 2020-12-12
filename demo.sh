# =============================================
# Perustiedot:
# - Tuni-mail: nino.penttinen@tuni.fi
# - Kuvaus: Käytetään tietokantana supistettua versiota mallinnus-
#           harjoitustyössä tehdystä NBA:n statistiikka ja tulos-
#           palvelusta. (lisätietoja README:ssa)
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
# - Mikäli demo ei lähtenyt toimimaan, ei Docker todennäköisesti
#   ehtinyt rakentamaan ja käynnistämään kaikkia kontteja ajoissa.
#   Tässä tapauksessa kannattaa muokata scriptistä sleep aikaa 
#   pidemmäksi ja kokeilla uudestaan.
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

echo; echo " ----------- Haetaan vain kaikki Los Angeles Lakersin pelaamat pelit:"
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
curl -i -X DELETE "http://localhost:9000/api/v1/games/results/21"



echo; echo " ----------- THE END ------------"