# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

HubLcSection.destroy_all
LcSection.destroy_all

unless ElementType.exists?(:name => "Wall")
  ElementType.create({id:1, name: "Wall"})
end

ids = Array.new()
ids.push(ElementType.find_by(name: "Wall").id)

Dir.foreach('app/assets/images') do |item|
  next if item == '.' or item == '..' or not item.end_with? ".svg"
  file = Nokogiri::Slop(File.open("app/assets/images/" + item))

  viewBox = file.at_css("svg").attr("viewbox").split
  width = viewBox[2]
  height = viewBox[3]

  if (width != nil and height != nil)
    type = ElementType.where(name: item[0..-5]).first_or_initialize
    type.name = item[0..-5]
    type.width = width
    type.height = height
    type.svg_path = item
    type.save
    ids.push(type.id)
  end
end


ElementType.all.each do |e|
  unless ids.include? e.id
    ElementType.find(e.id).destroy
  end
end


CLASS_HASH = {
    'A' => {
        :name => 'General Works',
        :subclasses => {
            'AC'   => { :name => 'Collections; Series; Collected works' },
            'AE'   => { :name => 'Encyclopedias' },
            'AG'   => { :name => 'Dictionaries and other general reference works' },
            'AI'   => { :name => 'Indexes' },
            'AM'   => { :name => 'Museums. Collectors and collecting' },
            'AN'   => { :name => 'Newspapers' },
            'AP'   => { :name => 'Periodicals' },
            'AS'   => { :name => 'Academies and learned societies' },
            'AY'   => { :name => 'Yearbooks. Almanacs. Directories' },
            'AZ'   => { :name => 'History of scholarship and learning. The humanities' }
        }
    },
    'B' => {
        :name => 'Philosophy, Psychology, Religion',
        :subclasses => {
            'B'    => { :name => 'Philosophy (General)' },
            'BC'   => { :name => 'Logic' },
            'BD'   => { :name => 'Speculative philosophy' },
            'BF'   => { :name => 'Psychology' },
            'BH'   => { :name => 'Aesthetics' },
            'BJ'   => { :name => 'Ethics' },
            'BL'   => { :name => 'Religions; Mythology; Rationalism' },
            'BM'   => { :name => 'Judaism' },
            'BP'   => { :name => 'Islam; Bahaism; Theosophy, etc.' },
            'BQ'   => { :name => 'Buddhism' },
            'BR'   => { :name => 'Christianity' },
            'BS'   => { :name => 'The Bible' },
            'BT'   => { :name => 'Doctrinal Theology' },
            'BV'   => { :name => 'Practical Theology' },
            'BX'   => { :name => 'Christian Denominations' }
        }
    },
    'C' => {
        :name => 'Auxiliary Sciences of History (General)',
        :subclasses => {
            'CB'   => { :name => 'History of Civilization' },
            'CC'   => { :name => 'Archaeology' },
            'CD'   => { :name => 'Diplomatics. Archives. Seals' },
            'CE'   => { :name => 'Technical Chronology. Calendar' },
            'CJ'   => { :name => 'Numismatics' },
            'CN'   => { :name => 'Inscriptions. Epigraphy' },
            'CR'   => { :name => 'Heraldry' },
            'CS'   => { :name => 'Genealogy' },
            'CT'   => { :name => 'Biography' }
        }
    },
    'D' => {
        :name => 'World History and History of Europe, Asia, Africa, Australia, New Zealand, etc.',
        :subclasses => {
            'D'    => { :name => 'History (General)' },
            'DA'   => { :name => 'Great Britain' },
            'DAW'  => { :name => 'Central Europe' },
            'DB'   => { :name => 'Austria - Liechtenstein - Hungary - Czechoslovakia' },
            'DC'   => { :name => 'France - Andorra - Monaco' },
            'DD'   => { :name => 'Germany' },
            'DE'   => { :name => 'Greco-Roman World' },
            'DF'   => { :name => 'Greece' },
            'DG'   => { :name => 'Italy - Malta' },
            'DH'   => { :name => 'Low Countries - Benelux Countries' },
            'DJ'   => { :name => 'Netherlands (Holland)' },
            'DJK'  => { :name => 'Eastern Europe (General)' },
            'DK'   => { :name => 'Russia. Soviet Union. Former Soviet Republics - Poland' },
            'DL'   => { :name => 'Northern Europe. Scandinavia' },
            'DP'   => { :name => 'Spain - Portugal' },
            'DQ'   => { :name => 'Switzerland' },
            'DR'   => { :name => 'Balkan Peninsula' },
            'DS'   => { :name => 'Asia' },
            'DT'   => { :name => 'Africa' },
            'DU'   => { :name => 'Oceania (South Seas)' },
            'DX'   => { :name => 'Gypsies' }
        }
    },
    'E' => {
        :name => 'History of America, United States',
        :subclasses => {
            'E'  => { :name => 'North America and United States' },
        }
    },
    'F' => {
        :name => 'Local History of the United States and British, Dutch, French, and Latin America',
        :subclasses => {
            'F'  => { :name => 'Canada and Latin America' },
        }
    },
    'G' => {
        :name => 'Geography, Anthropology, Recreation',
        :subclasses => {
            'G'  => { :name => 'Geography (General). Atlases. Maps' },
            'GA' => { :name => 'Mathematical geography. Cartography' },
            'GB' => { :name => 'Physical geography' },
            'GC' => { :name => 'Oceanography' },
            'GE' => { :name => 'Environmental Sciences' },
            'GF' => { :name => 'Human ecology. Anthropogeography' },
            'GN' => { :name => 'Anthropology' },
            'GR' => { :name => 'Folklore' },
            'GT' => { :name => 'Manners and customs (General)' },
            'GV' => { :name => 'Recreation. Leisure' }
        }
    },
    'H' => {
        :name => 'Social Sciences',
        :subclasses => {
            'H'  => { :name => 'Social sciences (General)' },
            'HA' => { :name => 'Statistics' },
            'HB' => { :name => 'Economic theory. Demography' },
            'HC' => { :name => 'Economic history and conditions' },
            'HD' => { :name => 'Industries. Land use. Labor' },
            'HE' => { :name => 'Transportation and communications' },
            'HF' => { :name => 'Commerce' },
            'HG' => { :name => 'Finance' },
            'HJ' => { :name => 'Public finance' },
            'HM' => { :name => 'Sociology (General)' },
            'HN' => { :name => 'Social history and conditions. Social problems. Social reform' },
            'HQ' => { :name => 'The family. Marriage. Women' },
            'HS' => { :name => 'Societies: secret, benevolent, etc.' },
            'HT' => { :name => 'Communities. Classes. Races' },
            'HV' => { :name => 'Social pathology. Social and public welfare. Criminology' },
            'HX' => { :name => 'Socialism. Communism. Anarchism' }
        }
    },
    'J' => {
        :name => 'Political Sciences',
        :subclasses => {
            'J'  => { :name => 'General legislative and executive papers' },
            'JA' => { :name => 'Political science (General)' },
            'JC' => { :name => 'Political theory' },
            'JF' => { :name => 'Political institutions and public administration' },
            'JJ' => { :name => 'Political institutions and public administration (North America)' },
            'JK' => { :name => 'Political institutions and public administration (United States)' },
            'JL' => { :name => 'Political institutions and public administration (Canada, Latin America, etc.)' },
            'JN' => { :name => 'Political institutions and public administration (Europe)' },
            'JQ' => { :name => 'Political institutions and public administration (Asia, Africa, Australia, Pacific Area, etc.)' },
            'JS' => { :name => 'Local government. Municipal government' },
            'JV' => { :name => 'Colonies and colonization. Emigration and immigration. International migration' },
            'JX' => { :name => 'International law, see JZ and KZ (obsolete)' },
            'JZ' => { :name => 'International relations' }
        }
    },
    'K' => {
        :name => 'Law',
        :subclasses => {
            'K'  => { :name => 'Law in general. Comparative and uniform law. Jurisprudence' },
            'KB'  => { :name => 'General and comparative religious law' },
            'KBM'  => { :name => 'Jewish law. Halakhah' },
            'KBP'  => { :name => 'Islamic law. Sharia' },
            'KBR'  => { :name => 'History of canon law (Christian) to late 19th cent.' },
            'KBS'  => { :name => 'Canon law of the Eastern Christian churches' },
            'KBU'  => { :name => 'Canon law of the Roman Catholic Church' },
            'KBX'  => { :name => 'Law of Protestant churches' },
            'KD'  => { :name => 'United Kingdom . England . Wales' },
            'KDC'  => { :name => 'Scotland' },
            'KDE'  => { :name => 'Northern Ireland' },
            'KDG'  => { :name => 'Isle of Man. Channel Islands' },
            'KDK'  => { :name => 'Ireland' },
            'KDZ'  => { :name => 'Western hemisphere (general & comparative). North America (general & comparative). Bermuda . Greenland . St. Pierre et Miquelon' },
            'KE'  => { :name => 'Canada (general)' },
            'KEA'  => { :name => 'Alberta' },
            'KEB'  => { :name => 'British Columbia' },
            'KEM'  => { :name => 'Manitoba' },
            'KEN'  => { :name => 'New Brunswick . Newfoundland . Northwest Territories . Nova Scotia . Nunavut' },
            'KEO'  => { :name => 'Ontario' },
            'KEP'  => { :name => 'Prince Edward Island' },
            'KEQ'  => { :name => 'Québec' },
            'KES'  => { :name => 'Saskatchewan' },
            'KEY'  => { :name => 'Yukon Territory' },
            'KEZ'  => { :name => 'Cities, towns, etc.' },
            'KF'  => { :name => 'United States (general)' },
            'KGA'  => { :name => 'Belize' },
            'KGB'  => { :name => 'Costa Rica' },
            'KGC'  => { :name => 'El Salvador' },
            'KGD'  => { :name => 'Guatemala' },
            'KGE'  => { :name => 'Honduras' },
            'KGF'  => { :name => 'Mexico' },
            'KGG'  => { :name => 'Nicaragua' },
            'KGH'  => { :name => 'Panama' },
            'KGJ'  => { :name => 'West Indies & Caribbean area (general & comparative). Anguilla' },
            'KGK'  => { :name => 'Antigua & Barbuda . Aruba' },
            'KGL'  => { :name => 'Bahamas . Barbados . British Leeward Islands, Virgin Islands, West Indies, Windward Islands' },
            'KGM'  => { :name => 'Cayman Islands' },
            'KGN'  => { :name => 'Cuba' },
            'KGP'  => { :name => 'Curaçao. Dominica' },
            'KGQ'  => { :name => 'Dominican Republic .' },
            'KGR'  => { :name => 'Dutch Leeward Islands, West Indies, Windward Islands . French West Indies , Grenada , Guadeloupe' },
            'KGS'  => { :name => 'Haiti' },
            'KGT'  => { :name => 'Jamaica . Martinique . Montserrat' },
            'KGU'  => { :name => 'Navassa islands' },
            'KGV'  => { :name => 'Puerto Rico' },
            'KGW'  => { :name => 'Saba . St Kitts, Nevis & Anguilla. St. Lucia . St. Vincent & the Grenadines . St. Eustatius . St. Maarten' },
            'KGX'  => { :name => 'Trinidad & Tobago' },
            'KGY'  => { :name => 'Turks & Caicos Islands' },
            'KH'  => { :name => 'South America (general & comparative)' },
            'KHA'  => { :name => 'Argentina' },
            'KHC'  => { :name => 'Bolivia' },
            'KHD'  => { :name => 'Brazil' },
            'KHF'  => { :name => 'Chile' },
            'KHH'  => { :name => 'Colombia' },
            'KHK'  => { :name => 'Ecuador' },
            'KHL'  => { :name => 'Falkland Islands' },
            'KHM'  => { :name => 'French Guiana' },
            'KHN'  => { :name => 'Guyana' },
            'KHP'  => { :name => 'Paraguay' },
            'KHQ'  => { :name => 'Peru' },
            'KHR'  => { :name => 'South Georgia and South Sandwich Islands' },
            'KHS'  => { :name => 'Suriname' },
            'KHU'  => { :name => 'Uruguay' },
            'KHW'  => { :name => 'Venezuela' },
            'KJ'  => { :name => 'History of law in Europe. Law of ancient European tribes (Celts, etc.)' },
            'KJA'  => { :name => 'Roman law. Byzantine law' },
            'KJC'  => { :name => 'Regional and comparative law' },
            'KJE'  => { :name => 'Regional organization and integration. European Union' },
            'KJG'  => { :name => 'Albania' },
            'KJH'  => { :name => 'Andorra' },
            'KJJ'  => { :name => 'Austria' },
            'KJK'  => { :name => 'Belgium . Bosnia & Hercegovina (1992-; cf. KKZ)' },
            'KJM'  => { :name => 'Bulgaria . Croatia (1992-; cf. KKZ)' },
            'KJN'  => { :name => 'Cyprus' },
            'KJP'  => { :name => 'Czechoslovakia . Czech Republic (1993-)' },
            'KJQ'  => { :name => 'Slovakia (1993-)' },
            'KJR'  => { :name => 'Denmark' },
            'KJS'  => { :name => 'Estonia' },
            'KJT'  => { :name => 'Finland' },
            'KJV'  => { :name => 'France (general)' },
            'KJW'  => { :name => 'France (regions, provinces, departments, etc.; cities, towns, etc.)' },
            'KK'  => { :name => 'Germany . West Germany' },
            'KKA'  => { :name => 'East Germany' },
            'KKB'  => { :name => 'German states and provinces (A-Pr)' },
            'KKC'  => { :name => 'German states and provinces (Ps-Z)' },
            'KKE'  => { :name => 'Greece' },
            'KKF'  => { :name => 'Hungary' },
            'KKG'  => { :name => 'Iceland' },
            'KKH'  => { :name => 'Italy' },
            'KKI'  => { :name => 'Latvia' },
            'KKJ'  => { :name => 'Liechtenstein . Lithuania' },
            'KKK'  => { :name => 'Luxembourg . Macedonia (1992-; cf. KKZ). Malta' },
            'KKL'  => { :name => 'Monaco' },
            'KKM'  => { :name => 'Netherlands' },
            'KKN'  => { :name => 'Norway' },
            'KKP'  => { :name => 'Poland' },
            'KKQ'  => { :name => 'Portugal' },
            'KKR'  => { :name => 'Romania' },
            'KKS'  => { :name => 'San Marino . Serbia & Montenegro (2003-; cf. KKZ). Slovenia (1992-)' },
            'KKT'  => { :name => 'Spain' },
            'KKV'  => { :name => 'Sweden' },
            'KKW'  => { :name => 'Switzerland' },
            'KKX'  => { :name => 'Turkey' },
            'KKY'  => { :name => 'Ukraine (post-Soviet, 1991-; cf. KLP)' },
            'KKZ'  => { :name => 'Yugoslavia' },
            'KL'  => { :name => 'History of law in the ancient Middle East (Egyptian, Babylonian, Assyrian, etc.). Eurasia (general & comparative)' },
            'KLA'  => { :name => 'Russia (pre-Soviet). Soviet Union (general). Commonwealth of Independent States' },
            'KLB'  => { :name => 'Russia (Federation, 1992-; cf. KLA, KLN)' },
            'KLD'  => { :name => 'Armenia (to 1991; cf. KMF)' },
            'KLE'  => { :name => 'Azerbaijan' },
            'KLF'  => { :name => 'Belarus' },
            'KLH'  => { :name => 'Georgia' },
            'KLM'  => { :name => 'Moldova' },
            'KLN'  => { :name => 'Russia (as a Soviet Republic ; cf. KLA, KLB)' },
            'KLP'  => { :name => 'Ukraine (as a Soviet Republic ; cf. KKY). Transcaucasian Federation' },
            'KLQ'  => { :name => 'Bukharskaia N.S.R.' },
            'KLR'  => { :name => 'Kazakhstan . Khorezmskaia S.S.R.' },
            'KLS'  => { :name => 'Kyrgyzstan' },
            'KLT'  => { :name => 'Tajikistan' },
            'KLV'  => { :name => 'Turkmenistan' },
            'KLW'  => { :name => 'Uzbekistan' },
            'KM'  => { :name => 'Asia (general & comparative)' },
            'KMC'  => { :name => 'Middle East . Southwest Asia (regional comparative and uniform law)' },
            'KME'  => { :name => 'Middle East . Southwest Asia (regional organization and integration)' },
            'KMF'  => { :name => 'Armenia (1991-; cf. KLD). Bahrain' },
            'KMG'  => { :name => 'Gaza (cf. KMM)' },
            'KMH'  => { :name => 'Iran' },
            'KMJ'  => { :name => 'Iraq' },
            'KMK'  => { :name => 'Israel' },
            'KML'  => { :name => 'Jerusalem' },
            'KMM'  => { :name => 'Jordan. West Bank . Palestinian National Authority' },
            'KMN'  => { :name => 'Kuwait' },
            'KMP'  => { :name => 'Lebanon' },
            'KMQ'  => { :name => 'Oman . Palestine (to 1948)' },
            'KMS'  => { :name => 'Qatar' },
            'KMT'  => { :name => 'Saudi Arabia' },
            'KMU'  => { :name => 'Syria' },
            'KMV'  => { :name => 'United Arab Emirates' },
            'KMX'  => { :name => 'Yemen .' },
            'KMY'  => { :name => 'Yemen , South (to 1990)' },
            'KNC'  => { :name => 'South Asia . Southeast Asia . East Asia (regional comparative and uniform law)' },
            'KNE'  => { :name => 'South Asia . Southeast Asia . East Asia (regional organization and integration)' },
            'KNF'  => { :name => 'Afghanistan' },
            'KNG'  => { :name => 'Bangladesh' },
            'KNH'  => { :name => 'Bhutan' },
            'KNK'  => { :name => 'Brunei' },
            'KNL'  => { :name => 'Burma' },
            'KNM'  => { :name => 'Cambodia' },
            'KNN'  => { :name => 'China (to 1949)' },
            'KNP'  => { :name => 'Taiwan (1949-)' },
            'KNQ'  => { :name => 'China (People\'s Republic, 1949-)' },
            'KNR'  => { :name => 'Hong Kong (to 1997)' },
            'KNS'  => { :name => 'India (general)' },
            'KNT'  => { :name => 'India (States and union territories, A-L)' },
            'KNU'  => { :name => 'India (States and union territories, M-Z; cities, towns, etc.)' },
            'KNV'  => { :name => 'French Indochina (to 1946)' },
            'KNW'  => { :name => 'Indonesia . East Timor' },
            'KNX'  => { :name => 'Japan (general & prefectures)' },
            'KNY'  => { :name => 'Japan (cities, towns, etc.)' },
            'KPA'  => { :name => 'Korea. South Korea' },
            'KPC'  => { :name => 'North Korea' },
            'KPE'  => { :name => 'Laos' },
            'KPF'  => { :name => 'Macau (to 1999)' },
            'KPG'  => { :name => 'Malaysia' },
            'KPH'  => { :name => 'Malaysia (cont.). Maldives' },
            'KPJ'  => { :name => 'Mongolia' },
            'KPK'  => { :name => 'Nepal' },
            'KPL'  => { :name => 'Pakistan' },
            'KPM'  => { :name => 'Philippines' },
            'KPP'  => { :name => 'Singapore' },
            'KPS'  => { :name => 'Sri Lanka' },
            'KPT'  => { :name => 'Thailand' },
            'KPV'  => { :name => 'Vietnam (to 1945). North Vietnam (1945-1975). Vietnam (1975-)' },
            'KPW'  => { :name => 'South Vietnam' },
            'KQ'  => { :name => 'History of law in Africa . Extinct jurisdictions. Customary law' },
            'KQC'  => { :name => 'Regional comparative and uniform law' },
            'KQE'  => { :name => 'Regional organization and integration' },
            'KQG'  => { :name => 'Algeria' },
            'KQH'  => { :name => 'Angola' },
            'KQJ'  => { :name => 'Benin' },
            'KQK'  => { :name => 'Botswana' },
            'KQM'  => { :name => 'British Central Africa Protectorate' },
            'KQP'  => { :name => 'British Somaliland (to 1960)' },
            'KQT'  => { :name => 'Burkina Faso' },
            'KQV'  => { :name => 'Burundi' },
            'KQW'  => { :name => 'Cameroon' },
            'KQX'  => { :name => 'Cape Verde' },
            'KRB'  => { :name => 'Central African Republic' },
            'KRC'  => { :name => 'Chad' },
            'KRE'  => { :name => 'Comoros' },
            'KRG'  => { :name => 'Congo (Brazzaville)' },
            'KRK'  => { :name => 'Djibouti' },
            'KRL'  => { :name => 'East Africa Protectorate' },
            'KRM'  => { :name => 'Egypt (United Arab Republic) (cf. KL)' },
            'KRN'  => { :name => 'Eritrea' },
            'KRP'  => { :name => 'Ethiopia' },
            'KRR'  => { :name => 'French Equatorial Africa' },
            'KRS'  => { :name => 'French West Africa' },
            'KRU'  => { :name => 'Gabon' },
            'KRV'  => { :name => 'Gambia' },
            'KRW'  => { :name => 'German East Africa' },
            'KRX'  => { :name => 'Ghana' },
            'KRY'  => { :name => 'Gibraltar' },
            'KSA'  => { :name => 'Guinea' },
            'KSC'  => { :name => 'Guinea-Bissau' },
            'KSE'  => { :name => 'Equatorial Guinea . Ifni' },
            'KSG'  => { :name => 'Italian East Africa . Italian Somaliland' },
            'KSH'  => { :name => 'Côte d\'Ivoire' },
            'KSK'  => { :name => 'Kenya' },
            'KSL'  => { :name => 'Lesotho' },
            'KSN'  => { :name => 'Liberia' },
            'KSP'  => { :name => 'Libya' },
            'KSR'  => { :name => 'Madagascar' },
            'KSS'  => { :name => 'Malawi' },
            'KST'  => { :name => 'Mali' },
            'KSU'  => { :name => 'Mauritania' },
            'KSV'  => { :name => 'Mauritius. Mayotte' },
            'KSW'  => { :name => 'Morocco' },
            'KSX'  => { :name => 'Mozambique' },
            'KSY'  => { :name => 'Namibia' },
            'KSZ'  => { :name => 'Niger' },
            'KTA'  => { :name => 'Nigeria' },
            'KTC'  => { :name => 'Réunion' },
            'KTD'  => { :name => 'Rwanda' },
            'KTE'  => { :name => 'Saint Helena' },
            'KTF'  => { :name => 'Sao Tome and Principe' },
            'KTG'  => { :name => 'Senegal' },
            'KTH'  => { :name => 'Seychelles' },
            'KTJ'  => { :name => 'Sierra Leone' },
            'KTK'  => { :name => 'Somalia' },
            'KTL'  => { :name => 'South Africa' },
            'KTN'  => { :name => 'Spanish West Africa. Spanish Sahara' },
            'KTQ'  => { :name => 'Sudan' },
            'KTR'  => { :name => 'Swaziland' },
            'KTT'  => { :name => 'Tanzania' },
            'KTU'  => { :name => 'Togo' },
            'KTV'  => { :name => 'Tunisia' },
            'KTW'  => { :name => 'Uganda' },
            'KTX'  => { :name => 'Congo (Democratic Republic). Zaire' },
            'KTY'  => { :name => 'Zambia. Zanzibar' },
            'KTZ'  => { :name => 'Zimbabwe' },
            'KU'  => { :name => 'Australia (general)' },
            'KUA'  => { :name => 'Australian Capital Territory' },
            'KUB'  => { :name => 'Northern Territory' },
            'KUC'  => { :name => 'New South Wales' },
            'KUD'  => { :name => 'Queensland' },
            'KUE'  => { :name => 'South Australia' },
            'KUF'  => { :name => 'Tasmania' },
            'KUG'  => { :name => 'Victoria' },
            'KUH'  => { :name => 'Western Australia' },
            'KUN'  => { :name => 'Norfolk Island. Cities, towns, etc.' },
            'KUQ'  => { :name => 'New Zealand' },
            'KVB'  => { :name => 'Regional comparative and uniform law: Australia and New Zealand' },
            'KVC'  => { :name => 'Regional comparative and uniform law: Other Pacific area jurisdictions' },
            'KVE'  => { :name => 'Regional comparative and uniform law: Regional organization and integration' },
            'KVH'  => { :name => 'American Samoa. British New Guinea' },
            'KVL'  => { :name => 'Cook Islands' },
            'KVM'  => { :name => 'Easter Island' },
            'KVN'  => { :name => 'Fiji' },
            'KVP'  => { :name => 'French Polynesia. German New Guinea' },
            'KVQ'  => { :name => 'Guam' },
            'KVR'  => { :name => 'Kiribati' },
            'KVS'  => { :name => 'Marshall Islands. Micronesia. Midway Islands' },
            'KVU'  => { :name => 'Nauru. Netherlands New Guinea' },
            'KVW'  => { :name => 'New Caledonia' },
            'KWA'  => { :name => 'Niue' },
            'KWC'  => { :name => 'Northern Mariana Islands' },
            'KWE'  => { :name => 'Pacific Islands Trust Territory' },
            'KWG'  => { :name => 'Palau' },
            'KWH'  => { :name => 'Papua New Guinea' },
            'KWL'  => { :name => 'Pitcairn Island. Solomon Islands' },
            'KWP'  => { :name => 'Tonga' },
            'KWQ'  => { :name => 'Tuvalu' },
            'KWR'  => { :name => 'Vanuatu' },
            'KWT'  => { :name => 'Wake Island. Wallis and Futuna Islands' },
            'KWW'  => { :name => 'Samoa. Western Samoa' },
            'KWX'  => { :name => 'Antarctica' },
            'KZ'  => { :name => 'Law of Nations. International law' },
            'KZA'  => { :name => 'Law of the sea' },
            'KZD'  => { :name => 'Space law. Law of outer space' }
        }
    },
    'L' => {
        :name => 'Education',
        :subclasses => {
            'L'  => { :name => 'Education (General)' },
            'LA' => { :name => 'History of education' },
            'LB' => { :name => 'Theory and practice of education' },
            'LC' => { :name => 'Special aspects of education' },
            'LD' => { :name => 'Individual institutions - United States' },
            'LE' => { :name => 'Individual institutions - America (except United States)' },
            'LF' => { :name => 'Individual institutions - Europe' },
            'LG' => { :name => 'Individual institutions - Asia, Africa, Indian Ocean islands, Australia, New Zealand, Pacific islands' },
            'LH' => { :name => 'College and school magazines and papers' },
            'LJ' => { :name => 'Student fraternities and societies, United States' },
            'LT' => { :name => 'Textbooks' }
        }
    },
    'M' => {
        :name => 'Music',
        :subclasses => {
            'M'  => { :name => 'Music' },
            'ML' => { :name => 'Literature on music' },
            'MT' => { :name => 'Instruction and study' }
        }
    },
    'N' => {
        :name => 'Fine Arts',
        :subclasses => {
            'N'  => { :name => 'Visual arts' },
            'NA' => { :name => 'Architecture' },
            'NB' => { :name => 'Sculpture' },
            'NC' => { :name => 'Drawing. Design. Illustration' },
            'ND' => { :name => 'Painting' },
            'NE' => { :name => 'Print media' },
            'NK' => { :name => 'Decorative arts' },
            'NX' => { :name => 'Arts in general' }
        }
    },
    'P' => {
        :name => 'Language and Literature',
        :subclasses => {
            'P'  => { :name => 'Philology. Linguistics' },
            'PA' => { :name => 'Greek language and literature. Latin language and literature' },
            'PB' => { :name => 'Modern languages. Celtic languages' },
            'PC' => { :name => 'Romanic languages' },
            'PD' => { :name => 'Germanic languages. Scandinavian languages' },
            'PE' => { :name => 'English language' },
            'PF' => { :name => 'West Germanic languages' },
            'PG' => { :name => 'Slavic languages and literatures. Baltic languages. Albanian language' },
            'PH' => { :name => 'Uralic languages. Basque language' },
            'PJ' => { :name => 'Oriental languages and literatures' },
            'PK' => { :name => 'Indo-Iranian languages and literatures' },
            'PL' => { :name => 'Languages and literatures of Eastern Asia, Africa, Oceania' },
            'PM' => { :name => 'Hyperborean, Indian, and artificial languages' },
            'PN' => { :name => 'Literature (General)' },
            'PQ' => { :name => 'French literature - Italian literature - Spanish literature - Portuguese literature' },
            'PR' => { :name => 'English literature' },
            'PS' => { :name => 'American literature' },
            'PT' => { :name => 'Germanic, Scandinavian, and Icelandic literatures' },
            'PZ' => { :name => 'Fiction and juvenile belles lettres' }
        }
    },
    'Q' => {
        :name => 'Science',
        :subclasses => {
            'Q'  => { :name => 'Science (General)' },
            'QA' => { :name => 'Mathematics' },
            'QB' => { :name => 'Astronomy' },
            'QC' => { :name => 'Physics' },
            'QD' => { :name => 'Chemistry' },
            'QE' => { :name => 'Geology' },
            'QH' => { :name => 'Natural history - Biology' },
            'QK' => { :name => 'Botany' },
            'QL' => { :name => 'Zoology' },
            'QM' => { :name => 'Human anatomy' },
            'QP' => { :name => 'Physiology' },
            'QR' => { :name => 'Microbiology' },
            'QS' => { :name => 'Human Anatomy' },
            'QT' => { :name => 'Physiology' },
            'QU' => { :name => 'Biochemistry' },
            'QV' => { :name => 'Pharmacology' },
            'QW' => { :name => 'Microbiology & Immunology' },
            'QX' => { :name => 'Parasitology' },
            'QY' => { :name => 'Clinical Pathology' },
            'QZ' => { :name => 'Pathology' }
        }
    },
    'R' => {
        :name => 'Medicine',
        :subclasses => {
            'R'  => { :name => 'Medicine (General)' },
            'RA' => { :name => 'Public aspects of medicine' },
            'RB' => { :name => 'Pathology' },
            'RC' => { :name => 'Internal medicine' },
            'RD' => { :name => 'Surgery' },
            'RE' => { :name => 'Ophthalmology' },
            'RF' => { :name => 'Otorhinolaryngology' },
            'RG' => { :name => 'Gynecology and obstetrics' },
            'RJ' => { :name => 'Pediatrics' },
            'RK' => { :name => 'Dentistry' },
            'RL' => { :name => 'Dermatology' },
            'RM' => { :name => 'Therapeutics. Pharmacology' },
            'RS' => { :name => 'Pharmacy and materia medica' },
            'RT' => { :name => 'Nursing' },
            'RV' => { :name => 'Botanic, Thomsonian, and eclectic medicine' },
            'RX' => { :name => 'Homeopathy' },
            'RZ' => { :name => 'Other systems of medicine' }
        }
    },
    'S' => {
        :name => 'Agriculture',
        :subclasses => {
            'S'  => { :name => 'Agriculture (General)' },
            'SB' => { :name => 'Plant culture' },
            'SD' => { :name => 'Forestry' },
            'SF' => { :name => 'Animal culture' },
            'SH' => { :name => 'Aquaculture. Fisheries. Angling' },
            'SK' => { :name => 'Hunting sports' }
        }
    },
    'T' => {
        :name => 'Technology',
        :subclasses => {
            'T'  => { :name => 'Technology (General)' },
            'TA' => { :name => 'Engineering (General). Civil engineering' },
            'TC' => { :name => 'Hydraulic engineering. Ocean engineering' },
            'TD' => { :name => 'Environmental technology. Sanitary engineering' },
            'TE' => { :name => 'Highway engineering. Roads and pavements' },
            'TF' => { :name => 'Railroad engineering and operation' },
            'TG' => { :name => 'Bridge engineering' },
            'TH' => { :name => 'Building construction' },
            'TJ' => { :name => 'Mechanical engineering and machinery' },
            'TK' => { :name => 'Electrical engineering. Electronics. Nuclear engineering' },
            'TL' => { :name => 'Motor vehicles. Aeronautics. Astronautics' },
            'TN' => { :name => 'Mining engineering. Metallurgy' },
            'TP' => { :name => 'Chemical technology' },
            'TR' => { :name => 'Photography' },
            'TS' => { :name => 'Manufactures' },
            'TT' => { :name => 'Handicrafts. Arts and crafts' },
            'TX' => { :name => 'Home economics' }
        }
    },
    'U' => {
        :name => 'Military Science',
        :subclasses => {
            'U'  => { :name => 'Military science (General)' },
            'UA' => { :name => 'Armies: Organization, distribution, military situation' },
            'UB' => { :name => 'Military administration' },
            'UC' => { :name => 'Maintenance and transportation' },
            'UD' => { :name => 'Infantry' },
            'UE' => { :name => 'Cavalry. Armor' },
            'UF' => { :name => 'Artillery' },
            'UG' => { :name => 'Military engineering. Air forces' },
            'UH' => { :name => 'Other services' }
        }
    },
    'V' => {
        :name => 'Naval Science',
        :subclasses => {
            'V'  => { :name => 'Naval science (General)' },
            'VA' => { :name => 'Navies: Organization, distribution, naval situation' },
            'VB' => { :name => 'Naval administration' },
            'VC' => { :name => 'Naval maintenance' },
            'VD' => { :name => 'Naval seamen' },
            'VE' => { :name => 'Marines' },
            'VF' => { :name => 'Naval ordnance' },
            'VG' => { :name => 'Minor services of navies' },
            'VK' => { :name => 'Navigation. Merchant marine' },
            'VM' => { :name => 'Naval architecture. Shipbuilding. Marine engineering' }
        }
    },
    'W' => {
        :name => 'Medicine (NLM)',
        :subclasses => {
            'W'  => { :name => 'General Medicine. Health Professions' },
            'WA' => { :name => 'Public Health' },
            'WB' => { :name => 'Practice of Medicine'},
            'WC' => { :name => 'Communicable Diseases' },
            'WD' => { :name => 'Disorders of Systemic, Metabolic or Environmental Origin, etc.' },
            'WE' => { :name => 'Musculoskeletal System' },
            'WF' => { :name => 'Respiratory System' },
            'WG' => { :name => 'Cardiovascular System' },
            'WH' => { :name => 'Hemic and Lymphatic Systems' },
            'WI' => { :name => 'Digestive System' },
            'WJ' => { :name => 'Urogenital System' },
            'WK' => { :name => 'Endocrine System' },
            'WL' => { :name => 'Nervous System' },
            'WM' => { :name => 'Psychiatry' },
            'WN' => { :name => 'Radiology. Diagnostic Imaging' },
            'WO' => { :name => 'Surgery' },
            'WP' => { :name => 'Gynecology' },
            'WQ' => { :name => 'Obstetrics' },
            'WR' => { :name => 'Dermatology' },
            'WS' => { :name => 'Pediatrics' },
            'WT' => { :name => 'Geriatrics. Chronic Disease' },
            'WU' => { :name => 'Dentistry. Oral Surgery' },
            'WV' => { :name => 'Otolaryngology' },
            'WW' => { :name => 'Ophthalmology' },
            'WX' => { :name => 'Hospitals and Other Health Facilities' },
            'WY' => { :name => 'Nursing' },
            'WZ' => { :name => 'History of Medicine. Medical Miscellany' }
        }
    },
    'Z' => {
        :name => 'Bibliography, Library Science',
        :subclasses => {
            'Z'   => { :name => 'Books (General). Writing. Paleography. Book industries and trade. Libraries. Bibliography' },
            'ZA'  => { :name => 'Information resources (General)' },
            'ZW'   => { :name => 'NULL' },
            'ZWZ'  => { :name => 'NULL' }
        }
    }
}


