//
//  TimeZone+Extensions.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 13/08/22.
//

import Foundation

public extension TimeZone {
    @inlinable static var gmt: TimeZone {
        self.init(secondsFromGMT: .zero)!
    }
    
    @inlinable static func africa(_ timeZone: Africa) -> TimeZone {
        TimeZone(identifier: timeZone.rawValue)!
    }
    
    @inlinable static func america(_ timeZone: America) -> TimeZone {
        TimeZone(identifier: timeZone.rawValue)!
    }
    
    @inlinable static func america(argentina timeZone: Argentina) -> TimeZone {
        TimeZone(identifier: timeZone.rawValue)!
    }
    
    @inlinable static func america(indiana timeZone: Indiana) -> TimeZone {
        TimeZone(identifier: timeZone.rawValue)!
    }
    
    @inlinable static func america(kentucky timeZone: Kentucky) -> TimeZone {
        TimeZone(identifier: timeZone.rawValue)!
    }
    
    @inlinable static func america(northDakota timeZone: NorthDakota) -> TimeZone {
        TimeZone(identifier: timeZone.rawValue)!
    }
    
    @inlinable static func antarctica(_ timeZone: Antarctica) -> TimeZone {
        TimeZone(identifier: timeZone.rawValue)!
    }
    
    @inlinable static func arctic(_ timeZone: Arctic) -> TimeZone {
        TimeZone(identifier: timeZone.rawValue)!
    }
    
    @inlinable static func asia(_ timeZone: Asia) -> TimeZone {
        TimeZone(identifier: timeZone.rawValue)!
    }
    
    @inlinable static func atlantic(_ timeZone: Atlantic) -> TimeZone {
        TimeZone(identifier: timeZone.rawValue)!
    }
    
    @inlinable static func australia(_ timeZone: Australia) -> TimeZone {
        TimeZone(identifier: timeZone.rawValue)!
    }
    
    @inlinable static func europe(_ timeZone: Europe) -> TimeZone {
        TimeZone(identifier: timeZone.rawValue)!
    }
    
    @inlinable static func indian(_ timeZone: Indian) -> TimeZone {
        TimeZone(identifier: timeZone.rawValue)!
    }
    
    @inlinable static func pacific(_ timeZone: Pacific) -> TimeZone {
        TimeZone(identifier: timeZone.rawValue)!
    }
}

// MARK: Enum

public extension TimeZone {
    
    // MARK: Africa
    
    enum Africa: String, CaseIterable {
        case abidjan = "Africa/Abidjan"
        case accra = "Africa/Accra"
        case addisAbaba = "Africa/Addis_Ababa"
        case algiers = "Africa/Algiers"
        case asmara = "Africa/Asmara"
        case bamako = "Africa/Bamako"
        case bangui = "Africa/Bangui"
        case banjul = "Africa/Banjul"
        case bissau = "Africa/Bissau"
        case blantyre = "Africa/Blantyre"
        case brazzaville = "Africa/Brazzaville"
        case bujumbura = "Africa/Bujumbura"
        case cairo = "Africa/Cairo"
        case casablanca = "Africa/Casablanca"
        case ceuta = "Africa/Ceuta"
        case conakry = "Africa/Conakry"
        case dakar = "Africa/Dakar"
        case darEsSalaam = "Africa/Dar_es_Salaam"
        case djibouti = "Africa/Djibouti"
        case douala = "Africa/Douala"
        case elAaiun = "Africa/El_Aaiun"
        case freetown = "Africa/Freetown"
        case gaborone = "Africa/Gaborone"
        case harare = "Africa/Harare"
        case johannesburg = "Africa/Johannesburg"
        case juba = "Africa/Juba"
        case kampala = "Africa/Kampala"
        case khartoum = "Africa/Khartoum"
        case kigali = "Africa/Kigali"
        case kinshasa = "Africa/Kinshasa"
        case lagos = "Africa/Lagos"
        case libreville = "Africa/Libreville"
        case lome = "Africa/Lome"
        case luanda = "Africa/Luanda"
        case lubumbashi = "Africa/Lubumbashi"
        case lusaka = "Africa/Lusaka"
        case malabo = "Africa/Malabo"
        case maputo = "Africa/Maputo"
        case maseru = "Africa/Maseru"
        case mbabane = "Africa/Mbabane"
        case mogadishu = "Africa/Mogadishu"
        case monrovia = "Africa/Monrovia"
        case nairobi = "Africa/Nairobi"
        case ndjamena = "Africa/Ndjamena"
        case niamey = "Africa/Niamey"
        case nouakchott = "Africa/Nouakchott"
        case ouagadougou = "Africa/Ouagadougou"
        case portoNovo = "Africa/Porto-Novo"
        case saoTome = "Africa/Sao_Tome"
        case tripoli = "Africa/Tripoli"
        case tunis = "Africa/Tunis"
        case windhoek = "Africa/Windhoek"
    }
    
