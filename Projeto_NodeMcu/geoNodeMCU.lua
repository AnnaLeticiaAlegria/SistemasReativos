-- Renan da Fonte - 1412122
-- Pedro Ferreira - 1320981
-- Anna Letícia Alegria - 1410427

-- Recebe uma lista com as informações dos pontos de acesso e retorna o json a ser enviado
local cl;
local topico = "inf1805-prl";

function montaJson(wifiAccessPoints)
  primeirovalor = true;
  s = '  [[\n  {\n  "wifiAccessPoints": [';
  for key, value in pairs(wifiAccessPoints) do
    print(key .. " " .. value);
    --vírgula
    if primeirovalor then
      primeirovalor = false;
    else
      s = s .. ','
    end
  
    --linha
    local authmode, rssi, bssid, channel = string.match(value, "([^,]+),([^,]+),([^,]+),([^,]+)");
    s = s .. '\n      { "macAddress": "' .. bssid .. '" }';
    
  end
  
  s = s .. '\n    ]\n  }\n  ]]';
  print(s);
  http.post('https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyCj-JSZSFVOpRPkbfa-W3VNdfjeI_QKg5c',
  'Content-Type: application/json\r\n', s,
  function(code, data)
    if (code < 0) then
      print("HTTP request failed :", code)
    else
      print(code, data);
      cl:publish(topico,data,0,0, 
            function(client) print("mandou!") end);
      topico = "inf1805-prl"
    end
  end);
  return s;
end

local meuid = "1410427"
local m = mqtt.Client("clientid " .. meuid, 120)

sw1 = 1

function publica(c)
  cl = c;
  wifi.sta.getap(montaJson)
end


function novaInscricao (c)
  local msgsrec = 0
  function novamsg (c, t, m)
    print ("mensagem ".. msgsrec .. ", topico: ".. t .. ", dados: " .. m)
    msgsrec = msgsrec + 1
    topico = m
    publica(c)
  end
  c:on("message", novamsg)
end

function conectado (client)
  publica(client)
  client:subscribe("inf1805-prl-love", 0, novaInscricao)
end 

m:connect("test.mosquitto.org", 1883, 0, 
             conectado,
             function(client, reason) print("failed reason: "..reason) end)


gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.trig(sw1, "down", function(level, timestamp) publica(m) end)