# Create Main LC conversion table
i = 1;
CLASS_HASH.each do |key, klas|
  klas[:subclasses].each do |letter, body|
    LcSection.create({letters: "Pamph. " + letter, token: i, name: "Pamphlet - " + body[:name]})
    i = i + 1;
  end
  klas[:subclasses].each do |letter, body|
    LcSection.create({letters: "Folio " + letter, token: i, name: "Folio - " + body[:name]})
    i = i + 1;
  end
  klas[:subclasses].each do |letter, body|
    LcSection.create({letters: letter, token: i, name: body[:name]})
    i = i + 1;
  end
end


# Create HUB conversion table

i = 1
CLASS_HASH.each do |key, klas|
  klas[:subclasses].each do |letter, body|
    HubLcSection.create({letters: 'Pamph. ' + letter, token: i, name: 'Pamphlet - ' + body[:name]})
    i = i + 1
  end
end
CLASS_HASH.each do |key, klas|
  klas[:subclasses].each do |letter, body|
    if letter[0] != 'N'
      HubLcSection.create({letters: 'Folio ' + letter, token: i, name: 'Folio - ' + body[:name]})
    end
    i = i + 1
  end
end

CLASS_HASH.each do |key, klas|
  klas[:subclasses].each do |letter, body|
    if letter == 'N'
      klas[:subclasses].each do |letter1, body1|
        HubLcSection.create({letters: 'Folio ' + letter1, token: i, name: 'Folio - ' + body1[:name]})
        i = i + 1
      end
    end
    HubLcSection.create({letters: letter, token: i, name: body[:name]})
    i = i + 1
  end
end