    // MARK: America
    
    enum America: String, CaseIterable {
        case adak = "America/Adak"
        case anchorage = "America/Anchorage"
        case anguilla = "America/Anguilla"
        case antigua = "America/Antigua"
        case araguaina = "America/Araguaina"
        case aruba = "America/Aruba"
        case asuncion = "America/Asuncion"
        case atikokan = "America/Atikokan"
        case bahia = "America/Bahia"
        case bahiaBanderas = "America/Bahia_Banderas"
        case barbados = "America/Barbados"
        case belem = "America/Belem"
        case belize = "America/Belize"
        case blancSablon = "America/Blanc-Sablon"
        case boaVista = "America/Boa_Vista"
        case bogota = "America/Bogota"
        case boise = "America/Boise"
        case cambridgeBay = "America/Cambridge_Bay"
        case campoGrande = "America/Campo_Grande"
        case cancun = "America/Cancun"
        case caracas = "America/Caracas"
        case cayenne = "America/Cayenne"
        case cayman = "America/Cayman"
        case chicago = "America/Chicago"
        case chihuahua = "America/Chihuahua"
        case costaRica = "America/Costa_Rica"
        case creston = "America/Creston"
        case cuiaba = "America/Cuiaba"
        case curacao = "America/Curacao"
        case danmarkshavn = "America/Danmarkshavn"
        case dawson = "America/Dawson"
        case dawsonCreek = "America/Dawson_Creek"
        case denver = "America/Denver"
        case detroit = "America/Detroit"
        case dominica = "America/Dominica"
        case edmonton = "America/Edmonton"
        case eirunepe = "America/Eirunepe"
        case elSalvador = "America/El_Salvador"
        case fortNelson = "America/Fort_Nelson"
        case fortaleza = "America/Fortaleza"
        case glaceBay = "America/Glace_Bay"
        case godthab = "America/Godthab"
        case gooseBay = "America/Goose_Bay"
        case grandTurk = "America/Grand_Turk"
        case grenada = "America/Grenada"
        case guadeloupe = "America/Guadeloupe"
        case guatemala = "America/Guatemala"
        case guayaquil = "America/Guayaquil"
        case guyana = "America/Guyana"
        case halifax = "America/Halifax"
        case havana = "America/Havana"
        case hermosillo = "America/Hermosillo"
        case inuvik = "America/Inuvik"
        case iqaluit = "America/Iqaluit"
        case jamaica = "America/Jamaica"
        case juneau = "America/Juneau"
        case kralendijk = "America/Kralendijk"
        case laPaz = "America/La_Paz"
        case lima = "America/Lima"
        case losAngeles = "America/Los_Angeles"
        case lowerPrinces = "America/Lower_Princes"
        case maceio = "America/Maceio"
        case managua = "America/Managua"
        case manaus = "America/Manaus"
        case marigot = "America/Marigot"
        case martinique = "America/Martinique"
        case matamoros = "America/Matamoros"
        case mazatlan = "America/Mazatlan"
        case menominee = "America/Menominee"
        case merida = "America/Merida"
        case metlakatla = "America/Metlakatla"
        case mexicoCity = "America/Mexico_City"
        case miquelon = "America/Miquelon"
        case moncton = "America/Moncton"
        case monterrey = "America/Monterrey"
        case montevideo = "America/Montevideo"
        case montreal = "America/Montreal"
        case montserrat = "America/Montserrat"
        case nassau = "America/Nassau"
        case newYork = "America/New_York"
        case nipigon = "America/Nipigon"
        case nome = "America/Nome"
        case noronha = "America/Noronha"
        case nuuk = "America/Nuuk"
        case ojinaga = "America/Ojinaga"
        case panama = "America/Panama"
        case pangnirtung = "America/Pangnirtung"
        case paramaribo = "America/Paramaribo"
        case phoenix = "America/Phoenix"
        case portAuPrince = "America/Port-au-Prince"
        case portOfSpain = "America/Port_of_Spain"
        case portoVelho = "America/Porto_Velho"
        case puertoRico = "America/Puerto_Rico"
        case puntaArenas = "America/Punta_Arenas"
        case rainyRiver = "America/Rainy_River"
        case rankinInlet = "America/Rankin_Inlet"
        case recife = "America/Recife"
        case regina = "America/Regina"
        case resolute = "America/Resolute"
        case rioBranco = "America/Rio_Branco"
        case santaIsabel = "America/Santa_Isabel"
        case santarem = "America/Santarem"
        case santiago = "America/Santiago"
        case santoDomingo = "America/Santo_Domingo"
        case saoPaulo = "America/Sao_Paulo"
        case scoresbysund = "America/Scoresbysund"
        case shiprock = "America/Shiprock"
        case sitka = "America/Sitka"
        case stBarthelemy = "America/St_Barthelemy"
        case stJohns = "America/St_Johns"
        case stKitts = "America/St_Kitts"
        case stLucia = "America/St_Lucia"
        case stThomas = "America/St_Thomas"
        case stVincent = "America/St_Vincent"
        case swiftCurrent = "America/Swift_Current"
        case tegucigalpa = "America/Tegucigalpa"
        case thule = "America/Thule"
        case thunderBay = "America/Thunder_Bay"
        case tijuana = "America/Tijuana"
        case toronto = "America/Toronto"
        case tortola = "America/Tortola"
        case vancouver = "America/Vancouver"
        case whitehorse = "America/Whitehorse"
        case winnipeg = "America/Winnipeg"
        case yakutat = "America/Yakutat"
        case yellowknife = "America/Yellowknife"
    }
    
