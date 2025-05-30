#DSDP, ODP, IODP Age Map
#started: 10 April 2023
#updated: 10 April 2023
#Laurel Childress; childress@iodp.tamu.edu

###############################################################################
# A very basic map leaflet and table of expedition site geologic ages.

#This application provides epoch and period ages for scientific ocean drilling 
#...sites of DSDP, ODP, and IODP. Data should not be considered complete or 
#...exhaustive and is based on http://iodp.tamu.edu/database/ages_dsdp.html
###############################################################################

#Packages
if(!require(rmarkdown)){ #check if the package is installed and sourced
  install.packages("rmarkdown") #if not, install the package
  library(rmarkdown) #and source the package 
}

if(!require(ggplot2)){ #check if the package is installed and sourced
  install.packages("ggplot2") #if not, install the package
  library(ggplot2) #and source the package 
}

if(!require(tidyr)){ #check if the package is installed and sourced
  install.packages("tidyr") #if not, install the package
  library(tidyr) #and source the package 
}

if(!require(stringr)){  #check if the package is installed and sourced
  install.packages("stringr") #if not, install the package
  library(stringr) #and source the package 
}

if(!require(leaflet)){ #check if the package is installed and sourced
  install.packages("leaflet") #if not, install the package
  library(leaflet) #and source the package 
}

if(!require(DT)){ #check if the package is installed and sourced
  install.packages("DT") #if not, install the package
  library(DT) #and source the package 
}

if(!require(shiny)){ #check if the package is installed and sourced
  install.packages("shiny") #if not, install the package
  library(shiny) #and source the package
}

if(!require(shinyjs)){ #check if the package is installed and sourced
  install.packages("shinyjs") #if not, install the package
  library(shinyjs) #and source the package
}

if(!require(shinyWidgets)){ #check if the package is installed and sourced
  install.packages("shinyWidgets") #if not, install the package
  library(shinyWidgets) #and source the package
}

if(!require(shinydashboard)){ #check if the package is installed and sourced
  install.packages("shinydashboard") #if not, install the package
  library(shinydashboard) #and source the package
}

if(!require(shinydashboardPlus)){ #check if the package is installed and sourced
  install.packages("shinydashboardPlus") #if not, install the package
  library(shinydashboardPlus) #and source the package
}

age_df <- read.csv("SOD_ages_edited3.csv")

#######EXP LIST ORDERFOR USE BELOW#############################################
ages_unique <- c("Pleistocene", "Pliocene", "Miocene", "Oligocene", "Eocene", "Paleocene", "Cretaceous", "Jurassic", "Triassic", "Paleozoic", "Cambrian-Ordovician", "Precambrian")

all_exp <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28",
             "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55",
             "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82",
             "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "100", "101", "103", "104", "105", "106", "107", "108", "109", "110", "111",
             "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "123", "124", "125", "126", "127", "128", "129", "130", "131", "132", "133", "134",
             "135", "136", "137", "138", "139", "140", "141", "142", "143", "144", "145", "146", "147", "148", "149", "150", "151", "152", "153", "154", "155", "156", "157",
             "158", "159", "160", "161", "162", "163", "164", "165", "166", "167", "168", "169", "170", "171A", "171B", "172", "173", "174A", "174B", "175", "176", "177",
             "178", "179", "180", "181", "182", "183", "184", "185", "186", "187", "188", "189", "190", "191", "192", "193", "194", "195", "196", "197", "198", "199", "200",
             "201", "202", "203", "204", "205", "206", "207", "208", "209", "210", "301", "303", "304", "305", "306", "307", "308", "309", "311", "312", "320", "321", "323",
             "324", "317", "318", "327", "328", "329", "330", "334", "336", "339", "340T", "340", "342", "344", "345", "341S", "341", "346", "349", "350", "351", "352", "353",
             "354", "355", "356", "359", "360", "361", "362", "362T", "363", "366", "367", "368", "369", "371", "372", "374", "375", "376", "378", "379", "382", "383", "385")

