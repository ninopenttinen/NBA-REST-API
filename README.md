Perustiedot:
Käytetään tietokantana supistettua versiota mallinnusharjoitustyössä tehdystä NBA:n statistiikka ja tulospalvelusta. Kanta sisältää neljä toisiinsa linkitettyä taulua:

Players
- player_ID (PK)
- joukkue_ID (FK)
- name
- born
- height

/api/v1/players             - kaikki pelaajat  
/api/v1/players?            - query parametri haut  
/api/v1/players/:id         - tietty pelaaja  
/api/v1/teams/:id/players   - tietyn joukkueen kaikki pelaajat  

Teams
- team_ID (PK)
- name
- wins
- losses

/api/v1/teams       - kaikki joukkueet  
/api/v1/teams?      - query parametri haut  
/api/v1/teams/:id   - tietty joukkue  

Games
- game_ID (PK)
- home_team_ID (FK)
- guest_team_ID (FK)
- home_team_score
- guest_team_score
- date

/api/v1/games           - kaikki pelit  
/api/v1/games?          - query parametri haut  
/api/v1/games/:id       - tietty peli  
/api/v1/teams/:id/games - tietyn joukkueen kaikki pelit  

Results
- result_ID (PK)
- game_ID (FK)
- player_ID (FK)
- points
- rebounds
- assists

/api/v1/results             - kaikki tulokset  
/api/v1/results?            - query parametri haut  
/api/v1/results/:id         - tietyn pelin tulokset  
/api/v1/players/:id/results - tietyn pelaajan kaikki tulokset  
/api/v1/games/:id/results   - tietyn pelin kaikki tulokset  


![alt text](https://github.com/ninopenttinen/NBA-REST-API/blob/main/Entity relations.png?raw=true)


JOUKKUEILLE:  

Lisää joukkue:  
curl -i -X POST \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "team_id": "POR_2019_2020", "name": "Portland Trail Blazers", "wins": "0", "losses": "0" }' \
"http://localhost:9000/api/v1/teams"

Muokkaa joukkuetta:  
curl -i -X PUT \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "wins": "35", "losses": "39" }' \
"http://localhost:9000/api/v1/teams/POR_2019_2020"

Muokkaa joukkuetta jota ei ole olemassa (luo uuden joukkueen):  
curl -i -X PUT \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "name": "Philadelphia 76ers", "wins": "43", "losses": "30" }' \
"http://localhost:9000/api/v1/teams/PHI_2019_2020"

Poista joukkue:
curl -i -X DELETE "http://localhost:9000/api/v1/teams/PHI_2019_2020"


PELAAJILLE:  

Lisää pelaaja:  
curl -i -X POST \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "team_id": "POR_2019_2020", "name": "Damian Lillard", "born": "1990-07-15", "height": "1.88" }' \
"http://localhost:9000/api/v1/players"

Muokkaa pelaajaa:  
curl -i -X PUT \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "team_id": "MIA_2019_2020" }' \
"http://localhost:9000/api/v1/players/11"

Muokkaa pelaajaa jota ei ole olemassa (luo uuden pelaajan):  
curl -i -X PUT \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "team_id": "PHI_2019_2020", "name": "Ben Simmons", "born": "1996-07-20", "height": "2.08" }' \
"http://localhost:9000/api/v1/players/24"

Poista pelaaja:  
curl -i -X DELETE "http://localhost:9000/api/v1/players/11"


PELEILLE:  

Lisää peli:  
curl -i -X POST \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "game_id": "MIAvsLAL_07102020", "home_team_id": "MIA_2019_2020", "guest_team_id": "LAL_2019_2020", "home_team_score": "0", "guest_team_score": "0", "date": "2020-10-07" }' \
"http://localhost:9000/api/v1/games"

Muokkaa peliä:  
curl -i -X PUT \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "home_team_score": "96", "guest_team_score": "102" }' \
"http://localhost:9000/api/v1/games/MIAvsLAL_07102020"

Muokkaa peliä jota ei ole olemassa (luo uuden pelin):  
curl -i -X PUT \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "home_team_id": "MIA_2019_2020", "guest_team_id": "LAL_2019_2020", "home_team_score": "115", "guest_team_score": "104", "date": "2020-10-05" }' \
"http://localhost:9000/api/v1/games/MIAvsLAL_05102020"

Poista peli:  
curl -i -X DELETE "http://localhost:9000/api/v1/games/MIAvsLAL_05102020"


TULOKSILLE:  

Lisää tulos:  
curl -i -X POST \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "game_id": "MIAvsLAL_07102020", "player_id": "6", "points": "0", "rebounds": "0", "assists": "0" }' \
"http://localhost:9000/api/v1/results"

Muokkaa tulosta:  
curl -i -X PUT \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "points": "22", "rebounds": "10", "assists":"9" }' \
"http://localhost:9000/api/v1/results/21"

Muokkaa tulosta jota ei ole olemassa (luo uuden tuloksen):  
curl -i -X PUT \
-H "Content-Type: application/json;charset=UTF-8" \
-d '{ "game_id": "MIAvsLAL_07102020", "player_id": "1", "points": "28", "rebounds": "12", "assists": "8" }' \
"http://localhost:9000/api/v1/results/26"

Poista tulos:  
curl -i -X DELETE "http://localhost:9000/api/v1/results/22"