    // MARK: America/Argentina
    
    enum Argentina: String, CaseIterable {
        case buenosAires = "America/Argentina/Buenos_Aires"
        case catamarca = "America/Argentina/Catamarca"
        case cordoba = "America/Argentina/Cordoba"
        case jujuy = "America/Argentina/Jujuy"
        case laRioja = "America/Argentina/La_Rioja"
        case mendoza = "America/Argentina/Mendoza"
        case rioGallegos = "America/Argentina/Rio_Gallegos"
        case salta = "America/Argentina/Salta"
        case sanJuan = "America/Argentina/San_Juan"
        case sanLuis = "America/Argentina/San_Luis"
        case tucuman = "America/Argentina/Tucuman"
        case ushuaia = "America/Argentina/Ushuaia"
    }
    
    // MARK: America/Indiana
    
    enum Indiana: String, CaseIterable {
        case indianapolis = "America/Indiana/Indianapolis"
        case knox = "America/Indiana/Knox"
        case marengo = "America/Indiana/Marengo"
        case petersburg = "America/Indiana/Petersburg"
        case tellCity = "America/Indiana/Tell_City"
        case vevay = "America/Indiana/Vevay"
        case vincennes = "America/Indiana/Vincennes"
        case winamac = "America/Indiana/Winamac"
    }
    
    // MARK: America/Kentucky
    
    enum Kentucky: String, CaseIterable {
        case louisville = "America/Kentucky/Louisville"
        case monticello = "America/Kentucky/Monticello"
    }
    
    // MARK: America/NorthDakota
    