all_site <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25",
"26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51",
"52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77",
"78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "100", "101", "102",
"103", "104", "105", "106", "107", "108", "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "123", "124", "125", "126",
"127", "128", "129", "130", "131", "132", "133", "134", "135", "136", "137", "138", "139", "140", "141", "142", "143", "144", "146", "147", "148", "149",
"150", "151", "152", "153", "154", "155", "156", "157", "158", "159", "160", "161", "162", "163", "164", "165", "166", "167", "168", "169", "170", "171",
"172", "173", "174", "175", "176", "177", "178", "179", "180", "181", "182", "183", "184", "185", "186", "187", "188", "189", "190", "191", "192", "193",
"194", "195", "196", "197", "198", "199", "200", "201", "202", "203", "204", "205", "206", "207", "208", "209", "210", "211", "212", "213", "214", "215",
"216", "217", "218", "219", "220", "221", "222", "223", "224", "225", "226", "227", "228", "229", "230", "231", "232", "233", "234", "235", "236", "237",
"238", "239", "240", "241", "242", "243", "244", "245", "246", "247", "248", "249", "250", "251", "252", "253", "254", "255", "256", "257", "258", "259",
"260", "261", "262", "263", "264", "265", "266", "267", "268", "269", "270", "271", "272", "273", "274", "275", "276", "277", "278", "279", "280", "281",
"282", "283", "284", "285", "286", "287", "288", "289", "290", "291", "292", "293", "294", "295", "296", "297", "298", "299", "300", "301", "302", "303",
"304", "305", "306", "307", "308", "309", "310", "311", "312", "313", "314", "315", "316", "317", "318", "319", "320", "321", "322", "323", "324", "325",
"326", "327", "328", "329", "330", "331", "332", "333", "334", "335", "336", "337", "338", "339", "340", "341", "342", "343", "344", "345", "346", "347",
"348", "349", "350", "351", "352", "353", "354", "355", "356", "357", "358", "359", "360", "361", "362", "363", "364", "365", "366", "367", "368", "369",
"370", "371", "372", "373", "374", "375", "376", "377", "378", "379", "380", "381", "382", "383", "384", "385", "386", "387", "388", "389", "390", "391",
"392", "393", "394", "395", "396", "397", "398", "399", "400", "401", "402", "403", "404", "405", "406", "407", "408", "409", "410", "411", "412", "413",
"414", "415", "416", "417", "418", "419", "420", "421", "422", "423", "424", "425", "426", "427", "428", "429", "430", "431", "432", "433", "434", "435",
"436", "437", "438", "439", "440", "441", "442", "443", "444", "445", "446", "447", "448", "449", "450", "451", "452", "453", "454", "455", "456", "457",
"458", "459", "460", "461", "462", "463", "464", "465", "466", "467", "468", "469", "470", "471", "472", "473", "474", "475", "476", "477", "478", "479",
"480", "481", "482", "483", "484", "485", "486", "487", "488", "489", "490", "491", "492", "493", "494", "495", "496", "497", "498", "499", "500", "501",
"502", "503", "504", "505", "506", "507", "508", "509", "510", "511", "512", "513", "514", "515", "516", "517", "518", "519", "520", "521", "522", "523",
"524", "525", "526", "527", "528", "529", "530", "531", "532", "533", "534", "535", "536", "537", "538", "539", "540", "541", "542", "543", "544", "545",
"546", "547", "548", "549", "550", "551", "552", "553", "554", "555", "556", "557", "558", "559", "560", "561", "562", "563", "564", "565", "566", "567",
"568", "569", "570", "571", "572", "573", "574", "575", "576", "577", "578", "579", "580", "581", "582", "583", "584", "585", "586", "587", "588", "589",
"590", "591", "592", "593", "594", "595", "596", "597", "598", "599", "600", "601", "602", "603", "604", "605", "606", "607", "608", "609", "610", "611",
"612", "613", "614", "615", "616", "617", "618", "619", "620", "621", "622", "623", "624", "625", "626", "627", "628", "629", "630", "631", "632", "633",
"634", "635", "636", "637", "638", "639", "640", "641", "642", "643", "644", "645", "646", "647", "648", "649", "650", "651", "652", "653", "654", "655",
"656", "657", "658", "659", "660", "661", "662", "663", "664", "665", "666", "667", "668", "669", "670", "671", "672", "673", "674", "675", "676", "677",
"678", "679", "680", "681", "682", "683", "684", "685", "686", "687", "688", "689", "690", "691", "692", "693", "694", "695", "696", "697", "698", "699",
"700", "701", "702", "703", "704", "705", "706", "707", "708", "709", "710", "711", "712", "713", "714", "715", "716", "717", "718", "719", "720", "721", 
"722", "723", "724", "725", "726", "727", "728", "729", "730", "731", "732", "733", "734", "735", "736", "737", "738", "739", "740", "741", "742", "743", 
"744", "745", "746", "747", "748", "749", "750", "751", "752", "753", "754", "755", "756", "757", "758", "759", "760", "761", "762", "763", "764", "765", 
"766", "767", "768", "769", "770", "771", "772", "773", "774", "775", "776", "777", "778", "779", "780", "781", "782", "783", "784", "785", "786", "787", 
"788", "789", "790", "791", "792", "793", "794", "795", "796", "797", "798", "799", "800", "801", "802", "803", "804", "805", "806", "807", "808", "809", 
"810", "811", "812", "813", "814", "815", "816", "817", "818", "819", "820", "821", "822", "823", "824", "825", "826", "827", "828", "829", "830", "831", 
"832", "833", "834", "835", "836", "837", "838", "839", "840", "841", "842", "843", "844", "845", "846", "847", "848", "849", "850", "851", "852", "853", 
"854", "855", "856", "857", "858", "859", "860", "861", "862", "863", "864", "865", "866", "867", "868", "869", "870", "871", "872", "873", "874", "875", 
"876", "877", "878", "879", "880", "881", "882", "883", "884", "885", "886", "887", "888", "889", "890", "891", "892", "893", "894", "895", "896", "897", 
"898", "899", "900", "901", "902", "903", "904", "905", "906", "907", "908", "909", "910", "911", "912", "913", "914", "915", "916", "917", "918", "919", 
"920", "921", "922", "923", "924", "925", "926", "927", "928", "929", "930", "931", "932", "933", "934", "935", "936", "937", "938", "939", "940", "941", 
"942", "943", "944", "945", "946", "947", "948", "949", "950", "951", "952", "953", "954", "955", "956", "957", "958", "959", "960", "961", "962", "963", 
"964", "965", "966", "967", "968", "969", "970", "971", "972", "973", "974", "975", "976", "977", "978", "979", "980", "981", "982", "983", "984", "985", 
"986", "987", "988", "989", "990", "991", "992", "993", "994", "995", "996", "997", "998", "999", "1000", "1001", "1002", "1003", "1004", "1005", "1006", 
"1007", "1008", "1009", "1010", "1011", "1012", "1013", "1014", "1015", "1016", "1017", "1018", "1019", "1020", "1021", "1022", "1023", "1024", "1025", 
"1026", "1027", "1028", "1029", "1030", "1031", "1032", "1033", "1034", "1035", "1036", "1037", "1038", "1039", "1040", "1041", "1042", "1043", "1044", 
"1045", "1046", "1047", "1048", "1049", "1050", "1051", "1052", "1053", "1054", "1055", "1056", "1057", "1058", "1059", "1060", "1061", "1062", "1063", 
"1064", "1065", "1066", "1067", "1068", "1069", "1070", "1071", "1072", "1073", "1074", "1075", "1076", "1077", "1078", "1079", "1080", "1081", "1082", 
"1083", "1084", "1085", "1086", "1087", "1088", "1089", "1090", "1091", "1092", "1093", "1094", "1095", "1096", "1097", "1098", "1099", "1100", "1101", 
"1102", "1103", "1104", "1105", "1106", "1107", "1108", "1109", "1110", "1111", "1112", "1113", "1114", "1115", "1116", "1117", "1118", "1119", "1120", 
"1121", "1122", "1123", "1124", "1125", "1126", "1127", "1128", "1129", "1130", "1131", "1132", "1133", "1134", "1135", "1136", "1137", "1138", "1139", 
"1140", "1141", "1142", "1143", "1144", "1145", "1146", "1147", "1148", "1149", "1150", "1151", "1152", "1153", "1154", "1155", "1156", "1157", "1158", 
"1159", "1160", "1161", "1162", "1163", "1164", "1165", "1166", "1167", "1168", "1169", "1170", "1171", "1172", "1173", "1174", "1175", "1176", "1177", 
"1178", "1179", "1180", "1181", "1182", "1183", "1184", "1185", "1186", "1187", "1188", "1189", "1190", "1191", "1192", "1193", "1194", "1195", "1196", 
"1197", "1198", "1199", "1200", "1201", "1202", "1203", "1204", "1205", "1206", "1207", "1208", "1209", "1210", "1211", "1212", "1213", "1214", "1215", 
"1216", "1217", "1218", "1219", "1220", "1221", "1222", "1223", "1224", "1225", "1226", "1227", "1228", "1229", "1230", "1231", "1232", "1233", "1234", 
"1235", "1236", "1237", "1238", "1239", "1240", "1241", "1242", "1243", "1244", "1245", "1246", "1247", "1248", "1249", "1250", "1251", "1252", "1253", 
"1254", "1255", "1256", "1257", "1258", "1259", "1260", "1261", "1262", "1263", "1264", "1265", "1266", "1267", "1268", "1269", "1270", "1271", "1272", 
"1273", "1274", "1275", "1276", "1277", "1301", "1302", "1303", "1304", "1305", "1306", "1307", "1308", "1309", "1310", "1311", "1312", "1313", "1314", 
"1315", "1316", "1317", "1318", "1319", "1320", "1321", "1322", "1323", "1324", "1325", "1326", "1327", "1328", "1329", "U1331", "U1332", "U1333", "U1334", 
"U1335", "U1336", "U1337", "U1338", "U1339", "U1340", "U1341", "U1342", "U1343", "U1344", "U1345", "U1346", "U1347", "U1348", "U1349", "U1350", "U1351", "U1352", 
"U1353", "U1354", "U1355", "U1356", "U1357", "U1358", "U1359", "U1360", "U1361", "U1362", "U1363", "U1364", "U1365", "U1366", "U1367", "U1368", "U1369", "U1370", 
"U1371", "U1372", "U1373", "U1374", "U1375", "U1376", "U1377", "U1378", "U1379", "U1380", "U1381", "U1382", "U1383", "U1384", "U1385", "U1386", "U1387", "U1388", 
"U1389", "U1390", "U1391", "U1392", "U1393", "U1394", "U1395", "U1396", "U1397", "U1398", "U1399", "U1400", "U1401", "U1402", "U1403", "U1404", "U1405", "U1406", 
"U1407", "U1408", "U1409", "U1410", "U1411", "U1412", "U1413", "U1414", "U1415", "U1416", "U1417", "U1418", "U1419", "U1420", "U1421", "U1422", "U1423", "U1424", 
"U1425", "U1426", "U1427", "U1428", "U1429", "U1430", "U1431", "U1432", "U1433", "U1434", "U1435", "U1436", "U1437", "U1438", "U1439", "U1440", "U1441", "U1442", 
"U1443", "U1444", "U1445", "U1446", "U1447", "U1448", "U1449", "U1450", "U1451", "U1452", "U1453", "U1454", "U1455", "U1457", "U1458", "U1459", "U1460", "U1461", 
"U1462", "U1463", "U1464", "U1465", "U1466", "U1467", "U1468", "U1469", "U1470", "U1471", "U1472", "U1473", "U1474", "U1475", "U1476", "U1477", "U1479", "U1480", 
"U1481", "U1482", "U1483", "U1484", "U1485", "U1486", "U1487", "U1488", "U1489", "U1490", "U1491", "U1492", "U1493", "U1494", "U1495", "U1496", "U1497", "U1498", 
"U1499", "U1500", "U1501", "U1502", "U1503", "U1504", "U1505", "U1512", "U1513", "U1514", "U1515", "U1516", "U1506", "U1507", "U1508", "U1509", "U1510", "U1511", 
"U1517", "U1521", "U1522", "U1523", "U1524", "U1525", "U1518", "U1519", "U1520", "U1526", "U1527", "U1528", "U1529", "U1530", "U1531", "U1553", "U1532", "U1533", 
"U1534", "U1535", "U1536", "U1537", "U1538", "U1539", "U1540", "U1541", "U1542", "U1543", "U1544", "U1545", "U1546", "U1547", "U1548", "U1549", "U1550", "U1551", 
"U1552")



