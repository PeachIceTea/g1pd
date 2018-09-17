-- Copyright 2018 Jonas Thiem

-- Data
local partyAddress = 0x0000D163
local pkmDB = {
    0x99, -- bulba
    0x09, -- ivy
    0x9A, -- venu
    0xB0, -- char
    0xB2, -- charme
    0xB4, -- charza
    0xB1, -- squri
    0xB3, -- wartot
    0x1C, -- blasto
    0x7B, -- cater
    0x7C, -- metapod
    0x7D, -- butter
    0x70, -- weedle
    0x71, -- kakuna
    0x72, -- beedrill
    0x24, -- pidgey
    0x96, -- pidgeotto
    0x97, -- pidgeot
    0xA5, -- rattata
    0xA6, -- raticate
    0x05, -- spearow
    0x23, -- fearow
    0x6C, -- ekans
    0x2D, -- arbok
    0x54, -- pikachu
    0x55, -- raichu
    0x60, -- sandshrew
    0x61, -- sandslash
    0x0F, -- nidoran_f
    0xA8, -- nidorina
    0x10, -- nidoqueen
    0x03, -- nidoran_m
    0xA7, -- nidorino
    0x07, -- nidoking
    0x04, -- clefairy
    0x8E, -- clefable
    0x52, -- vulpix
    0x53, -- nintetales
    0x64, -- jiggly
    0x65, -- wiggly 
    0x6B, -- zubat
    0x82, -- golbat
    0xB9, -- oddish
    0xBA, -- gloom
    0xBB, -- vileplume
    0x6D, -- paras
    0x2E, -- parasect
    0x41, -- venonat
    0x77, -- venomoth
    0x3B, -- diglett
    0x76, -- dugtrio
    0x4D, -- meowth
    0x90, -- persian
    0x2F, -- psyduck
    0x80, -- golduck
    0x39, -- mankey
    0x75, -- primeape
    0x21, -- growlithe
    0x14, -- arcanine
    0x47, -- poliwag
    0x6E, -- poliwhirl
    0x6F, -- poliwrath
    0x94, -- abra
    0x26, -- kadbra
    0x95, -- alakazam
    0x6A, -- machop
    0x29, -- machoke
    0x7E, -- machamp
    0xBC, -- bellsprout
    0xBD, -- weepinbell
    0xBE, -- Victribell
    0x18, -- tentacool
    0x9B, -- tentacruel
    0xA9, -- geodude
    0x27, -- graveler 
    0x31, -- golem
    0xA3, -- ponyta 
    0xA4, -- rapidash
    0x25, -- slowpoke
    0x08, -- slowbro
    0xAD, -- magnemite
    0x36, -- magneton
    0x40, -- farfetchd
    0x46, -- doduo
    0x74, -- dodrio
    0x3A, -- seel
    0x78, -- dewgong
    0x0d, -- grimer
    0x88, -- muk
    0x17, -- shellder
    0x8B, -- cloyster
    0x19, -- gastly 
    0x93, -- haunter 
    0x0E, -- gengar
    0x22, -- onix
    0x30, -- drowzee 
    0x81, -- hypno
    0x4E, -- krabby
    0x8a, -- kingler
    0x06, -- voltorb
    0x8D, -- electrode
    0x0C, -- exeggcute
    0x0A, -- exeggutor
    0x11, -- cubone
    0x91, -- marowak
    0x2B, -- hitmonlee
    0x2C, -- hitmonchan
    0x0B, -- lickitung
    0x37, -- koffing
    0x8F, -- weezing
    0x12, -- rhyhorn
    0x01, -- rhydon
    0x28, -- chansey
    0x1E, -- tangela
    0x02, -- kangaskhan
    0x5C, -- horsea
    0x5D, -- seadra
    0x9D, -- goldeen
    0x9E, -- seaking
    0x1B, -- staryu
    0x98, -- starmie
    0x2A, -- mr_mime
    0x1A, -- sycther
    0x48, -- jynx
    0x35, -- electabuzz
    0x33, -- magmar
    0x1D, -- pinsir
    0x3C, -- tauros
    0x85, -- magikarp
    0x16, -- gyarados
    0x13, -- lapras
    0x4C, -- ditto
    0x66, -- eevee
    0x69, -- vaporeon
    0x68, -- jolteon
    0x67, -- flareon 
    0xAA, -- porygon
    0x62, -- omanyte
    0x63, -- omastar
    0x5A, -- kabuto
    0x5B, -- kabutops
    0xAB, -- aerodactyl
    0x84, -- snorlax
    0x4A, -- aritcuno
    0x4B, -- zapdos
    0x49, -- moltres 
    0x58, -- dratini
    0x59, -- dragonair
    0x42, -- dragonite
    0x83, -- mewtwo
    0x15, -- mew
}

-- code

local prevParty = {0, 0, 0, 0, 0, 0}
local party = {0, 0, 0, 0, 0, 0}

local function copyArray(a, b)
    for i, v in pairs(a) do
        b[i] = v
    end
end

local function readParty()
    copyArray(party, prevParty)
    for  i = 1, 6, 1 do
        local p = memory.readbyteunsigned(partyAddress + i - 1)
        if p ~= 255 then
            party[i] = p
        else
            party[i] = 0
        end
    end
end

local function didPartyChange()
    local r = {false, false, false, false, false, false, false}
    
    for i = 1, 6, 1 do
        if prevParty[i] ~= party[i] then
            r[1] = true
            r[i + 1] = true 
        end
    end

    return r
end

local function getPokedexNumber(id)
    for i = 1, 151, 1 do
        if pkmDB[i] == id then
            return i
        end
    end

    return 0
end

local function update()
    readParty()

    local changeMap = didPartyChange()
    if changeMap[1] then
        for i = 1, 6, 1 do
            if changeMap[i + 1] then
                local newPNG = io.open("./sprites/" .. tostring(getPokedexNumber(party[i])) .. ".png", "rb") 
                local newData = newPNG:read("*a")
                newPNG:flush()
                
                local oldPNG = io.open("./party/p" .. tostring(i) .. ".png", "wb")
                oldPNG:write(newData)
                oldPNG:flush()
            end
        end
    end
end

local function clearPartyDisplay()
    local newPNG = io.open("./sprites/0.png", "rb+")
    local newData = newPNG:read("*a")
    newPNG:flush()

    for i = 1, 6, 1 do
        local oldPNG = io.open("./party/p" .. tostring(i) .. ".png", "wb+")
        oldPNG:write(newData)
        oldPNG:flush()
    end
end

clearPartyDisplay()
gui.register(update)
vba.print("g1pd 1.1 loaded <3")