    enum NorthDakota: String, CaseIterable {
        case beulah = "America/North_Dakota/Beulah"
        case center = "America/North_Dakota/Center"
        case newSalem = "America/North_Dakota/New_Salem"
    }
    
    // MARK: Antarctica
    
    enum Antarctica: String, CaseIterable {
        case casey = "Antarctica/Casey"
        case davis = "Antarctica/Davis"
        case dumontDUrville = "Antarctica/DumontDUrville"
        case macquarie = "Antarctica/Macquarie"
        case mawson = "Antarctica/Mawson"
        case mcMurdo = "Antarctica/McMurdo"
        case palmer = "Antarctica/Palmer"
        case rothera = "Antarctica/Rothera"
        case southPole = "Antarctica/South_Pole"
        case syowa = "Antarctica/Syowa"
        case troll = "Antarctica/Troll"
        case vostok = "Antarctica/Vostok"
    }
    
    // MARK: Arctic
    
    enum Arctic: String, CaseIterable {
        case longyearbyen = "Arctic/Longyearbyen"
    }
    
    // MARK: Asia
    
    enum Asia: String, CaseIterable {
        case aden = "Asia/Aden"
        case almaty = "Asia/Almaty"
        case amman = "Asia/Amman"
        case anadyr = "Asia/Anadyr"
        case aqtau = "Asia/Aqtau"
        case aqtobe = "Asia/Aqtobe"
        case ashgabat = "Asia/Ashgabat"
        case atyrau = "Asia/Atyrau"
        case baghdad = "Asia/Baghdad"
        case bahrain = "Asia/Bahrain"
        case baku = "Asia/Baku"
        case bangkok = "Asia/Bangkok"
        case barnaul = "Asia/Barnaul"
        case beirut = "Asia/Beirut"
        case bishkek = "Asia/Bishkek"
        case brunei = "Asia/Brunei"
        case calcutta = "Asia/Calcutta"
        case chita = "Asia/Chita"
        case choibalsan = "Asia/Choibalsan"
        case chongqing = "Asia/Chongqing"
        case colombo = "Asia/Colombo"
        case damascus = "Asia/Damascus"
        case dhaka = "Asia/Dhaka"
        case dili = "Asia/Dili"
        case dubai = "Asia/Dubai"
        case dushanbe = "Asia/Dushanbe"
        case famagusta = "Asia/Famagusta"
        case gaza = "Asia/Gaza"
        case harbin = "Asia/Harbin"
        case hebron = "Asia/Hebron"
        case hoChiMinh = "Asia/Ho_Chi_Minh"
        case hongKong = "Asia/Hong_Kong"
        case hovd = "Asia/Hovd"
        case irkutsk = "Asia/Irkutsk"
        case jakarta = "Asia/Jakarta"
        case jayapura = "Asia/Jayapura"
        case jerusalem = "Asia/Jerusalem"
        case kabul = "Asia/Kabul"
        case kamchatka = "Asia/Kamchatka"
        case karachi = "Asia/Karachi"
        case kashgar = "Asia/Kashgar"
        case kathmandu = "Asia/Kathmandu"
        case katmandu = "Asia/Katmandu"
        case khandyga = "Asia/Khandyga"
        case krasnoyarsk = "Asia/Krasnoyarsk"
        case kualaLumpur = "Asia/Kuala_Lumpur"
        case kuching = "Asia/Kuching"
        case kuwait = "Asia/Kuwait"
        case macau = "Asia/Macau"
        case magadan = "Asia/Magadan"
        case makassar = "Asia/Makassar"
        case manila = "Asia/Manila"
        case muscat = "Asia/Muscat"
        case nicosia = "Asia/Nicosia"
        case novokuznetsk = "Asia/Novokuznetsk"
        case novosibirsk = "Asia/Novosibirsk"
        case omsk = "Asia/Omsk"
        case oral = "Asia/Oral"
        case phnomPenh = "Asia/Phnom_Penh"
        case pontianak = "Asia/Pontianak"
        case pyongyang = "Asia/Pyongyang"
        case qatar = "Asia/Qatar"
        case qostanay = "Asia/Qostanay"
        case qyzylorda = "Asia/Qyzylorda"
        case rangoon = "Asia/Rangoon"
        case riyadh = "Asia/Riyadh"
        case sakhalin = "Asia/Sakhalin"
        case samarkand = "Asia/Samarkand"
        case seoul = "Asia/Seoul"
        case shanghai = "Asia/Shanghai"
        case singapore = "Asia/Singapore"
        case srednekolymsk = "Asia/Srednekolymsk"
        case taipei = "Asia/Taipei"
        case tashkent = "Asia/Tashkent"
        case tbilisi = "Asia/Tbilisi"
        case tehran = "Asia/Tehran"
        case thimphu = "Asia/Thimphu"
        case tokyo = "Asia/Tokyo"
        case tomsk = "Asia/Tomsk"
        case ulaanbaatar = "Asia/Ulaanbaatar"
        case urumqi = "Asia/Urumqi"
        case ustNera = "Asia/Ust-Nera"
        case vientiane = "Asia/Vientiane"
        case vladivostok = "Asia/Vladivostok"
        case yakutsk = "Asia/Yakutsk"
        case yangon = "Asia/Yangon"
        case yekaterinburg = "Asia/Yekaterinburg"
        case yerevan = "Asia/Yerevan"
    }
    