ui <- dashboardPage(
  title = "Scientific Ocean Drilling Site Ages", #website title
  header = dashboardHeader(title = "Scientific Ocean Drilling Site Ages"),
  sidebar = dashboardSidebar(width = "0px"),
  body = dashboardBody(
    tags$style(type = "text/css", "#mymap {height: calc(100vh - 400px) !important;}"),
    tags$style(".input2 .btn {height: 26.5px; min-height: 26.5px; padding: 0px;}"),
    fluidRow(
      box(width = 12,
          leafletOutput("mymap")
      )
    ),
    fluidRow(
              box(width = 4,
                  pickerInput('input1', 'Expedition:', 
                              choices = all_exp,
                              selected = all_exp,
                              options = pickerOptions(`actions-box` = TRUE),
                              multiple = T)
              ),
             box(width = 4,
                 pickerInput('input2', 'Ages:', 
                             choices = ages_unique,
                             selected = ages_unique,
                             options = list(`actions-box` = TRUE, dropupAuto = FALSE), 
                             multiple = T)
             ),
             column(width = 2,
                 h1(" "),
                 actionBttn(inputId = "reset_all", label = "Reset", style = "bordered", color = "success", icon = icon("cog")
                 )
             )
    ),
      fluidRow(
        box(width = 12,
          DT::dataTableOutput("SiteHoleTable"))),
    br(),
    br(),
    "Data is derived from: ",
    tags$a(href="http://iodp.tamu.edu/database/ages_dsdp.html", 
           "http://iodp.tamu.edu/database/ages_dsdp.html",
           target="_blank"), #app link
    br(),
    tags$a(href="http://iodp.tamu.edu/database/ages_janus.html", 
           "http://iodp.tamu.edu/database/ages_janus.html",
           target="_blank"), #app link
    br(),
    tags$a(href="http://iodp.tamu.edu/database/ages_lims.html", 
           "http://iodp.tamu.edu/database/ages_lims.html",
           target="_blank"), #app link
    br(),
    "*Cores may be temporarily housed in other repositories. Always check with the repository curator for the most up-to-date information.",
    br(),
    tags$i("These are not official IODP-JRSO applications and functionality is 
           not guaranteed. User assumes all risk."), #italic disclaimer
    br(),
    tags$i("Questions, comments, concerns, compliments: shinylaurelwebmaster@gmail.com"),
    br(),
    tags$i("This app can be cited by DOI: 10.5281/zenodo.10498831"),
    br(),
    tags$head(tags$style(HTML('
        /* logo */
        .skin-blue .main-header .logo {
                              background-color: #f4b943;width: 400px;
                              }

        /* logo when hovered */
        .skin-blue .main-header .logo:hover {
                              background-color: #f4b943;
                              }

        /* navbar (rest of the header) */
        .skin-blue .main-header .navbar {
                              background-color: #f4b943;margin-left: 400px;
                              }
        /* main sidebar */
        .skin-blue .main-sidebar {
                              background-color: #325669;
                              }
         .box-header{ display: none}
                           '))),
    tags$head(includeHTML(("google_analytics.html"))),
    tags$script("document.getElementsByClassName('sidebar-toggle')[0].style.visibility = 'hidden';")
  )
)

server <- function(input, output, session) {
#########---Reactive Searched Dataframe---######################################
  
  observeEvent(input$reset_all, {
    updatePickerInput(session, "input1", choices = all_exp, selected = all_exp)
    updatePickerInput(session, "input2", choices = ages_unique, selected = ages_unique)
  })
  
  
  choose_program <- reactive({
    exp_range <- subset(age_df, leg_exp %in% input$input1)
    exp_range1 <- exp_range[exp_range$value %in% ages_unique,"value"]
    exp_range2 <- unique(exp_range1)
    sorted_age <- exp_range2[order(match(exp_range2, ages_unique))]
  })
  
  observe({ #use Program to limit Exp choices
    updatePickerInput(session, "input2", choices = choose_program(), selected = choose_program())
  })
  
  chosen_progs <- reactive({
    prog_range <- subset(age_df, leg_exp %in% input$input1) #narrow down to programs
    exp_range <- subset(prog_range, value %in% input$input2) #narrow down to Exps
    exp_range <- exp_range[!duplicated(exp_range[1:2]),]
    exp_range
  })
  
#########---Output Map---#######################################################
  output$mymap <- renderLeaflet({
    leaflet(chosen_progs()) %>%
      addTiles() %>% #related to our background, can allow us to label
      addCircles(lng = ~Longitude_DD, lat = ~Latitude_DD, #add our exp points
                 popup = paste("Expedition:", chosen_progs()$leg_exp, "<br>",
                               "Site:", chosen_progs()$site, "<br>",
                               "Ages:", chosen_progs()$all_ages2), #if you click one, it will show the date
                 weight = 15, radius = 30,
                 color = "red") %>% #, #size of the circles
                 # color = ~pal[value]) %>% #color of the circles
      # addLegend("bottomright", pal = pal, values = ~value,
      #           title = "Age",
                # opacity = 1) %>%
      setView( lng = 0, lat = 0, zoom = 2.5 ) %>% #set the initial view
      addProviderTiles("Esri.WorldImagery") #nice looking background
  })
#########---Output Table---#####################################################  
  output$SiteHoleTable <- DT::renderDataTable({
    pretty_table <- chosen_progs()
    pretty_table <- pretty_table[,c(1,2,5,15,18,19)]
    pretty_table <- pretty_table[,c(1,2,4,3,5,6)]
    pretty_table <- pretty_table[order(
      factor(pretty_table$leg_exp, levels = all_exp),
      factor(pretty_table$site, levels = all_site)), ]
    names(pretty_table)[1] <- "Leg or Expedition"
    names(pretty_table)[2] <- "Site"
    names(pretty_table)[3] <- "Ages"
    names(pretty_table)[4] <- "Other"
    names(pretty_table)[5] <- "Program"
    names(pretty_table)[6] <- "Repository"
    DT::datatable(pretty_table, options = list(pageLength = 50, scrollX = TRUE, 
                                               columnDefs = list(list(className = 'dt-center', targets = "_all"))), 
                  rownames= FALSE)
  })
}

shinyApp(ui = ui, server = server)