    // MARK: Atlantic
    
    enum Atlantic: String, CaseIterable {
        case azores = "Atlantic/Azores"
        case bermuda = "Atlantic/Bermuda"
        case canary = "Atlantic/Canary"
        case capeVerde = "Atlantic/Cape_Verde"
        case faroe = "Atlantic/Faroe"
        case madeira = "Atlantic/Madeira"
        case reykjavik = "Atlantic/Reykjavik"
        case southGeorgia = "Atlantic/South_Georgia"
        case stHelena = "Atlantic/St_Helena"
        case stanley = "Atlantic/Stanley"
    }
    
    // MARK: Australia
    
    enum Australia: String, CaseIterable {
        case adelaide = "Australia/Adelaide"
        case brisbane = "Australia/Brisbane"
        case brokenHill = "Australia/Broken_Hill"
        case currie = "Australia/Currie"
        case darwin = "Australia/Darwin"
        case eucla = "Australia/Eucla"
        case hobart = "Australia/Hobart"
        case lindeman = "Australia/Lindeman"
        case lordHowe = "Australia/Lord_Howe"
        case melbourne = "Australia/Melbourne"
        case perth = "Australia/Perth"
        case sydney = "Australia/Sydney"
    }
    
    // MARK: Europe
    
    enum Europe: String, CaseIterable {
        case amsterdam = "Europe/Amsterdam"
        case andorra = "Europe/Andorra"
        case astrakhan = "Europe/Astrakhan"
        case athens = "Europe/Athens"
        case belgrade = "Europe/Belgrade"
        case berlin = "Europe/Berlin"
        case bratislava = "Europe/Bratislava"
        case brussels = "Europe/Brussels"
        case bucharest = "Europe/Bucharest"
        case budapest = "Europe/Budapest"
        case busingen = "Europe/Busingen"
        case chisinau = "Europe/Chisinau"
        case copenhagen = "Europe/Copenhagen"
        case dublin = "Europe/Dublin"
        case gibraltar = "Europe/Gibraltar"
        case guernsey = "Europe/Guernsey"
        case helsinki = "Europe/Helsinki"
        case isleOfMan = "Europe/Isle_of_Man"
        case istanbul = "Europe/Istanbul"
        case jersey = "Europe/Jersey"
        case kaliningrad = "Europe/Kaliningrad"
        case kiev = "Europe/Kiev"
        case kirov = "Europe/Kirov"
        case lisbon = "Europe/Lisbon"
        case ljubljana = "Europe/Ljubljana"
        case london = "Europe/London"
        case luxembourg = "Europe/Luxembourg"
        case madrid = "Europe/Madrid"
        case malta = "Europe/Malta"
        case mariehamn = "Europe/Mariehamn"
        case minsk = "Europe/Minsk"
        case monaco = "Europe/Monaco"
        case moscow = "Europe/Moscow"
        case oslo = "Europe/Oslo"
        case paris = "Europe/Paris"
        case podgorica = "Europe/Podgorica"
        case prague = "Europe/Prague"
        case riga = "Europe/Riga"
        case rome = "Europe/Rome"
        case samara = "Europe/Samara"
        case sanMarino = "Europe/San_Marino"
        case sarajevo = "Europe/Sarajevo"
        case saratov = "Europe/Saratov"
        case simferopol = "Europe/Simferopol"
        case skopje = "Europe/Skopje"
        case sofia = "Europe/Sofia"
        case stockholm = "Europe/Stockholm"
        case tallinn = "Europe/Tallinn"
        case tirane = "Europe/Tirane"
        case ulyanovsk = "Europe/Ulyanovsk"
        case uzhgorod = "Europe/Uzhgorod"
        case vaduz = "Europe/Vaduz"
        case vatican = "Europe/Vatican"
        case vienna = "Europe/Vienna"
        case vilnius = "Europe/Vilnius"
        case volgograd = "Europe/Volgograd"
        case warsaw = "Europe/Warsaw"
        case zagreb = "Europe/Zagreb"
        case zaporozhye = "Europe/Zaporozhye"
        case zurich = "Europe/Zurich"
    }
    
    //    GMT
    
    // MARK: Indian
    
    enum Indian: String, CaseIterable {
        case antananarivo = "Indian/Antananarivo"
        case chagos = "Indian/Chagos"
        case christmas = "Indian/Christmas"
        case cocos = "Indian/Cocos"
        case comoro = "Indian/Comoro"
        case kerguelen = "Indian/Kerguelen"
        case mahe = "Indian/Mahe"
        case maldives = "Indian/Maldives"
        case mauritius = "Indian/Mauritius"
        case mayotte = "Indian/Mayotte"
        case reunion = "Indian/Reunion"
    }
    
    // MARK: Pacific
    
    enum Pacific: String, CaseIterable {
        case apia = "Pacific/Apia"
        case auckland = "Pacific/Auckland"
        case bougainville = "Pacific/Bougainville"
        case chatham = "Pacific/Chatham"
        case chuuk = "Pacific/Chuuk"
        case easter = "Pacific/Easter"
        case efate = "Pacific/Efate"
        case enderbury = "Pacific/Enderbury"
        case fakaofo = "Pacific/Fakaofo"
        case fiji = "Pacific/Fiji"
        case funafuti = "Pacific/Funafuti"
        case galapagos = "Pacific/Galapagos"
        case gambier = "Pacific/Gambier"
        case guadalcanal = "Pacific/Guadalcanal"
        case guam = "Pacific/Guam"
        case honolulu = "Pacific/Honolulu"
        case johnston = "Pacific/Johnston"
        case kanton = "Pacific/Kanton"
        case kiritimati = "Pacific/Kiritimati"
        case kosrae = "Pacific/Kosrae"
        case kwajalein = "Pacific/Kwajalein"
        case majuro = "Pacific/Majuro"
        case marquesas = "Pacific/Marquesas"
        case midway = "Pacific/Midway"
        case nauru = "Pacific/Nauru"
        case niue = "Pacific/Niue"
        case norfolk = "Pacific/Norfolk"
        case noumea = "Pacific/Noumea"
        case pagoPago = "Pacific/Pago_Pago"
        case palau = "Pacific/Palau"
        case pitcairn = "Pacific/Pitcairn"
        case pohnpei = "Pacific/Pohnpei"
        case ponape = "Pacific/Ponape"
        case portMoresby = "Pacific/Port_Moresby"
        case rarotonga = "Pacific/Rarotonga"
        case saipan = "Pacific/Saipan"
        case tahiti = "Pacific/Tahiti"
        case tarawa = "Pacific/Tarawa"
        case tongatapu = "Pacific/Tongatapu"
        case truk = "Pacific/Truk"
        case wake = "Pacific/Wake"
        case wallis = "Pacific/Wallis"
    }
}
